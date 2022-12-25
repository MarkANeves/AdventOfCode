internal class Q20
{
    //private readonly string _fileName = @"C:\Mark\Google Drive\Projects\AdventOfCode\2022\20\20-test.txt";
    private readonly string _fileName = @"C:\Mark\Google Drive\Projects\AdventOfCode\2022\20\20.txt";

    private Item _head = new Item(0,0);
    private int _total = 0;

    private List<Item> _numList = new List<Item>();
    private List<Item> _origList = new List<Item>();

    public void Q20Part1V2()
    {
        ReadInputV2(1);
        //RenderV2();

        for (int i = 0; i < _total; i++)
        {
            var v = _origList[i];
            var val = v.Value;
            var index = _numList.IndexOf(v);
            Int64 newIndex;

            if (val >= 0)
                newIndex = (index + val) % (_total - 1);
            else
            {
                newIndex = index + (val % (_total - 1));
                if (newIndex < 0)
                    newIndex = _total + newIndex - 1;
            }

            _numList.RemoveAt(index);
            _numList.Insert((int)newIndex, v);
        }

        var zero = _numList.First(x => x.Value == 0);
        int z = _numList.IndexOf(zero);

        var a = _numList[(1000 + z) % _total].Value;
        var b = _numList[(2000 + z) % _total].Value;
        var c = _numList[(3000 + z) % _total].Value;
        var result = a + b + c;
        Console.WriteLine($"Part 1 answer {a} + {b} + {c} = {a + b + c}");
    }
    public void Q20Part2V2()
    {
        ReadInputV2(811589153);
        //RenderV2();

        for (int n = 0; n < 10; n++)
        {
            for (int i = 0; i < _total; i++)
            {
                var v = _origList[i];
                var val = v.Value;
                var index = _numList.IndexOf(v);
                Int64 newIndex;

                if (val >= 0)
                    newIndex = (index + val) % (_total - 1);
                else
                {
                    newIndex = (index + val) % (_total - 1);
                    if (newIndex < 0)
                        newIndex = _total + newIndex - 1;
                }

                _numList.RemoveAt(index);
                _numList.Insert((int)newIndex, v);
            }
        }

        var zero = _numList.First(x => x.Value == 0);
        int z = _numList.IndexOf(zero);

        var a = _numList[(1000 + z) % _total].Value;
        var b = _numList[(2000 + z) % _total].Value;
        var c = _numList[(3000 + z) % _total].Value;
        var result = a + b + c;
        Console.WriteLine($"Part 2 answer {a} + {b} + {c} = {a + b + c}");
    }

    private void ReadInputV2(int multiplier)
    {
        _total = 0;
        _numList = new List<Item>();
        _origList = new List<Item>();

        foreach (string line in System.IO.File.ReadLines(_fileName))
        {
            var v = new Item(_total, Int64.Parse(line) * multiplier);
            _numList.Add(v);
            _origList.Add(v);
            _total++;
        }
    }

    void RenderV2()
    {
        Console.WriteLine("--------------------------");
        foreach (var n in _numList)
        {
            Console.WriteLine($"{n.Value} : id {n.Id}");
        }
    }
    /*
        public void Q20Part1()
        {
            ReadInput();
            Render();

            var item = _head;

            for (int n=0;n < _total;n++)
            {
                Console.WriteLine($"n={n}");
                while (item.Id != n)
                    item = item.Next;

                Item newPos = item;
                for (int i = 0; i < Math.Abs(item.Value); i++)
                {
                    if (item.Value > 0)
                        newPos = newPos.Next;
                    else
                        newPos = newPos.Prev;
                }

                if (item.Id == _head.Id)
                    _head = item.Next;

                //Console.WriteLine($"Moving {item.Value} to {newPos.Value}");
                if (item.Value > 0)
                    MoveRight(item, newPos);
                else if (item.Value < 0)
                    MoveLeft(item, newPos);

                Render();
            }

            var a = GetNthNumber(1000);
            var b = GetNthNumber(2000);
            var c = GetNthNumber(3000);

            Console.WriteLine($"Q20 Part 1 answer = {a}+{b}+{c}={a+b+c}");
        }

        private Int64 GetNthNumber(int i)
        {
            var item = _head;
            while (item.Value != 0) 
                item= item.Next;

            for (int n=0;n < i;n++)
                item = item.Next;

            return item.Value;
        }

        void Render()
        {
            return;
            Console.WriteLine("--------------------------");
            Item item = _head;
            for (int n = 0; n < _total; n++)
            {
                Console.WriteLine($"{item.Value} : prev {item.Prev.Value} : next {item.Next.Value}");
                item = item.Next;
            }
        }



        private void MoveRight(Item item, Item newPos)
        {
            item.Prev.Next = item.Next;
            item.Next.Prev = item.Prev;

            item.Prev = newPos;
            item.Next = newPos.Next;
            newPos.Next.Prev = item;
            newPos.Next = item;

        }
        private void MoveLeft(Item item, Item newPos)
        {
            item.Prev.Next = item.Next;
            item.Next.Prev = item.Prev;

            item.Next = newPos;
            item.Prev = newPos.Prev;
            newPos.Prev.Next = item;
            newPos.Prev = item;
        }

        void ReadInput()
        {
            Item prev = null;
            Item next = _head = new Item();
            foreach (string line in System.IO.File.ReadLines(_fileName))
            {
                _total++;

                next.Value = Int16.Parse(line);
                if (prev != null)
                {
                    prev.Next = next;
                    next.Prev = prev;
                }

                prev = next;
                next = new Item();
            }

            prev.Next = _head;
            _head.Prev = prev;
            Render();
            var x = 0;
        }
    */

}
/*
1
2
-3
3
-2
0
4
*/