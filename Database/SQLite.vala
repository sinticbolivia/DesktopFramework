using GLib;
using Sqlite;
using Gee;
using SinticBolivia;

namespace SinticBolivia.Database
{
	public class SBSQLite : SBDatabase
	{
		protected 	string _dbFile = "";
		protected 	Sqlite.Database _db;
		protected	Statement		stmt;
		
		//protected static ArrayList _results;
		//protected static SBDBRow[] _results;
		
		public SBSQLite(string db_file = "")
		{
			this._databaseType = "sqlite3";
			this.columnLeftWrap = "[";
			this.columnRightWrap = "]";
			this._dbFile = SinticBolivia.SBFileHelper.SanitizePath(db_file.strip());
			Sqlite.config(Sqlite.Config.MULTITHREAD);
		}
		public override bool Open()
		{
			int res = Sqlite.Database.open(this._dbFile, out this._db);
			if( res != Sqlite.OK )
			{
				stderr.printf("Can't open database: %s (%d)", this._db.errmsg(), res);
				return false;
			}
			
			return true;
		}
		public override bool Close()
		{
			return true;
		}
		public override void SelectDb(string db_name)
		{
			//this.databaseName = db_name;
			//this.dbh.select_db(this.databaseName);
		}
		public override void BeginTransaction()
		{
			this.Execute("BEGIN");
		}
		public override void EndTransaction()
		{
			this.Execute("END TRANSACTION");
		}
		public override long Query(string? query = null) throws SBDatabaseException
		{
			this.stmt = null;
			//Statement stmt;
			//string error = "";
			string q = query != null ? query : this.builtQuery;
			int res = this._db.prepare_v2(q, -1, out this.stmt, null);
			if( res != Sqlite.OK )
			{
				stderr.printf("SQLite Query Error: %s, QUERY WAS:%s\n", this._db.errmsg (), q);
				throw new SBDatabaseException.GENERAL(this._db.errmsg());
				return 0;
			}
			//this.stmt = null;
			
			return 0;
			
		}
		public override ArrayList<T> getObjects<T>(string? query, InstanceFactory? factory = null)
		{
			Gee.ArrayList<T> results = new Gee.ArrayList<T>();
			if( query != null )
				this.Query(query);
			int cols = this.stmt.column_count();
			int res = 0;
			do 
			{
				res = this.stmt.step();
				switch (res) 
				{
					case Sqlite.DONE:
						break;
					case Sqlite.ROW:
						T obj = factory != null ? factory(this) : (T)Object.new(typeof(T));
						//T obj = (T)Object.new(typeof(T));
						results.add(obj);
						//GLib.Value[] objValues = new GLib.Value[cols];
						//string[] objProps = new string[cols];
						
						for (int col = 0; col < cols; col++) 
						{
							string column_name 		= stmt.column_name(col);
							string? column_value 	= stmt.column_text(col);
							if( Sqlite.NULL == stmt.column_type(col) )
							{
								//print("%s => NULL\n", column_name);
								continue;
							}
							//GLib.Value pv = GLib.Value(typeof(string));
							//pv.set_string(column_value);
							//objProps[col] = column_name;
							//objValues[col] = pv;
							
							ParamSpec? spec;
							if( (obj as SBObject).propertyExists(column_name, out spec) )
							{
								if( spec.value_type == typeof(DateTime) )
								{
									if( column_value.strip().length > 0 )
									{
										//print("DATETIME column found: %s => %s\n", spec.name, column_value);
										DateTime datetime = SBDateTime.parseDbDateTime(column_value);
										if( datetime != null )
										{
											//print("VALUE: %s\n", datetime.format("%Y-%m-%d %H:%M:%S"));
											(obj as Object).set_property(spec.name, datetime);
										}
									}
								}
								else if( spec.value_type.is_object() && column_value.strip().length > 0 )
								{
									var jsonObj = Json.gobject_deserialize(spec.value_type, Json.from_string(column_value));
									(obj as SBObject).setPropertyGValue(spec.name, jsonObj);
								}
								else
								{
									(obj as SBObject).setPropertyValue(spec.name, column_value);
								}
							}
						}
						//T obj = factory != null ? ()factory() : (T)Object.new_with_properties(typeof(T), objProps, objValues);
						//if( factory != null )
						//	factory(this, (SBObject)obj);
						
						break;
					default:
						printerr ("Error: %d, %s\n", res, this._db.errmsg ());
						break;
				}
			} while (res == Sqlite.ROW);
			this.stmt = null;
			
			return results;
		}
		public override	T getObject<T>(string? query)
		{
			var rows = this.getObjects<T>(query);
			if( rows.size <= 0 )
				return null;
			
			return rows.get(0);
		}
		public override SBDBRow? GetRow(string? query)
		{
			var rows = (ArrayList<SBDBRow>)this.GetResults(query);
			if( rows.size <= 0 )
				return null;
			
			return rows.get(0);
		}
		public override ArrayList<SBDBRow> GetResults(string? query)
		{
			ArrayList<SBDBRow> records = new ArrayList<SBDBRow>();
			
			this.Query(query);
			int cols = this.stmt.column_count();
			int res = 0;
			do 
			{
				res = this.stmt.step();
				switch (res) 
				{
					case Sqlite.DONE:
						break;
					case Sqlite.ROW:
						SBDBRow row = new SBDBRow();
						for (int col = 0; col < cols; col++) 
						{
							SBDBCell cell = new SBDBCell();
							cell.ColumnName = stmt.column_name (col);
							cell.TheValue = stmt.column_text(col);
							row.Add(cell);
						    //string txt = stmt.column_text(col);
						    //print ("%s = %s\n", stmt.column_name (col), txt);
						}
						records.add(row);
						break;
					default:
						printerr ("Error: %d, %s\n", res, this._db.errmsg ());
						break;
				}
			} while (res == Sqlite.ROW);
			this.stmt = null;
			
			return records;
		}
		public override long Execute(string sql) throws SBDatabaseException
		{
			this.stmt = null;
			string error;
			int res = this._db.exec(sql, null, out error);
			
			if( res != Sqlite.OK )
			{
				stderr.printf("SQLITE ERROR: %s\nQUERY WAS: %s\n", this._db.errmsg(), sql);
				throw new SBDatabaseException.GENERAL(this._db.errmsg());
				//throw new Error(Quark.from_string("SQLITE_ERROR"), -1, "SQLITE ERROR: %s, SQL (DML) WAS: %s\n".printf(error, sql));
			}
			//stdout.printf("QUERY: %s\n", sql);
			if( sql.down().index_of("insert") != -1 )
			{
				this.LastInsertId = (int)this._db.last_insert_rowid();
				return this.LastInsertId;
			}
			this.stmt = null;
			return res;
		}
		public static int QueryCallback (int n_columns, string[] values, string[] column_names)
		{
			/* 
			SBDBRow row = new SBDBRow();
			for (int i = 0; i < n_columns; i++) 
			{
				//stdout.printf ("%s = %s\n", column_names[i], values[i]);
				//var row = new HashMap<string, string>();
				//row.set(column_names[i], values[i]);
				SBDBCell cell = new SBDBCell();
				cell.ColumnName = column_names[i];
				cell.TheValue = values[i];
				row.Add(cell);
				//stdout.printf ("%s = %s |", cell.ColumnName, cell.TheValue);
				//row[column_names[i]] = values[i];
				//results.add(row);
			}
			*/
			//((ArrayList<SBDBRow>)SBSQLite._results).add(row);
			//SBSQLite._results += row;
			//stdout.printf("\n");
			return 0;
		}
		public override string EscapeString(string? str)
		{
			if( str == null )
				return "";
			return str.replace("'", "''");
		}
		public override SBDBTable get_table(string name)
		{
			var table = new SBDBTable()
			{
				name	= name,
				comments	= "",
				columns		= this.get_table_columns(name)
			};
			return table;
		}
		public override ArrayList<SBDBTable> show_tables()
		{
			var items = new ArrayList<SBDBTable>();
			return items;
		}
		public ArrayList<SBDBColumn> get_table_columns(string name)
		{
			var columns = new ArrayList<SBDBColumn>();
			return columns;
		}
	}
}
