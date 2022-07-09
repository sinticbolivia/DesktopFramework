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
}
