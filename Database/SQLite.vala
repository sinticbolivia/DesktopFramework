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
		}
		public override bool Open()
		{
			/*
			if( !FileUtils.test(this._dbFile, FileTest.IS_REGULAR) )
			{
				stderr.printf("The database file (%s) does not exists\n", this._dbFile);
				return false;
			}
			*/
			
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
		public override long Query(string? query = null)
		{
			this.stmt = null;
			//Statement stmt;
			//string error = "";
			//SBDBRow[] rows = {};
			string q = query != null ? query : this.builtQuery;
			int res = this._db.prepare_v2(q, -1, out this.stmt, null);
			if( res != Sqlite.OK )
			{
				stderr.printf("SQLite Query Error: %s, QUERY WAS:%s\n", this._db.errmsg (), q);
				return 0;
			}
			/*
			int cols = stmt.column_count();
			do 
			{
				res = stmt.step();
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
						rows += row;
						break;
					default:
						printerr ("Error: %d, %s\n", res, this._db.errmsg ());
						break;
				}
			} while (res == Sqlite.ROW);
			this._rows = rows;
			*/
			return 0;
			
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
			//Statement stmt;
			
			ArrayList<SBDBRow> records = new ArrayList<SBDBRow>();
			/*			
			int res = this._db.prepare_v2(query, -1, out stmt, null);
			if( res != Sqlite.OK )
			{
				stderr.printf("SQLite Query Error: %s, QUERY WAS:%s\n", this._db.errmsg (), query);
				return records;
			}
			*/
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
			
			return records;
		}
		public override long Execute(string sql)
		{
			string error;
			int res = this._db.exec(sql, null, out error);
			
			if( res != Sqlite.OK )
			{
				throw new Error(Quark.from_string("SQLITE_ERROR"), -1, "SQLITE ERROR: %s, SQL (DML) WAS: %s\n".printf(error, sql));
			}
			if( sql.down().index_of("insert") != -1 )
			{
				this.LastInsertId = (int)this._db.last_insert_rowid();
				return this.LastInsertId;
			}
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
	}
}
