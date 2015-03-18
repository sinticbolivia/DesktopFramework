using GLib;
using SinticBolivia;
using SinticBolivia.Database;

namespace SinticBolivia
{
	public class SBRole : Object
	{
		protected	SBDBRow dbData = null;
		protected	List<string> permissions;
		
		public	int Id
		{
			get
			{
				return (this.dbData != null) ? int.parse(this.dbData.Get("role_id")) : 0;
			}
			//set{}
		}
		public	string Name
		{
			get
			{
				return this.dbData.Get("role_name");
			}
			set{ this.dbData.Set("role_name", value);}
		}
			   
		public SBRole()
		{
			this.permissions = new List<string>();
		}
		public SBRole.from_id(int role_id)
					requires( role_id > 0 )
		{
			this.permissions = new List<string>();
			this.GetDbData(role_id);
		}
		public void GetDbData(int rid)
		{
			var dbh = (SBDatabase)SBGlobals.GetVar("dbh");
			
			string query = "SELECT * FROM user_roles WHERE role_id = %d LIMIT 1".printf(rid);
			var row = dbh.GetRow(query);
			if( row == null )
				return;
				
			this.dbData	= row;
			
			//##get permissions
			query = "SELECT * FROM permissions p, role2permission r2p "+
							"WHERE p.permission_id = r2p.permission_id "+
							"AND r2p.role_id = %d";
			query = query.printf(rid);
			var perms = dbh.GetResults(query);
			if( perms.size <= 0 )
				return;
			foreach(var trow in perms)
			{
				this.permissions.append(trow.Get("permission"));
			}
			
		}
		public void SetDbData(owned SBDBRow row)
		{
			this.dbData = (owned)row;
		}
		public bool HasPermission(string perm)
		{
			
			bool exist = false;
			
			this.permissions.foreach( (entry) => 
			{
				if( entry == perm )
					exist = true;
			});
			
			return exist;
		}
	}
}
