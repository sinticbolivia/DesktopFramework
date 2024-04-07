using Gee;
//using SinticBolivia.Classes;

namespace SinticBolivia.Classes
{
	public class RestServer
	{
		protected 	delegate Type GetModuleType (Module module);

		public	Soup.Server				server;
		protected	uint				port;
		protected	ArrayList<Soup.WebsocketConnection>	sockets;
		protected	ArrayList<WebRoute>	routes;
		//public delegate void ControllerHandler(Soup.Message msg, string path, GLib.HashTable? query, Soup.ClientContext client);
		public signal void on_handler_done(string path, RestController? controller = null);

		public RestServer(uint sport = 2205)
		{
			this.port 		= sport;
			//this.server = new Soup.Server(Soup.SERVER_PORT, this.port);
			this.server		= new Soup.Server(""/*Soup.SOCKET_TIMEOUT, "1000"*/);
			this.sockets 	= new ArrayList<Soup.WebsocketConnection>();
			this.routes 	= new ArrayList<WebRoute>();
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
		public RestHandler add_handler_args(string prefix, Type controller_type)
		{
			var handler = new RestHandler(prefix, controller_type);
			this.add_handler(handler);
			return handler;
		}
		public void prepare_websocket()
		{
			string[] protocols = {"chat", "data", "ws"};
			this.server.add_websocket_handler("/", null, protocols, this.websocket_callback);
		}
		public void websocket_callback(
			Soup.Server srv,
			#if __SOUP_VERSION_2_70__
			Soup.WebsocketConnection conn,
			string path,
			Soup.ClientContext client
			#else
			Soup.ServerMessage message,
			string path,
			Soup.WebsocketConnection conn
			#endif
		)
		{
			print("WEBSOCKET HANDLER CALLBACK\n");
			//conn.message.connect( (id, bytes) =>
			//{
			//});
			conn.message.connect(this.websocket_message_received);
			#if __SOUP_VERSION_2_70__
			string host = client.get_host();
			info (@"Client connected! Host: $host");
			#endif

			#if __SOUP_VERSION_2_70__
			//conn.io_stream.input_stream.read_all();
			string ws_key = "";
			string ws_protocol = "";
			string ws_version = "";
			#else
			var headers = message.get_request_headers();
			string ws_key = headers.get_one("Sec-WebSocket-Key");
			string ws_protocol = headers.get_one("Sec-WebSocket-Protocol");
			string ws_version = headers.get_one ("Sec-WebSocket-Version");
			#endif
			
			print("WS KEY: %s\n", ws_key);
			var ws_accept_sha1 = new Checksum (ChecksumType.SHA1);
			ws_accept_sha1.update (ws_key.data, ws_key.length);
			ws_accept_sha1.update ("258EAFA5-E914-47DA-95CA-C5AB0DC85B11".data, 36);
			uint8 ws_accept_digest[20];
			size_t ws_accept_digest_len = 20;
			ws_accept_sha1.get_digest (ws_accept_digest, ref ws_accept_digest_len);
			var ws_accept = Base64.encode (ws_accept_digest);

			//foreach(var header_protocol in Soup.header_parse_list(ws_protocol))
			//{
			//	print("SOUP PROTOCOL: %s\n", header_protocol);
			//}
			#if __SOUP_VERSION_2_70__

			#else
			var reponse_headers = message.get_response_headers();
			#endif
			this.sockets.add(conn);
			conn.message.connect((type, buffer) =>
			{
				print("WEB SOCKET MESSAGE RECEIVED: %s\n", (string)buffer.get_data());
			});
			string socket_headers =
				"HTTP/1.1 %u WebSocket Protocol Handshake\r\n".printf(Soup.Status.SWITCHING_PROTOCOLS) +
				"Connection: Upgrade\r\n" +
				"WebSocket-Origin: %s\r\n".printf(conn.get_origin()) +
				"Upgrade: websocket\r\n" +
				"Sec-WebSocket-Accept: %s\r\n".printf(ws_accept) +
				"\r\n";
			print("SOCKETS HEADERS: \n%s\n", socket_headers);
			conn.io_stream.output_stream.write_all(socket_headers.data, null, null);

			string msg = """test_message1""";
			print(@"Sending to client message: $msg");
			//conn.send_text(msg);
			conn.io_stream.output_stream.write_all(msg.data, null, null);
		}
		public void websocket_message_received(int id, Bytes buffer)
		{
			print("WEBSOCKET MESSAGE RECEIVED\n");
			string message = (string)buffer.get_data();
			info(@"Message received! ID: $id Message:\n$message\n");
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
		public void add_route(string route, string method, WebRouteCallback cb)
		{
			var webroute = new WebRoute()
			{
				route = route,
				method = method,
				content_type = "application/json"
				//callback = cb
			};
			this.routes.add(webroute);
		}
		public bool load_module(string path) throws SBException
		{
			if( !FileUtils.test(path, FileTest.IS_REGULAR) )
			{
				stderr.printf("The module file '%s' does not exists", path);
				//throw new SBException.GENERAL("The module file '%s' does not exists".printf(path))
				return false;
			}
			GLib.Module module = GLib.Module.open(path, ModuleFlags.BIND_LAZY);
			if( module == null )
			{
				stderr.printf("The module '%s' cant by loaded", path);
				return false;
			}
			void* function;
			string module_symbol = "sb_get_rest_module_type";
			//##we call a generic functions into module and we get the function into a pointer
			module.symbol(module_symbol, out function);
			//##we cast the pointer to delegate
			unowned GetModuleType get_module_type = (GetModuleType)function;
			GLib.Type mod_type = get_module_type(module);
			//##note: we have the module ready to execute
			//## now we create an instance of module and using the module interface
			var module_obj	= (ISBRestModule)Object.new(mod_type);
			//##we call the module methods
			module_obj.load();
			module_obj.init(this);
			//## We don't want our modules to ever unload
			module.make_resident ();
			return true;
		}
	}
}
