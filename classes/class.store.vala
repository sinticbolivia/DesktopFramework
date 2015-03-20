using GLib;
using Gee;
using SinticBolivia;
using SinticBolivia.Database;

namespace SinticBolivia
{
	public class SBStore : SBDbObject
	{
		//protected SBDBRow dbData;
		
		public int Id
		{
			get
			{
				return int.parse(this.dbData.Get("store_id"));
			}
		}
		public string Name
		{
			get{return this.dbData.Get("store_name");}
		}
		public string Address
		{
			get{return this.dbData.Get("store_address");}
		}
		
		public SBStore()
		{
			this.dbData = new SBDBRow();
		}
		public SBStore.from_id(int store_id)
						requires(store_id > 0)
		{
			this();
			this.GetDbData(store_id);
		}
		public SBStore.with_db_data(SBDBRow row)
		{
			this.dbData = row;
		}
		public void GetDbData(int store_id)
						requires(store_id > 0)
		{
			var dbh = (SBDatabase)SBGlobals.GetVar("dbh");
			string query = "SELECT * FROM stores WHERE store_id = %d".printf(store_id);
			var row = dbh.GetRow(query);
			if( row == null )
				return;
				
			this.dbData = row;
		}
		public void SetDbData(owned SBDBRow row)
		{
			this.dbData = row;
		}
		public string GetMeta(string meta_key)
		{
			return SBStore.SGetMeta(this.Id, meta_key);
		}
		public bool UpdateMeta(string meta_key, string meta_value)
		{
			return SBStore.SUpdateMeta(this.Id, meta_key, meta_value);
		}
		public static string SGetMeta(int store_id, string meta_key)
		{
			return SBMeta.GetMeta("store_meta", meta_key, "store_id", store_id);
		}
		public static bool SUpdateMeta(int store_id, string meta_key, string meta_value)
		{
			return SBMeta.UpdateMeta("store_meta", meta_key, meta_value, "store_id", store_id);
		}
	}
}
