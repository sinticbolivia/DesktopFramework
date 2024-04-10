using SinticBolivia;

namespace SinticBolivia.Classes
{
    public interface ISBRestModule : Object
    {
        public abstract string id {get; set construct;}
        public abstract string name {get; set construct;}
        public abstract string description {get; set construct;}
        public abstract string version {get; set construct;}

        public abstract void set_config(SBConfig cfg);
        public abstract void load();
        public abstract void init(RestServer server);
    }
}
