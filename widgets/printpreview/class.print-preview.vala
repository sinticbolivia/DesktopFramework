using GLib;
using Gtk;
using SinticBolivia;

namespace SinticBolivia.Gtk
{
	public class SBPrintPreview : Box
	{
		protected double 					_ZOOM_IN_FACTOR = 1.2;
		protected double 					_ZOOM_OUT_FACTOR = 0;
		protected PrintOperation 			_operation;
		protected PrintContext				_context;
		protected PrintOperationPreview		_operationPreview;
		protected PageSetup					_pageSetup;
		protected Layout					_layout;
		protected ScrolledWindow			_scrolledWindow;
		protected ToolButton				_next;
		protected ToolButton				_prev;
		protected ToolItem					_multi;
		protected ToolItem					_zoomOne;
		protected ToolItem					_zoomFit;
		protected ToolButton				_zoomIn;
		protected ToolButton				_zoomOut;
		protected ToolButton				_buttonPrint;
		protected Entry						_pageEntry;
		protected Label						_labelLastPage;
		protected double					_paperWidth;
		protected double					_paperHeight;
		protected double					_pixelsWidth;
		protected double					_pixelsHeight;
		protected double					_dpi;
		protected double					_scale;
		protected int						_PAGE_PAD = 12;
		/**
		 * size of the tile of a page (including padding
		 * and drop shadow) in pixels 
		 */
		protected 	int 						_tile_w;
		protected 	int 						_tile_h;

		/* multipage support */
		protected 	int						_rows = 1;
		protected 	int 					_cols = 1;

		protected 	uint 						_n_pages;
		protected 	uint 						_cur_page;
		protected 	double					_dpi_x = 72;
		protected 	double					_dpi_y = 72;
		public		uint					TotalPages = 0;
		public		uint					CurrentPage	= 0;
		
		public 		signal void ClosedPreview();
		public		signal void ButtonPrintClicked();
		
		public Cairo.Context	CairoContext
		{
			get
			{
				return this._context.get_cairo_context();
			}
		}
		
