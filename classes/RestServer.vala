using Gee;
//using SinticBolivia.Classes;

namespace SinticBolivia.Classes
{
	public class RestServer
	{
		public	Soup.Server				server;
		protected	uint				port;
		
		//public delegate void ControllerHandler(Soup.Message msg, string path, GLib.HashTable? query, Soup.ClientContext client);
		public signal void on_handler_done(string path, RestController? controller = null);
		
		public RestServer(uint sport = 2205)
		{
			this.port = sport;
			//this.server = new Soup.Server(Soup.SERVER_PORT, this.port);
			this.server = new Soup.Server("");
			this.setEvents();
		}
		protected void setEvents()
		{
			
		}
		protected void baseHandler(Soup.Server server, 
			#if __SOUP_VERSION_2_70__
			Soup.Message message, 
			#else
			Soup.ServerMessage message, 
			#endif
			string path,
			GLib.HashTable? query
		)
		{
			
		}
		public string getRequestMethod(
			#if __SOUP_VERSION_2_70__
			Soup.Message message
			#else
			Soup.ServerMessage message
			#endif
		)
		{
			#if __SOUP_VERSION_2_70__
			return message.method;
			#else
			return message.get_method();
			#endif
		}
		public void add_handler(RestHandler handler)
		{
			handler.rest_server = this;
			this.server.add_handler(handler.prefix, handler.handler);
		}
		public void start(bool init_loop = false)
		{
			try
			{
				bool res = this.server.listen_all(this.port, Soup.ServerListenOptions.IPV4_ONLY);
				stdout.printf(@"Rest server started at $(this.port) => $res\n");
				if( init_loop )
				{
					var loop = new MainLoop ();
					loop.run ();
				}
			}
			catch(Error e)
			{
				stderr.printf("REST SERVER ERROR: %s\n", e.message);
			}
			
			//this.server.run_async();
		}
		public void send_response(
			#if __SOUP_VERSION_2_70__
			Soup.Message message, 
			#else
			Soup.ServerMessage message, 
			#endif
			owned RestResponse? response
		)
		{
			//this.send_response(message, response);
			if( response == null )
			{
				response = new RestResponse(500, "Invalid response, response is null");
			}
			//msg.set_response("application/json", Soup.MemoryUse.COPY, json.data);
			//stdout.printf((string)response.body.data);
			foreach(var entry in response.headers.entries)
			{
				#if __SOUP_VERSION_2_70__
				message.response_headers.append(entry.key, entry.value);
				#else
				message.get_response_headers().append(entry.key, entry.value);
				#endif
			}
			#if __SOUP_VERSION_2_70__
			message.set_status(response.code);
			#else
			message.set_status(response.code, null);
			#endif
			message.set_response(response.content_type, Soup.MemoryUse.COPY, response.body.data);
			
		}
	}
}
