using GLib;
using Gee;
//using Postgres;
using SinticBolivia;

namespace SinticBolivia.Database
{
	public class SBPostgres : SBDatabase
	{
		protected	string		server;
		protected	string		databaseName;
		protected	string 		username;
		protected	string		password;
		protected	int					port;
		protected	Postgres.Database	dbh;
		protected	Postgres.Result 	resultSet;

		public SBPostgres(string db_server, string? db_name, string db_user, string db_pass, int db_port = 5432)
		{
			this._databaseType 		= "postgres";
			this.columnLeftWrap 	= "\"";
			this.columnRightWrap 	= "\"";
			this.server 			= db_server;
			this.databaseName 		= db_name != null ? db_name : "";
			this.username			= db_user;
			this.password			= db_pass;
			this.port				= db_port;
			//string conninfo = "dbname = %s".printf(this.databaseName);
			//this.dbh = Postgres.connect_db(conninfo);
			stdout.printf("DATABASE: %s\nUSERNAME: %s\nPASS: %s\nSERVER: %s\nPORT: %d\n", db_name, db_user, db_pass, db_server, db_port);
			//this.dbh = Postgres.set_db_login(this.server, this.port.to_string(), "", "", this.databaseName, this.username, this.password);
			//string conn_info = "user=%s password=%s host=%s port=%d dbname=%s target_session_attrs=read-write\n".printf(
			string conn_info = "user=%s password=%s host=%s port=%d dbname=%s".printf(
				this.username,
				this.password,
				this.server,
				this.port,
				db_name
			);
			print("%s\n", conn_info);
			this.dbh = Postgres.connect_db(conn_info);
		}
		public override bool Open() throws SBDatabaseException
		{
			if( this.dbh.get_status() != Postgres.ConnectionStatus.OK )
			{
				string error = "Connection to database failed: %s\n".printf(this.dbh.get_error_message ());
				stderr.printf(error);
				throw new SBDatabaseException.GENERAL(error);
			}
			return true;
		}
		public override bool Close()
		{
			this.dbh = null;
			return true;
		}
		public override void SelectDb(string db_name)
		{
			//this.databaseName = db_name;
			//this.dbh.select_db(this.databaseName);
		}
		public override long Query(string? query = null) throws SBDatabaseException
		{
			var res = this.dbh.exec(query);
			if( res.get_status() != Postgres.ExecStatus.TUPLES_OK )
			{
				string error = "[POSTGRES ERROR]: Database query failed: %s\nQUERY: %s\n".printf(
					this.dbh.get_error_message (),
					query
				);
				stderr.printf(error);
				throw new SBDatabaseException.GENERAL(error);
			}
			this.resultSet = (owned)res;
			return 0;
		}
		public override	long Execute(string sql) throws SBDatabaseException
		{
			//message(sql);
			var res = this.dbh.exec(sql);
			if( res.get_status() != Postgres.ExecStatus.COMMAND_OK )
			{
				string error = "[POSTGRES ERROR]: Database command failed: %s\nSQL: %s\n".printf( this.dbh.get_error_message (), sql );
				throw new SBDatabaseException.GENERAL(this.dbh.get_error_message());
			}
			if( sql.down().index_of("insert") != -1 )
			{
				string[] parts = sql.down().split("insert into");
				string table_name = parts[1].strip().split("(")[0].strip();
				string dml = "SELECT currval('%s_id_seq') AS last_id".printf(table_name);
				//message(dml);
				var resSeq = this.dbh.exec(dml);
				this.LastInsertId = long.parse(resSeq.get_value(0, 0));
				//message("last_id: %ld\n", this.LastInsertId);
				return this.LastInsertId;
			}
			return 0;
		}
		public override	void BeginTransaction()
		{
			this.Execute("BEGIN");
		}
		public override	void EndTransaction()
		{
			this.Execute("END");
		}
		protected SBDBRow? get_row_from_result(Postgres.Result result, int row_index = 0)
		{
			int rows = result.get_n_tuples();
			if( rows <= 0 )
				return null;
			int fields 	= result.get_n_fields();
			var db_row	= new SBDBRow();
			for(int i = 0; i < fields; i++)
			{
				string column_name = result.get_field_name(i);
				string column_value = result.get_value(row_index, i);
				int type = (int)result.get_field_type(i);
				stdout.printf("Column: %s\nValue: %s\nType: %d\n", column_name, column_value, type);
				var cell = new SBDBCell();
				cell.ColumnName = column_name;
				cell.TheValue 	= column_value;
				cell.ctype 		= this.get_cell_type(type);
				cell.length 	= column_value.length;
				cell.max_length = this.resultSet.get_length(row_index, i);
				cell.decimals 	= 0;
				db_row.Add(cell);
			}

			return db_row;
		}
		public override	SBDBRow? GetRow(string? query)
		{
			this.Query(query);
			if( this.resultSet == null )
				return null;
			return this.get_row_from_result(this.resultSet, 0);
		}
		public override	ArrayList<SBDBRow> GetResults(string? query)
		{
			var rows = new ArrayList<SBDBRow>();
			if( query == null )
				return rows;
			this.Query(query);

			if( this.resultSet == null )
				return rows;
			int total_rows = this.resultSet.get_n_tuples();

			if( total_rows <= 0 )
				return rows;
			int fields = this.resultSet.get_n_fields();
			stdout.printf("Total rows: %d\nTotal columns: %d\n", total_rows, fields);
			for(int row = 0; row < total_rows; row++)
			{
				var db_row = this.get_row_from_result(this.resultSet, row);
				rows.add(db_row);
			}

			return rows;
		}
		public ArrayList<SBDBColumn> get_table_columns(string name)
		{
			string[] table_columns = {
				"c.column_name", "c.column_default", "c.is_nullable", "c.data_type",
				"kcu.constraint_name", "tc.constraint_type",
				"c.character_maximum_length",
				"c.numeric_precision", "c.numeric_precision_radix", "c.is_identity"
			};
			string query = "SELECT %s FROM information_schema.columns WHERE table_schema = 'public' AND table_name = '%'".printf(
				string.joinv(",", table_columns),
				name
			);
			this.Query(query);
			Postgres.Result res = (owned)this.resultSet;
			var columns = new ArrayList<SBDBColumn>();
			if( res == null )
				return columns;
			var row = this.get_row_from_result(res, 0);
			if( row == null )
				return columns;
			foreach(var cell in row.Cells)
			{
				var column = new SBDBColumn()
				{
					name = cell.ColumnName,
					comments = "",
					db_type = 0, //cell.ctype,
					type = cell.ctype, //this.get_cell_type_from_name(row[1]),
					is_key = false //(row[3] == "PRI") ? true : false
				};
				columns.add(column);
			}
			return columns;
		}
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
			string query = "SELECT * FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema';";
			this.Query(query);
			/*
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
			*/
			return items;
		}
		public override T getObject<T>(string? query)
		{
			var rows = this.getObjects<T>(query);
			if( rows.size <= 0 )
				return null;

			return rows.get(0);
		}
		public override	ArrayList<T> getObjects<T>(string? query, InstanceFactory? factory = null)
		{
			var results = new ArrayList<T>();
			if( query != null )
				this.Query(query);
			if( this.resultSet == null )
				return results;

			Postgres.Result result = (owned)this.resultSet;
			int total_rows = result.get_n_tuples();
			if( total_rows <= 0 )
				return results;
			int fields = result.get_n_fields();

			for(int row_index = 0; row_index < total_rows; row_index++)
			{
				//var row = this.get_row_from_result(res, row_index);
				T obj = (T)Object.new(typeof(T));
				if( obj is SBDBRow )
				{
					var row = this.get_row_from_result(result, row_index);
					results.add(row);
					continue;
				}

				for(int i = 0; i < fields; i++)
				{
					string column_name	= result.get_field_name(i);
					string column_value = result.get_value(row_index, i);
					ParamSpec? spec 	= null;
					if( obj is SBObject && (obj as SBObject).propertyExists(column_name, out spec) )
					{
						if( spec.value_type == typeof(DateTime) || spec.value_type == typeof(SBDateTime) )
						{
							if( column_value.strip().length > 0 )
							{
								//DateTime datetime = SBDateTime.parseDbDateTime(column_value);
								Value? datetime = Value(spec.value_type);
								if(spec.value_type == typeof(SBDateTime))
									datetime.set_object(new SBDateTime.from_string(column_value));
								else
									datetime = SBDateTime.parseDbDateTime(column_value);
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
		public CellType get_cell_type(int type)
		{
			CellType t;

			switch(type)
			{
				case 20:
					t = CellType.INT;
				break;
				case 1043:
					t = CellType.VARCHAR;
				break;
				case 1114:
					t = CellType.DATETIME;
				break;
				default:
					t = CellType.VARCHAR;
				break;
			}
			return t;
		}
	}
}
