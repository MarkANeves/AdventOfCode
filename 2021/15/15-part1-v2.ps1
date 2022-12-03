$ErrorActionPreference="Stop"
$data=@()
Get-Content "$PSScriptRoot\15.txt" | %{$data+=$_}

$maxx=$data[0].Length
$maxy=$data.Length

$sptSet=@{}
$dist=@{}

$notInSptSet=@{}

$weight=@{}
1..$maxy | %{
    $y = $_
    1..$maxx | %{
        $x = $_
        $dist["$x,$y"]=[int]::MaxValue
        $weight["$x,$y"]=[int]"$($data[$y-1][$x-1])"
       
        $notInSptSet["$x,$y"]=[PSCustomObject]@{
            x = $x
            y = $y
        }
    }
}
$dist["1,1"]=0

function UpdateAdjacent($dist,$x,$y,$d,$maxx,$maxy)
{
    if ($x -ge 1 -and $x -le $maxx -and $y -ge 1 -and $y -le $maxy)
    {
        $v = $dist["$x,$y"]
        $sum = $d + $weight["$x,$y"]
        if ($sum -lt $v)
        {
            $dist["$x,$y"] = $sum
        }
    }
}

$stopwatch =  [system.diagnostics.stopwatch]::StartNew()

while (1)
{
    $min = [int]::MaxValue
    $fx=$fy=-1

    foreach ($k in $notInSptSet.Keys)
    {
        if (-not($sptSet.ContainsKey($k))) {
            if ($dist[$k] -le $min)
            {
                $v = $notInSptSet[$k]
                $fx=$v.x;$fy=$v.y;$min=$dist[$k]
            }
        }   
    }

    #"fx:$fx  fy:$fy"
    #$dist

    $sptSet["$fx,$fy"]=1
    $notInSptSet.Remove("$fx,$fy")
    #$weight["$fx,$fy"]
    if ($sptSet.Count % 100 -eq 0) { $sptSet.Count;
        "$($stopwatch.Elapsed.hours):$($stopwatch.Elapsed.minutes):$($stopwatch.Elapsed.seconds):$($stopwatch.Elapsed.Milliseconds)"
        $stopwatch.Restart()
    }

    if ($fx -eq $maxx -and $fy -eq $maxy)
    {
        break;
    }

    $d = $dist["$fx,$fy"]
    UpdateAdjacent $dist ($fx-1) $fy $d $maxx $maxy
    UpdateAdjacent $dist ($fx+1) $fy $d $maxx $maxy
    UpdateAdjacent $dist $fx ($fy-1) $d $maxx $maxy
    UpdateAdjacent $dist $fx ($fy+1) $d $maxx $maxy

    if ($sptSet.Count -eq ($maxx*$maxy))
    { break }
}

$dist["$maxx,$maxy"]