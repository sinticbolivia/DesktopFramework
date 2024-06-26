using Gee;
using Soup;

namespace SinticBolivia.Classes
{
    public class SBRequest : SBObject
    {
        public  string  content_type = "text/html";
        public  string  body_mime = "text/plain";

        public  HashMap<string, string>     headers;

        public SBRequest()
        {
            this.headers = new Gee.HashMap<string,string>();
        }
        public virtual SBResponse request(string url, string method = "GET", string? data = null)
        {
            var session = new Session();
            #if __SOUP_VERSION_2_70__
            session.ssl_strict = false;
            #endif

            var req_message = new Message(method, url);
            foreach(var header in this.headers.entries)
            {
                debug("HEADER: %s: %s", header.key, header.value);
                req_message.request_headers.append(header.key, header.value);
                if( header.key.down() == "content-type" )
                    this.content_type = header.value;
            }
            if( (method == "POST" || method == "PUT") && data != null )
            {
                //message.request_body.append(MemoryUse.COPY, data.data);
                #if __SOUP_VERSION_2_70__
                req_message.request_body.append_take(data.data);
                #else
                debug("BODY CONTENT TYPE: %s", this.body_mime);
                req_message.set_request_body_from_bytes(this.body_mime, new Bytes(data.data));
                #endif
            }

            #if __SOUP_VERSION_2_70__
            session.send_message(req_message);
            string raw = (string)req_message.response_body.data;
            #else
            string raw = (string)session.send_and_read(req_message).get_data();
            #endif
            var res_type = req_message.response_headers.get_one("Content-Type");
            var response = new SBResponse(raw, req_message.status_code, res_type != null ? res_type : "text/html");
            req_message.response_headers.foreach( (name, val) =>
            {
                response.headers.set(name, val);
            });

            return response;
        }
        public virtual SBResponse @get(string url)
        {
            return this.request(url);
        }
        public virtual SBResponse post(string url, string data)
        {
            return this.request(url, "POST", data);
        }
        public virtual SBResponse put(string url, string data)
        {
            return this.request(url, "PUT", data);
        }
        public virtual SBResponse delete(string url)
        {
            return this.request(url, "DELETE");
        }
    }
}
