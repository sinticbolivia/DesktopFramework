using Soup;

namespace SinticBolivia.Classes
{
    public class SBRequest : SBObject
    {
        public  string content_type = "text/html";

        public SBRequest()
        {

        }
        public SBResponse request(string url, string method = "GET", string? data = null)
        {
            var session = new Session();
            #if __SOUP_VERSION_2_70__
            session.ssl_strict = false;
            #endif

            var message = new Message(method, url);
            if( (method == "POST" || method == "PUT") && data != null )
            {
                //message.request_body.append(MemoryUse.COPY, data.data);
                #if __SOUP_VERSION_2_70__
                message.request_body.append_take(data.data);
                #else
                message.set_request_body_from_bytes(this.content_type, new Bytes(data.data));
                #endif
            }
            #if __SOUP_VERSION_2_70__
            session.send_message(message);
            string raw = (string)message.response_body.data;
            #else
            string raw = (string)session.send_and_read(message).get_data();
            #endif

            var response = new SBResponse(raw, message.status_code, "text/html");
            message.response_headers.foreach( (name, val) =>
            {
                response.headers.set(name, val);
            });

            return response;
        }
        public SBResponse @get(string url)
        {
            return this.request(url);
        }
        public SBResponse post(string url, string data)
        {
            return this.request(url, "POST", data);
        }
        public SBResponse put(string url, string data)
        {
            return this.request(url, "PUT", data);
        }
        public SBResponse delete(string url)
        {
            return this.request(url, "DELETE");
        }
    }
}
