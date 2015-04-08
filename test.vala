using GLib;
using SinticBolivia;

public int main(string[] args)
{
	var os = new SBOS();
	string psn = os.GetProcessorSN();

	stdout.printf("Processor S/N: %s\n", psn);
	return 0;
}
