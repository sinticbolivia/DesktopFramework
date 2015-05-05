/* SinticBoliviaReports.vapi generated by valac 0.24.0, do not modify. */

namespace SinticBolivia {
	namespace Reports {
		[CCode (cheader_filename = "SinticBoliviaReports.h")]
		public class PdfCell : GLib.Object {
			public string Align;
			public bool BottomBorder;
			public weak HPDF.Font Font;
			public string FontFamily;
			public float FontSize;
			public float Height;
			public int Index;
			public bool LeftBorder;
			public float Padding;
			public bool RightBorder;
			public SinticBolivia.Reports.PdfRow Row;
			public float SourceX;
			public float SourceY;
			public int Span;
			public bool TopBorder;
			public float Width;
			protected HPDF.Image image;
			protected Gee.ArrayList<string> lines;
			protected string text;
			public PdfCell ();
			public Gee.ArrayList<string> BuildCellText (float font_size, string text);
			public void Draw ();
			public void SetImage (HPDF.Image? image);
			public void SetText (string text);
			public PdfCell.with_row (SinticBolivia.Reports.PdfRow row);
			public bool Border { set; }
		}
		[CCode (cheader_filename = "SinticBoliviaReports.h")]
		public class PdfReport : GLib.Object {
			public float BottomMargin;
			public float[] ColumnsWidth;
			public float FontSize;
			public string FontType;
			public float LeftMargin;
			public float RightMargin;
			public string Title;
			public float TopMargin;
			public float XPos;
			public float YPos;
			public weak HPDF.Font font;
			public weak HPDF.Page page;
			public float pageAvailableSpace;
			protected float pageHeight;
			protected float pageWidth;
			public HPDF.Doc pdf;
			protected float rowHeight;
			protected int totalCols;
			public PdfReport ();
			public bool CheckNewPage (float obj_height);
			public void Draw ();
			public void Preview (string name = "catalog");
			public void Print (string name = "catalog", string printer = "");
			public string Save (string name = "catalog");
			public void SetMargins (float top, float right, float bottom, float left);
			public void WriteText (string text, string align = "left", float font_size = -1, string? color = null);
		}
		[CCode (cheader_filename = "SinticBoliviaReports.h")]
		public class PdfRow : GLib.Object {
			public float[] ColumnsWidth;
			public float Height;
			public int NumCells;
			public float SourceX;
			public float SourceY;
			public SinticBolivia.Reports.PdfTable Table;
			public float Width;
			public float X;
			public float Y;
			protected Gee.ArrayList<SinticBolivia.Reports.PdfCell> cells;
			public PdfRow ();
			public SinticBolivia.Reports.PdfCell? AddCell ();
			public void Draw ();
			public void SetXY (float x, float y);
			public void calculateRowSize ();
			public PdfRow.with_table (SinticBolivia.Reports.PdfTable table);
			public int Size { get; }
		}
		[CCode (cheader_filename = "SinticBoliviaReports.h")]
		public class PdfTable : GLib.Object {
			public float[] ColumnsWidth;
			public weak HPDF.Doc Doc;
			public weak HPDF.Font Font;
			public string[] Headers;
			public float Height;
			public weak HPDF.Page PdfPage;
			public SinticBolivia.Reports.PdfReport Report;
			public float SourceX;
			public float SourceY;
			public float Width;
			public float X;
			public float Y;
			protected int currentCell;
			protected SinticBolivia.Reports.PdfRow? currentRow;
			protected Gee.ArrayList<SinticBolivia.Reports.PdfRow> rows;
			protected int totalCols;
			public PdfTable (HPDF.Doc doc, HPDF.Page page, HPDF.Font font, float width, float source_x, float source_y);
			public SinticBolivia.Reports.PdfCell? AddCell ();
			public SinticBolivia.Reports.PdfRow AddRow ();
			public void AddTextCell (string text, string align = "left", float font_size = 12, bool border = true, int span = 1, string? bg = null, string? fg = null);
			public void Draw ();
			public void SetColumnsWidth (float[] widths);
			public void SetTableHeaders (string[] headers);
		}
	}
}