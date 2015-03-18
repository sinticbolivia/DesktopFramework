using GLib;
using Gee;
using SinticBolivia;
using SinticBolivia.Database;

namespace SinticBolivia
{
	public class SBTransactionItem : Object
	{
		public SBDBRow dbData;
		
		public int Id
		{
			get{return this.dbData.GetInt("transaction_item_id");}
		}
		public string Code
		{
			get{return this.dbData.Get("transaction_code");}
		}
		public int TransactionId
		{
			get{return this.dbData.GetInt("transaction_id");}
			set{this.dbData.Set("transaction_id", value.to_string());}
		}
		public int ProductId
		{
			get{return this.dbData.GetInt("object_id");}
			set{this.dbData.Set("object_id", value.to_string());}
		}
		public int Quantity
		{
			get{return this.dbData.GetInt("object_quantity");}
			set{this.dbData.Set("object_quantity", value.to_string());}
		}
		public double Price
		{
			get{return this.dbData.GetDouble("object_price");}
			set{this.dbData.Set("object_price", value.to_string());}
		}
		public double SubTotal
		{
			get{return this.dbData.GetDouble("sub_total");}
		}
		public double Discount
		{
			get{return this.dbData.GetDouble("discount");}
			set{this.dbData.Set("discount", value.to_string());}
		}
		public double Total
		{
			get{return this.dbData.GetDouble("total");}
		}
		public string Notes
		{
			get{return this.dbData.Get("notes");}
			set{this.dbData.Set("notes", value);}
		}
		public string Status
		{
			get{return this.dbData.Get("status");}
			set{this.dbData.Set("status", value);}
		}
		public SBTransactionItem()
		{
			this.dbData = new SBDBRow();
		}
		public SBTransactionItem.from_id(int item_id)
		{
			this();
			this.GetDbData(item_id);
		}
		public SBTransactionItem.with_db_data(SBDBRow data)
		{
			this();
			this.dbData =  data;
		}
		public void GetDbData(int item_id)
		{
			var dbh = (SBDatabase)SBGlobals.GetVar("dbh");
			string query = "SELECT * FROM transaction_items WHERE transaction_item_id = %d LIMIT 1".printf(item_id);
			var records = (ArrayList<SBDBRow>)dbh.GetResults(query);
			if( records.size <= 0 )
				return;
			
			this.dbData = records.get(0);
		}
	}
}
