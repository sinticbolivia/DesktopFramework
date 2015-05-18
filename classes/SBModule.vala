using GLib;
using Gee;

namespace SinticBolivia
{
	//##declare public modules delegates
	//[CCode (has_target = false, has_type_id = false)]
	public		delegate void ActionHandler(SBModuleArgs obj);
	
	public class SBModuleArgs<G> : Object
	{
		private G Data;
		
		public void SetData(G data){this.Data = data;}
		public G GetData()
		{
			return this.Data;
		}
	}
	//[Compact]
	public class SBModuleHook : Object
	{
		public 	ActionHandler handler;
		public	string	HookName;
				
		public SBModuleHook()
		{
			GLib.Object();
		}
	}
	public class SBModules : Object
	{
		protected 	delegate Type GetModuleObjectType (Module module);
		protected	static ArrayList<string>	modulesFiles;
		protected 	static HashMap<string, ISBModule> _modules;
		protected 	static HashMap<string, ArrayList<SBModuleHook>> _actions;
		
		public static ArrayList<HashMap<string, string>> ListModules(string path)
		{
			var modules = new ArrayList<HashMap>();
			GLib.Type 	mod_type;
			GLib.Module module;
			
			assert(GLib.Module.supported());
			Dir dir = Dir.open(path, 0);
			string? module_file = null;
			while( ( module_file = dir.read_name() ) != null )
			{
				string[] parts = SBFileHelper.GetParts(module_file);
				string ext = SBOS.GetOS().IsUnix() ? "so" : "dll";
				
				if( ext != parts[1] ) continue;
				
				stdout.printf("%s -- %s\n", module_file, ext);
				{
					string the_module_path = GLib.Module.build_path(path, module_file);
					//##load the module
					//module = GLib.Module.open(the_module_path, ModuleFlags.BIND_LAZY);
					module = GLib.Module.open(the_module_path, ModuleFlags.BIND_LOCAL);
					if( module == null )
					{
						continue;
					}
					void* function;
					//##we call a generic functions into module and we get the function into a pointer
					module.symbol("sb_get_module_type", out function);
					//##we cast the pointer to delegate
					unowned GetModuleObjectType get_module_type = (GetModuleObjectType)function;
					
					mod_type = get_module_type(module);
					//## now we create an instance of module and using the module interface
					var module_obj	= (ISBModule)Object.new(mod_type);
					//##we call the module methods
					module_obj.Load();
					var mod = new HashMap<string, string>();
					mod.set("id", module_obj.Id);
					mod.set("name", module_obj.Name);
					mod.set("desc", module_obj.Description);
					mod.set("author", module_obj.Author);
					mod.set("version", module_obj.Version.to_string());
					mod.set("lib_name", module_obj.LibraryName);
					modules.add(mod);
					//module_obj = null;
				}
			}
			return modules;
			
		}
		public static void LoadModules(string modules_path)
		{
			Dir dir = Dir.open(modules_path, 0);
			string? module_file = null;
			while( ( module_file = dir.read_name() ) != null )
			{
				string[] parts = SBFileHelper.GetParts(module_file);
				string ext = SBOS.GetOS().IsUnix() ? "so" : "dll";
				
				if( ext != parts[1] ) continue;
				SBModules.LoadModule(SBFileHelper.SanitizePath(module_file), SBFileHelper.SanitizePath(modules_path), ext);
			}
		}
		public static bool LoadModule(string module_name, string? path = null, string mod_extension = "so")
		{
			GLib.Type 	mod_type;
			GLib.Module module;
			
			//##save the module reference into class modules list
			if( SBModules._modules == null )
			{
				SBModules._modules	= new HashMap<string, ISBModule>();
			}
			if( SBModules.modulesFiles == null )
			{
				SBModules.modulesFiles = new ArrayList<string>();
			}
			if( SBModules.modulesFiles.contains(module_name) )
			{
				stdout.printf("Module %s is already loaded\n", module_name);
				return true;
			}
				
			string module_dir = (path != null) ? path : Environment.get_current_dir();
			//##check if modules is supported by OS
			assert(GLib.Module.supported());
			//##check for module dependencies
			string deps_file = module_dir + "/" + module_name + ".deps";
			if( FileUtils.test(deps_file, FileTest.IS_REGULAR) )
			{
				stdout.printf("Loading %s module dependencies: %s\n", module_name, mod_extension);
				string deps_str = "";
				FileUtils.get_contents(deps_file, out deps_str);
				string[] mod_deps = deps_str.split(",");
				foreach(string _dep in mod_deps)
				{
					string dep = _dep.replace("\n", "");
					if( !SBModules.IsModuleLoaded(dep) )
					{
						//##load dependencie
						string dep_file = "lib" + dep + "." + mod_extension;
						stdout.printf("\tDependencie: %s\n", dep_file);
						SBModules.LoadModule(dep_file, module_dir, mod_extension);
					}
				}
			}
			string the_module_path = GLib.Module.build_path(module_dir, module_name);
			stdout.printf("Loading module from path: %s\n", the_module_path);
			//##load the module
			module = GLib.Module.open(the_module_path, ModuleFlags.BIND_LAZY);
			if( module == null )
			{
				stderr.printf("Error loading module: %s, ERROR: %s\n", the_module_path, GLib.Module.error());
				return false;
			}
			
			void* function;
			string module_symbol = "sb_get_module_%s_type".printf(module_name.down().strip().replace(".dll", "").replace(".so", ""));
			//##we call a generic functions into module and we get the function into a pointer
			module.symbol(module_symbol, out function);
			//##we cast the pointer to delegate
			unowned GetModuleObjectType get_module_type = (GetModuleObjectType)function;
			
			mod_type = get_module_type(module);
			//##note: we have the module ready to execute
			//## now we create an instance of module and using the module interface
			var module_obj	= (ISBModule)Object.new(mod_type);
			
			
			//##we call the module methods
			module_obj.Load();
			//module_obj.Init();
			//## We don't want our modules to ever unload
			module.make_resident ();
			
			//SBModules._modules.set(module_name, module_obj);
			SBModules._modules.set(module_obj.LibraryName, module_obj);
			SBModules.modulesFiles.add(module_name);
			return true;
		}
		public static bool UnloadModule(string module_name)
		{
			if( SBModules._modules == null )
			{
				return false;
			}
			(SBModules._modules.get(module_name) as ISBModule).Unload();
			return true;
		}
		public static bool IsModuleLoaded(string mod_name)
		{
			return SBModules._modules.has_key(mod_name);
		}
		public static HashMap<string, ISBModule> GetModules()
		{
			return SBModules._modules;
		}
		public static ISBModule? GetModule(string mod_name)
		{
			if( !SBModules.IsModuleLoaded(mod_name) )
				return null;
			
			return SBModules._modules.get(mod_name);
		}
		public static void add_action(string hook, ref SBModuleHook hook_obj)
		{
			if( SBModules._actions == null )
			{
				SBModules._actions = new HashMap<string, ArrayList<SBModuleHook>>(null, null);
			}
			if( !SBModules._actions.has_key(hook) )
			{
				SBModules._actions.set(hook, new ArrayList<SBModuleHook>());
			}
			var _handlers = (ArrayList<SBModuleHook>)SBModules._actions.get(hook);
			_handlers.add(hook_obj);
		}
		public static void remove_action(string hook, ActionHandler handler)
		{
			if( !SBModules._actions.has_key(hook) )
				return;
			var hooks = (ArrayList<SBModuleHook>)SBModules._actions[hook];
			foreach(SBModuleHook module_hook in hooks )
			{
				if( module_hook.handler == handler )
				{
					hooks.remove(module_hook);
				}
			}
		}
		public static Value? do_action(string hook, SBModuleArgs marg)
		{
			if( SBModules._actions == null )
				return null;
			if( !SBModules._actions.has_key(hook) )
				return null;
			
			ArrayList<SBModuleHook> _handlers = (ArrayList<SBModuleHook>)SBModules._actions.get(hook);
			//var args		= va_list();
			foreach(SBModuleHook mh in _handlers)
			{
				//stdout.printf("Passing arg type: %s\n", marg.get_type().name());
				mh.handler(marg);
			}
			
			return null;
		}
	}
	
	public abstract class SBModule : Object
	{
	}	
}
