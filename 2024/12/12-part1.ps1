
$total=[int64]0

$lines = @()

Get-Content "$PSScriptRoot\12-test.txt" | %{
    $line = $_
    $lines += $line
}

#$lines
$w = $lines[0].Length
$h = $lines.Count

function getChar($x,$y)
{
    #"w: $w  h: $h"
    if ($x -lt 0 -or $x -ge $w) { return '.'}
    if ($y -lt 0 -or $y -ge $h) { return '.'}
    $lines[$y][$x]
}

function setChar($c,$x,$y)
{
    #"w: $w  h: $h"
    if ($x -lt 0 -or $x -ge $w) { return }
    if ($y -lt 0 -or $y -ge $h) { return }
    $l=$lines[$y]
    $left = $l.Substring(0,$x)
    $right = $l.Substring($x+1,$l.Length-$x-1)
    #"left: $left   right: $right"
    $lines[$y]=$left+$c+$right
}

function findRegion([ref]$region,$c,$x,$y)
{
    #$lines
    $nc = getChar $x $y
    #"x: $x   y: $y  c: $c   nc: $nc"
    #"region: $($region.Value)"
    #Read-Host "find"
    if ($nc -eq '.') { return }
    if ($nc -ne $c) { return }

    if ($nc -eq $c)
    {
        $region.Value+=[PSCustomObject]@{
            c = $c
            x = $x
            y = $y
        }
        setChar '.' $x $y
        findRegion $region $c ($x+1) ($y+0)
        findRegion $region $c ($x-1) ($y+0)
        findRegion $region $c ($x+0) ($y+1)
        findRegion $region $c ($x+0) ($y-1)
    }
}

$regions=@{}
$count=0
for ($y=0;$y -lt $h;$y++)
{
    for ($x=0;$x -lt $w;$x++)
    {
        $c = getChar $x $y
        if ($c -eq '.')
        {
            continue
        }
        #"x: $x   y: $y  c: $c"
        #Read-Host "x"
        $region=@()
        findRegion ([ref]$region) $c $x $y
        #"region2: $region"

        $regions[$count++] = $region
        #Read-Host "Enter"
        #Write-Host $c -NoNewline
    }
    #Write-Host ""
}

function getPerimeter($region)
{
    $p = @{}
    foreach($r in $region)
    {
        #$r
        $key = "$($r.x)-$($r.y)|$($r.x+1)-$($r.y)"
        #$key
        $p[$key] += 1
        $key = "$($r.x)-$($r.y)|$($r.x)-$($r.y+1)"
        #$key
        $p[$key] += 1
        $key = "$($r.x)-$($r.y+1)|$($r.x+1)-$($r.y+1)"
        #$key
        $p[$key] += 1
        $key = "$($r.x+1)-$($r.y)|$($r.x+1)-$($r.y+1)"
        #$key
        $p[$key] += 1
    }
    #Read-Host "eh up"
    $perimTotal=0
    foreach($v in $p.Values)
    {
        #"v: $v"
        if ($v -eq 1) {
            $perimTotal++
        }
    }
    return $perimTotal
}

$regions
"#############"
foreach($key in $regions.Keys) {
    "---------------"
    $r = $regions[$key]
    $area = $regions[$key].Count
    $perimeter = getPerimeter $r
    "$($r[0].c) : perimeter: $perimeter | area: $area"
    $total += $area * $perimeter
}

#getPerimeter $regions[0]
"Result:"
$total
# answer: 1431316