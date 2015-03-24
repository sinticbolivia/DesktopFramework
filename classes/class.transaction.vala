using GLib;
using Gee;
using SinticBolivia;
using SinticBolivia.Database;

namespace SinticBolivia
{
	public class SBTransaction : SBDbObject
	{
		public int Id
		{
			get{return this.dbData.GetInt("transaction_id");}
			set{this.dbData.Set("transaction_id", value.to_string());}
		}
		public string Code
		{
			get{return this.dbData.Get("transaction_code");}
		}
		public int TypeId
		{
			get{return this.dbData.GetInt("transaction_type_id");}
			set{this.dbData.Set("transaction_type_id", value.to_string());}
		}
		public SBTransactionType Type;
		public int StoreId
		{
			get{return this.dbData.GetInt("store_id");}
			set{this.dbData.Set("store_id", value.to_string());}
		}
		
		public int UserId
		{
			get{return this.dbData.GetInt("user_id");}
			set{this.dbData.Set("user_id", value.to_string());}
		}
		protected	SBUser		user;
		public 		SBUser		User
		{
			get{ return this.user;}
		}
		public int CustomerId
		{
			get{return this.dbData.GetInt("owner_code_id");}
			set{this.dbData.Set("owner_code_id", value.to_string());}
		}
		public string Notes
		{
			get{return this.dbData.Get("details");}
			set{this.dbData.Set("details", value);}
		}
		public double SubTotal
		{
			get{return this.dbData.GetDouble("sub_total");}
		}
		public double Total
		{
			get{return this.dbData.GetDouble("total");}
		}
		public double Discount
		{
			get{return this.dbData.GetDouble("discount");}
			set{this.dbData.Set("discount", value.to_string());}
		}
		public string Status
		{
			get{return this.dbData.Get("status");}
			set{this.dbData.Set("status", value);}
		}
		public string CreationDate
		{
			get
			{
				//SinticBolivia.SBDateTime _d = new SinticBolivia.SBDateTime.from_string(this.dbData.Get("creation_date"));
				//return _d.get_datetime();
				return this.dbData.Get("creation_date");
			}
		}
		public int Sequence
		{
			get{return this.dbData.GetInt("sequence");}
		}
		
