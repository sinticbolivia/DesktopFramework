using Gee;

namespace SinticBolivia.Classes
{
	public abstract class Observable : Object
	{
		protected	ArrayList<Observer>		observers;
		public	HashMap<string, Value?>	data;

		protected Observable()
		{
			this.data = new HashMap<string, Value?>();
			this.observers = new ArrayList<Observer>();
		}
		public void subscribe(Observer obs)
		{
			this.observers.add(obs);
		}
		public void unsubscribre()
		{
		}
		public new void notify()
		{
			foreach(var observer in this.observers)
			{
				observer.update(this);
			}
		}
	}
}
