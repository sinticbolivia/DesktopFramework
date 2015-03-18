using GLib;
using Gee;
using Gtk;
using SinticBolivia;

namespace SinticBolivia.Gtk
{
	public abstract class SBGtkModule : SBModule
	{
		protected string 	_moduleId;
		protected string	_name;
		protected string	_description;
		protected string 	_author;
		protected double 	_version;
		
		protected string 		resourceFile;
		protected string 		resourceNs;
		protected GLib.Resource res_data;
				
		public void LoadResources()
		{
			try
			{
				if( FileUtils.test(this.resourceFile, FileTest.EXISTS) )
				{
					this.res_data = Resource.load(this.resourceFile);
							
				}
				else
				{
					stderr.printf("Resource file for %s does not exists\n", this._name);
				}
			}
			catch(GLib.Error e)
			{
				stderr.printf("ERROR LOADING RESOURCE: %s\n", e.message);
			}
		}
		public Builder GetGladeUi(string ui_file)
		{
			
			size_t ui_size;
			uint32 flags;
			
			this.res_data.get_info("%s/ui/%s".printf(this.resourceNs, ui_file), 
									ResourceLookupFlags.NONE, 
									out ui_size,
									out flags);
									
			InputStream ui_stream = this.GetInputStream("ui/%s".printf(ui_file));						
			
			uint8[] data = new uint8[ui_size];
			size_t length;
			ui_stream.read_all(data, out length);
			
			var gui = new Builder();
			gui.add_from_string((string)data, length);
			
			return gui;
		}
		public InputStream GetInputStream(string file)
		{
			return this.res_data.open_stream("%s/%s".printf(this.resourceNs, file), 
															ResourceLookupFlags.NONE);
		}
		public Gdk.Pixbuf GetPixbuf(string image, int width = 0, int height = 0)
		{
			var input_stream = this.GetInputStream("images/%s".printf(image));
			
			if( width > 0 && height > 0 )
			{
				var pixbuf = new Gdk.Pixbuf.from_stream(input_stream);
				pixbuf = pixbuf.scale_simple(width, height, Gdk.InterpType.BILINEAR);
				
				return pixbuf;
			}
			return new Gdk.Pixbuf.from_stream(input_stream);
		}
		public string[] GetSQLFromResource(string sql_file)
		{
			var istream 	= this.GetInputStream(sql_file);
			var ds 			= new DataInputStream(istream);
			string sql 		= "";
			string? line 	= "";
			while( (line = ds.read_line()) != null )
			{
				sql += line;
			}
			
			string[] queries = sql.split(";");
			
			return queries;
		}
	}
}
