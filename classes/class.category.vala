using GLib;
using Gee;
using SinticBolivia;
using SinticBolivia.Database;

namespace Woocommerce
{
	public class SBLCategory : Object
	{
		protected SBDBRow	dbData;
		protected ArrayList<SBLCategory> childs;
		
		public int Id
		{
			get{ return this.dbData.GetInt("category_id");}
			set{this.dbData.Set("category_id", value.to_string());}
		}
		public string Name
		{
			get{ return this.dbData.Get("name");}
		}
		public string Description
		{
			get{ return this.dbData.Get("description");}
		}
		public int ParentId
		{
			get{ return int.parse(this.dbData.Get("parent"));}
		}
		public int StoreId
		{
			get{ return int.parse(this.dbData.Get("store_id"));}
		}
		public ArrayList<SBLCategory> Childs
		{
			get{return this.childs;}
		}
		public SBLCategory()
		{
			this.childs = new ArrayList<SBLCategory>();
		}
		public SBLCategory.from_id(int cat_id)
						requires(cat_id > 0)
		{
			this();
			this.GetDbData(cat_id);
		}
		public SBLCategory.with_db_data(owned SBDBRow row)
		{
			this();
			this.dbData = row;
			this.getChilds();
		}
		public void GetDbData(int cat_id)
		{
			var dbh = (SBDatabase)SBGlobals.GetVar("dbh");
			string query = @"SELECT * FROM categories WHERE category_id = $cat_id LIMIT 1";
			var records = dbh.GetResults(query);
			if( records.size <= 0 )
				return;
			this.dbData = records.get(0);
			this.getChilds();
		}
		protected void getChilds()
		{
			var dbh = (SBDatabase)SBGlobals.GetVar("dbh");
			//##get childs
			string query = "SELECT * FROM categories WHERE parent = %d".printf(this.Id);
			var records = dbh.GetResults(query);
			if( records.size <= 0 )
				return;
			foreach(var row in records)
			{
				this.childs.add(new SBLCategory.with_db_data(row));
			}
		}
	}
}
