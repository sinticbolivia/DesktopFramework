using SinticBolivia;

namespace SinticBolivia.Classes
{
    public delegate RestResponse WebRouteCallback();

    public class WebRoute : SBObject
    {
        public  string              route;
        public  string              method;
        public  string              content_type;
        public  WebRouteCallback    callback;

        public WebRoute()
        {

        }
    }
}
