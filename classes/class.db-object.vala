using GLib;
using Gee;
using SinticBolivia.Database;

namespace SinticBolivia
{
	public class SBDbObject : Object
	{
		protected	SBDBRow		dbData;
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
