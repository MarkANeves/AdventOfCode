
function getAntenna($map,$x,$y)
{
    $h = $map.Count
    $w = $map[0].Length

    if ($x -lt 0 -or $x -ge $w) { return '.'}
    if ($y -lt 0 -or $y -ge $h) { return '.'}

    return $map[$y][$x]
}

$total=0

$map = @()
$mapResult = @()
$antennaTypeList = @()

Get-Content "$PSScriptRoot\08.txt" | %{
    $line = $_
    $map+=$line
    $mapResult+=$line

    foreach($c in $line.ToCharArray())
    {
        if (-not($antennaTypeList.Contains($c)) -and $c -ne '.') {
            $antennaTypeList += $c
        }
    }
}

$h = $map.Count
$w = $map[0].Length

$coordMap=@{}

for($y=0;$y -lt $h;$y++) {
    for($x=0;$x -lt $w;$x++) {
        $a = getAntenna $map $x $y

        if ($a -ne '.')
        {
            if (-not($coordMap.ContainsKey($a))) { $coordMap[$a] = @() }
            $coordMap[$a] += [PSCustomObject]@{x=$x;y=$y;}
        }
    }
}
$coordMap

function findAntinodes($m,$c1,$c2) {
    $dx = $c1.x - $c2.x
    $dy = $c1.y - $c2.y

    $w = $map[0].Length
    $h = $map.Count

    $an1x = $c1.x + $dx
    $an1y = $c1.y + $dy
    $valid = ($an1x -ge 0 -and $an1x -lt $w -and $an1y -ge 0 -and $an1y -lt $h)
    while ($valid) {
        $s = $m[$an1y]
        $s = $s.Substring(0,$an1x) + '#' + $s.Substring($an1x+1)
        $m[$an1y] = $s

        $an1x = $an1x + $dx
        $an1y = $an1y + $dy
        $valid = ($an1x -ge 0 -and $an1x -lt $w -and $an1y -ge 0 -and $an1y -lt $h)
    }

    $an2x = $c2.x - $dx
    $an2y = $c2.y - $dy
    $valid = ($an2x -ge 0 -and $an2x -lt $w -and $an2y -ge 0 -and $an2y -lt $h)
    while ($valid) {
        $s = $m[$an2y]
        $s = $s.Substring(0,$an2x) + '#' + $s.Substring($an2x+1)
        $m[$an2y] = $s

        $an2x = $an2x - $dx
        $an2y = $an2y - $dy
        $valid = ($an2x -ge 0 -and $an2x -lt $w -and $an2y -ge 0 -and $an2y -lt $h)
    }
}

foreach($aType in $antennaTypeList)
{
    $coords = $coordMap[$aType]
    for ($i=0;$i -lt ($coords.Count-1);$i++) {
        for ($j=$i+1;$j -lt ($coords.Count);$j++) {
            $c1 = $coords[$i]
            $c2 = $coords[$j]

            findAntinodes $mapResult $c1 $c2
        }
    }
}
"~~~~~~~~~~~~~~~~~"
$mapResult
for ($i=0;$i -lt ($mapResult.Count);$i++) {
    for ($j=0;$j -lt ($mapResult[0].Length);$j++) {
        $c = $mapResult[$i][$j]
        if ($c -ne '.') {
            $total++
        }
    }
}

"Result:"
$total
# answer: 813
