using Gee;
using SinticBolivia;
using SinticBolivia.Classes;

namespace SinticBolivia.Database
{
    public class SBHasOne<E> : SBObject
    {
        protected   string      _foreign_key;
        protected   string      _source_key;
        protected   Entity      _object;
        public      SBDBQuery   builder;

        construct
        {
            this.builder = new SBDBQuery();
        }
        public SBHasOne(string foreign_key, string source_key)
        {
            this._foreign_key   = foreign_key;
            this._source_key    = source_key;
        }
        public E @get()
        {
            var entity = (Entity)Object.new(typeof(E));
            this.builder
                .select_columns(entity.get_columns())
                .from(entity.get_table())
                .where()
                    .equals(this._foreign_key, this._object.getPropertyValue(this._source_key))
                .limit(1)
            ;
            message(this.builder.sql());
            var item = this.builder.first<E>();
            return item;
        }
        public static SBHasOne<T> instance<T>(Entity obj, string foreign_key, string source_key)
        {
            var hasone = new SBHasOne<T>(foreign_key, source_key);
            hasone._object = obj;

            return hasone;
        }
    }
}
