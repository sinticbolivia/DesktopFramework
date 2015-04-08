using GLib;
using Gee;
using SinticBolivia.Database;

namespace SinticBolivia
{
	public class SBParameter : Object
	{
		public static string Get(string parameter, SBDatabase? _dbh = null)
		{
			var dbh = (_dbh != null) ? _dbh : (SBDatabase)SBGlobals.GetVar("dbh");
			dbh.Select("*").From("parameters").Where("key = '%s'".printf(parameter));
			var row = dbh.GetRow(null);
			
			if( row == null )
				return "";
			
			return row.Get("value");
			
		}
		public static void Update(string parameter, string parameter_value, SBDatabase? _dbh = null)
		{
			var dbh = (_dbh != null) ? _dbh : (SBDatabase)SBGlobals.GetVar("dbh");
			
			var data = new HashMap<string, Value?>();
			data.set("key", parameter);
			data.set("value", parameter_value);
			if( SBParameter.Get(parameter) == "" )
			{
				dbh.Insert("parameters", data);
				return;
			}
			var where = new HashMap<string, Value?>();
			where.set("key", parameter);
			dbh.Update("parameters", data, where);
		}
	}
}
