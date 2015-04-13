using GLib;
using Gee;
using SinticBolivia;

namespace SinticBolivia.Database
{
	public class SBDBCell : Object
	{
		protected string _columnName;
		protected string? _columnValue;

		public string ColumnName
		{
			set
			{
				this._columnName = value;	
			}
			get
			{
				return this._columnName;	
			}
		}
		public string? TheValue
		{
			get
			{
				return this._columnValue;
			}	
			set
			{
				this._columnValue = value;	
			}
		}
		
		
		public SBDBCell()
		{
			
		}
		
	}
	public class SBDBRow : Object
	{
		protected int _length;
		protected Array<SBDBCell> _cells;
		protected Array<string> _keys;
		
		public Array<SBDBCell> Cells
		{
			get
			{
				return this._cells;	
			}
			set
			{
				//this._cells = value;				
			}
		}
		public SBDBRow()
		{
			this._cells = new Array<SBDBCell>();
			this._keys = new Array<string>();
			this._length = 0;
			
		}
		public void Add(SBDBCell cell)
		{
			this._cells.append_val(cell);
			this._length++;
						
		}
		public unowned string Get(string column_name)
		{
			int index = -1;
			if( !this.ColumnNameExists(column_name, out index) )
				return "";
			
			return (this.Cells.index(index).TheValue == null) ? "" : this.Cells.index(index).TheValue;
		}
		public unowned int GetInt(string column_name)
		{
			string? val = this.Get(column_name);
			return (val == null) ? 0 : int.parse(val);
		}
		public unowned double GetDouble(string column_name)
		{
			string? val = this.Get(column_name);
			return (val == null) ? 0.0 : double.parse(val);
		}
		public void Set(string column_name, string? the_value)
		{
			int index = -1;
			
			if( !this.ColumnNameExists(column_name, out index) )
			{
				//stderr.printf("SBDBRow ERROR: column \"%s\" does not exists\n", column_name);
				SBDBCell cell = new SBDBCell();
				cell.ColumnName = column_name;
				cell.TheValue = the_value;
				this.Add(cell);
				return;
			}
			this.Cells.index(index).TheValue = the_value;
		}
		public bool ColumnNameExists(string column, out int cell_index)
		{
			bool exists = false;
			cell_index = -1;
			
			for(int i = 0; i < this.Cells.length; i++)
			{
				if(this.Cells.index(i).ColumnName == column )
				{
					cell_index = i;
					exists = true;
					break;
				}
			}
			
			return exists;
		}
		public HashMap<string, string> ToHashMap()
		{
			var data = new HashMap<string,string>();
			//foreach(var cell in this._cells)
			for(int i = 0; i < this._cells.length; i++)
			{
				var cell = (SBDBCell)this._cells.index(i);
				data.set(cell.ColumnName, cell.TheValue == null ? "" : cell.TheValue);
			}
			
			return data;
		}
	}
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
		
		/**
		*  Insert a row into table
		*/
		public virtual long Insert(string table, HashMap<string, Value?> data)
		{
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
				else if( gtype == "glong" )
				{
					values += "%ld,".printf((long)data.get(key));
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
				else if( gtype == "glong" )
				{
					query += "%ld,".printf((long)data.get(key));
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
				else if( gtype == "glong" )
				{
					where_str += "%ld AND ".printf((long)w.get(key));
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
		public virtual string EscapeString(string str)
		{
			string striped = "";
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

