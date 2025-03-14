using Gee;
using SinticBolivia;

namespace SinticBolivia.Classes
{
    public class RestResponseJson : RestResponse
    {
        public RestResponseJson(uint status_code, SBSerializable obj)
        {
            base(status_code, obj.to_json(), "application/json; charset=utf-8");
        }
    }
}
