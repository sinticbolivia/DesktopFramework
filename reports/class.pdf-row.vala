using GLib;
using Gee;
using HPDF;

namespace SinticBolivia.Reports
{
	public class PdfRow : Object
	{
		protected	ArrayList<PdfCell> 		cells;
		public		PdfTable				Table;
		public		float					Width;
		public		float					Height;
		public		float					X;
		public		float					Y;
		public		float					SourceX;
		public		float					SourceY;
		public		int						NumCells = 0;
		public		float[]					ColumnsWidth;
		public		int						Size
		{
			get{return this.cells.size;}
		}
		public PdfRow()
		{
			this.cells = new ArrayList<PdfCell>();
			this.Width = 0;
			this.Height = 0;
		}
		public PdfRow.with_table(PdfTable table)
		{
			this();
			this.Table 	= table;
			this.Width	= this.Table.Width;
			
		}
		public PdfCell? AddCell()
		{
			int cells_length = 0;
			foreach(var cell in this.cells)
			{
				cells_length += cell.Span;
			}
			if( cells_length >= this.NumCells )
			{
				return null;
			}
			
			int index = (this.cells.size <= 0) ? 0 : cells_length;
			
			var cell 		= new PdfCell.with_row(this);
			cell.Index		= index;
			cell.Width		= this.ColumnsWidth[index];
			cell.SourceX 	= this.SourceX;
			cell.SourceY 	= this.SourceY;
			
			if( index > 0 )
			{
				//for(int i = 0; i < index; i++)
				
				foreach(var _cell in this.cells)
				{
					//cell.SourceX += this.ColumnsWidth[i];
					cell.SourceX 	+= _cell.Width;
					//cell.Width		= _cell.Width;
				}
			}
			this.cells.add(cell);
						
			return cell;
		}
		public void SetXY(float x, float y)
		{
			this.SourceX = x;
			this.SourceY = y;
			foreach(var cell in this.cells)
			{
				/*
				if( cell.Index > 0 )
					cell.SourceX 	+= _cell.Width;
				*/
				cell.SourceY = this.SourceY;
			}
		}
		public void calculateRowSize()
		{
			foreach(var cell in this.cells)
			{
				if( cell.Height > this.Height )
					this.Height = cell.Height;
				//this.Width += cell.Width;
			}
		}
		public void Draw()
		{
			/*
			stdout.printf("Row Total cells: %d\n", this.cells.size);
			this.Table.PdfPage.SetFontAndSize(this.Table.Font, 5);
			this.Table.PdfPage.BeginText();
			this.Table.PdfPage.TextOut(this.SourceX, this.SourceY, "(%.2f,%.2f)".printf(this.SourceX, this.SourceY));
			this.Table.PdfPage.EndText();
			*/
			
			this.Table.PdfPage.SetFontAndSize(this.Table.Font, this.Table.PdfPage.GetCurrentFontSize());
			this.calculateRowSize();
			
			//##draw row border
			//this.Table.PdfPage.SetLineWidth(0.3f);
			//this.Table.PdfPage.Rectangle(this.SourceX, this.SourceY - this.Height, this.Width, this.Height);
			//this.Table.PdfPage.Stroke();
			
			foreach(var cell in this.cells)
			{
				cell.Height = this.Height;
				cell.Draw();
			}
			//this.Table.PdfCatalog.YPos -= this.Height;
			this.Table.Report.YPos -= this.Height;
		}
	}
}
