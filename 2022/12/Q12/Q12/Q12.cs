internal class Q12
{
    private Board _board;
    private bool _enableRender = false;
    private string _fileName = @"C:\Mark\Google Drive\Projects\AdventOfCode\2022\12\12.txt";

    public void Part1()
    {
        Console.WriteLine("------------------------Part 1---------------------------");

        _board = Board.CreateBoard(_fileName);
        var steps = Solve(_board.StartX,_board.StartY);
        Console.WriteLine($"Part1 Answer: {steps}");
    }

    public void Part2()
    {
        Console.WriteLine("------------------------Part 2---------------------------");

        _board = Board.CreateBoard(_fileName);
        int minSteps = Int32.MaxValue;

        for (int j = 0; j < _board.Height; j++)
        {
            for (int i = 0; i < _board.Width; i++)
            {
                if (_board.Array[i, j] == 'a')
                {
                    int steps = Solve(i,j);
                    if (steps > 0)
                    {
                        if (steps < minSteps)
                        {
                            minSteps = steps;
                            Console.WriteLine($"New min steps: {minSteps}");
                        }
                    }
                    _board = Board.CreateBoard(_fileName);
                }
            }
        }
        Console.WriteLine($"Part2 Answer: {minSteps}");
    }

    int Solve(int sx, int sy)
    {
        Render(0, '?', sx, sy);

        var queue = new Queue<Tuple<int, int>>();
        queue.Enqueue(new Tuple<int, int>(sx, sy));

        var prev = new Tuple<int, int>[_board.Width * _board.Height];

        Solve(sx,sy,prev);

        int x = _board.EndX;
        int y = _board.EndY;
        _board.Array[x, y] = 'E';
        int steps = 0;
        while (x != sx || y != sy)
        {
            steps++;
            var p = prev[CalcArrayIndex(x, y)];
            if (p == null)
            {
                return -1; // Can't reach end point from sx,sy
            }
            x = p.Item1;
            y = p.Item2;
            _board.Array[x, y] = '#';
        }
        Render(steps, '?', x, y);

        return steps;
    }

    void Solve(int sx, int sy, Tuple<int, int>[] prev)
    {
        var queue = new Queue<Tuple<int, int>>();
        queue.Enqueue(new Tuple<int, int>(sx, sy));

        while (queue.Count > 0)
        {
            var d = queue.Dequeue();
            int x = d.Item1;
            int y = d.Item2;

            var c = _board.Array[x, y];
            _board.Array[x, y] = '.';

            if (CanMoveTo(x + 1, y, c))
            {
                queue.Enqueue(new Tuple<int, int>(x + 1, y));
                prev[CalcArrayIndex(x + 1, y)] = new Tuple<int, int>(x, y);
            }

            if (CanMoveTo(x - 1, y, c))
            {
                queue.Enqueue(new Tuple<int, int>(x - 1, y));
                prev[CalcArrayIndex(x - 1, y)] = new Tuple<int, int>(x, y);
            }

            if (CanMoveTo(x, y - 1, c))
            {
                queue.Enqueue(new Tuple<int, int>(x, y - 1));
                prev[CalcArrayIndex(x, y - 1)] = new Tuple<int, int>(x, y);

            }

            if (CanMoveTo(x, y + 1, c))
            {
                queue.Enqueue(new Tuple<int, int>(x, y + 1));
                prev[CalcArrayIndex(x, y + 1)] = new Tuple<int, int>(x, y);
            }
        }
    }

    bool CanMoveTo(int x, int y, char c)
    {
        if (x < 0 || y < 0 || x >= _board.Width || y >= _board.Height)
        {
            return false;
        }

        var c2 = _board.Array[x, y];
        if (c2 == '.')
            return false;

        if (c + 1 == c2)
            return true;
        if (c >= c2)
            return true;

        return false;
    }

    int CalcArrayIndex(int x, int y)
    {
        return x + (y * _board.Width);
    }

    void Render(int steps, char c, int px, int py)
    {
        if (!_enableRender)
            return;

        Console.WriteLine($"--------steps {steps}-{c}--{px}--{py}--------------------");
        var tc = _board.Array[px, py];
        _board.Array[px, py] = '*';
        for (int y = 0; y < _board.Height; y++)
        {
            string s = "";
            for (int x = 0; x < _board.Width; x++)
                s += _board.Array[x, y];
            Console.WriteLine(s);
        }
        _board.Array[px, py] = tc;
    }
}
