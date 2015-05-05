using GLib;
//using GLib.Intl;

namespace SinticBolivia
{
	public class SBText : Object
	{
		public static void LoadLanguage(string locale = "en_US", string domain = "", string path = "")
		{
			foreach(string _locale in Intl.get_language_names())
			{
				stdout.printf("Locale name: %s\n", _locale);
			}
			stdout.printf("setting up the local: %s:%s:%s\n", locale, domain, path);
			//GLib.Environment.set_variable("LC_MESSAGES", locale, true);
			GLib.Environment.set_variable("LC_MESSAGES", locale, true);
			//##set the language
			string? res = Intl.setlocale(LocaleCategory.MESSAGES, locale);
			//## sets the search directory for the translation files
			res = Intl.bindtextdomain(domain, path);
			Intl.bind_textdomain_codeset(domain, "utf-8"); 
			//##choose the domain by default
			Intl.textdomain(domain);
		}
		public static void LoadDomain(string domain, string path)
		{
			Intl.bindtextdomain(domain, path);
			Intl.bind_textdomain_codeset(domain, "utf-8"); 
		}
		public static string __(string text_id, string? domain = null)
		{
			if( text_id.strip().length <= 0 )
			{
				return "";
			}
			/*
			if( domain != null )
			{
				if( Intl.textdomain(domain) == null )
				{
					stderr.printf("SBText ERROR: Error selection domain:%s\n", domain);
				}
			}
			*/
			return dgettext(domain, text_id);
		}
	}
}
