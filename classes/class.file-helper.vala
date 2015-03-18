using GLib;

namespace SinticBolivia
{
	public class SBFileHelper : Object
	{
		/**
		 * Replace directory separator based on the OS
		 *  
		 */
		public static string SanitizePath(string path)
		{
			return path.replace("/", Path.DIR_SEPARATOR_S);
		}
		public static string[] GetParts(string filename)
		{
			int pos = filename.last_index_of(".");
			string name	= filename.substring(0, pos);
			string ext	= filename.substring(pos + 1); 
			
			return {name,ext};
		}
		/**
		 * Get a unique filename 
		 * 
		 * @param string path
		 * @param string filename
		 * 
		 * @return string a unique filename
		 **/
		public static string GetUniqueFilename(string path, string filename)
		{
			string full_path = SBFileHelper.SanitizePath("%s/%s".printf(path, filename));
			string new_filename = full_path;
			int sq = 0;
			
			while( FileUtils.test(new_filename, FileTest.EXISTS) )
			{
				string[] parts = SBFileHelper.GetParts(filename);
				new_filename = SBFileHelper.SanitizePath("%s/%s-%d.%s".printf(path, parts[0], sq, parts[1]));
				sq++;
			}
			
			
			return Path.get_basename(new_filename);
		}
	}
}
