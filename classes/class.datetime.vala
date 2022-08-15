using GLib;

namespace SinticBolivia
{
	public class SBDateTime : Object 
	{
		private GLib.DateTime datetime;
		private bool _valid = false;
		
		public SBDateTime () 
		{
			this.datetime = new GLib.DateTime.now_local ();
		}
		public SBDateTime.from_string (string dateStr) 
		{
			this();
			this.parse(dateStr);
		}
		public bool parse(string dateStr, string dateSep = "-") 
		{
			if (dateStr.index_of (":") > -1) 
			{
				//-- This is a time
				var parts = dateStr.split (":");
				var part = parts[0];
				var partsDate = part.index_of ("T") > -1 ? part.split("T") : part.split (" ");
				var parseDateStrArr = new string[partsDate.length - 1];
				for (var i = 0; i < partsDate.length - 1; i++) 
				{
					parseDateStrArr[i] = partsDate[i];
				}
				var parseDateStr = string.joinv (" ", parseDateStrArr);
				string[] dateParts = parseDateStr.split(dateSep);
				
				var r = /([0-9]{2})\:([0-9]{2})\:([0-9\.]{2,6})/;
				var timeParts = r.split (dateStr);
				print("DATE PARTS: %s\n", parseDateStr );
				print("TIME PARTS: %s\n", string.joinv(", ", timeParts));
				var hour = "00";
				var minute = "00";
				var second = "00";
				for (var i = 1; i < timeParts.length - 1; i++) 
				{
					if (i == 1) 
					{
						hour = timeParts[i];
					}
					else if (i == 2) 
					{
						minute = timeParts[i];
					}
					else if (i == 3) 
					{
						second = timeParts[i];
					}
				}
				//print("TIME: %s:%s:%s\n", hour, minute, second);
				this.parse_date (parseDateStr);
				if( this._valid )  
				{
					//print("IS VALID\n");
					
					var newdatetime = new GLib.DateTime.local (
						//this.datetime.get_year(), 
						int.parse(dateParts[0]),
						this.datetime.get_month (), 
						this.datetime.get_day_of_month (),
						int.parse (hour), 
						int.parse (minute), 
						int.parse (second)
					);
					this.datetime = newdatetime;
				}
				return _valid;
			} 
			else 
			{
				return this.parse_date (dateStr);
			}
			return _valid;
		}
		public bool parse_date (string dateStr) 
		{
			string[] parts = dateStr.replace("/", "-").split("-");
			
			message ("Parsing Date: %s\n", dateStr);
			var parsed_date = Date ();
			parsed_date.set_parse (dateStr.strip());
			if (parsed_date.valid ()) 
			{
				var time = Time();
				parsed_date.to_time (out time);
				
				var output = new char[100];
				var format = "%c";
				var success = parsed_date.strftime (output, format);
				if (success == 0) 
				{
					_valid = false;
					warning ("Failed to formart date '%s'.".printf(dateStr));
				} 
				else 
				{
					string yearStr = time.year.to_string();
					if( yearStr.length == 3 )
						yearStr = yearStr.substring(1);
					
					message("Building date with data: %d %d %d | %d %d %d\n",
						int.parse(yearStr), 
						time.month, 
						time.day,
						time.hour, 
						time.minute, 
						time.second
					);
					
					var bdatetime = new GLib.DateTime.local (
						int.parse(yearStr), 
						time.month + 1, 
						time.day,
						0, 0, 0
					);
					var formatted_output = ((string) output).chomp ();
					//message ("Parsed Date: '" + formatted_output + "'\n");
					message ("Format Date: %s\n", bdatetime.format("%Y-%m-%d %H:%M:%S"));
					this.datetime = bdatetime;
					_valid = true;
				}
			} 
			else 
			{
				_valid = false;
				warning ("INVALID DATE: Failed to formart date '%s'.".printf(dateStr));
			}
			
			return _valid;
		}
		public string format(string format) 
		{
			var result = format;
			string[] formats_types = {
				"a", "A", "b", "B", "c", "C", "d", "D", "e", "F", "g", "G", "h",
				"H", "I", "j", "k", "l", "m", "M", "p", "P", "r", "R", "s", "S",
				"t", "T", "u", "V", "w", "x", "X", "y", "Y", "z", "Z"
			};
			foreach (var format_type in formats_types) 
			{
				var type = @"%$format_type";
				if (result.index_of (type) == -1) {
					continue;
				}
				if (type == "%Y") {
					result = result.replace(type, get_year ().to_string ());
				} else {
					result = result.replace(type, get_datetime ().format (type));
				}
			}
			return result;
		}
		public bool valid () 
		{
			return _valid;
		}
		public GLib.DateTime get_datetime () 
		{
			return this.datetime;
		}
		public int get_year () 
		{
			return this.datetime.get_year () + 1900;
		}
		public int get_month () 
		{
			return this.datetime.get_month ();
		}
		public int get_day_of_month () 
		{
			return this.datetime.get_day_of_month ();
		}
		public int get_hour () 
		{
			return this.datetime.get_hour ();
		}
		public int get_minute () 
		{
			return this.datetime.get_minute ();
		}
		public int get_second () 
		{
			return this.datetime.get_second ();
		}
		public int get_microsecond () 
		{
			return this.datetime.get_microsecond ();
		}
		public static DateTime? parseDbDate(string dateStr)
		{
			string[] dateParts = dateStr.strip().replace("/", "-").split("-");
			
			DateTime dbDate = new DateTime(new TimeZone.local(), 
				int.parse(dateParts[0]),
				int.parse(dateParts[1]),
				int.parse(dateParts[2]),
				0, 0 ,0
			);
			
			return dbDate;
		}
		public static DateTime? parseDbDateTime(string datetime)
		{
			string[] parts = datetime.strip().split(" ");
			DateTime dbDate = parseDbDate(parts[0]);
			if( parts.length < 2 )
				return dbDate;
				
			string[] timeParts = parts[1].split(":");
			
			DateTime dbDateTime = new DateTime(new TimeZone.local(), 
				dbDate.get_year(),
				dbDate.get_month(),
				dbDate.get_day_of_month(),
				int.parse(timeParts[0]),
				int.parse(timeParts[1]),
				int.parse(timeParts[2])
			);
			
			return dbDateTime;
		}
	}
}
