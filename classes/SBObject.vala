namespace SinticBolivia
{
	public class SBObject : GLib.Object
	{
		construct{}
		public (unowned ParamSpec)[] getProperties()
		{
			Type type = this.get_type(); //typeof(theObj);

			var obj_class = (ObjectClass) type.class_ref ();
			return obj_class.list_properties();
		}
		public bool propertyExists(string name, out ParamSpec? property)
		{
			Type type = this.get_type();
			var obj_class = (ObjectClass) type.class_ref ();
			property = obj_class.find_property(name);

			return property != null;
		}
		public virtual Value? getParamSpecValue(ParamSpec param)
		{
			Value propVal = Value(param.value_type);
			this.get_property(param.name, ref propVal);

			return propVal;
		}
		public virtual Value? getPropertyValue(string property_name)
		{
			ParamSpec? property;
			if( !this.propertyExists(property_name, out property) )
				return null;

			return this.getParamSpecValue(property);
		}
		/*
		public virtual bool setParaSpecValue(ParamSpec param)
		{
		}
		*/
		public virtual bool setPropertyValue(string name, string val)
		{
			ParamSpec? property;

			if( !this.propertyExists(name, out property) )
				return false;
			/*
			if( property.value_type == typeof(DateTime) )
			{
				continue;
			}
			*/
			Value propertyVal = Value(property.value_type);
			if( property.value_type == typeof(string) )
			{
				propertyVal.set_string(val);
			}
			else if( property.value_type == typeof(int) )
			{
				propertyVal.set_int(int.parse(val));
			}
			else if( property.value_type == typeof(uint) )
			{
				propertyVal.set_uint((uint)int.parse(val));
			}
			else if( property.value_type == typeof(long) )
			{
				propertyVal.set_long(long.parse(val));
			}
			else if( property.value_type == typeof(ulong) )
			{
				propertyVal.set_ulong(ulong.parse(val));
			}
			else if( property.value_type == typeof(int64) )
			{
				propertyVal.set_int64(int64.parse(val));
			}
			else if( property.value_type == typeof(uint64) )
			{
				propertyVal.set_uint64(uint64.parse(val));
			}
			else if( property.value_type == typeof(float) )
			{
				propertyVal.set_float(float.parse(val));
			}
			else if( property.value_type == typeof(double) )
			{
				propertyVal.set_double(double.parse(val));
			}
			else if( property.value_type == typeof(bool) )
			{
				propertyVal.set_boolean(val == "true" ? true : false);
			}
			else
			{

			}
			/*else if( property.value_type == typeof(DateTime) )
			{

			}
			/*
			else if( property.value_type == typeof(Object) )
			{
				propertyVal.set_object(val);
			}
			*/
			this.set_property(name, propertyVal);

			return true;
		}
		public virtual bool setPropertyGValue(string name, Value? val)
		{
			if( val == null  )
				return false;

			ParamSpec? property;
			if( !this.propertyExists(name, out property) )
				return false;
			Type[] _object_types = {typeof(GLib.Object), typeof(Gee.ArrayList), typeof(SBObject)};

			string str_contents = (property.value_type in _object_types) ? "(object)" : val.strdup_contents();
			//debug("BIND PROP: %s => %s\n", name, str_contents);
			if( str_contents == "NULL" || str_contents == "(null)" )
				return false;
			if( property.value_type == typeof(DateTime) || property.value_type == typeof(SBDateTime) )
			{
				string str = (string)val;
				if( str == null || str.strip().length <= 0 )
					return false;
				var datetime = new SBDateTime.from_string(str);
				if( property.value_type == typeof(DateTime) )
				{
					this.set_property(name, datetime.get_datetime());
				}
				else if( property.value_type == typeof(SBDateTime) )
				{
					this.set_property(name, datetime);
				}
			}
			else if( property.value_type == typeof(Gee.ArrayList) )
			{
				//debug("PROP: name, %s, %s", property.value_type.name(), property.value_type.to_string());
				//Value dest_val = Value(property.value_type);
				//val.transform(ref dest_val);
				this.set_property(name, val);
			}
			else
			{
				this.set_property(name, val);
			}
			return true;
		}
		public string dump()
		{
			Type type = this.get_type();
			string dump = "%s {\n".printf(type.name());
			foreach(var prop in this.getProperties())
			{
				var val = this.getParamSpecValue(prop);
				string? val_str = null;
				if( val.type() == typeof(SBDateTime) || val.type() == typeof(DateTime) )
				{
					val_str = (val.type() == typeof(SBDateTime)) ?
						(val as SBDateTime).format("%Y-%m-%d %H:%M:%S") :
						(val as DateTime).format("%Y-%m-%d %H:%M:%S");
				}
				else if( val.type() == typeof(Gee.ArrayList) )
				{
					val_str = "[";
					Type vtype = (val as Gee.ArrayList).element_type;
					if( Utils.is_primitive_type(vtype) )
					{
						/*
						(val as Gee.ArrayList).foreach((vvv) =>
						{
							dump += (string)vvv; //vv.strdup_contents();
							return true;
						});
						*/
						val_str += "(elements: %d)".printf((val as Gee.ArrayList).size);
					}
					else
						val_str += "(elements: %d)".printf((val as Gee.ArrayList).size);
					val_str += "]";
				}
				else if( val.type() == typeof(Gee.HashMap) )
				{
					/*
					Type etype = (val as Gee.HashMap).element_type;
					if( Utils.is_primitive_type(etype) )
					{
						foreach(var entry in (val as Gee.HashMap).entries)
						{
							Value eval = Value(etype);
							eval = entry.value;
							dump += "\t%s: %s\n".printf(prop.name, eval.strdup_contents());
						}
					}
					else*/
						val_str = val.strdup_contents();
				}
				else
					val_str = val.strdup_contents();
				dump += "\t%s: %s\n".printf(prop.name, val_str);
			}
			dump += "}\n";
			return dump;
		}
	}
}
