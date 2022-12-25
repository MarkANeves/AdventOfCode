
using System.Text.RegularExpressions;

internal class Q15
{
    private readonly string _fileName = @"C:\Mark\Google Drive\Projects\AdventOfCode\2022\15\15.txt";
    private readonly int _startY = 2000000;
    private readonly int _maxX2 = 4000000;
    
    //private readonly string _fileName = @"C:\Mark\Google Drive\Projects\AdventOfCode\2022\15\15-test.txt";
    //private readonly int _startY = 10;
    //private readonly int _maxX2 = 20;

    private List<Sensor> _sensors = new List<Sensor>();
    private int _minX = Int32.MaxValue;
    private int _maxX = Int32.MinValue;

    public Q15()
    {
        LoadSensors();
    }

    private void LoadSensors()
    {
        foreach (string line in System.IO.File.ReadLines(_fileName))
        {
            var pattern = @"Sensor at x=(-*\d+), y=(-*\d+): closest beacon is at x=(-*\d+), y=(-*\d+)";
            // Create a Regex  
            Regex rg = new Regex(pattern);

            // Get all matches  
            MatchCollection matches = rg.Matches(line);

            var gc = matches[0].Groups;
            var ix = int.Parse(gc[1].Value);
            var iy = int.Parse(gc[2].Value);
            var bx = int.Parse(gc[3].Value);
            var by = int.Parse(gc[4].Value);
            _sensors.Add(new Sensor(ix, iy, bx, by));
        }

        foreach (var s in _sensors)
        {
            Console.WriteLine($"Sensor {s.X},{s.Y} beacon {s.Bx},{s.By} dist {s.Dist}");
            if (s.X - s.Dist < _minX) _minX = s.X - s.Dist;
            if (s.X + s.Dist > _maxX) _maxX = s.X + s.Dist;
        }

        Console.WriteLine($"minX {_minX}, maxX {_maxX}");
    }

    public void Q15Part1()
    {
        int count = 0;
        int y = _startY;
        for (int x = _minX; x <= _maxX; x++)
        {
            bool noSensor = false;
            foreach (var s in _sensors)
            {
                var dist = s.CalcDist(x, y);
                if (dist <= s.Dist && !s.IsBeacon(x, y))
                    noSensor = true;
            }

            if (noSensor)
            {
                count++;
                if (count % 100000 == 0)
                    Console.WriteLine($"{x},{y}");
            }
        }

        Console.WriteLine($"Answer: {count}");
    }

    //char[,] _board = new char[30, 30];

    public void Q15Part2()
    {
        //for (int x = 0; x < 30; x++)
        //for (int y = 0; y < 30; y++)
        //    _board[x, y] = '.';

        int count = 0;
        bool found=false;
        foreach (var s1 in _sensors)
        {
            //_board[s1.X, s1.Y] = '0';
            for (int d = 0; d <= s1.Dist + 1 && !found; d++)
            {
                count++;
                if (count % 10000 == 0)
                    Console.WriteLine($"{s1.Id}: count {count}");

                var y1 = s1.Y - d;
                var y2 = s1.Y + d;
                var x1 = s1.X - s1.Dist + d - 1;
                var x2 = s1.X + s1.Dist - d + 1;

                //Console.WriteLine($"s1.Dist: {s1.Dist}");
                //Console.WriteLine($"{x1},{y1}: {s1.CalcDist(x1, y1)}");
                //Console.WriteLine($"{x1},{y2}: {s1.CalcDist(x1, y2)}");
                //Console.WriteLine($"{x2},{y1}: {s1.CalcDist(x2, y1)}");
                //Console.WriteLine($"{x2},{y2}: {s1.CalcDist(x2, y2)}");

                if (Part2Found(x1, y1))
                {
                    PrintAnswer(x1,y1,count);
                    found = true;
                }
                if (Part2Found(x1, y2))
                {
                    PrintAnswer(x1, y2, count);
                    found = true;
                }
                if (Part2Found(x2, y1))
                {
                    PrintAnswer(x2, y1, count);
                    found = true;
                }
                if (Part2Found(x2, y2))
                {
                    PrintAnswer(x2, y2, count);
                    found = true;
                }
                if (found)

                    return;
                //Render();
            }
        }

        return;
    }

    void PrintAnswer(int x, int y, int count)
    {
        Console.WriteLine($"Part 2 answer: {((Int64)x*4000000)+y} in {count} iterations");
    }

    void Render()
    {
        for (int y = 0; y < 30; y++)
        {
            string s = "";
            for (int x = 0; x < 30; x++)
            {
                //s += _board[x, y];
            }
            Console.WriteLine(s);
        }
    }

    bool Part2Found(int x, int y)
    {
        if (x < 0 || x > _maxX2 || y < 0 || y > _maxX2)
            return false;

        //_board[x, y] = '#';

        foreach (var s in _sensors)
        {
            var dist = s.CalcDist(x, y);
            if (dist <= s.Dist)
                return false;
        }

        //_board[x, y] = '*';
        Console.WriteLine($"FOUND: {x},{y}");
        return true;
    }
}
