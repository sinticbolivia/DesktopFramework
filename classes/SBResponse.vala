using Gee;
using SinticBolivia;

namespace SinticBolivia.Classes
{
    public class SBResponse : SBObject
    {
        protected   string  _raw;
        protected   string  _body;
        public      uint     code;
        public	    string	content_type = "text/html";
        public      HashMap<string, string>	headers;

        public SBResponse(string raw, uint status_code, string ctype = "text/html")
        {
            this._raw           = raw;
            this._body          = raw;
            this.code           = status_code;
            this.content_type   = ctype;
            this.headers        = new HashMap<string, string>();
        }
        public Json.Node? to_json_node()
        {
			if( this._body == null || this._body.length <= 0 )
				return null;
			Json.Node? root = Json.from_string(this._body);

			return root;
        }
        public Json.Object? to_json_object()
        {
            Json.Node? root = this.to_json_node();
			if( root == null )
				return null;

			return root.get_object();
        }
        public Json.Array? to_json_array()
        {
            Json.Node? root = this.to_json_node();
			if( root == null )
				return null;
            return root.get_array();
        }
        public T to_object<T>()
        {
            Json.Node? _node = this.to_json_node();
			if( _node == null )
				return null;
            T obj = Object.new(typeof(T));
            if( obj is SBSerializable )
            {
                (obj as SBSerializable).bind_json_object(_node.get_object());
            }
            else
            {
                obj = null;
                obj = (T)Json.gobject_deserialize(typeof(T), _node);
            }
            return obj;
        }
    }
}
