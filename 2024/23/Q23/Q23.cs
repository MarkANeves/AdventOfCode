using System.Collections.Immutable;
using System.Linq;
using System.Text.RegularExpressions;

class Q23
{
    static HashSet<string> hashWithT = [];
    static Dictionary<string, List<string>> links = [];

    static string output = "C:\\Mark\\Google Drive\\Projects\\AdventOfCode\\2024\\23\\23-output.txt";

    public static void Part1(string input)
    {
        long total = 0;

        var lines = File.ReadLines(input);
        var pairs = File.ReadAllText(input).Replace("\r\n", "\n").Split("\n");

        var regex = new Regex("(..)-(..)");
        foreach (var pair in pairs)
        {
            var results = regex.Matches(pair);
            var left = results[0].Groups[1].Value;
            var right = results[0].Groups[2].Value;

            if (!links.ContainsKey(left))
            {
                links[left] = new List<string>();
            }
            links[left].Add(right);

            if (!links.ContainsKey(right))
            {
                links[right] = new List<string>();
            }
            links[right].Add(left);
        }

        foreach (var key in links.Keys)
        {
            foreach (var node in links[key])
            {
                foreach (var node2 in links[node])
                {
                    var nodeList = links[node2];
                    if (nodeList.Contains(key))
                    {
                        var l = new List<string>();
                        l.Add(key);
                        l.Add(node);
                        l.Add(node2);
                        l.Sort();
                        var nodes = $"{l[0]},{l[1]},{l[2]}";

                        if (nodes[0] == 't' || nodes[3] == 't' | nodes[6] == 't')
                        {
                            hashWithT.Add(nodes);
                        }
                    }
                }
            }
        }

        total = hashWithT.Count;

        Console.WriteLine($"Part 1: {total}");
        // answer: 1227
    }

    static bool isConnected(string a, string b)
    {
        if (string.Compare(a,b) == 0)
            return true;
        return links[a].Contains(b);
    }

    public static void Part2()
    {
        var sets = new List<HashSet<string>>();

        foreach (var key in links.Keys)
        {
            var set = new HashSet<string>();
            set.Add(key);
            sets.Add(set);
        }

        foreach (var key in links.Keys)
        {
            foreach (var set in sets)
            {
                bool add = true;
                foreach(var item in set.ToArray())
                {
                    if (!isConnected(key,item))
                        add=false;
                }
                if (add)
                    set.Add(key);
            }
        }

        var biggestSet = sets.OrderByDescending(set => set.Count).First().ToImmutableSortedSet();

        var password = string.Join(',', biggestSet);
        w($"Part 2: {password}");
        // answer: cl,df,ft,ir,iy,ny,qp,rb,sh,sl,sw,wm,wy
    }
    static void w(string s)
    {
        Console.WriteLine(s);
        using (var sw = File.AppendText(output))
        {
            sw.WriteLine(s);
        }
    }

    static void w2(string s)
    {
        Console.Write(s);
        using (var sw = File.AppendText(output))
        {
            sw.Write(s);
        }
    }
}