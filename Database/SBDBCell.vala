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
}
