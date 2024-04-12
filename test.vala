using GLib;
using SinticBolivia;
using SinticBolivia.Classes;
using SinticBolivia.Database;

namespace Test
{
	public class SBApplication : Entity
	{
		public long id {get; set;}
		public string name {get; set;}
		public string key {get; set;}
		public string description {get; set;}

		construct
		{
			//Object(table: "applications", primary_key: "id");
			this._table = "applications";
			this._primary_key = "id";
		}
		public SBApplication()
		{

		}
	}
}
public void send_email()
{
	var smtp = new SBSmtpClient()
	{
		server 	= "mail.sinticbolivia.net",
		port	= 25
	};
	smtp.open(SmtpConnectionSecurity.SECURITY_STARTTLS);
	smtp.auth("ventas@sinticbolivia.net", "JnmsAKmu4k5I", SmtpAuthMethod.AUTH_LOGIN);
	smtp.addFrom("ventas@sinticbolivia.net", "Test SinticLibrary");
	smtp.addAddress("marcenickg@gmail.com", "%s %s".printf("Pepito", "Perez"));
	//smtp.addAttachmentFile(this.printInvoice(invoice, false));
	//smtp.addAttachmentData("invoice-%s.xml".printf(invoice.invoice_number.to_string()), siatInvoice.toXml().data);
	smtp.send("Test subject", "Test Message body");
	smtp.close();
}
public void show_processor()
{
	var os = new SBOS();
	string psn = os.GetProcessorSN();

	stdout.printf("Processor S/N: %s\n", psn);
}
public SBDatabase get_db_instance() throws SBDatabaseException
{
	SBFactory.config = new SBConfig("config.xml", "config");
	var dbh = SBFactory.getDbh();
	return dbh;
}
public void test_postgres()
{
	try
	{
		var dbh = get_db_instance();
		//dbh.Query("SELECT * FROM mb_invoices");
		//dbh.Execute("BEGIN");
		//dbh.Execute("DECLARE myusers CURSOR FOR SELECT * FROM users;");
		//res = conn.exec ("FETCH ALL in myusers");
		//var items = dbh.GetResults("FETCH ALL in myusers;");
		var items = dbh.GetResults("SELECT * FROM applications");
		foreach(var row in items)
		{
			stdout.printf("Name: %s\n", row.Get("name"));
		}
		//dbh.Execute("END");
	}
	catch(SBDatabaseException e)
	{
		stderr.printf("ERROR: %s\n", e.message);
	}

}
public void test_entity()
{
	get_db_instance();
	size_t size;
	var a = new Test.SBApplication();
	//stdout.printf(a.get_table());
	var app = Entity.read<Test.SBApplication>(5);
	stdout.printf("Name: %s\nCreation Date: %s\n", app.name, app.creation_date.format("%Y-%m-%d %H:%M:%S"));
	stdout.printf(Json.gobject_to_data(app, out size));
}
public void test_query()
{
	var builder = new SBDBQuery();
	builder
		.select("id,application_id,product_id,name")
		.from("subscriptions_plans sp")
		.where()
			.equals("id", 1)
			.or()
			.greater_than("application_id", 5)
			.and()
			.where_group((qb) =>
			{
				qb.where("name", "like", "x")
					.or()
					.where("TRIM(sp.description)", "<>", "''")
				;
			})
			.and()
			.in_array("status", new string[]{"disabled", "enabled"})
			.and()
			.is_null("description")
		.order_by("id");
	stdout.printf("BUILT QUERY:\n%s\n", builder.sql());
}
public int main(string[] args)
{
	send_email();
	get_db_instance();
	//show_processor();
	//test_postgres();
	//test_entity();
	test_query();
	return 0;
}