		public SBPrintPreview(PrintOperation _op, PrintOperationPreview _op_preview, PrintContext _context)
		{
			this.set_orientation(Orientation.VERTICAL);
			this.set_spacing(5);
			this._operation 		= _op;
			this._operationPreview 	= _op_preview;
			this._context			= _context;
			this._operation.unit 	= Unit.POINTS;
			this._ZOOM_OUT_FACTOR 	=  (1.0 / this._ZOOM_IN_FACTOR);
			this._paperWidth 		= this._context.get_page_setup().get_paper_width(Unit.INCH);
			this._paperHeight 		= this._context.get_page_setup().get_paper_height(Unit.INCH);
			stdout.printf("Page dimensions: %lfx%lf\n", this._paperWidth, this._paperHeight);
			//##create preview surface
			this._pageSetup 		= this._context.get_page_setup();
			this.updatePaperSize();
			unowned PaperSize papersize = this._pageSetup.get_paper_size();
						
			this._pixelsWidth = papersize.get_width(Unit.POINTS);
			this._pixelsHeight = papersize.get_height(Unit.POINTS);
			stdout.printf("Paper dimensions (pixels): %lfx%lf\n", this._pixelsWidth, this._pixelsHeight);
			
			//##build cairo surfate to draw
			Cairo.PdfSurface surface = new Cairo.PdfSurface.for_stream(this.writeFunc, this._pixelsWidth, this._pixelsHeight);
			Cairo.Context cr = new Cairo.Context(surface);
			//##set cairo surface to print context
			this._context.set_cairo_context(cr, this._dpi_x, this._dpi_y);
			
			this._layout = new Layout(null, null);
			this._layout.set_size((uint)this._pixelsWidth, (uint)this._pixelsHeight);
			this._layout.show();
			this.buildWidget();
			//##set events
			this.setEvents();
		}
		~SBPrintPreview()
		{
			stdout.printf("SBPrintPreview destroyed\n");
			this._operationPreview.end_preview();
		}
		protected void buildWidget()
		{
			//var box		= new Box(Orientation.VERTICAL, 5);
			var toolbar	= new Toolbar();
			this._prev	= new ToolButton.from_stock("gtk-go-back");
			//this._prev.label	= "Previous Page";
			this._prev.use_underline = true;
			this._prev.tooltip_text = "Show the previous page";
			this._prev.clicked.connect(this.OnPrevButtonClicked);
			toolbar.add(this._prev);
			this._next	= new ToolButton.from_stock("gtk-go-forward");
			//this._next.label	= "Next Page";
			this._next.use_underline = true;
			this._next.tooltip_text	= "Show the next page";
			this._next.clicked.connect(this.OnNextButtonClicked);
			toolbar.add(this._next);
			var separator = new SeparatorToolItem();
			toolbar.add(separator);
			
			var pages_box		= new Box(Orientation.HORIZONTAL, 5);
			
			this._pageEntry		= new Entry();
			this._pageEntry.width_chars = 3;
			this._pageEntry.max_length	= 6;
			this._pageEntry.tooltip_text = "Current page (Alt+P)";
			pages_box.add(this._pageEntry);
			pages_box.add(new Label("of"));
			this._labelLastPage		= new Label(this.TotalPages.to_string());
			pages_box.add(this._labelLastPage);
			var dummy_item = new ToolItem();
			dummy_item.add(pages_box);
			toolbar.add(dummy_item);
			separator = new SeparatorToolItem();
			toolbar.add(separator);
			
			this._zoomIn	= new ToolButton.from_stock("gtk-zoom-in");
			this._zoomIn.use_underline = true;
			this._zoomIn.tooltip_text = "Zoom the page in";
			this._zoomIn.clicked.connect(this.OnZoomInButtonClicked);
			toolbar.add(this._zoomIn);
			this._zoomOut	= new ToolButton.from_stock("gtk-zoom-out");
			this._zoomOut.use_underline = true;
			this._zoomOut.tooltip_text = "Zoom the page out";
			this._zoomOut.clicked.connect(this.OnZoomOutButtonClicked);
			toolbar.add(this._zoomOut);
			toolbar.add(new SeparatorToolItem());
			this._buttonPrint = new ToolButton.from_stock("gtk-print");
			this._buttonPrint.use_underline = true;
			this._buttonPrint.tooltip_text = "Print";
			this._buttonPrint.clicked.connect( () => 
			{
				this.ButtonPrintClicked();
			});
			toolbar.add(this._buttonPrint);
			toolbar.add(new SeparatorToolItem());
			var close_btn = new ToolButton(null, "Close Preview");
			close_btn.label = "Close Preview";
			close_btn.use_underline = true;
			close_btn.is_important = true;
			close_btn.tooltip_text = "Close print preview";
			close_btn.clicked.connect( () => 
			{
				//stdout.printf("button close clicked\n");
				this.ClosedPreview();
				
				this.destroy();
			});
			toolbar.add(close_btn);
			
			toolbar.show_all();
			
			//var darea = new  DrawingArea();
			//darea.set_size_request(310, 310);
			//Gdk.CairoHelper.Create(darea.get_window());
			//this._context.get_cairo_context().save();
			//this._context.get_cairo_context().show_page();
			
			//this._context.get_cairo_context().get_target().write_to_png("s.png");
			this._scrolledWindow = new ScrolledWindow(null, null);
			this._scrolledWindow.expand = true;
			//this._scrolledWindow.add_with_viewport(darea);
			this._scrolledWindow.add(this._layout);
			this._scrolledWindow.show();
			this.add(toolbar);
			this.add(this._scrolledWindow);
			stdout.printf("built\n");
		}
		protected Cairo.Status writeFunc(uchar[] data){return Cairo.Status.SUCCESS;}
		protected void setEvents()
		{
			//stdout.printf("Setting preview events\n");
			this._operationPreview.ready.connect(this.onPreviewReady);
			this._operationPreview.got_page_size.connect(this.onGotPageSize);
		}
		protected void onPreviewReady(PrintContext context)
		{
			stdout.printf("Preview Ready\n");
			//##get total pages from print operation
			this.TotalPages = this._operation.n_pages;
			this._labelLastPage.label = "%u".printf(this.TotalPages);
			
			this._dpi = this.getScreenDpi();
			stdout.printf("dpi => %lf\n", this._dpi);
			this.setZoomFactor(1.0);
			this._layout.draw.connect(this.OnLayoutDraw);
			this._layout.queue_draw();
		}
		protected bool OnLayoutDraw(Cairo.Context context)
		{
			int page = (int)this.CurrentPage;
			var bin_window = this._layout.get_bin_window();
			if( cairo_should_draw_window(context, bin_window) )
			{
				context.save();
				cairo_transform_to_window(context, this._layout, bin_window);
				//this._layout.set_size((uint)this._pixelsWidth, (uint)this._pixelsHeight);
				this.buildPageFrame(ref context, this._pixelsWidth, this._pixelsHeight);
				this.drawPageContent(context, page);
				context.restore();
				
			}
			return true;
		}
		protected void buildPageFrame(ref unowned Cairo.Context context, double width, double height)
		{
			int PAGE_SHADOW_OFFSET 	= 5;
			width = this.getPaperWidth() * this._scale;
			height = this.getPaperHeight() * this._scale;
			
			//##draw page drop shadow
			context.set_source_rgb(0, 0, 0);
			context.rectangle(PAGE_SHADOW_OFFSET, PAGE_SHADOW_OFFSET, width, height);
			context.fill();
			//##draw page frame
			context.set_source_rgb(1, 1, 1);
			context.rectangle(0, 0, width, height);
			context.fill_preserve();
			context.set_source_rgb(0, 0, 0);
			context.set_line_width(1);
			context.stroke();
		}
		protected void drawPageContent(Cairo.Context context, int page_number)
		{
			context.scale(this._scale, this._scale);
			this._context.set_cairo_context(context, 72, 72);
			//##draw content
			this._operationPreview.render_page(page_number);
		}
		protected void onGotPageSize(PrintContext context, PageSetup page_setup)
		{
			//stdout.printf("GetPageSize\n");
			this.updatePaperSize();
			//stdout.printf("dimensions: %lfx%lf\n", this._paperWidth, this._paperHeight);
		}
		protected void updatePaperSize()
		{
			this._paperWidth	= this._pageSetup.get_paper_width(Unit.INCH);
			this._paperHeight 	= this._pageSetup.get_paper_height(Unit.INCH);
		}
		protected double getScreenDpi()
		{
			Gdk.Screen screen = this.get_screen();
			double dpi = screen.get_resolution();
			if ( dpi < 30 || 600 < dpi)
			{
				stderr.printf("Invalid the x-resolution for the screen, assuming 96dpi\n");
				dpi = 96;
			}

			return dpi;
		}
		protected void setZoomFactor(double zoom)
		{
			this._scale = zoom;
			this.updateTileSize();
			this.updateLayoutSize();
		}
		protected void updateTileSize()
		{
			this._tile_w = (int)(2 * this._PAGE_PAD + Math.floor(this._scale * this.getPaperWidth() + 0.5));
			this._tile_h = (int)(2 * this._PAGE_PAD + Math.floor(this._scale * this.getPaperHeight() + 0.5));
		}
		protected void updateLayoutSize()
		{
			this._layout.set_size(this._tile_w, this._tile_h);
			this._layout.queue_draw();
		}
		protected double getPaperWidth()
		{
			return this._paperWidth * this._dpi;
		}
		protected double getPaperHeight()
		{
			return this._paperHeight * this._dpi;
		}
		protected void goToPage(int page)
		{
			this._pageEntry.text = "%d".printf(page);
			this._prev.sensitive = (page > 0) && (this.TotalPages > 1);
			this._next.sensitive = (( page != (this.TotalPages - 1) ) && (this.TotalPages > 1));
			if( page != this.CurrentPage )
			{
				this.CurrentPage = page;
				if( this.TotalPages > 0 )
				{
					this._layout.queue_draw();
				}
			}
		}
		protected void OnZoomInButtonClicked()
		{
			this.setZoomFactor(this._scale * this._ZOOM_IN_FACTOR);
		}
		protected void OnZoomOutButtonClicked()
		{
			this.setZoomFactor(this._scale * this._ZOOM_OUT_FACTOR);
		}
		protected void OnPrevButtonClicked()
		{
			global::Gdk.Event event;
			uint page;

			event = global::Gtk.get_current_event ();

			if ((bool)(event.button.state & Gdk.ModifierType.SHIFT_MASK))
				page = 0;
			else
				//page = preview->priv->cur_page - preview->priv->rows * preview->priv->cols;
				page = this.CurrentPage - this._rows * this._cols;
			this.goToPage(int32.max((int)page, 0));
			//Gdk.event_free (event);
		}
		protected void OnNextButtonClicked()
		{
			Gdk.Event event;
			uint page;

			event = global::Gtk.get_current_event ();

			if ((bool)(event.button.state & Gdk.ModifierType.SHIFT_MASK))
				page = this.TotalPages - 1;
			else
				page = this.CurrentPage + this._rows * this._cols;
			
			this.goToPage(int32.min((int)page, (int)this.TotalPages - 1));
			//Gdk.event_free (event);
		}
	}
}
