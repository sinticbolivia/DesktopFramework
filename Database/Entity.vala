using Gee;
using SinticBolivia;
using SinticBolivia.Classes;

namespace SinticBolivia.Database
{
    public abstract class Entity : SBSerializable
    {
        public      delegate void AfterSaveCallback(Entity obj);

        protected   string      _table;
        protected   string      _table_alias;
        protected   string      _primary_key;
        protected   HashMap     _meta_data;
        protected   AfterSaveCallback   _after_save_callback;

        //inherit this common properties for each entity
        public SBDateTime       last_modification_date {get;set;}
        public SBDateTime       creation_date {get;set;}

        construct
        {
            this._meta_data = new HashMap<string, Value?>();
            //this.setPropertyValue(this._primary_key, 0);
        }
        public string get_table(){return this._table;}
        public string get_primary_key(){return this._primary_key;}
        public Value? get_primary_key_value()
        {
            Value? val = this.getPropertyValue(this._primary_key);
            return val;
        }
        public string[] get_columns(string? table_alias = null)
        {
            var columns = new ArrayList<string>();
            foreach(ParamSpec prop in this.getProperties())
			{
                string column_name = prop.name.replace("-", "_");
                columns.add(table_alias != null ? "%s.%s".printf(table_alias, column_name) : column_name);
            }
            return columns.to_array();
        }
        public void set_after_save_callback(AfterSaveCallback callback)
        {
            this._after_save_callback = callback;
        }
        public void save()
        {
            Value? pk_value = this.getPropertyValue(this._primary_key);
            if( pk_value == null || (pk_value.type() == typeof(long) && pk_value.get_long() <= 0) )
                this.create();
            else
                this.update();
            if( this._after_save_callback != null )
                this._after_save_callback(this);
        }
        public void create()
        {
            var dbh = SBFactory.getDbh();
            this.last_modification_date = new SBDateTime();
            this.creation_date = new SBDateTime();
            long id = dbh.insertObject(this._table, this);
            this.setPropertyGValue(this._primary_key, id);
        }
        public void update()
        {
            var dbh = SBFactory.getDbh();
            this.last_modification_date = new SBDateTime();
            dbh.updateObject(this._table, this);
        }
        public virtual bool delete(bool logic = false)
        {
            //long id = (long)this.get_primary_key_value();
            var data = new HashMap<string, Value?>();
            data.set(this._primary_key, this.get_primary_key_value());
            var dbh = SBFactory.getDbh();
            dbh.Delete(this._table, data);
            return true;
        }
        protected virtual SBHasMany has_many<T>(string foreign_key, string source_key)
        {
            var has_many = SBHasMany.instance<T>(this, foreign_key, source_key);
            return has_many;
        }
        protected virtual SBHasOne has_one<T>(string foreign_key, string source_key)
        {
            var hasone = SBHasOne.instance<T>(this, foreign_key, source_key);
            return hasone;
        }
        public virtual SBBelongsTo<T> belongs_to<T>(string foreign_key, string source_key)
        {
            var relationship = SBBelongsTo.instance<T>(this, foreign_key, source_key);
            return relationship;
        }
        public static T read<T>(long id) throws SBDatabaseException
        {
            //stdout.printf("Type: %s\n", typeof(T).name());
            T dummy = (T)Object.new(typeof(T));
            //stdout.printf((dummy as Entity).get_table());
            string query = "SELECT %s FROM %s WHERE %s = %ld LIMIT 1".printf(
                string.joinv(",", (dummy as Entity).get_columns()),
                (dummy as Entity).get_table(),
                (dummy as Entity).get_primary_key(),
                id
            );
            //stdout.printf(query);
            //
            var dbh = SBFactory.getDbh();
            var obj = dbh.getObject<T>(query);
            return obj;
        }
        public static ArrayList<T> all<T>(int limit = 25)
        {
            var dummy = (Entity)Object.new(typeof(T));
            var builder = new SBDBQuery();
            builder.select_columns(dummy.get_columns())
                .from(dummy.get_table())
                .where()
                .limit(limit)
                .order_by("creation_date", "DESC");
            var dbh = SBFactory.getDbh();
            var items = dbh.getObjects<T>(builder.sql());
            return items;
        }
        public static SBDBQuery where(string column, string operator, Value? val)
        {
            //var dummy = (Entity)Object.new(typeof(T));
            var builder = new SBDBQuery();
            builder
                //.select_columns(dummy.get_columns())
                //.from("{table}"})
                .where(column, operator, val)
            ;
            return builder;
        }
        public static SBDBQuery like(string column, string val)
        {
            var builder = new SBDBQuery();
            builder.like(column, val);
            return builder;
        }
        public static SBDBQuery ilike(string column, string val)
        {
            var builder = new SBDBQuery();
            builder.ilike(column, val);
            return builder;
        }
        public static SBDBQuery limit(int limit, int offset = 0)
        {
            //var dummy = (Entity)Object.new(typeof(T));
            var builder = new SBDBQuery();
            builder
                //.select_columns(dummy.get_columns())
                //.from(dummy.get_table())
                .limit(limit, offset)
            ;
            return builder;
        }
    }
}
