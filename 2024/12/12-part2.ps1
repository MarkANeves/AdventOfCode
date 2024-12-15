
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
        $key = "T|$($r.x)-$($r.y)|$($r.x+1)-$($r.y)"
        #$key
        $p[$key] += 1
        $key = "L|$($r.x)-$($r.y)|$($r.x)-$($r.y+1)"
        #$key
        $p[$key] += 1
        $key = "B|$($r.x)-$($r.y+1)|$($r.x+1)-$($r.y+1)"
        #$key
        $p[$key] += 1
        $key = "R|$($r.x+1)-$($r.y)|$($r.x+1)-$($r.y+1)"
        #$key
        $p[$key] += 1
    }
    #Read-Host "eh up"
    # foreach($v in $p.Values)
    # {
    #     #"v: $v"
    #     if ($v -eq 1) {
    #         $perimTotal++
    #     }
    # }
    $p2=@{}
    $perimTotal=0
    $hpoints=@{}
    $vpoints=@{}
    $p.keys
    Read-Host "keys generated"
    foreach($key in $p.keys)
    {
        "!!!!!!!!!!!!!!!!!!!"
        "key: $key   value:$($p[$key])"
        if ($p[$key] -eq 1) {
            $p2[$key] = $p[$key]

            $key -match "(.)\|(\d+)-(\d+)\|(\d+)-(\d+)" | out-null
            $q = $Matches[1]
            $x1 = $Matches[2]
            $y1 = $Matches[3]
            $x2 = $Matches[4]
            $y2 = $Matches[5]
            #$Matches[0]
            "q:$q x1:$x1  y1:$y1  x2:$x2  y2:$y2"
            if ($y1 -eq $y2) {
                $nk=$q+$y1
                if (-not($hpoints.ContainsKey($nk))) {
                    $hpoints[$nk]=@()
                }
                $hpoints[$nk] += $x1
                $hpoints[$nk] += $x2
            }
            else {
                $nk=$q+$x1
                if (-not($vpoints.ContainsKey($nk))) {
                    $vpoints[$nk]=@()
                }
                $vpoints[$nk] += $y1
                $vpoints[$nk] += $y2
            }

            "++++++++++++++++++++++"
            foreach($key in $vpoints.Keys)
            {
                "vkey:$key values:$($vpoints[$key] | sort)"
            }
            foreach($key in $hpoints.Keys)
            {
                "hkey:$key values:$($hpoints[$key]|sort)"
            }

            Read-host "key loop"
        }
        else {
            "skip"
        }
        #"key: $key  v: $v"
        #Read-Host
    }

    '------------------------'
    foreach($key in $vpoints.Keys)
    {
        "^^"
        "vkey: $key"
        $list = $vpoints[$key] | sort
        "list: $list"
        "list.Count: $($list.count)"

        $newlist=@()
        for($i=0;$i -lt $list.Count;$i++)
        {
            if ($null -eq $list[$i]) {
                continue
            }

            if ($list[$i] -eq $list[$i+1]) {
                $list[$i] = $null
                $list[$i+1] = $null
                continue
            }
            $newlist+=$list[$i]
        }
        "newlist: $newlist   length: $($newlist.Count)"
        $list=$newlist


        # $p = $list[0]
        # for ($i=1;$i -lt $list.Count;$i++)
        # {
        #     "vkey:$key  p: $p  list[$i]=$($list[$i])"
        #     if ($p -eq $list[$i]) {
        #         "ignoring $p $($list[$i])"
        #         $p=$list[$i+1]
        #         $i+=1
        #     }else {
        #         $perimTotal++
        #         $p=$list[$i]
        #     }
        #     Read-host "perimTotal: $perimTotal"
        # }
        $perimTotal += $newlist.Count/2
        Read-host "perimTotal: $perimTotal"
    }
    '~~~~~~~~~~~~~~~~~~~~~~~~'
    foreach($key in $hpoints.Keys)
    {
        "hkey: $key"
        $list = $hpoints[$key] | sort
        "list: $list"
        "list.Count: $($list.count)"

        $newlist=@()
        for($i=0;$i -lt $list.Count;$i++)
        {
            if ($null -eq $list[$i]) {
                continue
            }

            if ($list[$i] -eq $list[$i+1]) {
                $list[$i] = $null
                $list[$i+1] = $null
                continue
            }
            $newlist+=$list[$i]
        }
        "newlist: $newlist   length: $($newlist.Count)"
        $list=$newlist

        # $p = $list[0]
        # for ($i=1;$i -lt $list.Count;$i++)
        # {
        #     "hkey:$key  p: $p  list[$i]=$($list[$i])"
        #     if ($p -eq $list[$i]) {
        #         "ignoring $p $($list[$i])"
        #         $p=$list[$i+1]
        #         $i+=1
        #     }else {
        #         $perimTotal++
        #         $p=$list[$i]
        #     }
        #     Read-host "perimTotal: $perimTotal"
        # }
        $perimTotal += $newlist.Count/2
        Read-host "perimTotal: $perimTotal"
    }

    $p3=@{}
    foreach($key in $p2.Keys) {

    }

    return $perimTotal
}

$regions
"#############"
foreach($key in $regions.Keys) {
    "---------------"
    $r = $regions[$key]
    $r
    $area = $regions[$key].Count
    "area: $area"
}

#getPerimeter $regions[0]
"Result:"
$total
# answer: 1431316