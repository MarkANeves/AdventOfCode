$map=@()
$map+="..##......."
$map+="#...#...#.."
$map+=".#....#..#."
$map+="..#.#...#.#"
$map+=".#...##..#."
$map+="..#.##....."
$map+=".#.#.#....#"
$map+=".#........#"
$map+="#.##...#..."
$map+="#...##....#"
$map+=".#..#...#.#"

$map=@()
Get-Content "$PSScriptRoot\03.txt" | %{$map+=$_}

function CountTrees($slopeRight,$slopeDown)
{
    $x=$y=$numTrees=0
   
    while ($y -lt $map.Count)
    {
        $line = $map[$y]
        $c = $line[$x % $line.Length]
        if ($c -eq "#") {$numTrees++}
        $x+=$slopeRight
        $y+=$slopeDown
    }
    $numTrees
}

Write-Host "------------------"
Write-Host "Part One"

CountTrees 3 1

Write-Host "------------------"
Write-Host "Part Two"

$n1=CountTrees 1 1
$n2=CountTrees 3 1
$n3=CountTrees 5 1
$n4=CountTrees 7 1
$n5=CountTrees 1 2
#$n1;$n2;$n3;$n4;$n5
$n1*$n2*$n3*$n4*$n5
