using GLib;
using Gee;
using SinticBolivia;

namespace SinticBolivia.Database
{
	public delegate SBObject InstanceFactory(SBDatabase dbh);

	public abstract class SBDatabase : GLib.Object 
	{
		protected	string		_databaseType = "";
		protected	SBDBRow[]	_rows;
		public		int			LastInsertId = 0;
		public 		string 		LastQuery = "";
		protected	string		columnLeftWrap = "";
		protected	string		columnRightWrap = "";
		protected	string		builtQuery = "";
		
		/**
		 * Properties
		 */
		public SBDBRow[] Rows
		{
			get
			{
				return this._rows;
			}
			set
			{
				this._rows = value;
			}
		}
		public	string Engine
		{
			get{return this._databaseType;}
			protected set{this._databaseType = value;}
		}
		
		
		
		public 		abstract 	bool Open();
		public 		abstract 	bool Close();
		public 		abstract	void SelectDb(string db_name);
		public 		abstract 	long Query(string? query = null);
		public		abstract	SBDBRow? GetRow(string? query);
		public		abstract	ArrayList<SBDBRow> GetResults(string? query);
		public 		abstract 	long Execute(string sql);
		public		abstract	void BeginTransaction();
		public		abstract	void EndTransaction();
		public		abstract	ArrayList<T> getObjects<T>(string? query, InstanceFactory? factory = null);
		public		abstract	T getObject<T>(string? query);
		public		HashMap<string, string> getObjectKeys(SBObject obj)
		{
			var data = new HashMap<string, string>();
			int fk_count = 0;
			foreach(ParamSpec prop in obj.getProperties())
			{
				string column_name = prop.name.replace("-", "_");
				if( prop.get_blurb() == "PRIMARY_KEY" )
				{
					data.set("primary_key", column_name);
					continue;
				}
				if( prop.get_blurb() == "FOREIGN_KEY" )
				{
					data.set("primary_key_%d".printf(fk_count), column_name);
					fk_count++;
					continue;
				}
			}
			return data;
		}
		public virtual HashMap<string, Value?> objectToHashMap(SBObject obj)
		{
			var data = new HashMap<string, Value?>();
			foreach(ParamSpec prop in obj.getProperties())
			{
				Value? val 			= obj.getPropertyValue(prop.name);
				string column_name 	= prop.name.replace("-", "_");
				
				if( prop.value_type == typeof(DateTime) )
				{
					//stdout.printf("Property %s is %s (DateTime)\n", prop.name, prop.value_type.name());
					var dateVal = Value(typeof(string));
					if( (val as DateTime) != null )
					{
						string datetime = (val as DateTime).format("%Y-%m-%d %H:%M:%S");
						//stdout.printf("Property value %s\n", datetime);
						dateVal.set_string(datetime);
					}
					else
					{
						dateVal.set_string("NULL");
					}
					data.set(column_name, dateVal);
					continue;
				}
				//else if( prop.value_type == typeof(Object) )
				else if( prop.value_type.is_object() )
				{
					Json.Node root_node = Json.gobject_serialize((Object)val);
					Json.Generator generator = new Json.Generator();
					generator.set_root(root_node);
					string obj_json = generator.to_data(null);
					//print("%s => OBJ_JSON: %s\n", column_name, obj_json);
					data.set(column_name, obj_json);
					continue;
				}
				if( val == null )
				{
					//continue;
					data.set(column_name, "NULL");
					continue;
				}
				
				data.set(column_name, val);
			}
			return data;
		}
		public virtual long insertObject(string table, SBObject obj, string[] exclude = {})
		{
			var data = new HashMap<string, Value?>();
			
			foreach(ParamSpec prop in obj.getProperties())
			{
				Value? val = obj.getPropertyValue(prop.name);
				string column_name = prop.name.replace("-", "_");
				
				if( column_name in exclude )
					continue;
				
				//stdout.printf("Property %s is %s\n", prop.name, prop.value_type.name());
				//stdout.printf("Property %s is %s\n", prop.name, prop.value_type.is_object() ? "Object" : "Non Object");
				if( prop.get_blurb() == "PRIMARY_KEY" )
				{
					if( prop.value_type == typeof(int64) && (int64)val <= 0)
						continue;
					if( prop.value_type == typeof(uint64) && (uint64)val <= 0)
						continue;
					if( prop.value_type == typeof(long) && (long)val <= 0)
						continue;
					if( prop.value_type == typeof(ulong) && (ulong)val <= 0)
						continue;
					if( prop.value_type == typeof(int) && (int)val <= 0)
						continue;
					if( prop.value_type == typeof(uint) && (uint)val <= 0)
						continue;
					
				}
				if( prop.value_type == typeof(DateTime) )
				{
					//stdout.printf("Property %s is %s (DateTime)\n", prop.name, prop.value_type.name());
					var dateVal = Value(typeof(string));
					if( (val as DateTime) != null )
					{
						string datetime = (val as DateTime).format("%Y-%m-%d %H:%M:%S");
						//stdout.printf("Property value %s\n", datetime);
						dateVal.set_string(datetime);
					}
					else
					{
						dateVal.set_string("NULL");
					}
					data.set(column_name, dateVal);
					continue;
				}
				//else if( prop.value_type == typeof(Object) )
				else if( prop.value_type.is_object() )
				{
					Json.Node root_node = Json.gobject_serialize((Object)val);
					Json.Generator generator = new Json.Generator();
					generator.set_root(root_node);
					string obj_json = generator.to_data(null);
					//print("%s => OBJ_JSON: %s\n", column_name, obj_json);
					data.set(column_name, obj_json);
					continue;
				}
				if( val == null )
				{
					//continue;
					data.set(column_name, "NULL");
					continue;
				}
				
				data.set(column_name, val);
			}
			return this.Insert(table, data);
		}
		public virtual long updateObject(string table, SBObject obj, string[] exclude = {}) throws SBException
		{
			var data = new HashMap<string, Value?>();
			string pk_column = "";
			Value? pk_value = null;
			
			foreach(ParamSpec prop in obj.getProperties())
			{
				string column_name = prop.name.replace("-", "_");
				if( column_name in exclude )
					continue;
					
				Value? val = obj.getPropertyValue(prop.name);
				if( prop.get_blurb() == "PRIMARY_KEY" )
				{
					pk_column = column_name;
					pk_value = val;
					continue;
				}
				if( prop.value_type == typeof(DateTime) )
				{
					//var dateVal = Value(typeof(string));
					//stdout.printf("Property %s is DateTime\n", prop.name);
					string datetime = ( (val as DateTime) != null ) ? (val as DateTime).format("%Y-%m-%d %H:%M:%S") : "NULL";
					//stdout.printf("Property value %s\n", datetime);
					//val.set_string(datetime);
					data.set(column_name, datetime);
					continue;
				}
				else if( prop.value_type.is_object() )
				{
					Json.Node root_node = Json.gobject_serialize((Object)val);
					Json.Generator generator = new Json.Generator();
					generator.set_root(root_node);
					string obj_json = generator.to_data(null);
					data.set(column_name, obj_json);
					continue;
				}
				data.set(column_name, val == null ? "NULL" : val);
			}
			if( pk_column.strip().length <= 0 )
				throw new SBException.GENERAL("Unable to update, the object has no primary key");
				
			var wheres = new HashMap<string, Value?>();
			wheres.set(pk_column, pk_value);
			this.Update(table, data, wheres);
			return 0;
		}
		/**
		*  Insert a row into table
		*/
		public virtual long Insert(string table, HashMap<string, Value?> data)
		{
			if( data.size <= 0 )
				return 0;
				
			string query = @"INSERT INTO $table(%s) VALUES(%s)";
			string cols = "";
			string values = "";
			foreach(string key in data.keys)
			{
				cols += "%s%s%s,".printf(this.columnLeftWrap, key, this.columnRightWrap);
				//##build values
				string gtype = data.get(key).type_name();
							
				if( gtype == "gint" )
				{
					values += "%d,".printf((int)data.get(key));
				}
				else if( gtype == "guint" )
				{
					values += "%u,".printf((uint)data.get(key));
				}
				else if( gtype == "glong" )
				{
					values += "%ld,".printf((long)data.get(key));
				}
				else if( gtype == "gulong" )
				{
					values += "%lu,".printf((ulong)data.get(key));
				}
				else if( gtype == "gint64" )
				{
					//string format = "%"+int64.FORMAT+",";
					values += "%s,".printf(data.get(key).get_int64().to_string());
				}
				else if( gtype == "gfloat" )
				{
					values += "%.2f,".printf((float)data.get(key));
				}
				else if( gtype == "gdouble" )
				{
					values += "%.2lf,".printf(data.get(key).get_double());
				}
				else if( gtype == "gchararray" )
				{
					if( (string)data.get(key) == "NULL" || (string)data.get(key) == "null" )
					{
						values += "NULL,";
					}
					else
					{
						values += "'%s',".printf(this.EscapeString((string)data.get(key)));
					}
				}
				else
				{
					values += "'%s',".printf(this.EscapeString((string)data.get(key)));
				}
				
			}
			cols 	= cols.substring(0, cols.length - 1);
			values 	= values.substring(0, values.length - 1);
			query 	= query.printf(cols, values);
			//stdout.printf("LAST QUERY: %s\n", query);
			this.LastQuery = query;
			this.Execute(query);
			return this.LastInsertId;
		}
		public virtual void Update(string table, HashMap<string, Value?> data, HashMap<string, Value?> w)
		{
			string query = @"UPDATE $table SET ";
			string where_str = " WHERE ";
			
			foreach(string key in data.keys)
			{
				query += "%s%s%s = ".printf(this.columnLeftWrap, key, this.columnRightWrap);
				//##build values
				string gtype = data.get(key).type_name();
								
				if( gtype == "gint" )
				{
					query += "%d,".printf((int)data.get(key));
				}
				else if( gtype == "guint" )
				{
					where_str += "%u AND ".printf((uint)w.get(key));
				}
				else if( gtype == "glong" )
				{
					query += "%ld,".printf((long)data.get(key));
				}
				else if( gtype == "gulong" )
				{
					where_str += "%lu AND ".printf((ulong)w.get(key));
				}
				else if( gtype == "gint64" )
				{
					//string format = "%"+int64.FORMAT+",";
					query += "%s,".printf(data.get(key).get_int64().to_string());
				}
				else if( gtype == "gfloat" )
				{
					query += "%.2f,".printf((float)data.get(key));
				}
				else if( gtype == "gdouble" )
				{
					query += "%.2lf,".printf(data.get(key).get_double());
				}
				else if( gtype == "gchararray" )
				{
					if( (string)data.get(key) == "NULL" || (string)data.get(key) == "null" )
						query += "NULL,";
					else
						query += "'%s',".printf(this.EscapeString((string)data.get(key)));
				}
				else
				{
					query += "'%s',".printf(this.EscapeString((string)data.get(key)));
				}
			}
			query = query.substring(0, query.length - 1);
			//##build where
			foreach(string key in w.keys)
			{
				where_str += "%s%s%s = ".printf(this.columnLeftWrap, key, this.columnRightWrap);
				//##build values
				string gtype = w.get(key).type_name();
							
				if( gtype == "gint" )
				{
					where_str += "%d AND ".printf((int)w.get(key));
				}
				else if( gtype == "guint" )
				{
					where_str += "%u AND ".printf((uint)w.get(key));
				}
				else if( gtype == "glong" )
				{
					where_str += "%ld AND ".printf((long)w.get(key));
				}
				else if( gtype == "gulong" )
				{
					where_str += "%lu AND ".printf((ulong)w.get(key));
				}
				else if( gtype == "gint64" )
				{
					//string format = "%"+int64.FORMAT+",";
					where_str += "%s AND ".printf(w.get(key).get_int64().to_string());
				}
				else if( gtype == "gfloat" )
				{
					where_str += "%.2f AND ".printf((float)w.get(key));
				}
				else if( gtype == "gdouble" )
				{
					where_str += "%.2lf AND ".printf(w.get(key).get_double());
				}
				else if( gtype == "gchararray" )
				{
					where_str += "'%s' AND ".printf(this.EscapeString((string)w.get(key)));
				}
				else
				{
					where_str += "'%s' AND ".printf(this.EscapeString((string)w.get(key)));
				}
			}
			where_str = where_str.substring(0, where_str.length - 4);
			//print("UPDATE QUERY: %s\n", query + where_str);
			this.Execute(query + where_str);
		}
		public virtual void Delete(string table, HashMap<string, Value?> w)
		{
			string query = "DELETE FROM %s ".printf(table);
			//##build where
			foreach(string key in w.keys)
			{
				query += "%s%s%s = ".printf(this.columnLeftWrap, key, this.columnRightWrap);
				
				//##build values
				string gtype = w.get(key).type_name();
								
				if( gtype == "gint" )
				{
					query += "%d AND ".printf((int)w.get(key));
				}
				else if( gtype == "glong" )
				{
					query += "%ld AND ".printf((long)w.get(key));
				}
				else if( gtype == "gint64" )
				{
					//string format = "%"+int64.FORMAT+",";
					query += "%s AND ".printf(w.get(key).get_int64().to_string());
				}
				else if( gtype == "gfloat" )
				{
					query += "%.2f AND ".printf((float)w.get(key));
				}
				else if( gtype == "gdouble" )
				{
					query += "%.2lf AND ".printf(w.get(key).get_double());
				}
				else if( gtype == "gchararray" )
				{
					query += "'%s' AND ".printf((string)w.get(key));
				}
				else
				{
					query += "'%s' AND ".printf((string)w.get(key));
				}
			}
			query = query.substring(0, query.length - 4);
			this.Execute(query);
		}
		public virtual string FormatColumns(string columns)
		{
			if( columns.strip() == "*" )
				return columns;
			
			string formated = "";
			string[] cols = columns.strip().split(",");
			
			for(int i = 0; i < cols.length; i++)
			{
				if( cols[i].index_of(".") != -1 )
				{
					string[] parts = cols[i].strip().split(".");
					if( parts[1].strip() == "*" )
					{
						formated += "%s%s%s.*,".printf(this.columnLeftWrap, parts[0], this.columnRightWrap);
					}
					else
					{
						formated += "%s%s%s.%s%s%s,".printf(this.columnLeftWrap, parts[0], this.columnRightWrap, 
														this.columnLeftWrap, parts[1], this.columnRightWrap);
					}
					
				}
				else
				{
					if( cols[i].index_of("*") == -1 )
					{
						formated += "%s%s%s,".printf(this.columnLeftWrap, cols[i], this.columnRightWrap);
					}
					else
						formated += cols[i] + ",";
				}
			}
			return formated.substring(0, formated.length - 1);
		}
		public virtual string FormatCondition(string condition)
		{
			string formated = "";
			string sep = "";
			if( condition.index_of("=") != -1 )
			{
				sep = "=";
			}
			else if( condition.index_of("<") != -1 )
			{
				sep = "<";
			}
			else if( condition.index_of(">") != -1 )
			{
				sep = ">";
			}
			else if( condition.index_of("<=") != -1 )
			{
				sep = "<=";
			}
			else if( condition.index_of(">=") != -1 )
			{
				sep = ">=";
			}
			else if( condition.index_of("<>") != -1 )
			{
				sep = "<>";
			}
			
			string[] parts = condition.strip().split(sep);
			formated = "%s = %s".printf(this.FormatColumns(parts[0].strip()), parts[1].strip());
			return formated;
		}
		public virtual string FormatTables(string tables)
		{
			string formated = "";
			string[] n_tables = tables.strip().split(",");
			
			for(int i = 0; i < n_tables.length; i++)
			{
				if( n_tables[i].strip().index_of(" ") != 1 )
				{
					string[] parts = n_tables[i].strip().split(" ");
					formated += "%s%s%s %s,".printf(this.columnLeftWrap, parts[0], this.columnRightWrap, parts[1] != null ? parts[1] : "");
				}
				else
				{
					formated += "%s%s%s,".printf(this.columnLeftWrap, n_tables[i], this.columnRightWrap);
				}
			}
			return formated.substring(0, formated.length - 1);
		}
		public virtual SBDatabase Select(string columns)
		{
			this.builtQuery = "SELECT %s ".printf(this.FormatColumns(columns));
			
			return this;
		}
		public virtual SBDatabase From(string tables)
		{
			this.builtQuery += "FROM %s ".printf(this.FormatTables(tables));
			
			return this;
		}
		public virtual SBDatabase Where(string cond)
		{
			this.builtQuery += "WHERE %s ".printf(this.FormatCondition(cond));
			
			return this;
		}
		public virtual SBDatabase And(string cond)
		{
			this.builtQuery += "AND %s ".printf(this.FormatCondition(cond));
			return this;
		}
		public virtual SBDatabase Or(string cond)
		{
			this.builtQuery += "OR %s ".printf(this.FormatCondition(cond));
			return this;
		}
		public virtual SBDatabase OrderBy(string col, string desc_asc = "ASC")
		{
			this.builtQuery += "ORDER BY %s %s ".printf(col.strip(), desc_asc.strip());
			
			return this;
		}
		public virtual SBDatabase LeftJoin(string table)
		{
			this.builtQuery += "LEFT JOIN %s ".printf(this.FormatTables(table.strip()));
			
			return this;
		}
		public virtual SBDatabase On(string on)
		{
			this.builtQuery += "ON %s ".printf(this.FormatCondition(on.strip()));
			
			return this;
		}
		public virtual string EscapeString(string? str)
		{
			string striped = "";
			if( str == null )
				return striped;
			try
			{
				//var regex = new Regex("[']");
				//var regex = new Regex("'");
				//striped = regex.replace(str.strip(), str.strip().length, 0, "\\'");
				striped = str.replace("'", "\\'");
			}
			catch(RegexError e)
			{
				stderr.printf("RRROR: %s\n", e.message);
				striped = str.strip();
			}
			return striped;
		}
	}

}

