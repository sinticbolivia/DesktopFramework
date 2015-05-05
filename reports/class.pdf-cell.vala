using GLib;
using Gee;
using HPDF;

namespace SinticBolivia.Reports
{
	public class PdfCell : Object
	{
		//protected 	unowned HPDF.Page	page;
		public 		unowned HPDF.Font	Font;
		protected	string				text;
		protected	HPDF.Image			image;
		public		PdfRow				Row;
		public		int					Index		= 0;
		public		float				Width		= 0;
		public		float				Height		= 0;
		public		float				SourceX;
		public		float				SourceY;
		public		string				FontFamily  = "Helvetica";
		public		float				FontSize 	= 12;
		public		int					Span 		= 1;
		public		bool				Border
		{
			set
			{
				this.TopBorder = value;
				this.RightBorder = value;
				this.BottomBorder = value;
				this.LeftBorder = value;
			}
		}
		public		bool				TopBorder	= true;
		public		bool				RightBorder	= true;
		public		bool				BottomBorder	= true;
		public		bool				LeftBorder	= true;
		public		float				Padding		= 3;
		public		string				Align		= "left";
		
		protected ArrayList<string>		lines;
		
		public PdfCell()
		{
			this.lines = new ArrayList<string>();
		}
		public PdfCell.with_row(PdfRow row)
		{
			this();
			this.Row = row;
			this.Font		= this.Row.Table.Font;
			this.FontSize	= this.Row.Table.PdfPage.GetCurrentFontSize();
		}
		public void SetText(string text)
		{
			//##calculate cell width if span > 1
			if( this.Span > 1 && this.Span <= this.Row.NumCells && (this.Row.NumCells - this.Row.Size) >= this.Span )
			{
				this.Width = 0;
				for( int i = 0; i < this.Span; i++ )
				{
					this.Width += this.Row.ColumnsWidth[this.Index + i];
				}
				stdout.printf("cell span width: %.2f\n", this.Width);
			}
						
			this.lines 	= this.BuildCellText(this.FontSize, text);
			this.Height	= (this.FontSize * this.lines.size * 1.5f);
			//stdout.printf("(%s), lines: %d, width: %f, height: %f, span: %d,\n", text, this.lines.size, this.Width, this.Height, this.Span);
		}
		public void SetImage(HPDF.Image? image)
		{
			if( image == null )
				return;
			this.Row.Table.PdfPage.DrawImage(image, this.SourceX, this.SourceY - image.GetHeight(), image.GetWidth(), image.GetHeight());
			this.Height	= image.GetHeight();
		}
		public void Draw()
		{
			/*
			this.Row.Table.PdfPage.SetFontAndSize(this.Font, 5);
			this.Row.Table.PdfPage.BeginText();
			this.Row.Table.PdfPage.TextOut(this.SourceX, this.SourceY, "(%.2f,%.2f)".printf(this.SourceX, this.SourceY));
			this.Row.Table.PdfPage.EndText();
			*/
			this.Row.Table.PdfPage.SetFontAndSize(this.Font, this.FontSize);
			float border_width = 0.3f;
			this.Row.Table.PdfPage.SetLineWidth(border_width);
			if( this.TopBorder )
			{
				//##draw top cell border
				this.Row.Table.PdfPage.MoveTo(this.SourceX, this.SourceY);
				this.Row.Table.PdfPage.LineTo(this.SourceX + this.Width, this.SourceY);
				//this.Row.Table.PdfPage.Rectangle(this.SourceX, this.SourceY - this.Height, this.Width, this.Height);
				this.Row.Table.PdfPage.Stroke();
			}
			if( this.RightBorder )
			{
				//##draw right cell border
				this.Row.Table.PdfPage.MoveTo(this.SourceX + this.Width, this.SourceY);
				this.Row.Table.PdfPage.LineTo(this.SourceX + this.Width, this.SourceY - this.Height);
				this.Row.Table.PdfPage.Stroke();
			}
			if( this.BottomBorder )
			{
				//##draw bottom cell border
				this.Row.Table.PdfPage.MoveTo(this.SourceX, this.SourceY - this.Height);
				this.Row.Table.PdfPage.LineTo(this.SourceX + this.Width, this.SourceY - this.Height);
				this.Row.Table.PdfPage.Stroke();
			}
			if( this.LeftBorder )
			{
				//##draw left cell border
				this.Row.Table.PdfPage.MoveTo(this.SourceX, this.SourceY);
				this.Row.Table.PdfPage.LineTo(this.SourceX, this.SourceY - this.Height);
				this.Row.Table.PdfPage.Stroke();
			}
			
			float yy = this.SourceY - this.FontSize - this.Padding;
			float xx = this.SourceX + this.Padding;
			//##draw the cell text
			int i = 0;
			foreach(string _text in this.lines)
			{
				float text_width = this.Row.Table.PdfPage.TextWidth(_text);
				float text_x_pos = xx;
				float text_y_pos = yy;
				if( this.lines.size == 1 ) 
				{
					//text_y_pos -= (this.Height - this.FontSize - this.Padding) / 2;
					text_y_pos = this.SourceY - (this.Height / 2) - (this.FontSize / 2) + 1 ;
					//stdout.printf("cell text post: (%.2f, %.2f)\n", text_x_pos, text_y_pos);
				}
				/*
				else
				{
					text_y_pos -= 3f;
				}
				*/
				if( this.Align == "center")
					text_x_pos += ((this.Width - this.Padding) - text_width) / 2;
				else if( this.Align == "right" )
					text_x_pos = (text_x_pos + this.Width) - text_width - this.Padding;
				
				this.Row.Table.PdfPage.BeginText();
				this.Row.Table.PdfPage.TextOut(text_x_pos, text_y_pos, _text);
				this.Row.Table.PdfPage.EndText();
				i++;
				if( i < this.lines.size )
					yy -= this.FontSize;
			}
			
		}
		public ArrayList<string> BuildCellText(float font_size, string text)
		{
			float current_font_size = this.Row.Table.PdfPage.GetCurrentFontSize();
			
			this.Row.Table.PdfPage.SetFontAndSize(this.Font, font_size);
			var lines 			= new ArrayList<string>();
			string the_str = text.strip().normalize();
			if( the_str.index_of("\n") != -1 )
			{
				foreach(string _line in the_str.split("\n"))
				{
					float text_width 	= this.Row.Table.PdfPage.TextWidth(_line);
					if( text_width < this.Width )
					{
						lines.add(_line);
					}
					else
					{
						string[] words = _line.split(" ");
						string line = "";
						
						for(int i = 0; i < words.length; i++)
						{
							line += words[i] + " ";
							float w = this.Row.Table.PdfPage.TextWidth(line);
							if( w >= this.Width )
							{
								//stdout.printf("line: %s\n",line);
								lines.add(line.strip());
								line = "";
							}
							else if( i == words.length - 1)
							{
								//stdout.printf("line: %s\n",line);
								lines.add(line.strip());
								line = "";
							}
						}
					}
				}
			}
			else
			{
				float text_width 	= this.Row.Table.PdfPage.TextWidth(text);
				if( text_width < this.Width )
				{
					lines.add(text);
				}
				else
				{
					string[] words = the_str.split(" ");
			
					//stdout.printf("(%s) length: %d, words: %d\n", the_str, the_str.length, words.length);
					string line = "";
					
					for(int i = 0; i < words.length; i++)
					{
						//line += words[i] + " ";
						float w = this.Row.Table.PdfPage.TextWidth(line + words[i]);
						if( w >= this.Width )
						{
							lines.add(line.strip());
							line = words[i] + " ";
						}
						else if( i == words.length - 1)
						{
							//stdout.printf("line: %s\n",line);
							lines.add(line.strip());
							line = "";
						}
						else
						{
							line += words[i] + " ";
						}
					}
					
				}
			}
			//##restore font size
			this.Row.Table.PdfPage.SetFontAndSize(this.Font, current_font_size);
			return lines;
		}
	}
}
