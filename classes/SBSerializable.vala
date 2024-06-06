using SinticBolivia;
using Gee;

namespace SinticBolivia.Classes
{
	public abstract class SBSerializable : SBObject, Json.Serializable
	{
		protected	string _rawJson;
		protected	ArrayList<string> _lostJsonProperties;

		public virtual Json.Node serialize_property (string property_name, Value val, ParamSpec pspec)
		{
			message("Serializing: %s\n", property_name);
			if (val.type ().is_a (typeof (Gee.ArrayList))
				|| ( val.type ().is_a (typeof (Object)) && (val as Object) != null && (val as Object).get_type().is_a(typeof (Gee.ArrayList)) )
			)
			{
				unowned Gee.ArrayList<GLib.Object> list_value = val as Gee.ArrayList<GLib.Object>;
				if (list_value != null /*|| property_name == "data"*/)
				{
					var array = new Json.Array.sized (list_value.size);
					foreach (var item in list_value)
					{
						if( item is SBSerializable )
							array.add_element( (item as SBSerializable).to_json_node() );
						else
							array.add_element (Json.gobject_serialize (item));
					}

					var node = new Json.Node (Json.NodeType.ARRAY);
					node.set_array (array);
					return node;
				}
			}
			else if( val.type().is_a(typeof(DateTime)) || val.type().is_a(typeof(SBDateTime)) )
			{
				var node = new Json.Node (Json.NodeType.VALUE);

				if( (val as DateTime) != null )
				{
					string datetimeStr = (val as DateTime).format("%Y-%m-%d %H:%M:%S");
					//print("SERIALIZE PROP: %s => %s\n", property_name, datetimeStr);
					node.set_string ( datetimeStr );
				}
				else if( (val as SBDateTime) != null )
				{
					string datetimeStr = (val as SBDateTime).format("%Y-%m-%d %H:%M:%S");
					//print("SERIALIZE PROP: %s => %s\n", property_name, datetimeStr);
					node.set_string ( datetimeStr );
				}
				else
					node.init_null();
				return node;
			}
			var node = this.default_serialize_property(property_name.replace("-", "_"), val, pspec);
			//if( node != null )
			//	print("%s(%s) => %s\n", property_name, node.type_name(), Json.to_string(node, true));
			return node;
		}
		public virtual bool deserialize_property (string property_name, out Value val, ParamSpec pspec, Json.Node property_node)
		{
			if( ( pspec.value_type.is_a(typeof(DateTime)) || pspec.value_type.is_a(typeof(SBDateTime)) )
				&& !property_node.is_null()
			)
			{
				if( pspec.value_type.is_a(typeof(DateTime)) )
				{
					DateTime datetime = SBDateTime.parseDbDateTime(property_node.get_string());
					val = Value(pspec.value_type);
					val = datetime;
				}
				else
				{
					var datetime = new SBDateTime.from_string(property_node.get_string());
					val = Value(pspec.value_type);
					val = datetime;
				}

				return true;
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
		public void setRawJson(string json)
		{
			this._rawJson = json;
		}
		public string getRawJson()
		{
			return this._rawJson;
		}
		public Json.Node? getObjNode() throws GLib.Error
		{
			return Json.from_string(this._rawJson);
		}
		/*
		public override unowned ParamSpec? Json.Serializable.find_property (string name)
		{
			if( this._lostJsonProperties == null )
				this._lostJsonProperties = new ArrayList<string>();

			unowned ParamSpec? prop = (base as Json.Serializable).find_property(name);
			//this.propertyExists(name, out prop);
			if( prop == null )
			{
				//warning("Property does not exists: %s\n", name);
				this._lostJsonProperties.add( name );
			}
			return prop;
		}
		//*/
		public virtual Json.Object to_json_object()
		{
			var object = new Json.Object();
			var props = this.getProperties();
			foreach(var prop in props)
			{
				string prop_name = prop.name.replace("-", "_");
				Value? val = this.getParamSpecValue(prop);
				if( val == null || val.strdup_contents() == "NULL" )
				{
					object.set_null_member(prop_name);
					continue;
				}
				if( prop.value_type == typeof(int64) || prop.value_type == typeof(uint64)
					|| prop.value_type == typeof(long) || prop.value_type == typeof(ulong)
					|| prop.value_type == typeof(int) || prop.value_type == typeof(uint) )
				{
					if( val == null)
						object.set_null_member(prop_name);
					else
					{
						Value str = Value(typeof(string));
						val.transform(ref str);
						object.set_int_member(prop_name, int64.parse((string)str));
					}
				}
				else if( prop.value_type == typeof(float) || prop.value_type == typeof(double) )
				{
					//message("%s => %s\n", prop_name, val.strdup_contents());
					//if( val == null )
					//	object.set_null_member(prop_name);
					//else
						object.set_double_member(prop_name, double.parse(val.strdup_contents()));
				}
				else if( prop.value_type == typeof(DateTime) || prop.value_type == typeof(SBDateTime) )
				{
					string datetime = prop.value_type == typeof(DateTime) ?
						((DateTime)val).format("%Y-%m-%d %H:%M:%S") :
						((SBDateTime)val).format("%Y-%m-%d %H:%M:%S");
					object.set_string_member(prop_name, datetime);
				}
				else if( prop.value_type == typeof(Gee.ArrayList) )
				{
					object.set_string_member(prop_name, "ArrayList");
				}
				else if( prop.value_type == typeof(Object) || prop.value_type == typeof(SBObject) )
				{
					if( prop.value_type == typeof(SBSerializable) )
						object.set_string_member(prop_name, ((SBSerializable)val).to_json());
					else //if( prop.value_type == typeof(SBCollection) )
						object.set_string_member(prop_name, Json.gobject_to_data((Object)val, null)) ;
				}
				else
				{
					if( val == null)
						object.set_null_member(prop_name);
					else
						object.set_string_member(prop_name, (string)val);
				}
			}
			this.after_build_json_object(object);
			return object;
		}
		public virtual Json.Node to_json_node()
		{
			var node = new Json.Node(Json.NodeType.OBJECT);
			node.set_object(this.to_json_object());
			return node;
		}
		public virtual string to_json()
		{
			string json = "";
			var gen = new Json.Generator();
			gen.set_root(this.to_json_node());
			size_t length;
			json = gen.to_data(out length);

			return json;
		}
		public virtual void after_build_json_object(Json.Object obj){}
		public virtual void deserialize_array_property(string name, Json.Array? data){}
		public virtual void deserialize_object_property(string name, Json.Object? data){}
		public virtual void bind_json_object(Json.Object obj)
		{
			obj.foreach_member( (_obj, _name, _node) =>
			{
				//debug("_name: %s, type: %s", _name, _node.get_value_type().name());
				if( !_node.is_null() )
				{
					if( _node.get_value_type() == typeof(Json.Array) )
						//this.setPropertyGValue(_name, theval);
						this.deserialize_array_property(_name, _node.get_array());
					else if( _node.get_value_type() == typeof(Json.Object) )
						//this.setPropertyGValue(_name, theval);
						this.deserialize_object_property(_name, _node.get_object());
					else
					{
						Value theval = _node.get_value();
						this.setPropertyGValue(_name, theval);
						theval.unset();
					}

				}
			});
		}
	}
}
