using GLib;
using Gtk;
using SinticBolivia;

namespace SinticBolivia.GtkWidgets
{
	public class SBFixed : Fixed
	{
		public 		int		FixedWidth = 0;
		protected	int		width = 0;
		public		int		Width
		{
			get{return this.width;}
			set
			{
				this.width = value;
			}
		}
		public	int		X = 0;
		public	int		Y = 0;
		public	int		Margin = 5;
		public		int		WidgetWidth = 0;
		public		int 	WidgetHeight = 0;
		protected	int		totalColumns;
		protected	int 	currentColumn = 0;
		
		public SBFixed()
		{
			this.Build();
			this.SetEvents();
		}
		protected void Build()
		{
		}
		protected void SetEvents()
		{
			//this.size_allocated.connect();
		}
		public void SetWidgetSize(int width, int height)
		{
			this.WidgetWidth = width;
			this.WidgetHeight = height;
			//##calculate columns
			this.totalColumns = (int)(this.Width / (this.WidgetWidth + this.Margin));
		}
		public void AddWidget(Widget w)
		{
			w.set_size_request(this.WidgetWidth, this.WidgetHeight);
			if( this.X == 0 && this.Y == 0 )
			{
				this.X += this.Margin;
				this.Y += this.Margin;
			}
			if( this.currentColumn >= this.totalColumns )
			{
				this.currentColumn = 0;
				this.Y += this.WidgetHeight + this.Margin;
				this.X = this.Margin;
			}
			
			
			this.put(w, this.X, this.Y);
			this.X += this.WidgetWidth + this.Margin;
			this.currentColumn++;
			
		}
	}
}
