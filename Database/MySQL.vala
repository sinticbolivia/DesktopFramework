using GLib;
using Gee;
//using Mysql;
//using Mysql;

namespace SinticBolivia.Database
{
	public class SBMySQL : SBDatabase
	{
		protected	string		server;
		protected	string		databaseName;
		protected	string 		username;
		protected	string		password;
		protected	int			port;
		protected	Mysql.Database	dbh;
		protected	Mysql.Result		resultSet;
		
		public SBMySQL(string db_server, string? db_name, string db_user, string db_pass, int db_port = 3306)
		{
			this._databaseType 		= "mysql";
			this.columnLeftWrap 	= "`";
			this.columnRightWrap 	= "`";
			this.server 			= db_server;
			this.databaseName 		= db_name != null ? db_name : "";
			this.username			= db_user;
			this.password			= db_pass;
			this.port				= db_port;
			
			this.dbh = new Mysql.Database();
		}
		public override bool Open()
		{
			if( !this.dbh.real_connect(this.server, this.username, this.password, null, this.port) )
			{
				stderr.printf("MYSQL ERROR: %s\n", SBText.__("Error trying to connect with mysql server"));
				return false;
			}
			if( this.databaseName != "" )
				this.dbh.select_db(this.databaseName);
			
			return true;
		}
		public override bool Close()
		{
			this.dbh = null;
			return true;
		}
		public override void SelectDb(string db_name)
		{
			this.databaseName = db_name;
			this.dbh.select_db(this.databaseName);
		}
		public override long Query(string? query = null)
		{
			this.resultSet = null;
			string q = query != null ? query : this.builtQuery;
			int res = this.dbh.query( q );
			if( res != 0 )
			{
				stderr.printf("MYSQL ERROR: %s\nQUERY WAS: %s\n", this.dbh.error(), q);
				
				return res;
			}
			this.resultSet = this.dbh.use_result();
			
			return 0;
		}
		public override	SBDBRow? GetRow(string? query)
		{
			string[]? row = this.resultSet.fetch_row();
			
			if( row == null )
				return null;
				
			Mysql.Field[] fields 	= this.resultSet.fetch_fields();
			var db_row 		= new SBDBRow();
			
			for(int i = 0; i < fields.length; i++)
			{
				db_row.Set(fields[i].name, row[i]);
			}
			
			return db_row;
		}
		public override	ArrayList<SBDBRow> GetResults(string? query)
		{
			var rows = new ArrayList<SBDBRow>();
			Mysql.Field[] fields = this.resultSet.fetch_fields();
			
			string[] row;
			
			while( (row = this.resultSet.fetch_row()) != null )
			{
				var _row = new SBDBRow();
				for(int i = 0; i < fields.length; i++)
				{
					_row.Set(fields[i].name, row[i]);
				}
				rows.add(_row);
			}
			
			return rows;
		}
		public override	long Execute(string sql)
		{
			
			return 0;
		}
		public override	void BeginTransaction(){}
		public override	void EndTransaction(){}
	}
}
