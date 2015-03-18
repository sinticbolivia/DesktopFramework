using GLib;

namespace SinticBolivia
{
	public interface ISBModule : Object
	{
		public abstract string Id{get;}
		public abstract string Name{get;}
		public abstract string Description{get;}
		public abstract string LibraryName{get;}
		public abstract string Author{get;}
		public abstract double Version{get;}
		
		public abstract void Enabled();
		public abstract void Disabled();
		public abstract void Init();
		public abstract void Load();
		public abstract void Unload();
	}
}
