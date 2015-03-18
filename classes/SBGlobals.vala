using GLib;
using Gee;

namespace SinticBolivia
{
	public class SBGlobals : Object
	{
		protected static HashMap _vars = null;
		
		protected SBGlobals(){}
		public static void SetVar(string key, Object data)
		{
			
			if( SBGlobals._vars == null)
			{
				SBGlobals._vars = new HashMap<string,Object>();
				//var vars = new HashMap<string,Object>();
			}
			
			if( (SBGlobals._vars as HashMap<string,Object>).has_key(key) )
			{
				(SBGlobals._vars as HashMap<string,Object>)[key] = data;
			}
			else
			{
				(SBGlobals._vars as HashMap<string,Object>).set(key, data);
			}
			
		}
		public static Object GetVar(string key)
		{
			if( (SBGlobals._vars as HashMap<string,Object>).has_key(key) )
			{
				return (Object)(SBGlobals._vars as HashMap<string,Object>)[key];
			}
			return (Object)null;
		}
	}
}
