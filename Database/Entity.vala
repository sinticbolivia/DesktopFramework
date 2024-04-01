using Gee;
using SinticBolivia;
using SinticBolivia.Classes;

namespace SinticBolivia.Database
{
    public abstract class Entity : SBSerializable
    {
        protected   string      _table;
        protected   string      _table_alias;
        protected   string      _primary_key;
        protected   HashMap     _meta_data;
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
        public void save()
        {
            Value? pk_value = this.getPropertyValue(this._primary_key);
            if( pk_value == null || (pk_value.type() == typeof(long) && pk_value.get_long() <= 0) )
            {
                this.create();
                return;
            }
            this.update();

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
    }
}
