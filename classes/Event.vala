namespace SinticBolivia.Classes
{
	public class Event : Observable
	{
		public	string 	name;
		public	Object	obj;
		
		public Event(string name)
		{
			this.name = name;
		}
		public void dispatch()
		{
			this.notify();
		}
		public virtual string get_json_data()
		{
			size_t length;
			
			return Json.gobject_to_data(this.obj, out length);
		}
	}
}
