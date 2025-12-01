using System.Diagnostics;

var stopwatch = new Stopwatch();
stopwatch.Start();

long total = 0;

var input = "C:\\Mark\\Google Drive\\Projects\\AdventOfCode\\2024\\19\\19.txt";
var lines = File.ReadLines(input);

var text = File.ReadAllText(input).Replace("\r\n","\n").Split("\n\n");
var patterns = text[0].Split(",", StringSplitOptions.TrimEntries);
var designs = text[1].Split("\n", StringSplitOptions.TrimEntries);

var patternsArray = patterns.ToArray();

//patternsArray.ToList().ForEach(x => Console.WriteLine(x));
//Console.WriteLine("================");
//designs.ToList().ForEach(x => Console.WriteLine(x));
//Console.WriteLine("---------------");

var cache = new Dictionary<string, long>();

string genKey(string design, string[] patterns)
{
    return design+"|"+string.Join(",", patterns);
}

void countMatches(string design, string[] patterns, int index, ref long matchCount)
{
    if (index >= patterns.Length) {
        return;
    }

    if (design.Length == 0) {
        matchCount++;
        return;
    }

    var key = genKey(design, patterns);
    if (cache.ContainsKey(key))
    {
        matchCount+=cache[key];
        return;
    }

    var pattern = patterns[index];

    if (design.StartsWith(pattern))
    {
        countMatches(design.Substring(pattern.Length), patterns, 0, ref matchCount);
    }

    countMatches(design, patterns, index + 1, ref matchCount);
}

long countMatchesHelper(string design, string[] patterns)
{
    long total = 0;
    for (int i = design.Length; i >= 0; i--)
    {
        var subdesign = design.Substring(i, design.Length - i);
        long matchCount = 0;
        countMatches(subdesign, patterns, 0, ref matchCount);

        var subkey = genKey(subdesign, patterns);
        cache[subkey] = matchCount;
        total = matchCount;
    }
    return total;
}


string[] getPatternsInDesign(string design, string[] patterns)
{
    var patternsInDesign = new List<string>();
    foreach(var p in patterns)
    {
        if (design.Contains(p)) {
            patternsInDesign.Add(p);
        }
    }
    return patternsInDesign.ToArray();
}

foreach(var d in designs) {
    //Console.WriteLine("~~~~~~~~~");
    //Console.WriteLine($"Testing {d}");

    var patternsInDesign = getPatternsInDesign(d, patternsArray);
    var n = countMatchesHelper(d, patternsInDesign);
    total += n;
}
stopwatch.Stop();

Console.WriteLine("Result:");
Console.WriteLine($"{total}");
Console.WriteLine(stopwatch.ToString());
//answer: 643685981770598
