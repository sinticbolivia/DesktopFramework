using Gee;
using SinticBolivia;
using SinticBolivia.Classes;

namespace SinticBolivia.Database
{
    public class SBHasMany<D> : SBObject
    {
        protected   string          _foreign_key;
        protected   string          _source_key;
        protected   Entity          _object;
        protected   ArrayList<D>    _to_attach;
        public      int             per_page = 20;
        public      SBDBQuery       builder;

        construct
        {
            this.builder = new SBDBQuery();
            this._to_attach = new ArrayList<D>();
        }
        public SBHasMany(string foreign_key, string source_key)
        {
            this._foreign_key   = foreign_key;
            this._source_key    = source_key;
        }
        public SBCollection<D> get()
        {
            var obj = (Entity)Object.new(typeof(D));
            //this.builder
                //.select_columns(obj.get_columns("dt"))
                //.from(obj.get_table() + " dt")
                //.join("%s mt".printf(master.get_table()), "mt.%s".printf(this._source_key), "dt.%s".printf(this._foreign_key))
                //.where()
                //    .equals("mt." + this._foreign_key, master.get_primary_key_value())
            //;
            if( !this.builder.has_limit() )
                this.builder.limit(this.per_page);

            debug(this.builder.sql());
            var items = this.builder.get<D>();
            return items;
        }
        public D first()
        {
            var obj = (Entity)Object.new(typeof(D));
            this.builder
                //.select_columns(obj.get_columns("dt"))
                //.from(obj.get_table() + " dt")
                //.join("%s mt".printf(this._object.get_table()), "mt.%s".printf(this._source_key), "dt.%s".printf(this._foreign_key))
                //.where()
                //    .equals("mt." + this._foreign_key, this._object.get_primary_key_value())
                .limit(1)
            ;
            /*
            var dbh = SBFactory.getDbh();
            string sql = this.builder.sql();
            message(sql);
            var item = dbh.getObject<D>(sql);
            */
            debug(this.builder.sql());
            var item = this.builder.first<D>();
            return item;
        }
        public virtual void attach(D obj)
        {
            this._to_attach.add(obj);
        }
        protected virtual void after_save_callback()
        {
            foreach(var obj in this._to_attach)
            {
                (obj as Entity).setPropertyGValue(this._foreign_key, this._object.get_primary_key_value());
                (obj as Entity).save();
            }
            this._to_attach.clear();
        }
        public static SBHasMany<T> instance<T>(Entity obj, string foreign_key, string source_key)
        {
            var hm = new SBHasMany<T>(foreign_key, source_key);
            hm._object = obj;
            obj.set_after_save_callback(hm.after_save_callback);
            var tobj = (Entity)Object.new(typeof(T));
            hm.builder
                .select_columns(tobj.get_columns("dt"))
                .from(tobj.get_table() + " dt")
                .join("%s mt".printf(obj.get_table()), "mt.%s".printf(source_key), "dt.%s".printf(foreign_key))
                .where()
                    .equals("mt." + foreign_key, obj.get_primary_key_value())
            ;
            return hm;
        }
    }
}
