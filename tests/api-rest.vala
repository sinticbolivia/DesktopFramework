using SinticBolivia;
using SinticBolivia.Classes;

public void set_config()
{
    SBFactory.config = new SBConfig("config.xml", "config");
}
public void load_modules(RestServer server)
{
    string current_dir = GLib.Environment.get_current_dir();
    var modules = SBFactory.config.get_json_value("modules");
    modules.get_array().get_elements().foreach((module) =>
    {
        server.load_module("%s/%s".printf(current_dir, module));
    });

}
public int main(string[] args)
{
    assert(GLib.Module.supported());
	string current_dir = GLib.Environment.get_current_dir();
    stdout.printf("CURRENT DIR: %s\n", current_dir);
    set_config();
    var server = new RestServer((uint)SBFactory.config.get_int("server_port", 8080));
    load_modules(server);
    server.start(true);
    return 0;
}
