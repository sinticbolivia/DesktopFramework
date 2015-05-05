using GLib;
using Gee;
using HPDF;

namespace SinticBolivia.Reports
{
	public class PdfTable : Object
	{
		protected	ArrayList<PdfRow>		rows;
		public		unowned HPDF.Page		PdfPage;
		public		unowned HPDF.Doc		Doc;
		public		unowned	HPDF.Font		Font;
		public		PdfReport				Report;
		protected	int						totalCols = 0;
		public		float					Width;
		public		float					Height;
		public		float					X;
		public		float					Y;
		public		float					SourceX = 0;
		public		float					SourceY = 0;
		public		float[]					ColumnsWidth;
		public		string[]				Headers;
		protected	PdfRow?					currentRow = null;
		protected	int						currentCell = 0;
		
		public PdfTable(HPDF.Doc doc, HPDF.Page page, HPDF.Font font, float width, float source_x, float source_y)
		{
			this.rows 		= new ArrayList<PdfRow>();
			
			this.Doc		= doc;
			this.PdfPage	= page;
			this.Font		= font;//this.PdfPage.GetCurrentFont();
			
			this.Width 		= width;
			this.SourceX 	= source_x;
			this.SourceY	= source_y;
			this.Y			= this.SourceY;
		}
		/**
		 * Set Columns width percentage
		 * 
		 * */
		public void SetColumnsWidth(float[] widths)
		{
			this.ColumnsWidth = new float[widths.length];
			for(int i = 0; i < widths.length; i++)
			{
				this.ColumnsWidth[i] = this.Width * (widths[i] / 100);
			}
			this.totalCols = this.ColumnsWidth.length;
		}
		public void SetTableHeaders(string[] headers)
		{
			if(this.totalCols <= 0 )
			{
				stdout.printf("No columns found\n");
				return;
			}
			var row = this.AddRow();
			row.SourceX = this.SourceX;
			row.SourceY = this.SourceY;
			
			//this.Headers = headers;
			foreach(string header in headers)
			{
				this.AddTextCell(header, "center");
			}
		}
		public PdfRow AddRow()
		{
			var row 			= new PdfRow.with_table(this);
			row.ColumnsWidth	= this.ColumnsWidth;
			row.NumCells		= this.ColumnsWidth.length;
			row.SourceX 		= this.SourceX;
			row.SourceY 		= this.SourceY;
			if( this.rows.size > 0 )
			{
				this.currentRow.calculateRowSize();
				this.Y		= this.Y - this.currentRow.Height;
				row.SourceY = this.Y;
			}
			
			this.rows.add(row);
			
			return row;
		}
		public PdfCell? AddCell()
		{
			if( this.totalCols <= 0 )
			{
				stdout.printf("No columns found.\n");
				return null;
			}
			if( this.currentRow == null )	
			{
				this.currentRow = this.AddRow();
				this.currentCell = 0;
			}
			PdfCell? the_cell = this.currentRow.AddCell();
			if( the_cell == null )
			{
				this.currentRow = this.AddRow();
				this.currentCell = 0;
				the_cell = this.currentRow.AddCell();
			}
					
			return the_cell;
		}
		public void AddTextCell(string text, string align = "left", float font_size = 12, bool border = true, int span = 1, 
							string? bg = null, string? fg = null)
		{
			/*
			var the_cell = this.AddCell();
			the_cell.FontFamily = "Helvetica";
			the_cell.FontSize	= font_size;
			the_cell.PdfFont	= this.Doc.GetFont(the_cell.FontFamily);
			the_cell.Span 		= span;
			the_cell.Border		= border;
			the_cell.Align		= align;
			
			the_cell.SetText(text);
			
			if( span == this.totalCols )
			{
				if( this.currentRow.Size == 0 )
				{
					this.currentRow.AddCell();
					this.rows.add(this.currentRow);
				}
				else
				{
					this.rows.add(this.currentRow);
					this.currentRow = new PdfRow(this.page);
					this.currentRow.AddCell(the_cell);
					this.rows.add(this.currentRow);
					
				}
				this.currentRow = new PdfRow(this.page);
				this.currentCell = 0;
				return;
			}
			
			//##check space in row
			int cells_left = this.totalCols - this.currentRow.Size;
			if( cells_left > 0  )
			{
				this.currentRow.AddCell(the_cell);
				this.currentCell++;
			}
			cells_left = this.totalCols - this.currentRow.Size;
			if( cells_left <= 0 )
			{
				this.rows.add(this.currentRow);
				this.currentRow = new PdfRow(this.page);
				this.currentCell = 0;
			}
			*/
		}
		public void Draw()
		{
			/*
			this.PdfPage.SetFontAndSize(this.Font, 5);
			this.PdfPage.BeginText();
			this.PdfPage.TextOut(this.SourceX, this.SourceY, "(%.2f,%.2f)".printf(this.SourceX, this.SourceY));
			this.PdfPage.TextOut(this.SourceX + this.Width, this.SourceY, "(%.2f,%.2f)".printf(this.SourceX + this.Width, this.SourceY));
			this.PdfPage.EndText();
			*/
			foreach(var row in this.rows)
			{
				row.calculateRowSize();
				
				if( this.Report.CheckNewPage(row.Height) )
				{
					//row.SetPage(this.PdfPage);
					this.PdfPage = this.Report.page;
				}
				row.SetXY(this.Report.XPos, this.Report.YPos);
				row.Draw();
				this.Height += row.Height;
			}
		}
	}
}
