using GLib;
using Gee;
using SinticBolivia.Database;

namespace SinticBolivia
{
	public class SBMeta : Object
	{
		public static long AddMeta(string table, string meta_key, string object_id_col, 
							long object_id, Value meta_value)
		{
			var dbh = (SBDatabase)SBGlobals.GetVar("dbh");
			string query = @"INSERT INTO $table (meta_key, meta_value, $object_id_col, creation_date) ";
			query += "VALUES('%s', '%s', %ld, '%s')".printf(meta_key, (string)meta_value, object_id, new DateTime.now_local().format("%Y-%m-%d %H:%M:%S"));
			
			return dbh.Query(query);
		}
		public static void DeleteMeta(string table, string meta_key, string object_id_col, long object_id)
		{
			var dbh = (SBDatabase)SBGlobals.GetVar("dbh");
			string query = @"DELETE FROM $table WHERE meta_key = '$meta_key' AND $object_id_col = %ld";
			query = query.printf(object_id);
			dbh.Execute(query);
		}
		public static SBDBRow? GetMetaRow(string table, string meta_key, string object_id_col, long object_id)
		{
			var dbh = (SBDatabase)SBGlobals.GetVar("dbh");
			string query = @"SELECT * FROM $table WHERE meta_key = '$meta_key' AND $object_id_col = $object_id";
						
			return dbh.GetRow(query);
		}
		public static string GetMeta(string table, string meta_key, string object_id_col, long object_id)
		{
			var row = SBMeta.GetMetaRow(table, meta_key, object_id_col, object_id);
			if( row == null )
				return "";
			return row.Get("meta_value");
		}
		public static bool UpdateMeta(string table, string meta_key, string meta_value, string object_id_col, long object_id)
		{
			var dbh = (SBDatabase)SBGlobals.GetVar("dbh");
			if( SBMeta.GetMetaRow(table, meta_key, object_id_col, object_id) == null )
			{
				SBMeta.AddMeta(table, meta_key, object_id_col, object_id, meta_value);
				return true;
			}
			string query = @"UPDATE $table SET meta_value = '$meta_value' WHERE meta_key = '$meta_key' AND ";
			query += @"$object_id_col = $object_id";
			dbh.Execute(query);
			
			return true;
		}
	}
}
