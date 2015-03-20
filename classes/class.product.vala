using GLib;
using Gee;
using SinticBolivia;
using SinticBolivia.Database;

namespace SinticBolivia
{
	public class SBProduct : SBDbObject
	{
		public int Id
		{
			get{return int.parse(this.dbData.Get("product_id"));}
		}
		public string Code
		{
			get{return this.dbData.Get("product_code");}
		}
		public string InternalCode
		{
			get{return this.dbData.Get("product_internal_code");}
		}
		public int ExternId
		{
			get{return int.parse(this.dbData.Get("extern_id"));}
		}
		public string Name
		{
			get{return this.dbData.Get("product_name");}
		}
		public string Description
		{
			get{return this.dbData.Get("product_description");}
		}
		public string SerialNumber
		{
			get{return this.dbData.Get("product_serial_number");}
		}
		public string Barcode
		{
			get{return this.dbData.Get("product_barcode");}
		}
		public double Cost
		{
			get{return double.parse(this.dbData.Get("product_cost"));}
		}
		public double Price
		{
			get{return double.parse(this.dbData.Get("product_price"));}
		}
		public double Price2
		{
			get{return double.parse(this.dbData.Get("product_price_2"));}
		}
		public int Quantity
		{
			get{return this.dbData.GetInt("product_quantity");}
		}
		public int MinStock
		{
			get{return this.dbData.GetInt("min_stock");}
		}
		public int StoreId
		{
			
			get{return int.parse(this.dbData.Get("store_id"));}
		}
		public int AuthorId
		{
			
			get{return int.parse(this.dbData.Get("author_id"));}
		}
		public string Status
		{
			get{return this.dbData.Get("status");}
		}
		public ArrayList<string> ImageFiles
		{
			get{return this.images;}
		}
		public ArrayList<int> CategoriesIds
		{
			get{return this.categoriesIds;}
		}
		public ArrayList<SBLCategory> Categories
		{
			get{return this.categories;}
		}
		
		protected 	ArrayList<string> 		images;
		public		ArrayList<SBDBRow>		Attachments;
		protected 	ArrayList<int>			categoriesIds;
		protected 	ArrayList<SBLCategory>	categories;
		public		HashMap<string, string> Meta;
		
		public SBProduct()
		{
			this.dbData = new SBDBRow();
			this.images = new ArrayList<string>();
			this.Attachments = new ArrayList<SBDBRow>();
			this.categoriesIds = new ArrayList<int>();
			this.categories		= new ArrayList<SBLCategory>();
			this.Meta = new HashMap<string, string>();
		}
		public SBProduct.from_id(int id)
				requires( id > 0 )
		{
			this();
			//this.images = new ArrayList<string>();
			this.GetDbData(id);
			this.GetDbMeta();
		}
		public SBProduct.with_db_data(owned SBDBRow row)
		{
			this();
			//this.images = new ArrayList<string>();
			this.dbData = row;
			this.getCategories();
			this.getImages();
		}
		public void GetDbData(int id)
		{
			string query = "SELECT * FROM products WHERE product_id = %d".printf(id);
			var row = this.Dbh.GetRow(query);
			if( row == null)
				return;
			this.dbData = row;
			this.getCategories();
			this.getImages();
		}
		public void SetDbData(owned SBDBRow row)
		{
			this.dbData = row;
		}
		public void GetDbMeta()
		{
			this.Dbh.Select("*").From("product_meta").Where("product_id = %d".printf(this.Id));
			foreach(var row in this.Dbh.GetResults(null))
			{
				this.Meta.set(row.Get("meta_key"), row.Get("meta_value"));
			}
		}
		protected void getCategories()
		{
			var dbh = (SBDatabase)SBGlobals.GetVar("dbh");
			string query = "SELECT category_id FROM product2category WHERE product_id = %d".printf(this.Id);
			var records = dbh.GetResults(query);
			foreach(var row in records)
			{
				var cat = new SBLCategory.from_id( int.parse(row.Get("category_id")) );
				this.categories.add(cat);
				this.categoriesIds.add(cat.Id);
			}
		}
		protected void getImages()
		{
			var dbh = (SBDatabase)SBGlobals.GetVar("dbh");
			string query = "SELECT * FROM attachments "+
							"WHERE lower(object_type) = 'product' "+
							"AND object_id = '%d' "+
							"AND (type = 'image' OR type = 'image_thumbnail') "+
							"ORDER BY creation_date ASC";
			query = query.printf(this.Id);
			this.Attachments = dbh.GetResults(query);
			foreach(SBDBRow row in this.Attachments)
			{
				this.images.add(row.Get("file"));
			}
			
		}
		public string GetThumbnail()
		{
			string thumb = "";
			foreach(var row in this.Attachments)
			{
				if( row.Get("type") == "image_thumbnail" )
				{
					thumb = row.Get("file");
					break;
				}
			}
			
			return thumb;
		}
		public static long AddMeta(int pid, string meta_key, Value meta_value)
		{
			string cdate = new DateTime.now_local().format("%Y-%m-%d %H:%M-%S");
			var dbh = (SBDatabase)SBGlobals.GetVar("dbh");
			var data = new HashMap<string, Value?>();
			data.set("product_id", pid);
			data.set("meta_key", meta_key);
			data.set("meta_value", meta_value);
			data.set("last_modification_date", cdate);
			data.set("creation_date", cdate);
			return dbh.Insert("product_meta", data);
		}
		public static string? GetMeta(int pid, string meta_key)
		{
			var dbh = (SBDatabase)SBGlobals.GetVar("dbh");
			string query = @"SELECT * FROM product_meta WHERE product_id = $pid AND meta_key = '$meta_key' LIMIT 1";
			var recs = (ArrayList<SBDBRow>)dbh.GetResults(query);
			if( recs.size <= 0 )
				return null;
			
			return recs.get(0).Get("meta_value");
		}
		public static bool UpdateMeta(int pid, string meta_key, Value meta_value)
		{
			if( SBProduct.GetMeta(pid, meta_key) == null )
			{
				SBProduct.AddMeta(pid, meta_key, meta_value);
				return true;
			}
			
			var dbh = (SBDatabase)SBGlobals.GetVar("dbh");
			string cdate = new DateTime.now_local().format("%Y-%m-%d %H:%M-%S");
			var data = new HashMap<string, Value?>();
			var w = new HashMap<string, Value?>();
			
			data.set("meta_key", meta_key);
			data.set("meta_value", meta_value);
			data.set("last_modification_date", cdate);
			
			w.set("product_id", pid);
			w.set("meta_key", meta_key);
			dbh.Update("product_meta", data, w);
			return true;
		}
	}
}
