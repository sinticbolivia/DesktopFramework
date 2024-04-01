using Xml;
using GLib;
using Gee;

namespace SinticBolivia
{
	public class SBConfig : Object
	{
		protected string _cfg_file;
		protected string _rootNode;
		protected HashMap<string, Value?> _values;

		public SBConfig(string cfg_file, string root_node)
		{
			this._cfg_file = cfg_file;
			this._rootNode = root_node;
			this._values = new HashMap<string, Value?>();
			this._parseFile();
		}
		protected void _parseFile()
		{
			var fh = File.new_for_path(this._cfg_file);
			if( !fh.query_exists() )
			{
				stderr.printf("The file %s, does not exists\n", this._cfg_file);
				return;
			}
			stderr.printf("\n-----------------------------\n\n");
			Xml.Doc* doc = Xml.Parser.parse_file(this._cfg_file);
			if( doc == null )
			{
				stderr.printf("File %s not found or permissions missing.\n", this._cfg_file);
				return;
			}

			Xml.Node* node = doc->get_root_element();
			if( node == null )
			{
				delete doc;
				stderr.printf("The xml file '%s' is empty.\n", this._cfg_file);
				return;
			}

			if( node->name != this._rootNode )
			{
				delete doc;
				stderr.printf("The xml file '%s' does not contain the root element '%s'.\n", this._cfg_file, this._rootNode);
				return;
			}
			stderr.printf("\n\n");
			this._parseNode(node);
		}
		protected void _parseNode (Xml.Node* node)
		{
			// Loop over the passed node's children
			for (Xml.Node* iter = node->children; iter != null; iter = iter->next)
			{
				// Spaces between tags are also nodes, discard them
				if (iter->type != ElementType.ELEMENT_NODE) {
					continue;
				}

				// Get the node's name
				string node_name = iter->name;
				// Get the node's content with <tags> stripped
				string node_content = iter->get_content ();
				//print_indent (node_name, node_content);
				// Now parse the node's properties (attributes) ...
				//parse_properties (iter);
				// Followed by its children nodes
				((HashMap<string, Value?>)this._values).set(node_name, node_content);
				this._parseNode (iter);
			}
		}
		public Value? GetValue(string key, string? def_value = "")
		{
			if( !((HashMap<string, Value?>)this._values).has_key(key) )
				return def_value;

			return (Value?)((HashMap<string, Value?>)this._values).get(key);
		}
		public void SetValue(string key, Value obj)
		{
			if( ((HashMap<string, Value?>)this._values).has_key(key) )
			{
				((HashMap<string, Value?>)this._values)[key] = obj;
			}
			else
			{
				((HashMap<string, Value?>)this._values).set(key, obj);
			}
		}
		public void Save()
		{
			//save ecommerce settings
			Xml.Doc* doc = new Xml.Doc("1.0");
			//Xml.Ns* ns = new Xml.Ns (null, "", "foo");
			//ns->type = Xml.ElementType.ELEMENT_NODE;
			Xml.Node* root = new Xml.Node (null, this._rootNode);
			doc->set_root_element (root);
			root->new_prop ("version", "1.0");

			foreach(var entry in ((HashMap<string, Value?>)this._values).entries)
			{
				/*Xml.Node* subnode = */root->new_text_child (/*ns*/null, entry.key, "%s".printf((string)entry.value));
			}


			//subnode->new_text_child (null, "shop_type", (string)shop_type );
			//subnode->new_prop ("subprop", "escaping \" and  < and >" );
			//Xml.Node* comment = new Xml.Node.comment ("This is a comment");
			//root->add_child (comment);

			string xmlstr;
			// This throws a compiler warning, see bug 547364
			doc->dump_memory (out xmlstr);
			delete doc;

			var file = File.new_for_path (this._cfg_file);

			try
			{
				if( file.query_exists() )
				{
					file.delete();
				}
				FileOutputStream? stream = file.create(FileCreateFlags.NONE);
				if( stream == null )
				{
					stderr.printf("ERROR: outputstream\n");
				}
				else
				{
					// Write text data to file
					//var data_stream = new DataOutputStream (stream);
					//data_stream.put_string (xmlstr);
					//delete root;
					//stdout.printf("Writing file %s, with data\n%s\n", this._cfg_file, xmlstr);
					stream.write(xmlstr.data);
				}

			}
			catch(GLib.Error e)
			{
				stderr.printf("ERROR: %s\n", e.message);
			}
		}
		public string? get_string(string key, string? def_val = null)
		{
			Value? val = this.GetValue(key, def_val);
			if( val == null )
				return def_val;
			return (string)val;
		}
		public int get_int(string key, int def_val = 0)
		{
			string? val = this.get_string(key, def_val.to_string());
			if( val == null )
				return def_val;
			return int.parse(val);
		}
		public Json.Node? get_json_value(string key)
		{
			string? json = this.get_string(key, null);
			if( json == null /*json.strip().length <= 0*/ )
				return null;
			try
			{
				var parser = new Json.Parser();
				parser.load_from_data(json);
				return parser.get_root();
			}
			catch(GLib.Error e)
			{
				stderr.printf("JSON ERROR: %s\n", e.message);
				return null;
			}
		}
	}
}
