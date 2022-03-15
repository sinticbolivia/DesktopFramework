using Gee;
using Gtk;
using SinticBolivia;

namespace SinticBolivia.Gtk
{
	public class GtkHelper : Object
	{
		public static Builder GetGladeUI(string glade_file)
		{
			var b = new Builder();
			try{
				b.add_from_file(glade_file);
			}
			catch(GLib.Error r)
			{
				stderr.printf("ERROR: %s\n", r.message);
			}
			return b;
		}
		public static Gdk.Pixbuf GetPixbuf(string file, int width = 0, int height = 0)
		{
			Gdk.Pixbuf pixbuf = null;
			try
			{
				pixbuf = new Gdk.Pixbuf.from_file(file);
			
				if( width > 0 && height > 0)
				{
					pixbuf = pixbuf.scale_simple(width, height, Gdk.InterpType.BILINEAR);
				}
			}
			catch(GLib.Error e)
			{
				stderr.printf("ERROR: %s\n", e.message);
			}
			
			return pixbuf;
		}
		public static void BuildTreeViewColumns(string[,] cols, ref TreeView treeview)
		{
			
			for(int i = 0; i < cols.length[0]; i++)
			{
				double xalign = 0;
				CellRenderer? cell = null;
				if( cols[i, 3] == "center" )
					xalign = 0.5;
				if( cols[i, 3] == "right" )
					xalign = 1;
					
				if( cols[i, 1] == "text" || cols[i, 1] == "markup" )
				{
					cell = new CellRendererText()
					{
						xalign = (float)xalign,
						width = int.parse(cols[i, 2]),
						wrap_mode = Pango.WrapMode.WORD_CHAR,
						wrap_width = int.parse(cols[i, 2])
						
					};
					if( cols[i, 4] == "editable" )
					{
						(cell as CellRendererText).editable = true;
					}
				}
				else if( cols[i, 1] == "pixbuf" )
				{
					cell = new CellRendererPixbuf();
				}
				else if( cols[i, 1] == "toggle" )
				{
					int col_index = i;
					//stdout.printf("TOGGLE INDEX: %d\n", col_index);
					cell = new CellRendererToggle();
					var model = (treeview.model as global::Gtk.ListStore);
					(cell as CellRendererToggle).toggled.connect( (_toggle, _path) => 
					{
						
						//stdout.printf("TOGGLED INDEX: %d\n", col_index);
						TreePath tree_path = new TreePath.from_string (_path);
						TreeIter iter;
						model.get_iter (out iter, tree_path);
						model.set (iter, col_index, !_toggle.active);
					});
				}
				else if( cols[i, 1] == "combo" )
				{
					cell = new CellRendererCombo();
					if( cols[i, 4] == "editable" )
						(cell as CellRendererCombo).editable = true;
				}
				string attr = cols[i, 1];
				if( attr == "toggle" )
					attr = "active";
				if( attr == "combo" )
					attr = "text";
					
				treeview.insert_column_with_attributes(i, 
					cols[i, 0],
					cell,
					attr,//(cols[i, 1] == "toggle") ? "active" : cols[i, 1],
					i
				);
			}
		}
		public static GLib.Resource LoadResource(string resource_file)
		{
			GLib.Resource res = null;
			
			try
			{
				if( FileUtils.test(resource_file, FileTest.EXISTS) )
				{
					res = Resource.load(resource_file);
							
				}
				else
				{
					stderr.printf("Resource file for %s does not exists\n", resource_file);
				}
			}
			catch(GLib.Error e)
			{
				stderr.printf("ERROR LOADING RESOURCE: %s\n", e.message);
			}
			
			return res;
		}
		public static InputStream GetInputStreamFromResource(GLib.Resource res, string file)
		{
			return res.open_stream(file, ResourceLookupFlags.NONE);
		}
		public static Builder GetGladeUIFromResource(GLib.Resource res, string glade_ui = "")
		{
			size_t ui_size;
			uint32 flags;
			
			res.get_info(glade_ui, ResourceLookupFlags.NONE, out ui_size, out flags);
			InputStream ui_stream = GtkHelper.GetInputStreamFromResource(res, glade_ui);						
			
			uint8[] data = new uint8[ui_size];
			size_t length;
			ui_stream.read_all(data, out length);
			
			var gui = new Builder();
			gui.add_from_string((string)data, length);
			
			return gui;
		}
	}
}
