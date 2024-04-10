using Gee;
using SinticBolivia.Database;

namespace SinticBolivia.Classes
{
	public class RestHandler : Object
	{
		public	string				prefix;
		public	string 				route;
		public	RestController		controller = null;
		protected	Type			ctrl_type;
		public	RestServer			rest_server;
		public	ArrayList<string>	routes;

		public RestHandler(string prefix, Type ctrlType)
		{
			this.prefix 	= prefix;
			this.ctrl_type	= ctrlType;
			this.routes = new ArrayList<string>();
		}
		protected virtual void request_options()
		{
			var response = new RestResponse(200, "");
			response.add_header("Access-Control-Allow-Origin", "*");
			response.add_header("Access-Control-Allow-Methods", "GET,POST,PUT,DELETE,OPTIONS");
			response.add_header("Access-Control-Allow-Headers", "authorization,content-type,accept,origin,x-user-token");
			this.rest_server.send_response(this.controller.get_request_message(), response);
		}
		public virtual void handler(
			Soup.Server server,
			#if __SOUP_VERSION_2_70__
			Soup.Message message,
			#else
			Soup.ServerMessage message,
			#endif
			string path,
			GLib.HashTable? query
		)
		{
			stdout.printf("%s HANDLER\n", this.prefix);
			if( this.controller == null )
			{
				stdout.printf("Creation controller for %s HANDLER\n", this.prefix);
				this.controller = (RestController)Object.new(this.ctrl_type, null);
				stdout.printf("CONTROLLER CREATED\n");
			}
			this.controller.set(
				"server", server,
				"message", message,
				"path", path,
				"query", query,
				//"base_route", this.prefix,
				null
			);
			this.controller.register_routes();
			string method = this.controller.get_method();
			if( method == "OPTIONS" )
				this.request_options();
			bool next = true;
			var before_response = this.controller.before_dispatch(out next, this);
			if( !next )
			{
				this.rest_server.send_response(message, before_response);
				return;
			}
			stdout.printf("CONTROLLER DISPATCH\nPATH: %s (%s)\n", path, method);
			var response = this.controller.dispatch(path, method, this);
			this.controller.after_dispatch(response);
			response.add_header("Access-Control-Allow-Origin", "*");
			response.add_header("Access-Control-Allow-Methods", "GET,POST,PUT,DELETE,OPTIONS");
			response.add_header("Access-Control-Allow-Headers", "authorization,content-type,accept,origin,x-user-token");
			//var dbh = SBFactory.getDbh();
			//dbh.Close();
			this.rest_server.send_response(message, response);
		}
	}
}
