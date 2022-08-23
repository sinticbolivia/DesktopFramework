using SinticBolivia;
using Gee;

namespace SinticBolivia.Classes
{
	public abstract class SBSerializable : SBObject, Json.Serializable
	{
		public virtual Json.Node serialize_property (string property_name, Value val, ParamSpec pspec)
		{
			//print("SERIALIZE PROP: %s\n", property_name);
			if (val.type ().is_a (typeof (Gee.ArrayList)))
			{
				unowned Gee.ArrayList<GLib.Object> list_value = val as Gee.ArrayList<GLib.Object>;
				if (list_value != null /*|| property_name == "data"*/)
				{
					var array = new Json.Array.sized (list_value.size);
					foreach (var item in list_value)
					{
						array.add_element (Json.gobject_serialize (item));
					}

					var node = new Json.Node (Json.NodeType.ARRAY);
					node.set_array (array);
					return node;
				}
			}
			else if( val.type().is_a(typeof(DateTime)) )
			{
				var node = new Json.Node (Json.NodeType.VALUE);
				
				if( ( val as DateTime) != null)
				{
					string datetimeStr = (val as DateTime).format("%Y-%m-%d %H:%M:%S");
					//print("SERIALIZE PROP: %s => %s\n", property_name, datetimeStr);
					node.set_string ( datetimeStr );
				}
				else
					node.init_null();
				return node;
			}
			var node = this.default_serialize_property(property_name, val, pspec);
			//if( node != null )
			//	print("%s(%s) => %s\n", property_name, node.type_name(), Json.to_string(node, true));
			return node;
		}
		public virtual bool deserialize_property (string property_name, out Value val, ParamSpec pspec, Json.Node property_node)
		{
			if( pspec.value_type.is_a(typeof(DateTime)) && !property_node.is_null() )
			{
				DateTime datetime = SBDateTime.parseDbDateTime(property_node.get_string());
				if( datetime != null )
				{
					val = Value(typeof(DateTime));
					val = datetime;
					return true;
				}
				return false;
			}
			return this.default_deserialize_property (property_name, out val, pspec, property_node);
		}
		public virtual bool deserializeArrayProperty<T>(string prop,  out Value val, Json.Node property_node)
		{
			Json.Array list = property_node.get_array();
			if( list == null )
				return false;
				
			val	= Value(typeof(ArrayList));
			var list_value = new ArrayList<T>(); //(ArrayList<T>)Object.new(typeof(ArrayList<T>));
			
			list.foreach_element((array, index, node) => 
			{
				var obj = Json.gobject_deserialize(typeof(T), node);
				list_value.add(obj);
			});
			val.set_object(list_value);
			return true;
		}
		/*
		public override (unowned ParamSpec)[] list_properties () 
		{
			
			Type type = this.get_type(); //typeof(theObj);
			
			var obj_class = (ObjectClass) type.class_ref ();
			//return obj_class.list_properties();
			
			//unowned var specs  = this.getProperties();
			var specs = obj_class.list_properties();
			foreach(var spec in specs)
			{
				spec.name = spec.name.replace("-", "_");
			}
			return specs;
		}
		*/
	}
}
