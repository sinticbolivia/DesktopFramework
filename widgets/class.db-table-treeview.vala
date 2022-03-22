//using GLib;
using Gee;
using Gtk;
using SinticBolivia;
using SinticBolivia.Database;

namespace SinticBolivia.GtkWidgets
{
	public class DbTableTreeView : TreeView
	{
		protected	SBDatabase		dbh;
		protected	string			dbTable;
		protected	string[]		tableColumns;
		protected	string[]		treeviewColumns;
		protected	string			query;
		
		public DbTableTreeView(string db_table, string[] cols, SBDatabase _dbh)
		{
			this.dbTable = db_table;
			this.dbh = _dbh;
			this.ParseColumns(cols);
			this.BuildQuery();
			this.Build();
		}
		protected void ParseColumns(string[] cols)
		{
			this.tableColumns 		= new string[cols.length];
			this.treeviewColumns	= new string[cols.length];
			
			for(int i = 0; i < cols.length; i++)
			{
				string[] parts = cols[i].split("=>");
				this.tableColumns[i] = parts[0].strip();
				this.treeviewColumns[i] = ( parts[1] != null ) ? parts[1].strip() : parts[0].strip();
			}
		}
		protected void BuildQuery()
		{
			/*
			this.dbh.Select(string.joinv(",", this.tableColumns)).
				From(this.dbTable);
			*/
			this.query = "SELECT " + this.dbh.FormatColumns(string.joinv(",", this.tableColumns)) + 
						 " FROM " + this.dbTable;
		}
		protected void Build()
		{
			Type[] types = new Type[this.treeviewColumns.length];
			for(int i = 0; i < this.treeviewColumns.length; i++)
			{
				types[i] = typeof(string);
			}
			this.model = new global::Gtk.ListStore(this.treeviewColumns.length);
			
			(this.model as global::Gtk.ListStore).set_column_types(types);
			//GtkHelper.BuildTreeViewColumns(this.treeviewColumns);
			for(int i = 0; i < this.treeviewColumns.length; i++)
			{
				var cell = new CellRendererText();
				this.insert_column_with_attributes(i, this.treeviewColumns[i], cell, "text", i);
			}
			
		}
		public void Bind()
		{
			(this.model as global::Gtk.ListStore).clear();
			TreeIter iter;
			var rows = this.dbh.GetResults(this.query);
			foreach(var row in rows)
			{
				(this.model as global::Gtk.ListStore).append(out iter);
				for(int i = 0; i < this.tableColumns.length; i++)
				{
					(this.model as global::Gtk.ListStore).set(iter,
						i, row.Get(this.tableColumns[i])
					);
				}
				
			}
		}
	}
}
