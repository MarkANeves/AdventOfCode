$ErrorActionPreference="Stop"
$data=@()
Get-Content "$PSScriptRoot\09.txt" | %{$data+=$_}

$heightmap=New-Object object[] $data.Count

$lastIndex = $data[0].Length-1
$i=0
foreach ($line in $data)
{
    $heightmap[$i] =@()
    0..$lastIndex| %{
        $point=[PSCustomObject]@{
            h = [int]"$($line[$_])"
            visited = $false
        }
        $heightmap[$i] += $point
    }
    $i++
}

function CheckAdjacent($hm,$x,$y,$mx,$my)
{
    if ($x -le 0)   { $left=9}
    if ($x -ge $mx) { $right=9}
    if ($y -le 0)   { $top=9}
    if ($y -ge $my) { $bottom=9}

    if (-not($left))   { $left   = ($hm[$y])[$x-1].h}
    if (-not($right))  { $right  = ($hm[$y])[$x+1].h}
    if (-not($top))    { $top    = ($hm[$y-1])[$x].h}
    if (-not($bottom)) { $bottom = ($hm[$y+1])[$x].h}

    $v = $($hm[$y])[$x].h

    if ($v -lt $left -and $v -lt $right -and $v -lt $top -and $v -lt $bottom)
    {
        return $true
    }
    return $false
}

$mx = $data[0].Length-1
$my = $data.Length-1

function CountBasin($hm,$x,$y)
{
    if ($x -lt 0 -or $x -gt $mx -or $y -lt 0 -or $y -gt $my)
    {
        return 0
    }

    $h=$($hm[$y])[$x].h
    $v=$($hm[$y])[$x].visited

    if ($h -eq 9 -or $v -eq $true)
    {
        return 0
    }

    $($hm[$y])[$x].visited=$true

    return 1+(CountBasin $hm ($x+1) $y)+(CountBasin $hm ($x-1) $y)+(CountBasin $hm $x ($y-1))+(CountBasin $hm $x ($y+1))
}

$counts=@()
0..$my | % {
    $y=$_
    0..$mx | %{
        $x = $_
        if (CheckAdjacent $heightmap $x $y $mx $my)
        {
            $c=CountBasin $heightmap $x $y
            $counts+=$c
        }
    }
}
$counts = $counts | sort -Descending
$counts[0]*$counts[1]*$counts[2]