using GLib;
using Gee;
using SinticBolivia;
using HPDF;

namespace SinticBolivia.Reports
{	
	public class PdfReport : Object
	{
		public 	string 		Title;
		public 	float		XPos;
		public 	float		YPos;
		public	string		FontType = "Helvetica";
		public	float		FontSize = 12;
		public	float[]		ColumnsWidth;
		
		public	float		TopMargin;
		public	float		RightMargin;
		public	float		BottomMargin;
		public	float		LeftMargin;
		
		public		HPDF.Doc			pdf;
		public 		unowned HPDF.Page	page;
		public	 	unowned HPDF.Font	font;
		protected	float pageWidth;
		protected	float pageHeight;
		public		float pageAvailableSpace;
		
		//protected	int		currentRow = 0;
		protected	int		totalCols = 0;
		protected	float	rowHeight = 0;
		//protected	ArrayList<PdfRow>	rows;
		
		
		public PdfReport()
		{
			//##set margings
			this.TopMargin 	= this.RightMargin = this.BottomMargin = 40;
			this.LeftMargin = 40;
			
			this.pdf		= new HPDF.Doc((error_no, detail_no) => 
			{
				stderr.printf("Error %04X - detail %d\n", (uint)error_no, (int)detail_no);
			});
			this.page				= this.pdf.AddPage();
			//##create font
			this.font 				= this.pdf.GetFont(this.FontType);
			//##set page default font and size
			this.page.SetFontAndSize(this.font, this.FontSize);
			this.pageWidth			= this.page.GetWidth();
			this.pageHeight			= this.page.GetHeight();
			this.pageAvailableSpace	= this.pageWidth - this.LeftMargin - this.RightMargin;
			//initialize coordinates
			this.XPos 	= this.LeftMargin;
			this.YPos	= this.pageHeight - this.TopMargin;
		}
		public void SetMargins(float top, float right, float bottom, float left)
		{
			this.TopMargin 		= top;
			this.RightMargin 	= right;
			this.BottomMargin 	= bottom;
			this.LeftMargin 	= left;
			//initialize coordinates
			this.XPos 	= this.LeftMargin;
			this.YPos	= this.pageHeight - this.TopMargin;
		}
		public void WriteText(string text, string align = "left", float font_size = -1, string? color = null)
		{
			this.page.SetFontAndSize(this.font, (font_size > 0 ) ? font_size : this.FontSize);
			this.CheckNewPage(font_size);
			
			this.page.BeginText();
			
			if( align == "left" )
				this.page.TextOut(this.LeftMargin, this.YPos, text);
			if( align == "center" )
				this.page.TextOut((this.pageWidth - this.page.TextWidth(text)) / 2, this.YPos, text);
			if( align == "right" )
				this.page.TextOut((this.pageWidth - this.page.TextWidth(text)) / 2, this.YPos, text);
				
			this.page.EndText();
			
			this.YPos -= font_size + 10;
			this.XPos = this.LeftMargin;
			this.page.SetFontAndSize(this.font, this.FontSize);
		}
		
		public void Draw()
		{
			//float page_height = this.pageHeight - this.TopMargin - this.BottomMargin;
			//stdout.printf("page_height: %f\n", page_height);
			//stdout.printf("rows: %d, cols: %d\n", this.rows.size, this.totalCols);
			//stdout.printf("starting table at (%fx%f)\n\n", this.XPos, this.YPos);
			
		}
		public bool CheckNewPage(float obj_height)
		{
			float page_height = this.pageHeight - this.TopMargin - this.BottomMargin;
			stdout.printf("total_page_height => %f, page_height => %f, y => %f, obj_height => %f\n", 
							this.pageHeight, page_height, this.YPos, obj_height);
			if( this.YPos < obj_height )
			{
				stdout.printf("adding new page\n");
				this.page 	= this.pdf.AddPage();
				//##set page default font and size
				this.page.SetFontAndSize(this.font, this.FontSize);
				//this.pageWidth			= this.page.GetWidth();
				//this.pageHeight			= this.page.GetHeight();
				//this.pageAvailableSpace	= this.pageWidth - this.LeftMargin - this.RightMargin;
				var dst 	= this.page.CreateDestination();
				dst.SetXYZ(0, this.pageHeight, 1);
				this.YPos = this.pageHeight - this.TopMargin;
				this.XPos = this.LeftMargin;
				return true;
			}
			
			return false;
		}
		public string Save(string name = "catalog")
		{
			if( !FileUtils.test("temp", FileTest.IS_DIR) )
			{
				//create temp dir
				DirUtils.create("temp", 0744);
			}
			string filename = "%s-%s.pdf".printf(name, new DateTime.now_local().format("%Y-%m-%d"));
			//string pdf_path = SBFileHelper.SanitizePath("temp/%s".printf(filename));
			string pdf_path = "temp/%s".printf(filename);
			this.pdf.SaveToFile(pdf_path);
			
			return pdf_path;
		}
		public void Preview(string name = "catalog")
		{
			string pdf_path = this.Save(name);
			string command = "";
			//stdout.printf("OS: %s\n", SBOS.GetOS().OS);
			if( SBOS.GetOS().IsLinux() )
			{
				if( Environment.find_program_in_path("evince") != null )
				{
					command = "evince --preview %s".printf(pdf_path);
				}
				else if( Environment.find_program_in_path("atril") != null )
				{
					command = "atril --preview %s".printf(pdf_path);
				}
				else
				{
					command = "xdg-open %s".printf(pdf_path);
				}
			}
			else if( SBOS.GetOS().IsWindows() )
			{
				//command = SBFileHelper.SanitizePath("./bin/SumatraPDF.exe %s".printf(pdf_path));
				command = "bin/SumatraPDF.exe %s".printf(pdf_path);
			}	
			
			try
			{
				Process.spawn_command_line_async(command);
				//Posix.system(command);
			}
			catch(SpawnError e)
			{
				stderr.printf("ERROR: %s\nCOMMAND: %s\nCURRENT DIR:%s\n", e.message, command, Environment.get_current_dir());
			}
		}
		public void Print(string name = "catalog", string printer = "")
		{
			string pdf_path = this.Save(name);
			string cmd = "";
			if( SBOS.GetOS().IsWindows() )
			{
				cmd = SBFileHelper.SanitizePath("bin/SumatraPDF.exe %s -print-to %s -silent -exit-on-print".printf(pdf_path, printer));
			}
			else if( SBOS.GetOS().IsLinux() )
			{
				cmd = "evince --preview %s".printf(pdf_path);
			}
			//Posix.system(cmd);
			Process.spawn_command_line_async(cmd);
		}
	}
}
