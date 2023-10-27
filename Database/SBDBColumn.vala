namespace SinticBolivia.Database
{
	public class SBDBColumn
	{
		public 	string 		name;
		public 	string? 	comments;
		public	int			db_type;
		public	CellType	type;
		public	string		type_name
		{
			owned get{ return get_cell_type_name(this.type); }
		}
		public	bool 		is_key = false;
		public	bool		is_null = false;
		public	string		default_val = null;
		public	bool		is_auto_increment = false;
		
		public SBDBColumn()
		{
		}
	}
}
