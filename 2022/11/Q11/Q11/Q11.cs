using System.Text.RegularExpressions;

internal class Q11
{

    public void ReadMonkeys(string fileName, List<Monkey> monkeyList)
    {
        var lines = System.IO.File.ReadLines(fileName).ToArray();

        for (int i = 0; i < lines.Count(); i++)
        {
            if (lines[i].Contains("Monkey"))
            {
                var line = lines[++i];
                line = line.Substring(line.IndexOf(':') + 1);
                var itemList = line.Split(',').Select(Int64.Parse).ToList();

                line = lines[++i];
                OpType opType;
                int opNum = -1;
                var match = Regex.Match(line, @"([\*\+])\D+(\d+)");
                if (match.Success)
                {
                    opType = match.Groups[1].Value == "+" ? OpType.Add : OpType.Mul;
                    opNum = int.Parse(match.Groups[2].Value);
                }
                else
                    opType = OpType.Square;

                line = lines[++i];
                match = Regex.Match(line, @"divisible by (\d+)");
                var div = int.Parse(match.Groups[1].Value);

                line = lines[++i];
                match = Regex.Match(line, @"If true: throw to monkey (\d+)");
                var trueMonkey = int.Parse(match.Groups[1].Value);

                line = lines[++i];
                match = Regex.Match(line, @"If false: throw to monkey (\d+)");
                var falseMonkey = int.Parse(match.Groups[1].Value);

                var monkey = new Monkey(itemList, opType, opNum, div, trueMonkey, falseMonkey);

                monkeyList.Add(monkey);
            }
        }
    }

    public void Part1(string fileName)
    {
        List<Monkey> monkeyList = new List<Monkey>();
        ReadMonkeys(fileName, monkeyList);

        for (int i = 0; i < 20; i++)
        {
            for (int m = 0; m < monkeyList.Count; m++)
            {
                var monkey = monkeyList[m];
                while (monkey.Items.Count > 0)
                {
                    var item = monkey.Items[0];

                    Int64 worryLevel = 0;
                    if (monkey.OpType == OpType.Add)
                        worryLevel = item + monkey.OpNum;
                    if (monkey.OpType == OpType.Mul)
                        worryLevel = item * monkey.OpNum;
                    if (monkey.OpType == OpType.Square)
                        worryLevel = item * item;

                    worryLevel = worryLevel / 3;

                    if (worryLevel % monkey.Div == 0)
                    {
                        monkeyList[monkey.TrueMonkey].Items.Add(worryLevel);
                    }
                    else
                    {
                        monkeyList[monkey.FalseMonkey].Items.Add(worryLevel);
                    }

                    monkey.Items.RemoveAt(0);
                    monkey.InspectedCount++;
                }
            }
        }

        ShowMonkeyInspections("Answer Part 1: ", monkeyList);
    }

    public void Part2(string fileName)
    {
        List<Monkey> monkeyList = new List<Monkey>();

        ReadMonkeys(fileName,monkeyList);

        Int64 mod=1;
        foreach (Monkey monkey2 in monkeyList)
            mod *= monkey2.Div;

        for (int i = 0; i < 10000; i++)
        {
            for (int m = 0; m < monkeyList.Count; m++)
            {
                var monkey = monkeyList[m];
                while (monkey.Items.Count > 0)
                {
                    var item = monkey.Items[0];

                    Int64 worryLevel = 0;
                    if (monkey.OpType == OpType.Add)
                        worryLevel = item + monkey.OpNum;
                    if (monkey.OpType == OpType.Mul)
                        worryLevel = item * monkey.OpNum;
                    if (monkey.OpType == OpType.Square)
                        worryLevel = item * item;

                    worryLevel = worryLevel % mod;

                    if (worryLevel % monkey.Div == 0)
                    {
                        monkeyList[monkey.TrueMonkey].Items.Add(worryLevel);
                    }
                    else
                    {
                        monkeyList[monkey.FalseMonkey].Items.Add(worryLevel);
                    }

                    monkey.Items.RemoveAt(0);
                    monkey.InspectedCount++;
                }
            }
        }

        ShowMonkeyInspections("Answer Part 2: ",monkeyList);
    }

    void ShowMonkeyItems(int i, List<Monkey> monkey2List)
    {
        Console.WriteLine($"{i}##########################");
        for (int m = 0; m < monkey2List.Count; m++)
        {
            Console.Write($"Monkey {m}: ");
            for (int j = 0; j < monkey2List[m].Items.Count; j++)
                Console.Write($"{monkey2List[m].Items[j]},");
            Console.WriteLine();
        }

        Console.WriteLine("##########################");
    }

    void ShowMonkeyInspections(string prefix, List<Monkey> monkey2List)
    {
        var ss = new SortedSet<Int64>();
        
        Console.WriteLine($"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
        for (int m = 0; m < monkey2List.Count; m++)
        {
            Console.WriteLine($"Monkey {m} inspected item {monkey2List[m].InspectedCount} times");
            ss.Add(monkey2List[m].InspectedCount);
        }
        var results = ss.Reverse().ToArray();
        Console.WriteLine($"{prefix}{results[0]}*{results[1]} = {results[0] * results[1]}");
        Console.WriteLine("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
    }
}
