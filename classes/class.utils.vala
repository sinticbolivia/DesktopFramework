using GLib;
using Gee;

namespace SinticBolivia
{
	public class Utils
	{
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
			var parser = new Json.Parser ();
			var data = new HashMap<string,string>();
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
		public static string FillCeros(int number, int ceros_length)
		{
			string str = "";
			for(int i = 0; i < ceros_length; i++)
			{
				str += "0";
			}
			
			return "%s%d".printf(str, number);
		}
	}
}
