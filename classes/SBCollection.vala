using Gee;

namespace SinticBolivia.Classes
{
    public delegate T  MapCallback<T>(T item);
    /*
    public class SBCollectionIterator<T> : Object, Iterator<T>
    {
        protected   int _current = -1;
        protected   SBCollection    _collection;

        public bool read_only{ get{return true;} }
        public bool valid { get{return true;} }

        public SBCollectionIterator(SBCollection collection)
        {
            this._collection = collection;
        }
        public new T @get()
        {
            return this._collection.items.get(this._current);
        }
        public bool has_next()
        {
            if( this._current <= -1 )
                return false;
            return this._current < (this._collection.items.size - 1);
        }
        public bool next()
        {
            if( !this.has_next() )
                return false;
            this._current++;
            return true;
        }
        public void remove()
        {

        }
    }
    */
    public class SBCollection<T> : SBSerializable //, Iterable<T>
    {

        protected   ArrayList<T>    _items;
        public      ArrayList<T>    items
        {
            get{ return this._items; }
            set{ this._items = value; }
        }
        public      int size { get {return this._items.size;} }

        public Type element_type
        {
            get{ return typeof(T); }
        }

        construct
        {
            this._items = new ArrayList<T>();
        }
        public SBCollection()
        {

        }
        public SBCollection.from_array(T[] array)
        {
            this();
            this._items.add_all_array(array);
        }
        public void add(T item)
        {
            this.items.add(item);
        }
        public bool remove(T item)
        {
            return this.items.remove(item);
        }
        public T remove_at(int index)
        {
            return this.items.remove_at(index);
        }
        /*
        public SBCollection<T> map(MapCallback callback)
        {
            var items = new SBCollection<T>();
            foreach(var item in this._items)
            {
                var newItem = callback(item);
                items.add(newItem);
            }
            return items;
        }
        */
        public override string to_json()
        {
            if( this._items == null || this._items.size <= 0 )
                return "[]";
            Json.Array jitems = new Json.Array();
            foreach(T item in this._items)
            {
                if( item is Object )
                {
                    if( item is SBSerializable )
                    {
                        //message("is SBSerializable");
                        var node = (item as SBSerializable).to_json_node();
                        jitems.add_element(node);
                        //print(Json.to_string(node, false));
                    }
                    else
                    {
                        //message("is Object");
                        jitems.add_element( Json.gobject_serialize((Object)item) );
                    }
                    //continue;
                }
                else if( Utils.is_primitive_type( typeof(T) ) )
                {
                    var pnode = new Json.Node(Json.NodeType.VALUE);
                    if( item is int || item is uint || item is long || item is ulong || item is int64 || item is uint64 )
                    {
                        //node.set_int(int64.parse(item.to_string()));
                        pnode.set_int((int64)item);
                    }
                    else if( item is float || item is double )
                    {
                        pnode.set_double(double.parse(((string)item)));
                        //pnode.set_double((T)item);
                    }
                    else
                        pnode.set_string((string)item);
                    jitems.add_element(pnode);
                }
            }
            var array_node = new Json.Node(Json.NodeType.ARRAY);
            array_node.set_array(jitems);
            string json = Json.to_string(array_node, false);
            return json;
        }
        /*
        public Iterator<T> iterator()
        {
            return new SBCollectionIterator<T>(this);
        }
        */
    }
}
