using Gee;
using SinticBolivia;
using SinticBolivia.Classes;

namespace SinticBolivia.Database
{
    public class SBDBQuery : SBObject
    {
        public delegate void WhereCallback(SBDBQuery qb);

        protected   ArrayList<string>   _select;
        protected   ArrayList<string>   _from;
        protected   ArrayList<string>   _joins;
        protected   ArrayList<string>   _left_joins;
        protected   ArrayList<string>   _right_joins;
        protected   ArrayList<string>   _where;
        protected   ArrayList<string>   _orderby;
        protected   string              _limit;
        protected   ArrayList<string>   _having;
        protected   string              _group_by;

        public SBDBQuery()
        {
            this._select        = new ArrayList<string>();
            this._from          = new ArrayList<string>();
            this._joins         = new ArrayList<string>();
            this._left_joins    = new ArrayList<string>();
            this._right_joins   = new ArrayList<string>();
            this._where         = new ArrayList<string>();
            this._having        = new ArrayList<string>();
            this._orderby       = new ArrayList<string>();
        }
        public SBDBQuery select(string columns)
        {
            var dbh = SBFactory.getDbh();
            if( columns.index_of(",") != -1 )
            {
                return this.select_columns(columns.split(","));
            }
            this._select.add(dbh.prepare_column(columns));
            return this;
        }
        public SBDBQuery select_columns(string[] columns)
        {
            var dbh = SBFactory.getDbh();
            foreach(string col in columns)
            {
                this._select.add(dbh.prepare_column(col));
            }
            return this;
        }
        public SBDBQuery from(string table)
        {
            this._from.add(table);
            return this;
        }
        public SBDBQuery join(string table, string col1, string col2)
        {
            var dbh = SBFactory.getDbh();
            string join = "JOIN %s ON %s = %s".printf(
                table,
                dbh.prepare_column(col1),
                dbh.prepare_column(col2)
            );
            this._joins.add(join);
            return this;
        }
        public SBDBQuery left_join(string table, string col1, string col2)
        {
            var dbh = SBFactory.getDbh();
            string join = "LEFT JOIN %s ON %s = %s".printf(
                table,
                dbh.prepare_column(col1),
                dbh.prepare_column(col2)
            );
            this._joins.add(join);
            return this;
        }
        public SBDBQuery right_join(string table, string col1, string col2)
        {
            var dbh = SBFactory.getDbh();
            string join = "RIGHT JOIN %s ON %s = %s".printf(
                table,
                dbh.prepare_column(col1),
                dbh.prepare_column(col2)
            );
            this._joins.add(join);
            return this;
        }
        public SBDBQuery where(string? col1 = null, string? cond = null, Value? col2 = null)
        {
            if( col1 == null && cond == null )
                return this;

            var dbh = SBFactory.getDbh();
            string join = "%s %s %s".printf(
                dbh.prepare_column(col1),
                cond,
                dbh.prepare_column_value(col2)
            );
            this._where.add(join);
            return this;
        }
        public SBDBQuery equals(string column, Value? val)
        {
            this.where(column, "=", val);
            return this;
        }
        public SBDBQuery greater_than(string column, Value? val)
        {
            this.where(column, ">", val);
            return this;
        }
        /**
        * Query condition for greater than or equals (>=)
        * @param string column The column name
        * @param mixed the column value
        * @return SBDBQuery
        */
        public SBDBQuery greater_than_or_equals(string column, Value? val)
        {
            this.where(column, ">=", val);
            return this;
        }
        /**
        * Alias for greater_than_or_equals
        */
        public SBDBQuery gte(string column, Value? val)
        {
            return this.greater_than_or_equals(column, val);
        }
        public SBDBQuery less_than(string column, Value? val)
        {
            this.where(column, "<", val);
            return this;
        }
        public SBDBQuery less_than_or_equals(string column, Value? val)
        {
            this.where(column, "<=", val);
            return this;
        }
        public SBDBQuery lte(string column, Value? val)
        {
            return this.less_than_or_equals(column, val);
        }
        public SBDBQuery like(string column, Value? val)
        {
            var dbh = SBFactory.getDbh();
            string str = "%s LIKE %s".printf(column, dbh.prepare_column_value(val));
            this._where.add(str);
            return this;
        }
        public SBDBQuery not_like(string column, Value? val)
        {
            var dbh = SBFactory.getDbh();
            string str = "%s NOT LIKE %s".printf(column, dbh.prepare_column_value(val));
            this._where.add(str);
            return this;
        }
        public SBDBQuery ilike(string column, Value? val)
        {
            var dbh = SBFactory.getDbh();
            string str = "%s ILIKE %s".printf(column, dbh.prepare_column_value(val));
            this._where.add(str);
            return this;
        }
        public SBDBQuery not_ilike(string column, Value? val)
        {
            var dbh = SBFactory.getDbh();
            string str = "%s NOT ILIKE %s".printf(column, dbh.prepare_column_value(val));
            this._where.add(str);
            return this;
        }
        public SBDBQuery in(string column, string vals)
        {
            var dbh = SBFactory.getDbh();
            string str = "%s IN(%s)".printf(
                dbh.prepare_column(column),
                vals
            );
            this._where.add(str);
            return this;
        }
        public SBDBQuery in_array(string column, string[] vals)
        {
            this.in(column, string.joinv(",", vals));
            return this;
        }
        public SBDBQuery is_null(string column)
        {
            var dbh = SBFactory.getDbh();
            this._where.add("%s IS NULL".printf(dbh.prepare_column(column)));
            return this;
        }
        public SBDBQuery is_not_null(string column)
        {
            var dbh = SBFactory.getDbh();
            this._where.add("%s IS NOT NULL".printf(dbh.prepare_column(column)));
            return this;
        }
        public SBDBQuery where_group(WhereCallback callback)
        {
            this._where.add("(");
            callback(this);
            this._where.add(")");
            return this;
        }
        public SBDBQuery and()
        {
            this._where.add("AND");
            return this;
        }
        public SBDBQuery or()
        {
            this._where.add("OR");
            return this;
        }
        public SBDBQuery group_by(string stmt)
        {
            this._group_by = stmt;
            return this;
        }
        public SBDBQuery order_by(string column, string order = "DESC")
        {
            this._orderby.add("%s %s".printf(column, order));
            return this;
        }
        public virtual SBDBQuery limit(int limit, int offset = 0)
        {
            var dbh = SBFactory.getDbh();
            if( dbh.Engine == "postgres" )
                this._limit = "LIMIT %d OFFSET %d".printf(limit, offset);
            else
                this._limit = "LIMIT %d,%d".printf(offset, limit);
            return this;
        }
        public virtual bool has_limit(){ return this._limit.strip().length > 0;}
        public virtual SBDBQuery having()
        {
            return this;
        }
        public virtual string sql() throws SBException
        {
            if( this._select.size <= 0 )
                throw new SBException.GENERAL("Invalid SELECT columns, unable to build query");
            if( this._from.size <= 0 )
                throw new SBException.GENERAL("Invalid SELECT tables, unable to build query");
            string dml = "SELECT %s FROM %s".printf(
                string.joinv(",", this._select.to_array()),
                string.joinv(",", this._from.to_array())
            );

            if( this._joins.size > 0 )
            {
                dml += " " + string.joinv(" ", this._joins.to_array());
            }
            if( this._where.size > 0 )
            {
                dml += " WHERE " + string.joinv(" ", this._where.to_array());
            }
            if(  this._group_by != null && this._group_by.strip().length > 0 )
            {
                dml += " GROUP BY %s".printf(this._group_by);
            }
            if( this._orderby.size > 0 )
            {
                dml += " ORDER BY " + string.joinv(", ", this._orderby.to_array());
            }
            if( this._limit != null && this._limit.strip().length > 0 )
            {
                dml += " %s".printf(this._limit);
            }
            return dml;
        }
        public virtual SBCollection<T> get<T>()
        {
            var dummy = (Entity)Object.new(typeof(T));
            if( this._select.size <= 0 )
                this.select_columns(dummy.get_columns());
            if( this._from.size <= 0 )
                this.from(dummy.get_table());

            var dbh = SBFactory.getDbh();
            string sql = this.sql();
            message(sql);
            var items = dbh.getObjects<T>(sql);
            var collection = new SBCollection<T>();
            collection.items = items;
            return collection;
            //return new SBCollection<T>.from_array(items.to_array());
        }
        public virtual T first<T>()
        {
            var dummy = (Entity)Object.new(typeof(T));
            if( this._select.size <= 0 )
                this.select_columns(dummy.get_columns());
            if( this._from.size <= 0 )
                this.from(dummy.get_table());
            var dbh = SBFactory.getDbh();
            this.limit(1);
            string sql = this.sql();
            var obj = dbh.getObject<T>(sql);
            return obj;
        }
    }
}
