using GLib;
using Gee;
using SinticBolivia;
using SinticBolivia.Database;

namespace SinticBolivia
{
	public class SBFactory
	{
		public		static	SBConfig		config;
		protected	static	SBDatabase	dbh;
		
		public static SBDatabase? getDbh(bool new_conn = false) throws SBDatabaseException
		{
			if( dbh != null && !new_conn )
				return dbh;
			dbh = GetNewDbHandlerFromConfig(config);
			
			return dbh;
		}
		public static SBDatabase? GetNewDbHandlerFromConfig(SBConfig cfg)  throws SBDatabaseException
		{
			string db_engine 	= (string)cfg.GetValue("database_engine", "sqlite3");
			string db_server 	= (string)cfg.GetValue("db_server", "");
			string db_name 		= (string)cfg.GetValue("db_name", "");
			SBDatabase? dbh 	= null;
			
			if( db_engine == "sqlite3")
			{
				dbh = new SBSQLite( SinticBolivia.SBFileHelper.SanitizePath("database/%s".printf(db_server)));
			}
			else if( db_engine == "mysql")
			{
				string dbname 	= (string)cfg.GetValue("db_name", "");
				string user 	= (string)cfg.GetValue("db_user", "");
				string pass 	= (string)cfg.GetValue("db_pass", "");
				int port		= int.parse((string)cfg.GetValue("db_port", "3306"));
				
				dbh = new SBMySQL(db_server, dbname, user, pass, port);
				dbh.SelectDb(dbname);
			}
			else if( db_engine == "postgres" )
			{
				string dbname 	= (string)cfg.GetValue("db_name", "");
				string user 	= (string)cfg.GetValue("db_user", "");
				string pass 	= (string)cfg.GetValue("db_pass", "");
				int port		= int.parse((string)cfg.GetValue("db_port", "5432"));
				
				dbh = new SBPostgres(db_server, dbname, user, pass, port);
				dbh.SelectDb(dbname);
			}
			else
			{
				stderr.printf("ERROR: The database engine '%s' is not supported.\n", db_engine);
				return null;
			}
			dbh.Open();
			return dbh;
		}
		public static SBDatabase? GetNewDbHandler(string db_engine, HashMap<string, Value?> args) throws SBDatabaseException
		{
			SBDatabase? dbh = null;
			
			if( db_engine == "sqlite3")
			{
				dbh = new SBSQLite( SinticBolivia.SBFileHelper.SanitizePath("db/%s".printf((string)args["db_file"])) );
			}
			else if( db_engine == "mysql")
			{
				string db_server= (string)args["db_server"];
				string dbname 	= (string)args["db_name"];
				string user 	= (string)args["db_user"];
				string pass 	= (string)args["db_pass"];
				int port		= (int)args["db_port"];
				
				dbh = new SBMySQL(db_server, dbname, user, pass, port);
			}
			else if( db_engine == "postgres" )
			{
				string db_server= (string)args["db_server"];
				string dbname 	= (string)args["db_name"];
				string user 	= (string)args["db_user"];
				string pass 	= (string)args["db_pass"];
				int port		= int.parse((string)args["db_port"]);
				
				dbh = new SBPostgres(db_server, dbname, user, pass, port);
				//dbh.SelectDb(dbname);
			}
			else
			{
				stderr.printf("ERROR: The database engine '%s' is not supported.\n", db_engine);
				return null;
			}
			dbh.Open();
			return dbh;
		}
	}
}
