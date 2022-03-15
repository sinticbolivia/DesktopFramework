using GLib;
using Gtk;
using Gee;

namespace SinticBolivia.Gtk
{
	public class SBNotebook : Notebook
	{
		//protected 	Notebook					_notebook;
		protected 	int							_totalPages;
		protected	HashMap<string, int>		_pages;
		
		public SBNotebook()
		{
			GLib.Object();
			//this._notebook		= new Notebook();
			this._pages			= new HashMap<string, int>(null, null);
			this._totalPages	= 0;
		}
		public int AddPage(string page_id, string title, Widget content)
		{
			if( this._pages.has_key(page_id) )
			{
				this.SetCurrentPageById(page_id);
				return (int)this._pages.get(page_id);
			}
			//##build tab box	
			var box = new Box(Orientation.HORIZONTAL, 3);
			box.show();
			var label = new Label(title);
			label.show();
			var button = new Button.with_label("x"){relief = ReliefStyle.NONE};
			button.show();
			button.clicked.connect( () => 
			{
				this.RemovePage(page_id);
			});
			box.add(label);
			box.add(button);
			//set widget id
			content.name = "tab-%s".printf(page_id);
			content.set_data<string>("page_id", page_id);
			content.show();
			//##add page into notebook
			int page_index = this.append_page(content, box);
			this._pages.set(page_id, page_index);
			this._totalPages++;
			
			return page_index;
		}
		public bool RemovePage(string page_id)
		{
			if( !this._pages.has_key(page_id) )
				return false;
			
			int page_index = (int)this._pages.get(page_id);
			//remove page from notebook
			this.remove_page(page_index);
			stdout.printf("Removing page_index: %d\n", page_index);
			/*
			//destroy the child widget
			var child_widget = this.get_nth_page(page_index);
			if( child_widget is Object)
			{
				child_widget.dispose();
			}
			*/
			//remove page data from pages list
			this._pages.unset(page_id);
			//##reorder the pages index
			int index = 0;
			this.foreach( (child) => 
			{
				//stdout.printf("child name: %s\n", child.name);
				this._pages[child.get_data<string>("page_id")] = index;
				index++;
			});
			return true;
		}
		public Widget? GetPage(string page_id)
		{
			if( !this._pages.has_key(page_id) )
				return null;
			//int index = 0;
			Widget? page = null;
			
			this.foreach( (child) => 
			{
				if( child.get_data<string>("page_id") == page_id )
				{
					page = child;
				}
			});
			
			return page;
		}
		public void SetCurrentPageById(string page_id)
		{
			if( !this._pages.has_key(page_id) )
				return;
			int page_num = (int)this._pages.get(page_id);
			this.set_current_page(page_num);
		}
	}
}
