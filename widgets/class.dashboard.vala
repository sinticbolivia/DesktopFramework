using GLib;
using Gee;
using Gtk;
using SinticBolivia;

namespace SinticBolivia.Gtk
{
	public class SBDashboard : Fixed
	{
		protected	int			fixedWidth = 0;
		protected	int			fixedHeight = 0;
		protected	int			fixedX = 0;
		protected	int 		fixedY = 0;
		protected	int			fixedRow = 0;
		protected	int			fixedCol = 0;
		
		protected	int			widgetHeight 	= 0;
		protected	int			widgetWidth 	= 0;
		protected	int			widgetMargin 	= 10;
		
		public	int Width
		{
			set
			{
				this.fixedWidth = value;
			}
			get{return this.fixedWidth;}
		}
		public SBDashboard()
		{
			this.widgetHeight	= 250;
			this.widgetWidth	= 250;
			this.expand = true;
			this.get_style_context().add_class("sb-dashboard");
		}
		public void Add(Widget child)
		{
			int total_cols = (int)Math.ceil(this.fixedWidth / this.widgetWidth);
			if( this.fixedX == 0 && this.fixedY == 0 )
			{
				this.fixedX += 5;
				this.fixedY += 5;
			}
			var evt_box = new EventBox();
			evt_box.set_size_request(this.widgetWidth, this.widgetHeight);
			evt_box.show();
			evt_box.add(child);
			
			this.put(evt_box, this.fixedX, this.fixedY);
			this.fixedX += this.widgetWidth + this.widgetMargin;
			this.fixedCol++;
			if( this.fixedCol == total_cols)
			{
				this.fixedCol 	= 0;
				this.fixedX 	= 5;
				this.fixedY 	+= this.widgetHeight + this.widgetMargin;
			}
		}
	}
}
