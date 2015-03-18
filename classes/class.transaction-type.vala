using GLib;
using Gee;
using SinticBolivia.Database;

namespace SinticBolivia
{
	public class SBTransactionType : Object
	{
		protected SBDBRow dbData;
		
		public int Id
		{
			get{return this.dbData.GetInt("transaction_type_id");}
			set{this.dbData.Set("transaction_type_id", value.to_string());}
		}
		public string Key
		{
			get{return this.dbData.Get("transaction_key");}
			set{this.dbData.Set("transaction_key", value);}
		}
		public string Name
		{
			get{return this.dbData.Get("transaction_name");}
			set{this.dbData.Set("transaction_name", value);}
		}
		public string Description
		{
			get{return this.dbData.Get("transaction_description");}
			set{this.dbData.Set("transaction_description", value);}
		}
		public string InOut
		{
			get{return this.dbData.Get("in_out");}
			set{this.dbData.Set("in_out", value);}
		}
		public int StoreId
		{
			get{return this.dbData.GetInt("store_id");}
			set{this.dbData.Set("store_id", value.to_string());}
		}
		public SBTransactionType()
		{
			this.dbData = new SBDBRow();
		}
		public SBTransactionType.from_id(int tt_id)
		{
			this();
			this.GetDbData(tt_id);
		}
		public void GetDbData(int tt_id)
		{
			var dbh = (SBDatabase)SBGlobals.GetVar("dbh");
			string query = "SELECT * FROM transaction_types WHERE transaction_type_id = %d LIMIT 1".printf(tt_id);
			var row = dbh.GetRow(query);
			if( row == null )
			{
				return;
			}
			this.dbData = row;
		}
	}
}
