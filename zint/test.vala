using GLib;
using Zint;

public class TestZint : Object
{
	public static int main(string[] args)
	{
		int error_number = 0;
		int rotate_angle = 0;
		string barcode_text = "123343343492";
		Symbol my_symbol 		= new Symbol();
		my_symbol.input_mode 	= Barcode.UNICODE_MODE;
		my_symbol.outfile 		= "testv.png".to_utf8();
		error_number 			= my_symbol.Encode(barcode_text, barcode_text.length);
		error_number 			= my_symbol.Print(rotate_angle);
		
		return 0;
	}
}
