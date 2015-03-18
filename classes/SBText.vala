using GLib;
//using GLib.Intl;

namespace SinticBolivia
{
	public class SBText : Object
	{
		public static void LoadLanguage(string locale = "en_US", string domain = "", string path = "")
		{
			Intl.setlocale(LocaleCategory.MESSAGES, locale);
			Intl.bindtextdomain(domain, path);
		}
		public static string __(string text_id, string domain = "")
		{
			//return _(text_id);
			return text_id;
		}
	}
}
