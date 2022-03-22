using GLib;
using Pango;
using Cairo;

namespace SinticBolivia.GtkWidgets
{
	public class SBCairoCellTable : Object
	{
		public	string	Align;
		public	double	Width;
		public	double	Height;
		public	bool	Border = false;
		public	string	Text;
		public	double	X
		{
			get{return this._x;}
			set
			{
				this._x = value;
			}
		}
		public	double	Y
		{
			get{return this._y;}
			set
			{
				this._y = value;
			}
		}
		
		protected	double			_x;
		protected	double			_y;
		protected	Pango.Layout	_layout;
		protected	Cairo.Context	_cr;
		
		public SBCairoCellTable(Cairo.Context cr, Pango.Layout layout)
		{
			this._cr = cr;
			this._layout = layout;
		}
		public void Draw()
		{
			int text_width, text_height;
			int cell_width_units = Pango.units_from_double(this.Width);
			
			this._layout.set_width( cell_width_units );
			this._layout.set_text(this.Text, -1);
			this._layout.get_pixel_size(out text_width, out text_height);
			//stderr.printf("------- %d > %d :: %d, %d\n", (text_width / 0.75), (int)this.Width, cell_width_units, Pango.SCALE);
			while( (text_width / 0.75) > this.Width )
			{
				this.Text = this.Text.substring(0, this.Text.length - 1);
				this._layout.set_text(this.Text, -1);
				this._layout.get_pixel_size(out text_width, out text_height);
			}
			this.Height = text_height + 7;
			if( this.Align == "left" )
			{
				this._layout.set_alignment(Pango.Alignment.LEFT);
			}
			else if( this.Align == "center" )
			{
				this._layout.set_alignment(Pango.Alignment.CENTER);
			}
			else if( this.Align == "right" )
			{
				this._layout.set_alignment(Pango.Alignment.RIGHT);
			}
			if( this.Border )
			{
				//draw rectangle
				this._cr.rectangle(this.X, this.Y, this.Width, this.Height);
				this._cr.stroke();
			}
			//draw text
			this._cr.move_to(this.X, this.Y + 3);
			Pango.cairo_show_layout(this._cr, this._layout);
		}
	}

	public class SBCairoTable : Object
	{
		protected	Cairo.Context	_cr;
		protected	Pango.Layout	_layout;
		protected	uint _columns;
		protected	uint	_rows;
		protected	double[]	_columnsWidth;
		protected	uint _nextColumnIndex = 0;
		protected	uint _nextRowIndex = 0;
		
		public	double	X
		{
			get{return this._x;}
			set
			{
				this._x = value;
				this._nextX = this._x;
			}
		}
		public	double	Y
		{
			get{return this._y;}
			set
			{
				this._y = value;
				this._nextY = this._y;
			}
		}
		
		protected	double			_x;
		protected	double			_y;
		protected	double 			_nextX;
		protected	double			_nextY;
		
		public		double			Height = 0;
		
		public SBCairoTable(Cairo.Context cr, Pango.Layout layout, uint columns = 0, uint rows = 0)
		{
			this._cr = cr;
			this._layout = layout;
			this._columns = columns;
			this._rows = rows;
			this._cr.set_line_width(0.5);
		}
		public void SetColumnsWidth(double[] widths)
		{
			this._columnsWidth = widths;
		}
		public SBCairoCellTable AddCell(string text, string align = "left", bool border = true)
		{
			var cell 	= new SBCairoCellTable(this._cr, this._layout);
			cell.Text 	= text;
			cell.Width 	= this._columnsWidth[this._nextColumnIndex];
			cell.Border = border;
			cell.Align	= align;
			//calculate cell position
			cell.X		= this._nextX;
			cell.Y		= this._nextY;
			this._nextX = this._nextX + this._columnsWidth[this._nextColumnIndex];
			cell.Draw();
			
			this._nextColumnIndex++;
			if( this._nextColumnIndex == this._columns )
			{
				this._nextColumnIndex = 0;
				this._nextRowIndex++;
				this._nextX = this.X;
				this._nextY = this._nextY + cell.Height;
				this.Height += cell.Height;
			}
			return cell;
		}
	}
	public abstract class SBCairoObject : Object
	{
		protected 	string type;
		protected	int				height;
		protected	int				width;
		protected	Cairo.Context	context;
		protected	Pango.Layout	layout;
		public		double			PageWidth;
		
