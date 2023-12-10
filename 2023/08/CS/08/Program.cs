// See https://aka.ms/new-console-template for more information
using System.Text.RegularExpressions;
using System.Xml.Linq;

Console.WriteLine("Hello, World!");

// read the input file
var lines = File.ReadAllLines("C:\\git\\AdventOfCode\\2023\\08\\08.txt");

// write lines to console
var leftRight = lines[0];

// create dictionary
var map = new Dictionary<string, string[]>();

// for each line in lines
for (int i = 1; i < lines.Length; i++)
{
    var line = lines[i];
    var match = Regex.Match(line, "(...) = \\((...), (...)");
    if (match.Success)
    {
        var k = match.Groups[1].Value;
        var l = match.Groups[2].Value;
        var r = match.Groups[3].Value;
        map[k] = new string[] { l, r };
    }
}

// write map to console
foreach (var item in map)
{
    Console.WriteLine($"{item.Key} {item.Value[0]} {item.Value[1]}");
}

// create paths array
var paths = new string[] { };
foreach (var item in map)
{
    if (item.Key[2] == 'A')
    {
        paths = paths.Append(item.Key).ToArray();
    }
}

// write paths to console   
Console.WriteLine($"num paths = {paths.Length}");
foreach (var item in paths)
{
    Console.WriteLine(item);
}

Int64 result = 0;
var end = false;
var lr = 0;
while (!end)
{
    //Console.WriteLine("----------------------------");
    if (result % 1000000 == 0)
    {
        Console.WriteLine(result);
    }
    result++;
    var endInZ = 0;
    for (int j = 0; j < paths.Length; j++)
    {
        var k = paths[j];
        //Console.WriteLine($"path {j} {k}");
        var node = map[k];

        var d = leftRight[lr];
        if (d == 'L')
        {
            k = node[0];
        }
        else
        {
            k = node[1];
        }
        //Console.WriteLine($"new path {k}");
        paths[j] = k;

        if (k[2] == 'Z')
        {
            endInZ++;
        }
    }
    //Console.WriteLine($"endInZ {endInZ}");

    if (endInZ == paths.Length)
    {
        end = true;
    }

    lr++;
    if (lr == leftRight.Length)
    {
        lr = 0;
    }
}

Console.WriteLine("==============");
Console.WriteLine(result);

//while (-not($end))
//{
//#"----------------------------"
//    if ($result % 100000 - eq 0) {
//        "$result"
//    }
//    $result++
//    $endInZ = 0
//    $d = $leftRight[$i]
//    for ($j = 0; $j - lt $paths.Length; $j++)
//    {
//        $k = $paths[$j]
//        #"path $j $k"
//        $node = $map[$k]

//        if ($d - eq "L") {
//            $k = $node[0]
//        }
//        else
//        {
//            $k = $node[1]
//        }
//        #"new path $k"
//        $paths[$j] = $k

//        if ($k[2] - eq "Z") {
//            $endInZ++
//        }
//    }
//#"endInZ $endInZ"

//    if ($endInZ - eq $paths.Length) {
//        $end =$true
//    }

//    $i++
//    if ($i - eq $leftRight.Length) {
//        $i = 0
//    }
//# sleep 1
//}


//"=============="
//$result

//#answer 16531