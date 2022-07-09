using GLib;
using Gee;

namespace SinticBolivia
{
	public class SBGlobals : Object
	{
		protected static HashMap<string, Object> _vars = null;
		protected static HashMap<string, Value?>	values;
		
		protected SBGlobals(){}
		public static void SetVar(string key, Object data)
		{
			
			if( SBGlobals._vars == null)
			{
				SBGlobals._vars = new HashMap<string, Object>();
				//var vars = new HashMap<string,Object>();
			}
			
			if( SBGlobals._vars.has_key(key) )
			{
				SBGlobals._vars[key] = data;
			}
			else
			{
				SBGlobals._vars.set(key, data);
			}
			
		}
		public static Object GetVar(string key)
		{
			if( SBGlobals._vars.has_key(key) )
			{
				return (Object)SBGlobals._vars[key];
			}
			return (Object)null;
		}
		public static void SetValue(string key, Value? the_value)
		{
			if( SBGlobals.values == null )
			{
				SBGlobals.values = new HashMap<string, Value?>();
			}
			if( SBGlobals.values.has_key(key) )
			{
				SBGlobals.values[key] = the_value;
				return;
			}
			SBGlobals.values.set(key, the_value);
		}
		public static Value? GetValue(string key)
		{
			if( SBGlobals.values == null )
			{
				return null;
			}
			
			if( !SBGlobals.values.has_key(key) )
			{
				return null;
			}
			return SBGlobals.values[key];
		}
	}
}
