using GLib;
using Gee;
using SinticBolivia;
using SinticBolivia.Database;

namespace SinticBolivia
{
	public class SBCustomer : SBDbObject
	{
		public		HashMap<string, string> Meta;
		public		int			Id
		{
			get{return this.dbData.GetInt("customer_id");}
		}
		public SBCustomer()
		{
			this.dbData = new SBDBRow();
			this.Meta	= new HashMap<string, string>();
		}
		public SBCustomer.from_id(int id)
		{
			this();
			this.Dbh.Select("*").From("customers").Where("customer_id = %d".printf(id));
			var row = this.Dbh.GetRow(null);
			if( row == null )
				return;
			this.dbData = row;
			this.GetDbMeta();
		}
		public void GetDbMeta()
		{
			this.Dbh.Select("*").From("customer_meta").Where("customer_id = %d".printf(this.Id));
			foreach(var row in this.Dbh.GetResults(null))
			{
				this.Meta.set(row.Get("meta_key"), row.Get("meta_value"));
			}
		}
	}
}
