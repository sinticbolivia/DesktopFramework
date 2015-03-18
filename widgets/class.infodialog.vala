using GLib;
using Gee;
using Gtk;
using SinticBolivia;

namespace SinticBolivia.Gtk
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
			this.boxHeader		= new EventBox();
			this.boxHeader.show();
			this.LabelTitle		= new Label("");
			this.LabelTitle.show();
			this.boxHeader.add(this.LabelTitle);
			this.LabelMessage	= new Label("");
			this.LabelMessage.show();
			this.ButtonClose = (Button)this.add_button(SBText.__("Close"), ResponseType.CLOSE);
			
			this.get_content_area().add(this.LabelMessage);
			
			this.get_content_area().get_style_context().add_class("body");
			this.get_style_context().add_class("info-dialog");
			this.get_style_context().add_class(this.dlgType);
			this.boxHeader.get_style_context().add_class("title");
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
