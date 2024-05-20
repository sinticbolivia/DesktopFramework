using SinticBolivia;

namespace SinticBolivia.Classes
{
    //public delegate RestResponse WebRouteCallback();

    public class SBWebRoute : SBObject
    {
        public  string              route;
        public  string              method;
        public  string              content_type;
        public  RestController.RouteCallback    callback;
        public  SBCallbackArgs args;
        public  bool                is_protected = false;
        public  string              name;

        public SBWebRoute(string _method, string _pattern, RestController.RouteCallback _callback, SBCallbackArgs? _args = null)
        {
            this.method     = _method;
            this.route      = _pattern;
            this.callback   = _callback;
            this.args       = _args;
        }
        public SBWebRoute set_protected(bool p){this.is_protected = p;return this;}
        public SBWebRoute set_name(string n){this.name = n;return this;}
        public RestResponse? execute()
        {
            return this.callback(this.args);
        }
    }
}
