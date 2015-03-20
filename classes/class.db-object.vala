using GLib;
using Gee;
using SinticBolivia.Database;

namespace SinticBolivia
{
	public class SBDbObject : Object
	{
		protected	SBDatabase	dbh;
		public	SBDatabase	Dbh
		{
			get
			{
				if( dbh == null )
				{
					this.dbh = (SBDatabase)SBGlobals.GetVar("dbh");
				}
				return this.dbh;
			}
			set{this.dbh = value;}
		}
		protected	SBDBRow		dbData;
		public void SetDbRow(SBDBRow row)
		{
			this.dbData = row;
		}
		public string Get(string column)
		{
			return this.dbData.Get(column);
		}
		public int GetInt(string column)
		{
			return this.dbData.GetInt(column);
		}
		public double GetDouble(string column)
		{
			return this.dbData.GetDouble(column);
		}
		public void Set(string column, string string_value)
		{
			this.dbData.Set(column, string_value);
		}
	}
}
