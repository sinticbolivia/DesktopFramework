using GLib;
using Gtk;
using SinticBolivia.Gtk;

class SBInvoice : Object
{
	protected	double	_font_size;
	protected	int		_lines_per_page;
	protected	int		_num_lines;
	protected	int		_num_pages;
	
	protected	PrintOperation	_operation;
	protected	PrintSettings	_settings;
	//public	List<SBProduct>	Items;
	
	//##properties
	public		double	TotalAmount = 0.0d;
	public		weak 	Window	window;
	
	public SBInvoice()
	{
		this._font_size = 12.0f;
		//this.Items = new List<SBProduct>();
		this._operation = new PrintOperation();
		this._settings = new PrintSettings();
	}
	~SBInvoice()
	{
		stdout.printf("SBInvoice destroyed\n");
		this._settings.dispose();
		this._operation.dispose();
	}
	public void Prepare()
	{
		//##set events
		this._operation.begin_print.connect(this.OnBeginPrint);
		this._operation.draw_page.connect(this.OnDrawPage);
		this._operation.end_print.connect(this.OnEndPrint);
		this._operation.preview.connect(this.OnPreview);
		this._operation.use_full_page = false;
		this._operation.unit = Unit.POINTS;
		this._operation.embed_page_setup = true;
		this._operation.set_print_settings(this._settings);
	}
	public void Preview()
	{
		try
		{
			//this.Prepare();
			//string os = (string)SBGlobals.GetVar("OS");
			/*PrintOperationResult res = */
			this._operation.run(PrintOperationAction.PREVIEW, this.window);
			//this._operation.run(PrintOperationAction.PRINT_DIALOG, this.window);
		}
		catch(GLib.Error e)
		{
			stdout.printf("ERROR: %s\n", e.message);
		}
		
	}
	public void Print()
	{
	}
	protected bool OnPreview(PrintOperationPreview preview, PrintContext context, Window parent)
	{
		stdout.printf("Preview\n");
		var p = new SBPrintPreview(this._operation, preview, context);
		p.show();
		parent.add(p);
		p.ClosedPreview.connect( () =>
		{
			//p.destroy();
			//parent.destroy();
		});
		//parent.show();
		
		return true;
	}
	protected void OnBeginPrint(PrintContext context)
	{
		stdout.printf("BeginPrint\n");
		double height = context.get_height();
		this._lines_per_page = (int)GLib.Math.floor(height / this._font_size);
		string contents = "Hello World from vala printing!!!!\nSintic Bolivia";
		string[] lines = contents.split("\n");
		this._num_lines = lines.length;
		this._num_pages = (this._num_lines - 1) / this._lines_per_page + 1;
		//set total pages
		this._operation.n_pages = this._num_pages;
	}
	protected void OnDrawPage(PrintContext context, int page_nr)
	{
		int text_width, text_height;
		double top = 20;
		Cairo.Context cr = context.get_cairo_context();
		

		double width = context.get_width();
		Pango.Layout layout = context.create_pango_layout();
		Pango.FontDescription desc = Pango.FontDescription.from_string("sans 12");
		
		string invoice_title = "Woocommerce Point of Sale";
		layout.set_font_description(desc);
		layout.set_text(invoice_title, invoice_title.length);
		layout.get_pixel_size(out text_width, out text_height);
		
		if( text_width > width )
		{
			layout.set_width((int)width);
			layout.set_ellipsize(Pango.EllipsizeMode.START);
			layout.get_pixel_size(out text_width, out text_height);
		}
		cr.move_to( (width - text_width) / 2, top);
		Pango.cairo_show_layout(cr, layout);
		
		//##print invoice number
		top += 80;
		layout.set_text("%s #: %d".printf("Invoice", 1), -1);
		layout.set_width(-1);
		layout.get_pixel_size(out text_width, out text_height);
		cr.move_to(0, top);
		Pango.cairo_show_layout(cr, layout);
		
		//#print date
		// Get the current time in local timezone
		var now = new DateTime.now_local ();
		top += 20;
		layout.set_text(now.format("%x %X"), -1);
		layout.set_width(-1);
		layout.get_pixel_size(out text_width, out text_height);
		cr.move_to(0, top);
		Pango.cairo_show_layout(cr, layout);
		
		//#print customer name
		top += 20;
		layout.set_text("%s: %s".printf("Customer", "Customer01 Customer 01"), -1);
		layout.set_width(-1);
		layout.get_pixel_size(out text_width, out text_height);
		cr.move_to(0, top);
		Pango.cairo_show_layout(cr, layout);
		
		//##build column width
		double col_description = width / 2;
		double col_qty = (width / 2) / 3;
		double col_price = (width / 2) / 3;
		double col_total = (width / 2) / 3;
		
		top += 40;
		string[] headers = {"Description", "Qty", "Price", "Total"};
		
		//top += text_height;
		/*
		//##print table header description
		layout.set_markup("<span weight=\"bold\">Description</span>", -1);
		layout.set_width(-1);
		layout.get_pixel_size(out text_width, out text_height);
		cr.move_to(0, top);
		Pango.cairo_show_layout(cr, layout);
		//##print table header cantidad
		layout.set_markup("<span weight=\"bold\">Qty</span>", -1);
		layout.set_width(-1);
		layout.get_pixel_size(out text_width, out text_height);
		cr.move_to(col_description + 25, top);
		Pango.cairo_show_layout(cr, layout);
		//##print table header price
		layout.set_markup("<span weight=\"bold\">Price</span>", -1);
		layout.set_width(-1);
		layout.get_pixel_size(out text_width, out text_height);
		cr.move_to((col_description + col_qty) + 25, top);
		Pango.cairo_show_layout(cr, layout);
		//##print table header item total
		layout.set_markup("<span weight=\"bold\">Total</span>", -1);
		layout.set_width(-1);
		layout.get_pixel_size(out text_width, out text_height);
		cr.move_to((col_description + col_qty + col_price) + 25, top);
		Pango.cairo_show_layout(cr, layout);
		//##print line
		top += text_height + 10;
		cr.move_to(0, top); //line from
		cr.line_to(width, top); //line to
		cr.stroke();
		
		top += 10;
		layout.set_wrap(Pango.WrapMode.WORD_CHAR);
		//build list items table
		this.Items.foreach( (entry) => 
		{
			SBProduct p = (SBProduct)entry;
			
			layout.set_text(p.Name, -1);
			layout.get_pixel_size(out text_width, out text_height);
			cr.move_to(0, top);
			layout.set_width( Pango.units_from_double(col_description) );
			//layout.set_height( Pango.units_from_double(text_height) );
			Pango.cairo_show_layout(cr, layout);
			
			layout.set_text(p.Quantity.to_string(), -1);
			layout.set_width(-1);
			layout.get_pixel_size(out text_width, out text_height);
			cr.move_to(col_description + 25, top);
			Pango.cairo_show_layout(cr, layout);
			
			layout.set_text("%.2f".printf(p.Price), -1);
			layout.set_width( Pango.units_from_double(col_price) );
			layout.set_alignment(Pango.Alignment.RIGHT);
			layout.get_pixel_size(out text_width, out text_height);
			cr.move_to(col_description + col_qty + 25, top);
			Pango.cairo_show_layout(cr, layout);
			
			top += text_height;
		});
		
		//cr.rectangle(0, top, 50, 50);
		//cr.stroke();
		*/
	}
	protected void OnEndPrint(PrintContext context)
	{
		stdout.printf("end print\n");
	}
} 
public class PPText : Object
{
	public static int main(string[] args)
	{
		Gtk.init(ref args);
		var win = new Window();	
		win.set_default_size(400, 400);
		win.show();
		
		var invoice = new SBInvoice();
		invoice.window = win;
		invoice.Prepare();
		invoice.Preview();
		
		win.destroy.connect( () => 
		{
			invoice.dispose();
			stdout.printf("quit");
			Gtk.main_quit();
		});
		
		Gtk.main();
		return 0;
	}
}

