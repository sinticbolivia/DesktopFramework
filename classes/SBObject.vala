namespace SinticBolivia
{
	public class SBObject : Object
	{
		public ParamSpec[] getProperties()
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
		public bool setPropertyValue(string name, string val)
		{
			ParamSpec? property;
			
			if( !this.propertyExists(name, out property) )
				return false;
			
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
				propertyVal.set_uint(uint.parse(val));
			}
			else if( property.value_type == typeof(long) )
			{
				propertyVal.set_long(long.parse(val));
			}
			else if( property.value_type == typeof(ulong) )
			{
				propertyVal.set_ulong(ulong.parse(val));
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
			
			this.set_property(name, propertyVal);
			
			return true;
		}
		public Value? getPropertyValue(string name)
		{
			ParamSpec? property;
			
			if( !this.propertyExists(name, out property) )
				return null;
				
			Value propVal 	= Value (property.value_type);
			
			this.get_property(property.name, ref propVal);
			
			return propVal;
		}
	}
}
