using GLib;
using Gtk;

namespace SinticBolivia.Gtk
{
	public class Tag : Fixed
	{
		public		string Text
		{
			get
			{
				return this.label1.label;
			}
			set
			{
				this.label1.label = value;
			}
		}
		protected	Label		label1;
		protected	Button		button1;
		
		public Tag()
		{
			this.label1 = new Label("");
			this.label1.show();
			this.button1 = new Button.with_label("x");
			this.button1.show();
			this.put(this.label1, 0, 0);
			//int width = this.label1.get_allocated_width();
			//this.put(this.button1, width, 0);
			this.SetEvents();
		}
		protected void SetEvents()
		{
			//this.map.connect( () => 
			this.size_allocate.connect( (alloc) => 
			{
				int width = this.label1.get_allocated_width();
				stdout.printf("label width: %d\n", width);
				this.put(this.button1, width, 0);
			});
			this.button1.clicked.connect(this.OnButtonRemoveClicked);
		}
		protected void OnButtonRemoveClicked()
		{
			this.destroy();
		}
	}
}