		public Cairo.Context Context
		{
			get{return this.context;}
			set{this.context = value;}
		}
		public Pango.Layout PangoLayout
		{
			set{this.layout = value;}
			get{return this.layout;}
		}
		public int Height
		{
			get{return this.height;}
		}
		protected SBCairoObject(string type)
		{
			this.type = type;
		}
		public abstract void SetWidth(int w);
		public abstract void CalculateSize();
		public abstract void Draw();
	}
	public class SBCairoParagraph : SBCairoObject
	{
		protected 	string			text;
		public		string			Font = "Arial";
		public		double			FontSize = 12.0f;
		public		string			Align = "left";
		
		public string	Text
		{
			get{return this.text;}
			set{this.text = value;}
		}
		public SBCairoParagraph()
		{
			base("paragraph");
		}
		public SBCairoParagraph.with_context(Cairo.Context ctx, double page_width)
		{
			this();
			this.context	= ctx;
			this.PageWidth	= page_width;
			
		}
		/*
		public SBCairoParagraph.with_text(Cairo.Context ctx, string str)
		{
			this(ctx);
			this.text 		= str;
		}
		*/
		public void SetText(string str, string? font = null, string align = "left")
		{
			int text_width = 0, text_height = 0;
			int top = 0;
			this.text	= str;
			
			//Pango.Layout layout = this.context.create_pango_layout();
			Pango.Layout layout = Pango.cairo_create_layout(this.context);
			Pango.FontDescription desc = Pango.FontDescription.from_string(font != null ? font : "Arial %lf".printf(12.0f));
			layout.set_font_description(desc);
			layout.set_text(this.text, this.text.length);
			layout.get_pixel_size(out text_width, out text_height);
			
			if( text_width > this.PageWidth )
			{
				layout.set_width((int)this.PageWidth);
				layout.set_ellipsize(Pango.EllipsizeMode.START);
				layout.get_pixel_size(out text_width, out text_height);
			}
			//##draw the text
			if( this.Align == "left")
				this.context.rel_move_to(0, this.FontSize);
			else if( this.Align == "center")
				this.context.move_to( (width - text_width) / 2, this.FontSize);
			else if( this.Align == "right")
				this.context.move_to( width - text_width, this.FontSize);
				
			Pango.cairo_show_layout(this.context, layout);
			//##set paragraph size
			this.height = text_height;
			this.width	= text_width;
		}
		public override void SetWidth(int w)
		{
			this.PageWidth = w;
		}
		public override void CalculateSize()
		{
			int text_width = 0, text_height = 0;
			Pango.Layout layout = Pango.cairo_create_layout(this.context);
			Pango.FontDescription desc = Pango.FontDescription.from_string("%s %lf".printf(this.Font, this.FontSize));
			layout.set_font_description(desc);
			layout.set_text(this.text, this.text.length);
			layout.get_pixel_size(out text_width, out text_height);
			
			if( text_width > this.PageWidth )
			{
				layout.set_width((int)this.PageWidth);
				layout.set_ellipsize(Pango.EllipsizeMode.START);
				layout.get_pixel_size(out text_width, out text_height);
			}
			this.height = text_height;
			this.width = text_width;
		}
		public override void Draw()
		{
			int text_width = 0, text_height = 0;
			
			//Pango.Layout layout = this.context.create_pango_layout();
			//Pango.Layout layout = Pango.cairo_create_layout(this.context);
			Pango.FontDescription desc = Pango.FontDescription.from_string("%s %lf".printf(this.Font, this.FontSize));
			this.layout.set_font_description(desc);
			this.layout.set_text(this.text, this.text.length);
			this.layout.get_pixel_size(out text_width, out text_height);
			
			if( text_width > this.PageWidth )
			{
				this.layout.set_width((int)this.PageWidth);
				this.layout.set_ellipsize(Pango.EllipsizeMode.START);
				this.layout.get_pixel_size(out text_width, out text_height);
			}
			//##draw the text
			if( this.Align == "left")
				this.context.rel_move_to(0, 12.0f);
			else if( this.Align == "center")
				this.context.rel_move_to( (this.PageWidth - text_width) / 2, this.FontSize);
			else if( this.Align == "right")
				this.context.rel_move_to( this.PageWidth - text_width, this.FontSize);
				
			Pango.cairo_show_layout(this.context, this.layout);
			//##set paragraph size
			this.height = text_height;
			this.width	= text_width;
		}
	}
}
