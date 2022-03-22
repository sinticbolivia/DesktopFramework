using GLib;
using Gee;
using Gtk;
using SinticBolivia;

namespace SinticBolivia.GtkWidgets
{
	public class InfoDialog : Dialog
	{
		protected	string	dlgType;
		
		public string Title
		{
			get{return this.LabelTitle.label;}
			set{this.LabelTitle.label = value;}
		}
		public string Message
		{
			get{return this.LabelMessage.label;}
			set{this.LabelMessage.label = value;}
		}
		public		Label			LabelTitle{get;set;}
		public		Label			LabelMessage{get;set;}
		public		Button			ButtonClose{get;set;}
		protected	EventBox		boxHeader;
		
		public InfoDialog(string type = "info")
		{
			this.dlgType = type;
			this.Build();
			this.SetEvents();
		}
		protected void Build()
		{
			this.window_position 	= WindowPosition.CENTER_ALWAYS;
			this.decorated			= false;
			
			this.boxHeader		= new EventBox();
			this.boxHeader.get_style_context().add_class("header");
			this.boxHeader.show();
			this.LabelTitle		= new Label("");
			this.LabelTitle.show();
			this.LabelTitle.get_style_context().add_class("title");
			this.boxHeader.add(this.LabelTitle);
			this.get_content_area().add(this.boxHeader);
			//##build message body
			this.LabelMessage	= new Label("");
			this.LabelMessage.show();
			this.get_content_area().add(this.LabelMessage);
			//##add default close button
			this.ButtonClose = (Button)this.add_button(SBText.__("Close"), ResponseType.CLOSE);
						
			this.get_content_area().get_style_context().add_class("body");
			this.get_style_context().add_class("info-dialog");
			this.get_style_context().add_class(this.dlgType);
			
			this.ButtonClose.get_style_context().add_class("button-close");
			//this.get_content_area().get_style_context().add_class(type);
		}
		protected void SetEvents()
		{
			this.ButtonClose.clicked.connect(this.OnButtonCloseClicked);
		}
		protected void OnButtonCloseClicked()
		{
			this.hide();
		}
	}
}
