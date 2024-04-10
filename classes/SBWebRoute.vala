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

        public SBWebRoute(string _method, string _pattern, RestController.RouteCallback _callback)
        {
            this.method     = _method;
            this.route      = _pattern;
            this.callback   = _callback;
        }
    }
}
