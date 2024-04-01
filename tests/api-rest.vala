using SinticBolivia;
using SinticBolivia.Classes;

public void set_config()
{
    SBFactory.config = new SBConfig("config.xml", "config");
}
public int main(string[] args)
{
    assert(GLib.Module.supported());
	string current_dir = GLib.Environment.get_current_dir();
    stdout.printf("CURRENT DIR: %s\n", current_dir);
    set_config();
    var server = new RestServer((uint)SBFactory.config.get_int("server_port", 8080));
    server.load_module("%s/../subscriptions/build/libsubscriptions.dylib".printf(current_dir));
    server.start(true);
    return 0;
}
