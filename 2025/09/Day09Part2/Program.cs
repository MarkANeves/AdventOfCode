using System.Diagnostics;
using System.Text.RegularExpressions;

internal static class Program
{
    private static readonly Regex PointRegex = new(@"(\d+),(\d+)", RegexOptions.Compiled);

    private static int Main(string[] args)
    {
        var totalTime = Stopwatch.StartNew();

        var inputPath = Path.Combine(AppContext.BaseDirectory, "09.txt");
        var polygon = ReadPolygon(inputPath);

        long maxArea = 0;
        var map = new Dictionary<long, bool>();

        for (var i = 0; i < polygon.Count; i++)
        {
            Console.WriteLine($"------------------------------");
            Console.WriteLine($"Iteration {i}");
            var sw = Stopwatch.StartNew();
            long hitCount = 0;
            long tiles = 0;

            for (var j = 0; j < i; j++)
            {
                var p1 = polygon[i];
                var p2 = polygon[j];

                var xdiff = (long)Math.Abs(p1.X - p2.X) + 1;
                var ydiff = (long)Math.Abs(p1.Y - p2.Y) + 1;
                var area = xdiff * ydiff;
                if (area <= maxArea)
                {
                    Console.Write($"x");
                    continue;
                }

                bool inPolygone = CheckPoints(polygon, map, ref hitCount, ref tiles, p1, p2);

                if (inPolygone)
                {
                    maxArea = area;
                    Console.Write('.');
                }
                else
                    Console.Write('F');
            }
            Console.WriteLine("");
            sw.Stop();
            var seconds = (int)sw.Elapsed.TotalSeconds;
            var totalSeconds = (int)totalTime.Elapsed.TotalSeconds;
            var percent = tiles > 0 ? (int)((hitCount / (double)tiles) * 100) : 0;
            Console.WriteLine($"max: {maxArea}  Elapsed: {seconds}s ({totalSeconds}s)  tiles: {tiles}  hitcount: {hitCount}  hitrate: {percent}%  dict size: {map.Count}");
        }
        Console.WriteLine($"Answer: {maxArea}");
        // 1560299548

        totalTime.Stop();
        Console.WriteLine($"Took: {totalTime.Elapsed.Minutes}m {totalTime.Elapsed.Seconds}s");
        // Took: 3m 1s
        // Took: 6m 52s without area check
        return 0;
    }

    private static bool CheckPoints(List<Point> polygon, Dictionary<long, bool> map, ref long hitCount, ref long tiles, Point p1, Point p2)
    {
        bool inPolygone = true;
        var minx = Math.Min(p1.X, p2.X);
        var maxx = Math.Max(p1.X, p2.X);
        var miny = Math.Min(p1.Y, p2.Y);
        var maxy = Math.Max(p1.Y, p2.Y);

        for (int y=miny; y <= maxy && inPolygone; y++)
        {
            inPolygone = CheckPoint(polygon, map, ref hitCount, ref tiles, minx, y);
        }
        for (int y = miny; y <= maxy && inPolygone; y++)
        {
            inPolygone = CheckPoint(polygon, map, ref hitCount, ref tiles, maxx, y);
        }
        for (int x = minx; x <= maxx && inPolygone; x++)
        {
            inPolygone = CheckPoint(polygon, map, ref hitCount, ref tiles, x, miny);
        }
        for (int x = minx; x <= maxx && inPolygone; x++)
        {
            inPolygone = CheckPoint(polygon, map, ref hitCount, ref tiles, x, maxy);
        }

        return inPolygone;
    }

    private static bool CheckPoint(List<Point> polygon, Dictionary<long, bool> map, ref long hitCount, ref long tiles, int minx, int y)
    {
        bool inPolygone;
        tiles++;
        long k = (minx * 1000000) + y;
        if (map.ContainsKey(k))
        {
            hitCount++;
            inPolygone = map[k];
        }
        else
        {
            inPolygone = TestPointInPolygon(new Point(minx, y), polygon, includeBoundary: true);
            map[k] = inPolygone;
        }

        return inPolygone;
    }

    private static List<Point> ReadPolygon(string inputPath)
    {
        var polygon = new List<Point>();

        foreach (var line in File.ReadLines(inputPath))
        {
            var m = PointRegex.Match(line);
            if (!m.Success)
            {
                continue;
            }

            var x = int.Parse(m.Groups[1].Value);
            var y = int.Parse(m.Groups[2].Value);
            polygon.Add(new Point(x, y));
        }

        return polygon;
    }

    private static bool TestPointInPolygon(Point point, IReadOnlyList<Point> polygon, bool includeBoundary, double epsilon = 1e-9)
    {
        if (polygon.Count < 3)
        {
            return false;
        }

        var px = (double)point.X;
        var py = (double)point.Y;

        static bool PointOnSegment(double x, double y, double ax, double ay, double bx, double by, double eps)
        {
            var cross = (bx - ax) * (y - ay) - (by - ay) * (x - ax);
            if (Math.Abs(cross) > eps)
            {
                return false;
            }

            var dot = (x - ax) * (x - bx) + (y - ay) * (y - by);
            return dot <= eps;
        }

        var inside = false;
        var j = polygon.Count - 1;

        for (var i = 0; i < polygon.Count; i++)
        {
            var pi = polygon[i];
            var pj = polygon[j];

            var xi = (double)pi.X;
            var yi = (double)pi.Y;
            var xj = (double)pj.X;
            var yj = (double)pj.Y;

            if (PointOnSegment(px, py, xj, yj, xi, yi, epsilon))
            {
                return includeBoundary;
            }

            var intersects = (yi > py) != (yj > py);
            if (intersects)
            {
                var xAtY = (xj - xi) * (py - yi) / (yj - yi) + xi;
                if (px < xAtY)
                {
                    inside = !inside;
                }
            }

            j = i;
        }

        return inside;
    }
    private readonly record struct Point(int X, int Y);
}
