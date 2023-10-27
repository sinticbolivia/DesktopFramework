using Gee;

namespace SinticBolivia.Database
{
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
		construct
		{
			this._cells = new Array<SBDBCell>();
			this._keys = new Array<string>();
			this._length = 0;
		}
		public SBDBRow()
		{
			
			
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
		public string to_json()
		{
			string json = "";
			var gen = new Json.Generator();
			var root = new Json.Node(Json.NodeType.OBJECT);
			var object = new Json.Object();
			root.set_object(object);
			gen.set_root(root);
			foreach(var cell in this._cells)
			{
				if( cell.ctype == CellType.BIGINT || cell.ctype == CellType.UBIGINT 
					|| cell.ctype == CellType.LONG || cell.ctype == CellType.ULONG
					|| cell.ctype == CellType.INT || cell.ctype == CellType.UINT )
				{
					if( cell.TheValue == null)
						object.set_null_member(cell.ColumnName);
					else
						object.set_int_member(cell.ColumnName, int.parse(cell.TheValue));
				}
				else if( cell.ctype == CellType.FLOAT || cell.ctype == CellType.DOUBLE )
				{
					if( cell.TheValue == null)
						object.set_null_member(cell.ColumnName);
					else
						object.set_double_member(cell.ColumnName, double.parse(cell.TheValue));
				}
				//else if( cell.TheValue == null )
				//	object.set_null_member(cell.ColumnName);
				else
				{
					if( cell.TheValue == null )
						object.set_null_member(cell.ColumnName);
					else
						object.set_string_member(cell.ColumnName, cell.TheValue);
				}
			}
			size_t length;
			json = gen.to_data(out length);
			
			return json;
		}
	}
}
