using GLib;
using Gee;

namespace SinticBolivia
{
	public class Utils
	{
		public static string hashtable_to_json(HashTable<string, string> data)
		{
			var gen = new Json.Generator();
			var root_node = new Json.Node(Json.NodeType.OBJECT);
			var root_obj = new Json.Object();
			root_node.set_object(root_obj);
			gen.set_root(root_node);
			foreach(string key in data.get_keys())
			{
				root_obj.set_string_member(key, data.get(key));
			}
			size_t size;
			return gen.to_data(out size);
		}
		public static string JsonEncode(HashMap<string,Value?> data)
		{
			var gen = new Json.Generator();
			var root_node = new Json.Node(Json.NodeType.OBJECT);
			var root_obj = new Json.Object();
			root_node.set_object(root_obj);
			gen.set_root(root_node);
			
			foreach(string key in data.keys)
			{
				root_obj.set_string_member(key, (string)data[key]);
			}
			size_t size;
			return gen.to_data(out size);
		}
		public static HashMap<string,string> JsonDecode(string json)
		{
			var data = new HashMap<string,string>();
			if( json.length <= 0 )
				return data;
				
			var parser = new Json.Parser ();
			try
			{
				parser.load_from_data(json, -1);
				var main_obj = parser.get_root().get_object();
			
				foreach(string member in main_obj.get_members())
				{
					data.set(member, main_obj.get_string_member(member));
				}
			}
			catch(GLib.Error e)
			{
				stderr.printf("Utils.JsonDecode ERROR: %s\n", e.message);
			}
			return data;
		}
		public static string FillCeros(int number, int ceros_length = 6)
		{
			string number_str = number.to_string();
			string str = "";
			for(int i = 0; i < (ceros_length - number_str.length); i++)
			{
				str += "0";
			}
			
			return "%s%d".printf(str, number);
		}
		public static string hashmap_to_json(HashMap<string, Value?> data)
		{
			var gen = new Json.Generator();
			var root = new Json.Node(Json.NodeType.OBJECT);
			var object = new Json.Object();
			root.set_object(object);
			gen.set_root(root);
			
			foreach(string key in data.keys)
			{
				string gtype = data.get(key).type_name();
							
				if( gtype == "gint" )
				{
					if( data.get(key) == null )
						object.set_null_member(key);
					else
						object.set_int_member(key, (int)data.get(key));
				}
				else if( gtype == "guint" )
				{
					if( data.get(key) == null )
						object.set_null_member(key);
					else
						object.set_int_member(key, (uint)data.get(key));
				}
				else if( gtype == "glong" )
				{
					if( data.get(key) == null )
						object.set_null_member(key);
					else
						object.set_int_member(key, (long)data.get(key));
				}
				else if( gtype == "gulong" )
				{
					if( data.get(key) == null )
						object.set_null_member(key);
					else
						object.set_int_member(key, (ulong)data.get(key));
				}
				else if( gtype == "gint64" )
				{
					if( data.get(key) == null )
						object.set_null_member(key);
					else
						object.set_int_member(key, data.get(key).get_int64());
				}
				else if( gtype == "gfloat" )
				{
					if( data.get(key) == null )
						object.set_null_member(key);
					else
						object.set_double_member(key, (float)data.get(key));
				}
				else if( gtype == "gdouble" )
				{
					if( data.get(key) == null )
						object.set_null_member(key);
					else
						object.set_double_member(key, data.get(key).get_double());
				}
				else
				{
					object.set_string_member(key, (string)data.get(key));
				}
			}
			size_t length;
			string json = gen.to_data(out length);
			
			return json;
		}
	}
}
