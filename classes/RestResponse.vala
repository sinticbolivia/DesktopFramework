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
			//Value valueData = (obj != null && obj.get_type() == typeof(ArrayList)) ? 
			//		this.buildCollection((ArrayList<Object>)obj) : obj;
			//Object valueData = (obj != null && obj.get_type() == typeof(ArrayList)) ? 
			//		((ArrayList<Object>)obj).to_array() : obj;
			
			size_t size;
			var resObj = new ResponseObject()
			{
				response 	= this.code != 200 ? "error" : "ok",
				code 		= this.code,
				message		= message,
				data 		= obj
			};
			Json.Node root_node = Json.gobject_serialize(resObj);
			Json.Generator generator = new Json.Generator();
			generator.set_root(root_node);
			string _body = generator.to_data(null);
			//print(this.body);
			_body = this.sanitize_json(this.body);
			this(status_code, _body, "application/json");
		}
		protected string sanitize_json(string json)
		{
			//return json;
			
			MatchInfo jsonData;
			//json = /\r?\n|\r|\t/.replace(json, json.length, 0, "", RegexMatchFlags.NOTBOL);
			//json = /:s*/.replace(json, json.length, 0, "", RegexMatchFlags.NOTBOL);
			json = /\s(?=[\s":{}])/.replace(json, json.length, 0, "", RegexMatchFlags.NOTBOL);
			//print("JSON:\n%s\n", json);
			//if( !/"(.*)"\s*:/.match_all_full(json, json.length, 0, RegexMatchFlags.NOTBOL, out jsonData) )
			if( !/"(.*)"\s*:/.match_all(json, RegexMatchFlags.ANCHORED, out jsonData) )
			//if( !/"([a-zA-Z0-9_\-]+)"\s*:/x.match_all(json, RegexMatchFlags.ANCHORED, out jsonData) )
			//if( !/"(.*?)":/.match_all(json, RegexMatchFlags.NOTBOL, out jsonData) )
				return json;
			
			//stdout.printf("count: %d\n", jsonData.get_match_count());
			string newJson = json;
			foreach(string prop in jsonData.fetch_all())
			//for(int i = 0; i < jsonData.get_match_count(); i++)
			{
				//string prop = jsonData.fetch(i);
				//string searchProp = """"%s"""".printf(prop);
				//stdout.printf("%s => %s\n", prop, prop.replace("-", "_"));
				newJson = newJson.replace(prop, prop.replace("-", "_"));
			}
			return newJson;
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
		public RestResponse add_header(string name, string val)
		{
			this.headers.set(name, val);
			return this;
		}
	}
}
