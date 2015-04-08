using GLib;

public extern char* getPSN(/*out char* sn*/);
namespace SinticBolivia
{
	
	public class SBOS
	{
		public string OS;
		public string Name;
		public string Version;

		public SBOS()
		{
			#if __WIN32__
			this.OS = "Win32";
			#elif __WIN64__
			this.OS = "Win32";
			#elif __linux__
			this.OS = "Linux";
			#else
			this.OS = "Unknow";
			#endif
		}
		public bool IsWindows()
		{
			return (this.OS == "Win32" || this.OS == "Win32");
		}
		public bool IsLinux()
		{
			return this.OS == "Linux";
		}
		public bool IsUnix()
		{
			return (this.OS == "Linux" || this.OS == "Unix");
		}
		public static SBOS GetOS()
		{
			return new SBOS();
		}
		public string GetProcessorSN()
		{
			char* _sn = getPSN();
			string serial_number = (string)_sn;
			delete _sn;
			
			return serial_number;
		}
	}
}
