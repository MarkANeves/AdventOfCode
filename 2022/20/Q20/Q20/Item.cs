internal class Item
{
    public Int64 Value;
    //public Item Prev;
    //public Item Next;
    public int Id;

    public Item(int id, Int64 v)
    {
        Id = id;
        Value = v;
        //Prev = null;
        //Next = null;
    }
}
