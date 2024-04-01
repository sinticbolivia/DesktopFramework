using GLib;
using Gee;
using SinticBolivia;

namespace SinticBolivia.Database
{
	public class SBDBTable
	{
		public	string		name;
		public	string		comments;
		public	ArrayList	columns;
		public	string		primary_key 
		{
			owned get
			{
				string name = "";
				foreach(var col in (ArrayList<SBDBColumn>)this.columns)
				{
					if( col.is_key )
					{
						name = col.name;
						break;
					}
				}
				return name;
			}
		}
		
		public SBDBTable()
		{
			this.columns = new ArrayList<SBDBColumn>();
		}
		public bool has_column(string name)
		{
			bool found = false;
			foreach(var column in (ArrayList<SBDBColumn>)this.columns)
			{
				if( column.name == name )
				{
					found = true;
					break;
				}
			}
			return found;
		}
		public SBDBColumn? get_column(string col_name)
		{
			SBDBColumn? found = null;
			foreach(var column in (ArrayList<SBDBColumn>)this.columns)
			{
				if( column.name == col_name )
				{
					found = column;
					break;
				}
			}
			return found;
		}
		public HashMap<string, Value?> json_object_2_hashmap(Json.Object obj)
		{
			var data = new HashMap<string, Value?>();
			foreach(var column in (ArrayList<SBDBColumn>)this.columns)
			{
				if( !obj.has_member(column.name) )
				{
					//stdout.printf("Member not found: %s\n", column.name);
					continue;
				}
				if( column.type == CellType.BIGINT || column.type == CellType.UBIGINT 
					|| column.type == CellType.INT || column.type == CellType.UINT
					|| column.type == CellType.LONG || column.type == CellType.ULONG
				)
				{
					//destObject.set(column.name, obj.get_int_member(column.name), null);
					data.set(column.name, obj.get_int_member(column.name));
				}
				else if( column.type == CellType.FLOAT || column.type == CellType.UFLOAT 
					|| column.type == CellType.LONG || column.type == CellType.ULONG
					|| column.type == CellType.DOUBLE || column.type == CellType.UDOUBLE
				)
				{
					data.set(column.name, obj.get_double_member(column.name));
				}
				else if( column.type == CellType.DATETIME )
				{
					//destObject.set(column.name, SBDateTime.parseDbDateTime(obj.get_string_member(column.name)), null);
					data.set(column.name, SBDateTime.parseDbDateTime(obj.get_string_member(column.name)));
				}
				else
				{
					//destObject.set(column.name, obj.get_string_member(column.name), null);
					data.set(column.name, obj.get_string_member(column.name));
				}
			}
			return data;
		}
		public HashMap<string, Value?> json_2_hashmap(string json)
		{
			size_t size;
			try
			{
				var parser = new Json.Parser();
				parser.load_from_data(json);
				var obj = parser.get_root().get_object();
				//var destObject = new SBObject();
				return this.json_object_2_hashmap(obj);
				//string n_json = Json.gobject_to_data(destObject, out size);
				//stdout.printf(n_json);
			}
			catch(Error e)
			{
				stderr.printf("ERROR DESERIALIZING JSON OBJECT: %s\n", e.message);
			}
			return null;
		}
		public SBDBRow? get_single_by(string column, string val, ...)
		{
			string query = "SELECT * FROM %s WHERE 1 = 1 ".printf(this.name);
			var db_column = this.get_column(column);
			if( db_column != null )
			{
				query += "AND %s = %s ".printf(column, db_column.format_data(val));
			}
			query += "LIMIT 1";
			
			var dbh = SBFactory.getDbh();
			return dbh.GetRow(query);
		}
	}
}
