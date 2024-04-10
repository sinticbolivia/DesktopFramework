using Gee;
using SinticBolivia;

namespace SinticBolivia.Classes
{
    public class SBCallbackArgs : SBObject
    {
        public  HashMap<string, Value?>     args;

        construct
        {
            this.args = new Gee.HashMap<string, Value?>();
        }
        public SBCallbackArgs()
        {

        }
        public void set_value(string key, Value? val)
        {
            this.args.set(key, val);
        }
        public int get_int(string key, int defVal = 0)
        {
            if( !this.args.has_key(key) )
                return defVal;
            if( this.args[key].type() == typeof(string) )
                return int.parse((string)this.args[key]);
            if( this.args[key].type() != typeof(int) )
                return defVal;
            return (int)this.args[key];
        }
        public long get_long(string key, long defVal = 0)
        {
            if( !this.args.has_key(key) )
                return defVal;
            if( this.args[key].type() == typeof(string) )
            {
                return long.parse((string)this.args[key]);
            }
            if( this.args[key].type() != typeof(long) )
                return defVal;
            return (long)this.args[key];
        }
        public string? get_string(string key, string? defVal = null)
        {
            if( !this.args.has_key(key) )
                return defVal;
            if( this.args[key].type() != typeof(string) )
                return defVal;
            return (string)this.args[key];
        }
    }
}
