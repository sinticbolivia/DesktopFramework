namespace SinticBolivia.Database
{
	public enum CellType
	{
		TINYINT,
		INT,
		UINT,
		LONG,
		ULONG,
		BIGINT,
		UBIGINT,
		FLOAT,
		UFLOAT,
		DOUBLE,
		UDOUBLE,
		CHAR,
		VARCHAR,
		TEXT,
		LONGTEXT,
		DATE,
		DATETIME,
		JSON,
		NULL
	}
	public string get_cell_type_name(CellType type)
	{
		string t = "";
		
		switch(type)
		{
			case CellType.TINYINT:
				t = "TINYINT";
			break;
			case CellType.INT:
				t = "INT";
			break;
			case CellType.UINT:
				t = "UINT";
			break;
			case CellType.BIGINT:
				t = "BIGINT";
			break;
			case CellType.UBIGINT:
				t = "UBIGINT";
			break;
			case CellType.FLOAT:
				t = "FLOAT";
			break;
			case CellType.UFLOAT:
				t = "UFLOAT";
			break;
			case CellType.DOUBLE:
				t = "DOUBLE";
			break;
			case CellType.UDOUBLE:
				t = "UDOUBLE";
			break;
			case CellType.CHAR:
				t = "CHAR";
			break;
			case CellType.VARCHAR:
				t = "VARCHAR";
			break;
			case CellType.TEXT:
				t = "TEXT";
			break;
			case CellType.LONGTEXT:
				t = "LONGTEXT";
			break;
			case CellType.DATE:
				t = "DATE";
			break;
			case CellType.DATETIME:
				t = "DATETIME";
			break;
			default:
				t = "UNKNOWN";
			break;
		}
		return t;
	}
	public class SBDBCell : Object
	{
		protected 	string 		_columnName;
		protected 	string? 	_columnValue;
		protected	CellType	_type;
		//protected	string		_type_name;
		public		ulong		length;
		public		ulong		max_length;
		public		uint		decimals;
		
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
		public CellType ctype
		{ 
			get{return this._type;} set{ this._type = value;} 
		}
		public string type_name
		{
			owned get{ 
				string _type = get_cell_type_name(this._type); 
				return _type;
			}
		}
		
		public SBDBCell()
		{
			
		}
		
	}
}
