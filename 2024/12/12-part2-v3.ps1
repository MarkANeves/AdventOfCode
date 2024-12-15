
$total=[int64]0

$lines = @()

Get-Content "$PSScriptRoot\12-test5.txt" | %{
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

    $perimTotal=0
    $coords=@{}
    #$p.keys
    #Read-Host "keys generated"

    foreach($key in $p.keys)
    {
        #"!!!!!!!!!!!!!!!!!!!"
        #"key: $key   value:$($p[$key])"
        if ($p[$key] -eq 1) {

            $key -match "(\d+)-(\d+)\|(\d+)-(\d+)" | out-null
            $x1 = $Matches[1]
            $y1 = $Matches[2]
            $x2 = $Matches[3]
            $y2 = $Matches[4]
            #$Matches[0]

            $k="$x1-$y1"
            $coords[$k] = [PSCustomObject]@{x=$x1;y=$y1}
            $k="$x2-$y2"
            $coords[$k] = [PSCustomObject]@{x=$x2;y=$y2}

            #"coord keys: $($coords.keys)"
            #Read-host "key loop"
        }
        else {
            #"skip"
        }
        #"key: $key  v: $v"
        #Read-Host "next key"
    }
    #$coords

    #"-------------"
    #$p
    $pclean = @{}
    foreach($key in $p.Keys) {
        if ($p[$key] -eq 1) {
            $key -match "(\d+)-(\d+)\|(\d+)-(\d+)" | out-null
            $x1 = $Matches[1]
            $y1 = $Matches[2]
            $x2 = $Matches[3]
            $y2 = $Matches[4]
            $dir="Horizontal"
            if ($x1 -eq $x2) {
                $dir = "Vertical"
            }
            $pclean[$key] = $dir#[PSCustomObject]@{x1=$x1;y1=$y1;x2=$x2;y2=$y2}
        }
    }
    #"**"
    #$pclean
    #"-------------"

    foreach($key in $coords.Keys) {
        $dirs = $pclean.keys | %{if ($_ -like "*$key*") {$pclean[$_]}}
        $dc = $dirs.Count
        #"key: $key dirs count: $dc dirs[0]: $($dirs[0]) dirs[1]: $($dirs[1])"
        $allequal=$true
        for($i=0;$i -lt $dc-1;$i++) {
            if ($dirs[$i] -ne $dirs[$i+1]) {
                $allequal = $false
            }
        }
        if (-not($allequal)) {
            # if ($dc -gt 2) {
            #     $perimTotal+=1
            # }
            $perimTotal += 1
            # $perimTotal+=1
            # if ($dc -eq 4) {
            #     $perimTotal +=1
            # }
            # if ($dc -ne 2 -and $dc -ne 4) {
            #     Write-Host "key: $key dirs count: $dc dirs[0]: $($dirs[0]) dirs[1]: $($dirs[1])" -ForegroundColor Red
            #     Write-Host $pclean.Keys
            #     throw "BANG!"
            # }
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
    "Calculating $($r[0].c)"
    $perimeter = getPerimeter $r
    "$($r[0].c) : perimeter: $perimeter | area: $area"
    $total += $area * $perimeter
}
#getPerimeter $regions[0]
"Result:"
$total
# answer: 
#          837609 too high
#          836310 too high
#          822889 too high