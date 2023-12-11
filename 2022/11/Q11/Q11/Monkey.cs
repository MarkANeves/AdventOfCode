
internal class Monkey
{
    public List<Int64> Items;
    public OpType OpType;
    public Int64 OpNum;
    public Int64 Div;
    public int TrueMonkey;
    public int FalseMonkey;
    public Int64 InspectedCount = 0;

    public Monkey(List<Int64> items, OpType opType, Int64 opNum, Int64 div, int trueMonkey, int falseMonkey)
    {
        Items = items;
        OpType = opType;
        OpNum = opNum;
        Div = div;
        TrueMonkey = trueMonkey;
        FalseMonkey = falseMonkey;
    }
}
