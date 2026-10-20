using Curl;

namespace SinticBolivia.Classes
{
    public class EmailChecker : Object
    {
        protected   string server;
        protected   string username;
        protected   string password;
        protected   int port;

        public EmailChecker(string server, string username, string password, int port = 993)
        {
            this.server = server;
            this.username = username;
            this.password = password;
            this.port = port;
        }
        //public delegate size_t WriteCallback (char* buffer, size_t size, size_t nitems, void* outstream);
        private static size_t write_callback(char* buffer, size_t size, size_t nmemb, void* userdata)
        {
            size_t real_size = size * nmemb;
            string data = (string)buffer;
            stdout.printf("Received: %s\n", data);
            return real_size;
        }
        public bool check_email_imap(string command = "SEARCH UNSEEN")
        {
            var curl = new EasyHandle();
            bool success = false;
            try
            {
                string url = "imaps://%s:%d/INBOX".printf(this.server, this.port);
                //string url = "imaps://%s:%d".printf(this.server, this.port);
                /*
                curl.url = url;
                curl.username = username;
                curl.password = password;
                curl.ssl_verify_peer = false;
                curl.ssl_verify_host = false;
                curl.custom_request = "SEARCH UNSEEN";
                curl.write_function = this.write_callback;
                */
                curl.setopt(Curl.Option.URL, url);
                //curl.setopt(Option.USERNAME, username);
                //curl.setopt(Option.PASSWORD, password);
                curl.setopt(Option.USERPWD, "%s:%s".printf(this.username, this.password));
                curl.setopt(Option.SSL_VERIFYPEER, 0);
                curl.setopt(Option.SSL_VERIFYHOST, 0);
                curl.setopt(Option.CUSTOMREQUEST, command);
                curl.setopt(Option.WRITEFUNCTION, write_callback);

                var result = curl.perform();
                if( result == Code.OK )
                {
                    stdout.printf("Conexion exitosa con el servidor de correo");
                    success = true;
                }
                else
                    stderr.printf("Error en la conexión: %s\n", result.to_string());
            }
            catch (Error e)
            {
                stderr.printf("ERROR: %s\n", e.message);
            }
            return success;
        }
    }
}
