using Gee;

namespace SinticBolivia.Classes
{
	public abstract class RestController : Object
	{
		protected	Soup.Server		server {get; set;}
		
		#if __SOUP_VERSION_2_70__
		protected	Soup.Message		message {get; set;}
		#else
		protected	Soup.ServerMessage	message {get; set;}
		#endif
		
		protected	string				path {get; set;}
		protected	GLib.HashTable<string, string>?		query {get; set;}
		
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
		protected string get_method()
		{
			#if __SOUP_VERSION_2_70__
			return this.message.method;
			#else
			return this.message.get_method();
			#endif
		}
		public string @get(string param, string defVal = "")
		{
			return this.query.contains(param) ? this.query.get(param) : defVal;
		}
		public int getInt(string param, int defVal = 0)
		{
			return int.parse(this.get(param, defVal.to_string()));
		}
		protected string getRawBody()
		{
			#if __SOUP_VERSION_2_70__
			string raw_body = (string)this.message.request_body.flatten().data;
			#else
			string raw_body = (string)this.message.get_request_body().data;
			#endif
			//print("RAW BODY: %s\n", raw_body);
			return raw_body;
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
			string json = this.getRawBody();
			T obj = null;
			try
			{
				obj = Json.gobject_from_data(typeof(T), json);
			}
			catch(Error e)
			{
				throw new SBException.GENERAL(e.message);
			}
			/*
			if( typeof(T) == typeof(SBSerializable) )
			{
				((Entity)T).setRawJson(json);
			}
			*/
			return obj;
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
		public abstract RestResponse? before_dispatch(out bool next, RestHandler handler);
		public abstract RestResponse dispatch(string route, string method, RestHandler handler);
		public abstract void after_dispatch(RestResponse response);
	}
}
