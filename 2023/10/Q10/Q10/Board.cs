internal class Board
{
    public char[,] Array=null;
    public int Width;
    public int Height;
    public int StartX;
    public int StartY;

    public static Board CreateBoard(string fileName)
    {
        var board = new Board();

        var lines = new List<string>();
        foreach (string line in System.IO.File.ReadLines(fileName))
        {
            lines.Add(line);
        }

        board.Width = lines[0].Length;
        board.Height = lines.Count;
        board.Array = new char[board.Width, board.Height];

        for (int i = 0; i < board.Width; i++)
        {
            for (int j = 0; j < board.Height; j++)
            {
                var c = board.Array[i, j] = lines[j][i];
                if (c == 'S')
                {
                    board.StartX = i;
                    board.StartY = j;
                }
            }
        }

        return board;
    }
}
