using GLib;
using Gee;
using SinticBolivia.Database;

public class Test :  Object
{
	public Test()
	{
	}
	public static void main()
	{
		SBSQLite dbh = new SBSQLite("./mono_business.sqlite");
		dbh.Open();
		dbh.Query("SELECT * FROM categories");
		stdout.printf("total rows: %d\n", dbh.Rows.length);
		int i = 0;
		foreach(SBDBRow row in dbh.Rows)
		{
			stdout.printf("row: %d\n", i);
			stdout.printf("category_id => %s, category_name => %s, \n", row.Get("category_id"), row.Get("name"));
			i++;
		}
		dbh.Close();
		
	}
}
