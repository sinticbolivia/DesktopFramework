using Gee;

namespace SinticBolivia.Classes
{
	public abstract class RestController : Object
	{
		public delegate RestResponse? RouteCallback(SBCallbackArgs args);

		protected	Soup.Server		server {get; set;}

		#if __SOUP_VERSION_2_70__
		protected	Soup.Message		message {get; set;}
		#else
		protected	Soup.ServerMessage	message {get; set;}
		#endif
		protected	string				path {get; set;}
		protected	GLib.HashTable<string, string>?		query {get; set;}
		protected	ArrayList<SBWebRoute>		_routes;

		construct
		{
			this._routes 	= new ArrayList<SBWebRoute>();
		}
		protected RestController.with_args(Soup.Server srv,
			#if __SOUP_VERSION_2_70__
			Soup.Message msg,
			#else
			Soup.ServerMessage msg,
			#endif
			string spath,
			GLib.HashTable<string, string>? q
			//#if __SOUP_VERSION_2_70__
			//, Soup.ClientContext client
			//#endif
		)
		{
			this.server 	= srv;
			this.message 	= msg;
			this.path 		= spath;
			this.query 		= (q != null) ? q : new GLib.HashTable<string, string>(str_hash, str_equal);

		}
		public
		#if __SOUP_VERSION_2_70__
		Soup.Message
		#else
		Soup.ServerMessage
		#endif
		get_request_message()
		{
			return this.message;
		}
		protected string get_remote_address()
		{
			#if __SOUP_VERSION_2_70__
			return this.message.get_address().to_string();
			#else
			return this.message.get_remote_address().to_string();
			#endif
		}
		protected string get_user_agent()
		{
			return this.get_header("User-Agent", "");
		}
		public string get_method()
		{
			#if __SOUP_VERSION_2_70__
			return this.message.method;
			#else
			return this.message.get_method();
			#endif
		}
		public bool is_get()
		{
			return this.get_method() == "GET";
		}
		public bool is_post()
		{
			return this.get_method() == "POST";
		}
		public bool is_put()
		{
			return this.get_method() == "PUT";
		}
		public bool is_delete()
		{
			return this.get_method() == "DELETE";
		}
		public string @get(string param, string defVal = "")
		{
			return this.query.contains(param) ? this.query.get(param) : defVal;
		}
		public int getInt(string param, int defVal = 0)
		{
			return this.get_int(param, defVal);
		}
		public int get_int(string param, int defVal = 0)
		{
			return int.parse(this.get(param, defVal.to_string()));
		}
		public long get_long(string param, long defVal = 0)
		{
			return long.parse(this.get(param, defVal.to_string()));
		}
		protected string getRawBody()
		{
			#if __SOUP_VERSION_2_70__
			string raw_body = (string)this.message.request_body.flatten().data;
			#else
			string raw_body = (string)this.message.get_request_body().data;
			#endif
			stdout.printf("RAW BODY: %s\n", raw_body);
			return raw_body;
		}
		public HashMap<string, Value?> to_hashmap()
		{
			string body = this.getRawBody();
			return Utils.JsonDecode(body);
		}
		protected Json.Node? to_json_node()
		{
			string json = this.getRawBody();
			if( json.length <= 0 )
				return null;
			Json.Node? root = Json.from_string(json);

			return root;
		}
		protected Json.Object? to_json_object()
		{
			Json.Node? root = this.to_json_node();
			if( root == null )
				return null;

			return root.get_object();
		}
		protected Json.Array? to_json_array()
		{
			Json.Node? root = this.to_json_node();
			if( root == null )
				return null;

			return root.get_array();
		}
		protected T toObject<T>() throws SBException
		{
			T for_obj = null;
			try
			{
				//if( json == null || json.strip().length <= 0 )
				//	throw new SBException.GENERAL("Unable to parse json body, it is empty");
				//var node = Json.from_string(json);
				var node = this.to_json_node();
				if( node == null )
					throw new SBException.GENERAL("Unable to parse json body");
				/*
				node.get_object().foreach_member((_obj, _name, _node) =>
				{
					stdout.printf("name: %s, value: %s\n", _name, _node.get_value().strdup_contents());
				});
				*/
				for_obj = Object.new(typeof(T));
				if( for_obj is SBSerializable )
				{
					(for_obj as SBSerializable).bind_json_object(node.get_object());
				}
				else
				{
					for_obj = null;
					for_obj = (T)Json.gobject_deserialize(typeof(T), node);
				}

				if( for_obj == null )
					throw new SBException.GENERAL("Unable to deserialize json body to object");
			}
			catch(Error e)
			{
				throw new SBException.GENERAL(e.message);
			}

			return for_obj;
		}
		public string get_header(string name, string defVal = "")
		{
			#if __SOUP_VERSION_2_70__
			string? header_val = this.message.request_headers.get_one(name);
			#else
			string? header_val = this.message.get_request_headers().get_one(name);
			#endif
			if( header_val == null )
				return defVal;

			return header_val;
		}

		public virtual bool match_route(string method, string route, string pattern, out SBCallbackArgs args = null)
		{
			if( this.get_method() != method )
				return false;
			args = new SBCallbackArgs();
			MatchInfo pathDataArgs;
			MatchInfo pathData;
			bool found_args = false;
			stdout.printf("ROUTE: %s\nPATTERN: %s\n", route, pattern);
			if( new Regex(""".*P<(\w+)>.*""").match(pattern, RegexMatchFlags.ANCHORED, out pathDataArgs) )
			{
				stdout.printf("Matched args\n");
				found_args = true;
				//params = pathDataArgs.fetch_all();
			}
			if( new Regex(pattern).match(route, RegexMatchFlags.ANCHORED, out pathData) )
			{
				if( found_args )
				{
					foreach(string arg in pathDataArgs.fetch_all())
					{
						stdout.printf("ROUTE ARG: %s\n", arg);
						args.set_value(arg, pathData.fetch_named(arg));
					}
				}
				return true;
			}
			return false;
		}
		public virtual RestController add_route(string method, string pattern, RouteCallback callback)
		{
			//if( this.match_route(method) )
			this._routes.add( new SBWebRoute(method, pattern, callback) );
			return this;
		}
		public virtual void register_routes(){}
		public virtual RestResponse? before_dispatch(out bool next, RestHandler handler){next = true;return null;}
		public virtual RestResponse dispatch(string route, string method, RestHandler handler)
		{
			var response = new RestResponse(Soup.Status.BAD_REQUEST, "Invalid route");
			try
			{
				foreach(var webroute in this._routes)
				{
					SBCallbackArgs args;
					if( this.match_route(webroute.method, route, webroute.route, out args) )
					{
						response = webroute.callback(args);
						break;
					}
				}
			}
			catch(SBException e)
			{
				return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
			}
            catch(RegexError e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
			return response;
		}
		public virtual void after_dispatch(RestResponse response){}
	}
}
