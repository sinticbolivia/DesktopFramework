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

		public RestHandler(string prefix, Type ctrlType)
		{
			this.prefix 	= prefix;
			this.ctrl_type	= ctrlType;
		}
		protected virtual void request_options()
		{
			var response = new RestResponse(200, "");
			response.add_header("Access-Control-Allow-Origin", "*");
			response.add_header("Access-Control-Allow-Methods", "GET,POST,PUT,DELETE,OPTIONS");
			response.add_header("Access-Control-Allow-Headers", "authorization,content-type,accept,origin,x-user-token,referer");
			this.rest_server.send_response(this.controller.get_request_message(), response);
		}
		public virtual void handler(
			Soup.Server server,
			#if __SOUP_VERSION_2_70__
			Soup.Message srv_message,
			#else
			Soup.ServerMessage srv_message,
			#endif
			string path,
			GLib.HashTable? query
		)
		{
			stdout.printf("%s HANDLER\n", this.prefix);
			stdout.printf("Creation controller for %s HANDLER\n", this.prefix);
			this.controller = (RestController)Object.new(this.ctrl_type, null);
			stdout.printf("CONTROLLER CREATED\n");
			this.controller.set(
				"server", server,
				"message", srv_message,
				"path", path,
				"query", query,
				//"base_route", this.prefix,
				null
			);
			this.controller.init();
			this.controller.register_routes();
			string method = this.controller.get_method();
			if( method == "OPTIONS" )
			{
				this.request_options();
				return;
			}
			bool next = true;
			SBWebRoute? webroute = this.controller.find_webroute(path, method);
			if( webroute == null )
			{
				this.controller.dispose();
				this.rest_server.send_response(srv_message, new RestResponse(Soup.Status.BAD_REQUEST, "Invalid route, not found"));
				return;
			}
			//##TODO: Here we need to set next code into a thread
			//var thread = new Thread( () => 
			//{
				//dispatch code header ...
				
			//});
			//thread.start();
			
			var before_response = this.controller.before_dispatch(webroute, this, out next);
			if( !next )
			{
				this.rest_server.send_response(srv_message, before_response);
				return;
			}
			debug ("CONTROLLER DISPATCH\nPATH: %s (%s)\n", path, method);
			//var response = this.controller.dispatch(path, method, this);
			var response = this.controller.dispatch(webroute, this);
			this.controller.after_dispatch(response);
			response.add_header("Access-Control-Allow-Origin", "*");
			response.add_header("Access-Control-Allow-Methods", "GET,POST,PUT,DELETE,OPTIONS");
			response.add_header("Access-Control-Allow-Headers", "authorization,content-type,accept,origin,x-user-token");
			//var dbh = SBFactory.getDbh();
			//dbh.Close();
			this.controller.dispose();
			this.rest_server.send_response(srv_message, response);
		}
	}
}
