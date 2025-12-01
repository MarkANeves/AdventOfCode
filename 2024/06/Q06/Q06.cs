using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;

internal class Q06
{
    static int W;
    static int H;

    static void findStart(List<string> map, ref int x, ref int y)
    {
        for (int i = 0;i < map.Count;i++)
        {
            for (int j = 0;j < map[i].Length;j++)
            {
                var c = map[i][j];
                if (map[i][j] == '^')
                {
                    x = j;
                    y = i;
                    return;
                }
            }
        }
    }

    static void displayMap(List<string> map)
    {
        w("");
        foreach (var line in map)
            w(line);
    }

    //static void move(ref int x, ref int y, int dx, int dy)
    //{
    //    int x2 = x+dx;
    //    int y2 = y+dy;
    //}

    static void visited(List<string> map, int x, int y, char c)
    {
        var l = map[y];
        l = l.Substring(0,x) + c + l.Substring(x+1,l.Length-x-1);
        map[y] = l;
    }

    static int countVisted(List<string> map)
    {
        int total = 0;
        foreach(var l in map)
        {
            foreach(var v in l)
                if (v == '+')
                    total++;
        }
        return total;
    }

    public static void Q06Part1(string input)
    {
        var map = File.ReadLines(input).ToList();

        displayMap(map);

        int x=0, y = 0;
        int dx=0, dy=-1;
        findStart(map, ref x, ref y);

        var W = map[0].Length;
        var H = map.Count;
        w($"{W} : {H} : {x} : {y}");

        visited(map, x, y, '+');
        displayMap(map);

        int count = 0;
        bool outOfBounds = false;
        do
        {
            count++;
            if (count % 10000 == 0)
                displayMap(map);

            x += dx;
            y += dy;
            outOfBounds = x < 0 || x >= W || y < 0 || y >= H;
            if (!outOfBounds)
            {
                char c = map[y][x];
                if (c == '#')
                {
                    x -= dx;
                    y -= dy;
                    if (dx == 1)
                    {
                        dx = 0; dy = 1;
                    }
                    else if (dx == -1)
                    {
                        dx = 0; dy = -1;
                    }
                    else if (dy == -1)
                    {
                        dx = 1; dy = 0;
                    }
                    else if (dy == 1)
                    {
                        dx = -1; dy = 0;
                    }
                }
                else
                    visited(map, x, y, '+');
            }
            //displayMap(map);
            var z = 0;
        } while (!outOfBounds);
        displayMap(map);

        w($"Total: {countVisted(map)}");
        // answer:  4454
    }

    public static int runSim(List<string> map, int x, int y)
    {
        int dx = 0, dy = -1;

        W = map[0].Length;
        H = map.Count;
        //w($"{W} : {H} : {x} : {y}");

        visited(map, x, y, '+');

        int count = 0;
        bool outOfBounds = false;
        do
        {
            count++;
            if (count > 10000)
                return -1;

            x += dx;
            y += dy;
            outOfBounds = x < 0 || x >= W || y < 0 || y >= H;
            if (!outOfBounds)
            {
                char c = map[y][x];
                if (c == '#' || c == 'O')
                {
                    x -= dx;
                    y -= dy;
                    if (dx == 1)
                    {
                        dx = 0; dy = 1;
                    }
                    else if (dx == -1)
                    {
                        dx = 0; dy = -1;
                    }
                    else if (dy == -1)
                    {
                        dx = 1; dy = 0;
                    }
                    else if (dy == 1)
                    {
                        dx = -1; dy = 0;
                    }
                }
                else
                    visited(map, x, y, '+');
            }
        } while (!outOfBounds);

        return countVisted(map);
    }

    static List<string> Copy(List<string> list)
    {
        List<string> newList = [];

        foreach (var s in list)
        {
            newList.Add(s);
        }
        return newList;
    }
    public static void Q06Part2(string input)
    {
        var originalMap = File.ReadLines(input).ToList();
        var W = originalMap[0].Length;
        var H = originalMap.Count;
        int x =0, y=0;
        findStart(originalMap, ref x, ref y);


        var total = 0;
        for (int j = 0; j < H; j++)
        {
            for (int i = 0; i < W; i++)
            {
                var map = Copy(originalMap);
                visited(map, i, j, 'O');
                visited(map, x, y, '^');
                var r = runSim(map, x, y);
                if (r < 0)
                {
                    //displayMap(map);
                    w($"Total: {total}");
                    total++;
                }
            }
        }
        w($"Part2 {total}");
    }

    static string output = "C:\\Mark\\Google Drive\\Projects\\AdventOfCode\\2024\\06\\06-output.txt";

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
