using Gtk;

namespace SinticBolivia.GtkWidgets
{
	public class SBDateTimePicker : SBDatePicker
	{
		protected	SpinButton		hourSpin;
		protected	SpinButton		minuteSpin;
		protected	DateTime		datetime;
		
		public signal void on_datetime_changed(DateTime date);
		
		public SBDateTimePicker()
		{
			base();
			this.build();
			this.setEvents();
		}
		protected void build()
		{
			//var adjustmentHour = new Adjustment(0, 0, 23, 1, 1, 1);
			//var adjustmentMinute = new Adjustment(0, 0, 59, 1, 1, 1);
			
			//this.hourSpin = new SpinButton(adjustmentHour, 1, 2);
			//this.minuteSpin = new SpinButton(adjustmentMinute, 1, 2);
			
			this.hourSpin = new SpinButton.with_range(0, 23, 1d);
			this.minuteSpin = new SpinButton.with_range(0, 59, 1d);
			this.pack_start(this.hourSpin, false, false);
			this.pack_start(this.minuteSpin, false, false);
			
		}
		protected void setEvents()
		{
			this.on_date_changed.connect(this.onDateChanged);
			this.hourSpin.value_changed.connect(this.onHourChanged);
			this.minuteSpin.value_changed.connect(this.onMinuteChanged);
		}
		protected void onDateChanged(DateTime date)
		{
			this.on_datetime_changed(this.getDateTime());
		}
		protected void onHourChanged()
		{
			this.on_datetime_changed(this.getDateTime());
		}
		protected void onMinuteChanged()
		{
			this.on_datetime_changed(this.getDateTime());
		}
		public DateTime getDateTime()
		{
			this.datetime = new DateTime(
				new TimeZone.local(), 
				this.calendar.year, 
				this.calendar.month + 1, 
				this.calendar.day, 
				(int)this.hourSpin.value, 
				(int)this.minuteSpin.value, 
				0
			);
			
			return this.datetime;
		}
		public void setDateTime(DateTime dt)
		{
			this.datetime = dt;
			this.setDate(dt);
			this.hourSpin.value = dt.get_hour();
			this.minuteSpin.value = dt.get_minute();
		}
	}
}
