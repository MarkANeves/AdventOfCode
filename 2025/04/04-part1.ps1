$total=0
$map=@()
Get-Content "$PSScriptRoot\04.txt" | %{
    $map += $_
}

$maxX = $map[0].Length
$maxY = $map.Count  

function isAccessible($map, $x, $y, $maxX, $maxY)
{
    $c=$map[$y][$x]
    if ($c -ne '@')
    {
        return $false
    }

    $rolls=0
    if ($y+1 -lt $maxY) {
        $c=$map[$y+1][$x]
        if ($c -eq '@') { $rolls++ }
    }
    if ($y-1 -ge 0) {
        $c=$map[$y-1][$x]
        if ($c -eq '@') { $rolls++ }
    }
    if ($x+1 -lt $maxX) {
        $c=$map[$y][$x+1]
        if ($c -eq '@') { $rolls++ }
    }
    if ($x-1 -ge 0) {
        $c=$map[$y][$x-1]
        if ($c -eq '@') { $rolls++ }
    }

    if ($y+1 -lt $maxY -and $x+1 -lt $maxX) {
        $c=$map[$y+1][$x+1]
        if ($c -eq '@') { $rolls++ }
    }
    if ($y-1 -ge 0 -and $x-1 -ge 0) {
        $c=$map[$y-1][$x-1]
        if ($c -eq '@') { $rolls++ }
    }
    if ($x+1 -lt $maxX -and $y-1 -ge 0) {
        $c=$map[$y-1][$x+1]
        if ($c -eq '@') { $rolls++ }
    }
    if ($x-1 -ge 0 -and $y+1 -lt $maxY) {
        $c=$map[$y+1][$x-1]
        if ($c -eq '@') { $rolls++ }
    }

    if ($rolls -lt 4)
    {
        return $true
    }

    return $false
}

for ($y=0; $y -lt $maxY; $y++)
{
    for ($x=0;$x -lt $maxX; $x++)
    {
        $curr = $map[$y][$x]

        if (isAccessible $map  $x  $y $maxX  $maxY)
        {
            $curr='x'
            $total++
        }

        Write-Host "$curr" -NoNewline
    }
    Write-Host ""
}

"Result: $total"
# 1445