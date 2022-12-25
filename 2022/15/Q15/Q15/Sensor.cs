
internal class Sensor
{
    private static int _id = 0;

    public int Id;
    public int X;
    public int Y;
    public int Bx;
    public int By;

    public int Dist;

    public Sensor(int x, int y, int bx, int by)
    {
        this.Id = _id++;
        this.X = x;
        this.Y = y;
        this.Bx = bx;
        this.By = by;

        Dist = CalcDist(bx, by);
    }

    public bool IsBeacon(int x, int y)
    {
        return x == Bx && y == By;
    }

    public int CalcDist(int x, int y)
    {
        return Math.Abs(X - x) + Math.Abs(Y - y);
    }
}

