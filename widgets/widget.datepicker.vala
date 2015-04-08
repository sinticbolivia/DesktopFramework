using GLib;
using Gtk;

namespace SinticBolivia.Gtk
{
	public class SBDatePicker : Fixed
	{
		//protected	Fixed		fixed;
		protected	Entry		entryDate;
		//protected	Button		buttonSelectDate;
		protected	Calendar	calendar;
		//protected	Popover		popup;
		protected	Dialog		popup;
		
		public		string		DateString
		{
			set{this.entryDate.text = value;}
			get{return this.entryDate.text;}
		}
		public		Gdk.Pixbuf		Icon
		{
			set{this.entryDate.secondary_icon_pixbuf = value;}
		}
		public SBDatePicker()
		{
			//this.orientation = Orientation.HORIZONTAL;
			this.height_request = 30;
			//this.set_has_window(false);
			this.expand = false;
			//this.popup	= new Popover(this);
			this.popup		= new Dialog()
			{
				//modal 				= false, 
				resizable 			= false, 
				decorated 			= false, 
				skip_taskbar_hint 	= true
			};
			this.popup.set_size_request(210, 210);
			this.entryDate = new Entry(){placeholder_text = "YYYY-mm-dd"};
			//this.buttonSelectDate = new Button();
			
			this.calendar 	= new Calendar();
			this.calendar.set_size_request(200, 200);
			this.calendar.show();
			
			this.entryDate.show();
			//this.buttonSelectDate.show();
						
			this.entryDate.width_request = 150;
						
			this.put(this.entryDate, 0, 0);
			//this.put(this.buttonSelectDate, 161, 0);
			(this.popup.get_content_area() as Box).add(this.calendar);
			this.height_request = 30;
			this.width_request = 200;
			//this.add(this.fixed);
			//this.add_overlay(this.calendar);
			//this.calendar.valign = Align.END;
			//this.calendar.margin_top = 100;
			//this.calendar.margin_right = 200;
			//this.calendar.margin_left = 200;
			//this.calendar.margin_bottom = 200;
			this.SetEvents();
		}
		/*
		public void SetButtonImage(Image img)
		{
			this.buttonSelectDate.image = img;
		}
		*/
		protected void SetEvents()
		{
			//this.buttonSelectDate.clicked.connect(this.OnButtonSelectDateClicked);
			this.entryDate.icon_release.connect( (icon, e) => 
			{
				if( icon == EntryIconPosition.SECONDARY )
				{
					this.OnButtonSelectDateClicked();
				}
			});
			this.calendar.day_selected.connect(this.OnDateSelected);
			this.calendar.day_selected_double_click.connect(this.OnDaySelectedDoubleClick);
		}
		protected void OnButtonSelectDateClicked()
		{
			//this.popup.parent = (Container)this.get_ancestor(typeof(Window));
			int dx = 0, dy = 0, ox = 0, oy = 0;
			this.translate_coordinates(this.get_toplevel(), 0, 0, out dx, out dy);
			//this.translate_coordinates(this.get_ancestor(typeof(Container)), 0, 0, out dx, out dy);
			//this.translate_coordinates(this.get_root_window(), 0, 0, out dx, out dy);
			stdout.printf("(%d, %d)\n", dx, dy);
			//this.get_root_window().get_origin(out ox, out oy);
			this.get_window().get_origin(out ox, out oy);
			stdout.printf("(%d, %d)\n", ox, oy);
			this.popup.move((ox + dx) - 3, oy + dy + 30);
			this.popup.visible = !this.popup.visible;
			//this.popup.show();
		}
		protected void OnDateSelected()
		{
			//uint year,month,day;
			
			//this.calendar.get_date(out year, out month, out day);
			this.entryDate.text = "%04d-%02d-%02d".printf(this.calendar.year, this.calendar.month + 1, this.calendar.day);
		}
		protected void OnDaySelectedDoubleClick()
		{
			this.entryDate.text = "%04d-%02d-%02d".printf(this.calendar.year, this.calendar.month + 1, this.calendar.day);
			this.popup.visible = false;
		}
	}
}
