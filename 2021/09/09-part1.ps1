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
            min = $false
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
    # "x: $x  y:$y"
    # "v: $v"
    # "l: $left"
    # "r: $right"
    # "t: $top"
    # "b: $bottom"

    if ($v -lt $left -and $v -lt $right -and $v -lt $top -and $v -lt $bottom)
    {
        $($hm[$y])[$x].min = $true
    }
}

$mx = $data[0].Length-1
$my = $data.Length-1

0..$mx | % {
    $x=$_
    0..$my | %{
        $y = $_
        CheckAdjacent $heightmap $x $y $mx $my
    }
}

$sum=0
$heightmap | %{
    $_ | % {
        if ($_.min) {$sum+=$($_.h+1)}
    }
}
$sum