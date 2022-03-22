using GLib;
using Gee;
using Gtk;
using SinticBolivia;

namespace SinticBolivia.GtkWidgets
{
	public abstract class SBGtkModule : SBModule
	{
		public Builder GetGladeUi(string ui_file, string t_domain = "")
		{
			
			size_t ui_size;
			uint32 flags;
			
			this.res_data.get_info("%s/ui/%s".printf(this.resourceNs, ui_file), 
									ResourceLookupFlags.NONE, 
									out ui_size,
									out flags);
									
			InputStream ui_stream = this.GetInputStream("ui/%s".printf(ui_file));						
			
			uint8[] data = new uint8[ui_size];
			size_t length;
			ui_stream.read_all(data, out length);
			
			var gui = new Builder();
			/*
			if( t_domain == null )
			{
				t_domain = "";
			}
			*/
			gui.translation_domain = t_domain;
			gui.add_from_string((string)data, length);
			
			return gui;
		}
		
		public Gdk.Pixbuf GetPixbuf(string image, int width = 0, int height = 0)
		{
			var input_stream = this.GetInputStream("images/%s".printf(image));
			
			if( width > 0 && height > 0 )
			{
				var pixbuf = new Gdk.Pixbuf.from_stream(input_stream);
				pixbuf = pixbuf.scale_simple(width, height, Gdk.InterpType.BILINEAR);
				
				return pixbuf;
			}
			return new Gdk.Pixbuf.from_stream(input_stream);
		}
		
	}
}