		protected ArrayList<SBTransactionItem>	items;
		public	ArrayList<SBTransactionItem>	Items
		{
			get{return this.items;}
		}
		public SBTransaction()
		{
			this.items = new ArrayList<SBTransactionItem>();
			this.dbData	= new SBDBRow();
			this.Type = new SBTransactionType();
		}
		public SBTransaction.for_store(int store_id)
		{
			this();
			this.StoreId = store_id;
		}
		public SBTransaction.with_db_data(SBDBRow data)
		{
			this();
			this.dbData = data;
			this.GetDbItems();
		}
		public void GetDbData(int transaction_id)
		{
			var dbh = (SBDatabase)SBGlobals.GetVar("dbh");
			string query = "SELECT * FROM transactions WHERE transaction_id = %d LIMIT 1".printf(transaction_id);
			var row = dbh.GetRow(query);
			if( row == null )
				return;
			this.dbData = row;
			if( this.UserId > 0 )
			{
				this.user = new SBUser.from_id(this.UserId);
			}
			this.GetDbItems();
		}
		protected void GetDbItems()
		{
			var dbh = (SBDatabase)SBGlobals.GetVar("dbh");
			//##get transaction items
			string query = "SELECT * FROM transaction_items WHERE transaction_id = %d ORDER BY transaction_item_id ASC".
						printf(this.Id);
			var items = dbh.GetResults(query);
			if( items.size <= 0 )
				return;
			foreach(var item in items)
			{
				var t_item = new SBTransactionItem.with_db_data(item);
				this.items.add(t_item);
			}
		}
		public virtual int GetNextSequence()
		{
			var dbh = (SBDatabase)SBGlobals.GetVar("dbh");
			string query = "SELECT (MAX(sequence) + 1) AS next FROM transactions WHERE transaction_type_id = %d".printf(this.TypeId);
			var row = dbh.GetRow(query);
			
			return row.GetInt("next");
		}
		public virtual long CreateTransaction()
		{
			var dbh = (SBDatabase)SBGlobals.GetVar("dbh");
			if( this.items.size <= 0 )
				return -1;
			double subtotal = 0, total = 0;
			foreach(var item in this.items)
			{
				subtotal += item.Price;
			}
			total = subtotal - this.Discount;
			
			string cdate = new DateTime.now_local().format("%Y-%m-%d %H:%M:%S");
			var data = new HashMap<string, Value?>();
			data.set("transaction_type_id", this.TypeId);
			data.set("store_id", this.StoreId);
			data.set("user_id", this.UserId);
			data.set("details", this.Notes);
			data.set("sub_total", subtotal);
			data.set("discount", this.Discount);
			data.set("total", total);
			data.set("status", this.Status);
			data.set("sequence", this.GetNextSequence());
			data.set("owner_code_id", this.CustomerId);
			data.set("last_modification_date", cdate);
			data.set("creation_date", cdate);
			dbh.BeginTransaction();
			this.Id = (int)dbh.Insert("transactions", data);
			//##insert transaction items
			foreach(var item in this.items)
			{
				var oitem = new HashMap<string, Value?>();
				oitem.set("object_id", item.ProductId);
				oitem.set("object_type", "product");
				oitem.set("object_price", item.Price);
				oitem.set("object_quantity", item.Quantity);
				oitem.set("sub_total", item.Price * item.Quantity);
				oitem.set("discount", 0);
				oitem.set("total", item.Price * item.Quantity);
				oitem.set("notes", "");
				oitem.set("transaction_id", this.Id);
				oitem.set("status", "sold");
				oitem.set("last_modification_date", cdate);
				oitem.set("creation_date", cdate);
				dbh.Insert("transaction_items", oitem);
			}
			dbh.EndTransaction();
			return this.Id;
		}
		public void AddItem(int product_id, int qty, double price)
		{
			var item = new SBTransactionItem();
			item.ProductId 	= product_id;
			item.Quantity	= qty;
			item.Price		= price;
			
			this.items.add(item);
		}
		public bool UpdateStatus(string status)
		{
			var dbh = (SBDatabase)SBGlobals.GetVar("dbh");
			string query = "UPDATE transactions SET status = '%s' WHERE transaction_id = %d LIMIT 1".
							printf(status, this.Id);
			
			dbh.Execute(query);
			return true;
		}
		public bool UpdateStock()
		{
			if( this.Id <= 0 )
				return false;
			var dbh = (SBDatabase)SBGlobals.GetVar("dbh");
			foreach(var item in this.items)
			{
				if( item.Quantity <= 0 )
					continue;
				if( item.ProductId <= 0 )
					continue;
				string query = "UPDATE products SET product_quantity = product_quantity - %d " +
								"WHERE product_id = %d LIMIT 1";
					
				dbh.Execute(query.printf(item.Quantity, item.ProductId));
			}
			return true;
		}
		public bool Revert()
		{
			if( this.Id <= 0 )
				return false;
			var dbh = (SBDatabase)SBGlobals.GetVar("dbh");
			foreach(var item in this.items)
			{
				if( item.Quantity <= 0 )
					continue;
				if( item.ProductId <= 0 )
					continue;
				string query = "UPDATE products SET product_quantity = product_quantity + %d "+
								"WHERE product_id = %d LIMIT 1";
				dbh.Execute(query.printf(item.Quantity, item.ProductId));
			}
			this.UpdateStatus("reverted");
			return true;
		}
		public string GetMeta(string meta_key)
		{
			return SBTransaction.SGetMeta(this.Id, meta_key);
		}
		public bool UpdateMeta(string meta_key, string meta_value)
		{
			return SBTransaction.SUpdateMeta(this.Id, meta_key, meta_value);
		}
		public static string SGetMeta(int transaction_id, string meta_key)
		{
			return SBMeta.GetMeta("transaction_meta", meta_key, "transaction_id", transaction_id);
		}
		public static bool SUpdateMeta(int transaction_id, string meta_key, string meta_value)
		{
			return SBMeta.UpdateMeta("transaction_meta", meta_key, meta_value, "transaction_id", transaction_id);
		}
	}
}
