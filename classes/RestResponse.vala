using Gee;

namespace SinticBolivia.Classes
{
	public class ResponseObject : SBSerializable //Object
	{
		public	string response {get; set;}
		public	uint	code {get; set;}
		public	string?	message {get; set; default = null;}
		public	Object?	data	{get; set;}
	}
	public class RestResponse : Object
	{
		public	uint	code;
		public	string	body;
		public	string	content_type = "text/html";
		public	HashMap<string, string>	headers;

		public RestResponse(uint status_code, string body, string content_type = "text/html")
		{
			this.code = status_code;
			this.body = body;
			this.content_type = content_type;
			this.headers = new HashMap<string, string>();
		}
		public RestResponse.json_object(uint status_code, Object? obj, string? message = null)
		{
			size_t size;
			var resObj = new ResponseObject()
			{
				response 	= status_code != 200 ? "error" : "ok",
				code 		= status_code,
				message		= message,
				data 		= obj
			};
			//Json.Node root_node = Json.gobject_serialize(resObj);
			//Json.Generator generator = new Json.Generator();
			//generator.set_root(root_node);
			string _body = resObj.to_json(); //generator.to_data(null);
			//print(_body);
			//_body = this.sanitize_json(this.body);
			this(status_code, _body, "application/json");
		}
		public virtual RestResponse add_header(string name, string val)
		{
			this.headers.set(name, val);
			return this;
		}
		public virtual RestResponse set_content_type(string type)
		{
			this.content_type = type;
			return this;
		}
		protected virtual Object[] buildCollection(Gee.ArrayList<Object> items)
		{
			Object[] objs = new Object[items.size - 1];
			for(int i = 0; i < items.size; i++)
			{
				objs[i] = items.get(i);
			}
			return objs;
		}
	}
}
