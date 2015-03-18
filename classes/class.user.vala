using GLib;
using Gee;
using SinticBolivia.Database;

namespace SinticBolivia
{
	public class SBUser : SBDbObject
	{
		//protected 	SBDBRow	dbData = null;
		protected 	SBRole role;
		
		public	int Id
		{
			get{return (this.dbData != null) ? this.dbData.GetInt("user_id") : 0 ;}
			set{this.dbData.Set("user_id", value.to_string());}
		}
		public	string Firstname
		{
			get{return this.dbData.Get("first_name");}
			set{this.dbData.Set("first_name", value);}
		}
		public	string Lastname
		{
			get{return this.dbData.Get("last_name");}
			set{this.dbData.Set("last_name", value);}
		}
		public	string Username
		{
			get{return this.dbData.Get("username");}
			set{this.dbData.Set("username", value);}
		}
		public	string Password
		{
			get{return this.dbData.Get("pwd");}
		}
		public	string Email
		{
			get{return this.dbData.Get("email");}
			set{this.dbData.Set("email", value);}
		}
		public	string Status
		{
			get{return this.dbData.Get("status");}
		}
		
		public	int RoleId
		{
			get{return this.role.Id;}
		}
		public SBRole Role
		{
			get{return this.role;}
		}
		public SBUser()
		{
			Object();
			this.dbData = new SBDBRow();
		}
		public SBUser.from_id(int user_id)
						requires( user_id > 0)
		{
			this();
			this.GetDbData(user_id);
		}
		public SBUser.with_db_data(SBDBRow row)
		{
			this.dbData = row;
		}
		public void GetDbData(int user_id)
		{
			var dbh = (SBDatabase)SBGlobals.GetVar("dbh");
			string query = "SELECT * FROM users WHERE user_id = %d LIMIT 1".printf(user_id);
			
			var row = dbh.GetRow(query);
			if( row != null )
			{
				this.dbData = row;
				this.role = new SBRole.from_id( this.dbData.GetInt("role_id") );				
			}
		}
		public bool HasPermission(string perm)
		{
			if( this.role == null )
			{
				this.role = new SBRole.from_id( this.dbData.GetInt("role_id") );
			}
			return this.role.HasPermission(perm);
		}
		public string GetMeta(string meta_key)
		{
			return SBUser.SGetMeta(this.Id, meta_key);
		}
		public static string SGetMeta(int user_id, string meta_key)
		{
			return SBMeta.GetMeta("user_meta", meta_key, "user_id", user_id);
		}
	}
}
