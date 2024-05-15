using GLib;

namespace SinticBolivia.Classes
{
    public class SBSmtpConfig : SBObject
    {
        public  string server {get;set;}
        public  int port {get;set;}
        public  string username {get;set;}
        public  string password {get;set;}
        public  string from {get;set;}

        public SBSmtpConfig()
        {

        }
    }
}
