using GLib;
using Gtk;

namespace SinticBolivia.GtkWidgets
{
	public class SBDatePicker : Box
	{
		//protected	Fixed		fixed;
		protected	Entry		entryDate;
		//protected	Button		buttonSelectDate;
		protected	Calendar	calendar;
		//protected	Popover		popup;
		protected	Widget		popup;
		protected	bool		isDialog = false;
		public		DateTime	date;
		//public		string		format = "%Y-%m-%d %H:%M:%S";
		public		string		format = "%Y-%m-%d";
		public		string		DateString
		{
			set{this.entryDate.text = value;}
			get{return this.entryDate.text;}
		}
		public		Gdk.Pixbuf		Icon
		{
			set{this.entryDate.secondary_icon_pixbuf = value;}
		}
		public signal void on_date_changed(DateTime date);
		
		public SBDatePicker()
		{
			this.orientation = Orientation.HORIZONTAL;
			//this.height_request = 30;
			//this.set_has_window(false);
			//this.expand = false;
			//this.fill = true;
			//this.popup	= new Popover(this);
			
			
			this.entryDate = new Entry(){placeholder_text = "YYYY-mm-dd"};
			this.entryDate.secondary_icon_activatable = true;
			this.entryDate.set_icon_from_icon_name(EntryIconPosition.SECONDARY, "preferences-system-time-symbolic");
			//this.buttonSelectDate = new Button();
			
			this.calendar 	= new Calendar();
			this.calendar.set_size_request(200, 200);
			this.calendar.show();
			
			this.entryDate.show();
			//this.buttonSelectDate.show();
						
			//this.entryDate.width_request = 150;
						
			//this.put(this.entryDate, 0, 0);
			this.pack_start(this.entryDate, false, true);
			//this.buildPopupDialog();
			this.buildPopover();
			//this.put(this.buttonSelectDate, 161, 0);
			
			//this.height_request = 30;
			//this.width_request = 200;
			//this.add(this.fixed);
			//this.add_overlay(this.calendar);
			//this.calendar.valign = Align.END;
			//this.calendar.margin_top = 100;
			//this.calendar.margin_right = 200;
			//this.calendar.margin_left = 200;
			//this.calendar.margin_bottom = 200;
			this.SetEvents();
		}
		protected void buildPopover()
		{
			this.popup = new Popover(this.entryDate);
			(this.popup as Popover).position = PositionType.BOTTOM;
			(this.popup as Popover).add(this.calendar);
			(this.popup as Popover).border_width = 6;
		}
		protected void buildPopupDialog()
		{
			this.popup		= new Dialog()
			{
				//modal 				= false, 
				resizable 			= false, 
				decorated 			= false, 
				skip_taskbar_hint 	= true
			};
			this.popup.set_size_request(210, 210);
			(this.popup as Dialog).get_content_area().add(this.calendar);
			this.isDialog = true;
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
			if( this.isDialog )
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
				(this.popup as Dialog).move((ox + dx) - 3, oy + dy + 30);
				//this.popup.visible = !this.popup.visible;
			}
			
			print("CALENDAR VISIBLE: %d\n", this.popup.visible ? 1 : 0);
			if( this.popup.visible )
				this.popup.hide();
			else
				this.popup.show_all();
		}
		protected void OnDateSelected()
		{
			//uint year,month,day;
			this.date = new DateTime(new TimeZone.local(), this.calendar.year, this.calendar.month + 1, this.calendar.day, 0, 0, 0);
			this.entryDate.text = date.format(this.format);
			//this.calendar.get_date(out year, out month, out day);
			//this.entryDate.text = "%04d-%02d-%02d".printf(this.calendar.year, this.calendar.month + 1, this.calendar.day);
			this.on_date_changed(this.date);
		}
		protected void OnDaySelectedDoubleClick()
		{
			this.date = new DateTime(new TimeZone.local(), this.calendar.year, this.calendar.month + 1, this.calendar.day, 0, 0, 0);
			//this.entryDate.text = "%04d-%02d-%02d".printf(this.calendar.year, this.calendar.month + 1, this.calendar.day);
			this.entryDate.text = date.format(this.format);
			//this.popup.visible = false;
			this.popup.hide();
			this.on_date_changed(this.date);
		}
		public void setDate(DateTime ndate)
		{
			this.date = ndate;
			this.DateString = ndate.format(this.format);
			this.calendar.year = this.date.get_year();
			this.calendar.month = this.date.get_month() - 1;
			this.calendar.day = this.date.get_day_of_month();
		}
	}
}
