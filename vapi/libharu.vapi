[CCode(cheader_filename="hpdf.h", cprefix="HPDF_")]
namespace HPDF
{
	[SimpleType]
	[CCode(cname="HPDF_STATUS", has_type_id = false)]
    public struct Status : ulong {}
	[SimpleType]
    [CCode(cname="HPDF_REAL", has_type_id = false)]
    public struct Real : float {}
	/** Types **/
	[CCode (cname = "HPDF_Point")]
	public struct Point
	{
		public float x;
		public float y;
	}

    [CCode(cname="HPDF_Error_Handler", instance_pos = -1)]
    public delegate void ErrorHandler (Status error_no, Status detail_no);

    [Compact]
    [CCode(free_function="HPDF_Free", cname="HPDF_Doc")]
    public class Doc
    {
        [CCode(cname="HPDF_New", instance_pos = -1)]
        public Doc (ErrorHandler error_handler);

        [CCode(cname="HPDF_AddPage")]
        public unowned Page AddPage();

        [CCode(cname="HPDF_GetFont")]
        public unowned Font GetFont(string name, string? encoding = null);

        [CCode(cname="HPDF_SaveToFile")]
        public Status SaveToFile (string file);


        [CCode(cname="HPDF_LoadPngImageFromMem")]
        public Image LoadPngImageFromMem(uint8[] buffer, uint length);

        [CCode(cname="HPDF_LoadPngImageFromFile")]
        public Image LoadPngImageFromFile(string filename);

        [CCode(cname="HPDF_LoadJpegImageFromMem")]
        public Image LoadJpegImageFromMem(uint8[] buffer, uint length);

        [CCode(cname="HPDF_LoadJpegImageFromFile")]
        public Image LoadJpegImageFromFile(string filename);
    }

    [Compact]
    [CCode(cname="HPDF_Page")]
    public class Page
    {
        [CCode(cname="HPDF_Page_SetFontAndSize")]
        public Status SetFontAndSize(Font font, float size);

        [CCode(cname="HPDF_Page_BeginText")]
        public Status BeginText();

        [CCode(cname="HPDF_Page_EndText")]
        public Status EndText();

        [CCode(cname="HPDF_Page_TextOut")]
        public Status TextOut(Real x, Real y, string chars);

		[CCode (cname = "HPDF_Page_MoveTextPos")]
		public Status MoveTextPos(Real x, Real y);

		[CCode (cname = "HPDF_Page_ShowText")]
		public Status ShowText(string text);

		[CCode (cname = "HPDF_Page_ShowTextNextLine")]
		public Status ShowTextNextLine(string text);

		[CCode (cname = "HPDF_Page_TextWidth")]
		public Real TextWidth(string text);

		[CCode (cname = "HPDF_Page_MeasureText")]
		public uint MeasureText(string text, Real width, bool wordwrap, out float real_width);

		[CCode (cname = "HPDF_Page_GetCurrentTextPos")]
		public Point GetCurrentTextPos();

		[CCode (cname = "HPDF_Page_GetCurrentFont")]
		public Font GetCurrentFont();
		[CCode (cname = "HPDF_Page_GetCurrentFontSize")]
		public float GetCurrentFontSize();

        [CCode(cname="HPDF_Page_SetCharSpace")]
        public Status SetCharSpace(Real val);

        [CCode(cname="HPDF_Page_SetWordSpace")]
        public Status SetWordSpace(Real val);

        [CCode(cname="HPDF_Page_SetWidth")]
        public Status SetWidth(Real val);

        [CCode(cname="HPDF_Page_SetHeight")]
        public Status SetHeight(Real val);

        [CCode(cname="HPDF_Page_GetWidth")]
        public Status GetWidth();

        [CCode(cname="HPDF_Page_GetHeight")]
        public Status GetHeight();

        [CCode (cname = "HPDF_Page_GetCurrentPos")]
        public Point GetCurrentPos();

        //[CCode(cname="HPDF_Page_SetSize")]
        //public Status SetSize(Real val);
        [CCode (cname = "HPDF_Page_SetLineWidth")]
        public Status SetLineWidth(Real line_width);

        /** path construction operator **/
        [CCode (cname = "HPDF_Page_MoveTo")]
        public Status MoveTo(Real x, Real y);
        [CCode (cname = "HPDF_Page_LineTo")]
        public Status LineTo(Real x, Real y);
        [CCode (cname = "HPDF_Page_Rectangle")]
        public Status Rectangle(Real x, Real y, Real width, Real height);

        /** path painting operator **/
        [CCode (cname = "HPDF_Page_Stroke")]
        public Status Stroke();
        [CCode (cname = "HPDF_Page_Fill")]
        public Status Fill();
        [CCode (cname = "HPDF_Page_FillStroke")]
        public Status FillStroke();

        [CCode (cname = "HPDF_Page_DrawImage")]
        public ulong DrawImage(Image image, float x, float y, float width, float height);

        /** Color Showing **/
        [CCode (cname = "HPDF_Page_SetGrayFill")]
        public Status SetGrayFill(float real);
        [CCode (cname = "HPDF_Page_SetGrayStroke")]
        public Status SetGrayStroke(float real);
        [CCode (cname = "HPDF_Page_SetRGBFill")]
        public Status SetRGBFill(float r, float g, float b);
        [CCode (cname = "HPDF_Page_SetRGBStroke")]
        public Status SetRGBStroke(float r, float g, float b);

        /** Destination **/
        [CCode (cname = "HPDF_Page_CreateDestination")]
        public Destination CreateDestination();
    }

    [Compact]
    [CCode(cname="HPDF_Font")]
    public class Font
    {
    }
    [CCode (cname = "HPDF_Image", destroy_function = "", unref_function = "")]
    public class Image
    {
		[CCode (cname = "HPDF_Image_GetSize")]
		public Point GetSize();
		[CCode (cname = "HPDF_Image_GetWidth")]
		public uint GetWidth();
		[CCode (cname = "HPDF_Image_GetHeight")]
		public uint GetHeight();
		[CCode (cname = "HPDF_Image_GetBitsPerComponent")]
		public uint GetBitsPerComponent();
		[CCode (cname = "HPDF_Image_SetMaskImage")]
		public ulong SetMaskImage(Image mask_image);
	}
    [CCode (cname = "HPDF_Outline")]
    public class Outline
    {
		[CCode (cname = "HPDF_Outline_New")]
		public Outline();
	}
	[CCode (cname = "HPDF_Encoder")]
    public class Encoder
    {
	}
	[CCode (cname = "HPDF_Destination", destroy_function = "", unref_function = "")]
	public class Destination
	{
		[CCode(cname="HPDF_Destination_New"/*, instance_pos = -1*/)]
		public Destination();
		[CCode (cname = "HPDF_Destination_Validate")]
		public bool Validate();
		[CCode (cname = "HPDF_Destination_SetXYZ")]
		public Status SetXYZ(float left, float top, float zoom);
	}
    /** Other functions Section **/
    [CCode (cname = "HPDF_CreateOutline")]
    public Outline CreateOutline(Doc pdf, Outline parent, string title, Encoder encoder);

    [CCode (cname = "HPDF_LoadJpegImageFromFile")]
    public Image LoadJpegImageFromFile(Doc pdf, string filename);
}
