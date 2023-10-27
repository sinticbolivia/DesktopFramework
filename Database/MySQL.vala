using GLib;
using Gee;
//using Mysql.Database;
//using Mysql;

namespace SinticBolivia.Database
{
	public class SBMySQL : SBDatabase
	{
		protected	string		server;
		protected	string		databaseName;
		protected	string 		username;
		protected	string		password;
		protected	int			port;
		protected	Mysql.Database	dbh;
		protected	Mysql.Result		resultSet;
		
		public SBMySQL(string db_server, string? db_name, string db_user, string db_pass, int db_port = 3306)
		{
			this._databaseType 		= "mysql";
			this.columnLeftWrap 	= "`";
			this.columnRightWrap 	= "`";
			this.server 			= db_server;
			this.databaseName 		= db_name != null ? db_name : "";
			this.username			= db_user;
			this.password			= db_pass;
			this.port				= db_port;
			
			this.dbh = new Mysql.Database();
			
		}
		public override bool Open()
		{
			if( !this.dbh.real_connect(this.server, 
										this.username, 
										this.password, 
										(this.databaseName != "") ? this.databaseName : null, 
										this.port,
										null,
										0) 
			)
			{
				stderr.printf("MYSQL ERROR: %s\n", SBText.__("Error trying to connect with mysql server"));
				stderr.printf("MYSQL ERROR: Server: %s:%d, Database: %s, User: %s, Pass: %s\n",
								this.server, this.port, this.databaseName, this.username, this.password
				);
				return false;
			}
			/*
			if( this.databaseName != "" )
				this.dbh.select_db(this.databaseName);
			*/
			return true;
		}
		public override bool Close()
		{
			this.dbh = null;
			return true;
		}
		public override void SelectDb(string db_name)
		{
			this.databaseName = db_name;
			this.dbh.select_db(this.databaseName);
		}
		public override long Query(string? query = null) throws SBDatabaseException
		{
			this.resultSet = null;
			string q = query != null ? query : this.builtQuery;
			int res = this.dbh.query( q );
			if( res != 0 )
			{
				stderr.printf("MYSQL ERROR: %s\nQUERY WAS: %s\n", this.dbh.error(), q);
				throw new SBDatabaseException.GENERAL(this.dbh.error());
				return res;
			}
			this.resultSet = this.dbh.store_result(); //this.dbh.use_result();
			
			return 0;
		}
		public CellType get_cell_type_from_name(string name)
		{
			CellType t = CellType.VARCHAR;
			if( name == "bigint unsigned")
				t = CellType.UBIGINT;
			if( name == "bigint")
				t = CellType.BIGINT;
			else if( "varchar" in name )
				t = CellType.VARCHAR;
			else if ( "int" == name )
				t = CellType.INT;
			else if ( "int unsigned" == name )
				t = CellType.UINT;
			else if ( "text" == name )
				t = CellType.TEXT;
			else if ( "date" == name )
				t = CellType.DATE;
			else if ( "datetime" == name )
				t = CellType.DATETIME;
			return t;
		}
		public CellType get_cell_type(Mysql.FieldType type)
		{
			CellType t;
			
			switch(type)
			{
				case Mysql.FieldType.DATE:
					t = CellType.DATE;
				break;
				case Mysql.FieldType.DATETIME:
					t = CellType.DATETIME;
				break;
				case Mysql.FieldType.DECIMAL:
					t = CellType.DOUBLE;
				break;
				case Mysql.FieldType.DOUBLE:
					t = CellType.DOUBLE;
				break;
				case Mysql.FieldType.FLOAT:
					t = CellType.FLOAT;
				break;
				case Mysql.FieldType.INT24:
					t = CellType.INT;
				break;
				case Mysql.FieldType.LONG:
					t = CellType.LONG;
				break;
				case Mysql.FieldType.LONGLONG:
					t = CellType.BIGINT;
				break;
				case Mysql.FieldType.NULL:
					t = CellType.NULL;
				break;
				default:
					t = CellType.VARCHAR;
				break;
			}
			return t;
		}
		public override	ArrayList<T> getObjects<T>(string? query, InstanceFactory? factory = null)
		{
			var results = new ArrayList<T>();
			if( query != null )
				this.Query(query);
			owned Mysql.Result res = (owned)this.resultSet;
			string[]? row;
			Mysql.Field[] fields = res.fetch_fields();
			
			while( (row = res.fetch_row()) != null )
			{
				T obj = (T)Object.new(typeof(T));
				for(int i = 0; i < res.num_fields(); i++ )
				{
					string column_name = fields[i].name;
					string column_value = row[i];
					ParamSpec? spec = null;
					if( obj is SBDBRow )
					{
						var cell = new SBDBCell();
						cell.ColumnName = column_name;
						cell.TheValue 	= column_value;
						cell.ctype 		= this.get_cell_type(fields[i].type);
						cell.length 	= fields[i].length;
						cell.max_length = fields[i].max_length;
						cell.decimals 	= fields[i].decimals;
						(obj as SBDBRow).Add(cell);
					}
					else if( obj is SBObject && (obj as SBObject).propertyExists(column_name, out spec) )
					{
						if( spec.value_type == typeof(DateTime) )
						{
							if( column_value.strip().length > 0 )
							{
								DateTime datetime = SBDateTime.parseDbDateTime(column_value);
								if( datetime != null )
								{
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
				results.add(obj);
			}
			return results;
		}
		public override	T getObject<T>(string? query)
		{
			var rows = this.getObjects<T>(query);
			if( rows.size <= 0 )
				return null;
			
			return rows.get(0);
		}
		public override	SBDBRow? GetRow(string? query)
		{
			this.Query(query);
			if( this.resultSet == null )
				return null;
				
			string[]? row = this.resultSet.fetch_row();
			
			if( row == null )
				return null;
				
			Mysql.Field[] fields 	= this.resultSet.fetch_fields();
			var db_row 		= new SBDBRow();
			
			for(int i = 0; i < fields.length; i++)
			{
				db_row.Set(fields[i].name, row[i]);
			}
			
			return db_row;
		}
		public override	ArrayList<SBDBRow> GetResults(string? query)
		{
			this.Query(query);
			var rows = new ArrayList<SBDBRow>();
			Mysql.Field[] fields = this.resultSet.fetch_fields();
			
			string[] row;
			
			while( (row = this.resultSet.fetch_row()) != null )
			{
				var _row = new SBDBRow();
				for(int i = 0; i < fields.length; i++)
				{
					_row.Set(fields[i].name, row[i]);
				}
				rows.add(_row);
			}
			
			return rows;
		}
		public override	long Execute(string sql) throws SBDatabaseException
		{
			//stdout.printf("EXECUTE: %s\n", sql);
			int res = this.dbh.query( sql );
			if( res != 0 )
			{
				stderr.printf("MYSQL ERROR: %s\nQUERY WAS: %s\n", this.dbh.error(), sql);
				throw new SBDatabaseException.GENERAL(this.dbh.error());
				return res;
			}
			if( sql.down().index_of("insert") != -1 )
			{
				this.LastInsertId = (int)this.dbh.insert_id();
				return this.LastInsertId;
			}
			return res;
		}
		public override	void BeginTransaction(){}
		public override	void EndTransaction(){}
		public override	SBDBTable get_table(string name)
		{
			var table = new SBDBTable()
			{
				name 		= name,
				comments 	= "",
				columns 	= this.get_table_columns(name)
			};
			
			return table;
		}
		public override ArrayList<SBDBTable> show_tables()
		{
			var items = new ArrayList<SBDBTable>();
			string query = "SHOW TABLES";
			this.Query(query);
			string[]? row = null;
			
			owned Mysql.Result? res = (owned)this.resultSet;
			if( res == null )
				return items;
			while( (row = res.fetch_row()) != null )
			{
				string name = row[0];
				var table = new SBDBTable()
				{
					name = name,
					comments = "",
					columns = this.get_table_columns(name)
				};
				items.add(table);
			}
			
			return items;
		}
		public ArrayList<SBDBColumn> get_table_columns(string name)
		{
			var columns = new ArrayList<SBDBColumn>();
			string query = "DESCRIBE %s".printf(name);
			this.Query(query);
			owned Mysql.Result res = (owned)this.resultSet;
			if( res == null )
				return columns;
			Mysql.Field[] fields = res.fetch_fields();
			string[]? row = null;
			
			while( (row = res.fetch_row()) != null )
			{
				string col_name = row[0];
				var column = new SBDBColumn()
				{
					name = col_name,
					comments = "",
					db_type = fields[0].type,
					type = this.get_cell_type_from_name(row[1]),
					is_key = (row[3] == "PRI") ? true : false
				};
				columns.add(column);
			}
			return columns;
		}
	}
}
