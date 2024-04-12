using GLib;
using Gee;
using SinticBolivia;
using SinticBolivia.Classes;

namespace SinticBolivia.Database
{
	public string row_array_to_json(ArrayList<SBDBRow> rows)
	{
		if( rows.size <= 0 )
			return "[]";

		string json = "[";
		foreach(var row in rows)
		{
			json += row.to_json() + ",";
		}
		json = ((string)json.substring(0, json.length - 1)) + "]";

		return json;
	}
	public delegate SBObject InstanceFactory(SBDatabase dbh);

	public abstract class SBDatabase : GLib.Object
	{
		protected	string		_databaseType = "";
		protected	SBDBRow[]	_rows;
		public		long		LastInsertId = 0;
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

		public		abstract	SBDBTable get_table(string name);
		public		abstract	ArrayList<SBDBTable> show_tables();
		public 		abstract 	bool Open() throws SBDatabaseException;
		public 		abstract 	bool Close();
		public 		abstract	void SelectDb(string db_name);
		public 		abstract 	long Query(string? query = null) throws SBDatabaseException;
		public		abstract	SBDBRow? GetRow(string? query);
		public		abstract	ArrayList<SBDBRow> GetResults(string? query);
		public 		abstract 	long Execute(string sql) throws SBDatabaseException;
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
			string primary_key = "";
			if( obj is Entity )
			{
				primary_key = (obj as Entity).get_primary_key().strip().length > 0 ?
					(obj as Entity).get_primary_key() : "";
			}
			foreach(ParamSpec prop in obj.getProperties())
			{
				Value? val = obj.getPropertyValue(prop.name);
				string column_name = prop.name.replace("-", "_");

				if( column_name in exclude )
					continue;

				//stdout.printf("Property %s is %s\n", prop.name, prop.value_type.name());
				//stdout.printf("Property %s is %s\n", prop.name, prop.value_type.is_object() ? "Object" : "Non Object");
				if( prop.get_blurb() == "PRIMARY_KEY" || column_name == primary_key )
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
				data.set(column_name, val);
			}
			return this.Insert(table, data);
		}
		public virtual long updateObject(string table, SBObject obj, string[] exclude = {}) throws SBException
		{
			var data = new HashMap<string, Value?>();
			string pk_column = (obj is Entity) ? (obj as Entity).get_primary_key() : "";
			Value? pk_value = null;
			if( pk_column.strip().length <= 0 )
				throw new SBException.GENERAL("Unable to update, the object has no primary key");
			foreach(ParamSpec prop in obj.getProperties())
			{
				string column_name = prop.name.replace("-", "_");
				if( column_name in exclude )
					continue;

				Value? val = obj.getPropertyValue(prop.name);
				if( prop.get_blurb() == "PRIMARY_KEY" || column_name == pk_column )
				{
					pk_column = column_name;
					pk_value = val;
					continue;
				}
				data.set(column_name, val);
			}

			var wheres = new HashMap<string, Value?>();
			wheres.set(pk_column, pk_value);
			this.Update(table, data, wheres);
			return 0;
		}
		/**
		*  Insert a row into table
		*/
		public virtual long Insert(string table, HashMap<string, Value?> data) throws SBDatabaseException
		{
			if( data.size <= 0 )
				return 0;
			string query = @"INSERT INTO $table(%s) VALUES(%s)";
			string cols = "";
			string values = "";
			foreach(string key in data.keys)
			{
				cols += "%s,".printf(this.prepare_column(key));
				values += "%s,".printf(this.prepare_column_value(data.get(key)));
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
				query += "%s = %s,".printf(
					this.prepare_column(key),
					this.prepare_column_value(data.get(key))
				);
			}
			//##build where
			foreach(string key in w.keys)
			{
				where_str += "%s = %s AND ".printf(
					this.prepare_column(key),
					this.prepare_column_value(w.get(key))
				);
			}
			query 		= query.substring(0, query.length - 1);
			where_str 	= where_str.substring(0, where_str.length - 4);
			//print("UPDATE QUERY: %s\n", query + where_str);
			this.LastQuery = query + where_str;
			this.Execute(query + where_str);
		}
		public virtual void Delete(string table, HashMap<string, Value?> w)
		{
			string query = "DELETE FROM %s WHERE ".printf(table);
			//##build where
			foreach(string key in w.keys)
			{
				query += "%s = %s AND ".printf(
					this.prepare_column(key),
					this.prepare_column_value(w.get(key))
				);
			}
			query = query.substring(0, query.length - 4);
			this.LastQuery = query;
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
		public virtual string prepare_column(string column)
		{
			string pc = column;
			string? function = null;
			string aux = "";
			if( column.index_of("(") != -1 )
			{
				string pattern = """(?P<function>\w+)\s*\((?P<column>[0-1A-Za-z_\.]+)\)(?P<aux>.*)""";
				MatchInfo info;
				if( new Regex(pattern).match(column, RegexMatchFlags.ANCHORED, out info) )
				{
					function  = info.fetch_named("function");
					pc = info.fetch_named("column");
					aux = info.fetch_named("aux");
				}
				//var parts = column.split("(");
				//function = parts[0].strip();
				//pc = parts[1].replace(")", "").strip();
			}
			if( pc.index_of(".") != -1 )
			{
				string[] parts = pc.split(".");
				pc = "%s%s%s.%s%s%s".printf(
					this.columnLeftWrap, parts[0], this.columnRightWrap,
					this.columnLeftWrap, parts[1], this.columnRightWrap
				);
			}
			else
			{
				pc = "%s%s%s".printf(this.columnLeftWrap, pc, this.columnRightWrap);
			}
			if( function != null )
				pc = "%s(%s)%s".printf(function, pc, aux);
			return pc;
		}
		public virtual string prepare_column_value(Value? val)
		{
			//stdout.printf("%s => %s\n", val.strdup_contents(), val.type_name());
			if( val.strdup_contents() == "NULL" )
				return "NULL";
			var integers = new ArrayList<Type>();
			integers.add_all_array(new Type[]{
				typeof(int), typeof(uint),
				typeof(long), typeof(ulong),
				typeof(int64), typeof(uint64)
			});
			var floats = new ArrayList<Type>();
			integers.add_all_array(new Type[]{typeof(float), typeof(double)});

			if( integers.contains( val.type() ) )
			{
				Value str_int = Value(typeof(string));
				val.transform(ref str_int);
				return (string)str_int;
			}
			else if( floats.contains( val.type() ) )
			{
				//Value str = Value(typeof(string));
				//val.transform(ref str_int);
				return val.type() == typeof(float) ?
					"%.2f".printf((float)val) :
					"%.2lf".printf((double)val);
			}
			else if( val.type() == typeof(SBDateTime) || val.type() == typeof(DateTime) )
			{
				return val.type() == typeof(DateTime) ?
					((DateTime)val).format("'%Y-%m-%d %H:%M:%S'") :
					((SBDateTime)val).format("'%Y-%m-%d %H:%M:%S'");
			}
			else if( val.type() == typeof(Object) )
			{
				string json = "";
				if( val.type() == typeof(SBSerializable) )
				{
					json = ((SBSerializable)val).to_json();
				}
				else
				{
					size_t len;
					json = Json.gobject_to_data((Object)val, out len);
				}
				return "'%s'".printf(json);
			}
			return (string)val == "''" ? "''" : "'%s'".printf(this.EscapeString((string)val));
		}
	}
}
