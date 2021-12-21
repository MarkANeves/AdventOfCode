$ErrorActionPreference="Stop"
$overallStopwatch =  [system.diagnostics.stopwatch]::StartNew()
$data=@()
Get-Content "$PSScriptRoot\15.txt" | %{$data+=$_}

$maxx=$data[0].Length
$maxy=$data.Length

$queue = $null

function AddToQueue($priority,$k,$x,$y)
{
    $newitem=[PSCustomObject]@{
        priority = $priority
        k = $k
        x = $x
        y = $y
        next = $null
        prev = $null
    }

    if ($null -eq $global:queue) {$global:queue = $newitem; return}

    $i = $global:queue
    $last
    while ($null -ne $i)
    {
        if ($i.priority -ge $newitem.priority)
        {
            $newitem.next = $i
            if ($null -ne $i.prev)
            {
                $newitem.prev = $i.prev
                $i.prev.next = $newitem
            }
            $i.prev = $newitem
            if ($null -eq $newitem.prev)
            {
                $global:queue = $newitem
            }
            return
        }

        $last = $i
        $i = $i.next
    }

    $last.next = $newitem
    $newitem.prev = $last
}

function PopQueue
{
    $i = $Global:queue
    $global:queue = $Global:queue.next
    if ($null -ne $Global:queue.prev)
    {
        $Global:queue.prev = $null
    }
    return $i
}

$dist=@{}
$weight=@{}
1..$maxy | %{
    $y = $_
    1..$maxx | %{
        $x = $_

        $w=[int]"$($data[$y-1][$x-1])"
        $k = "$x,$y"
        $dist[$k]=[int]::MaxValue
        $weight[$k]=$w

        if ($k -eq "1,1"){
            AddToQueue 0 "1,1" $x $y
        }
        else {
            AddToQueue $([int]::MaxValue) "$x,$y" $x $y
        }
    }
}
$dist["1,1"]=0

function DuplicatePos($x,$y)
{
    $x1 = $x- ( [Math]::Floor(($x-1) / $maxx)*$maxx )
    $y1 = $y- ( [Math]::Floor(($y-1) / $maxy)*$maxy )

    $w=[int]"$($data[$y1-1][$x1-1])"

    $fx = [Math]::Floor(($x-1)/$maxx)
    $fy = [Math]::Floor(($y-1)/$maxy)

    $w1 = $w + $fx + $fy
    while($w1 -gt 9) { $w1 -= 9}

    $k = "$x,$y"
    $dist[$k]=[int]::MaxValue
    $weight[$k]=$w1
    AddToQueue $([int]::MaxValue) "$x,$y" $x $y
}

1..($maxy*5) | %{
    $y = $_
    "y=$y"
    1..($maxx*5) | %{
        $x = $_
        if ($x -gt 10 -or $y -gt 10) {
            DuplicatePos $x $y
        }
    }
}

$maxx*=5
$maxy*=5

function UpdateAdjacent($dist,$x,$y,$d,$maxx,$maxy)
{
    if ($x -ge 1 -and $x -le $maxx -and $y -ge 1 -and $y -le $maxy)
    {
        $k = "$x,$y"
        $v = $dist[$k]
        $sum = $d + $weight[$k]
        if ($sum -lt $v)
        {
            $dist[$k] = $sum
            AddToQueue $sum $k $x $y
        }
    }
}

function DisplayStopwatch($msg,$sw)
{
    "$msg : $($sw.Elapsed.hours):$($sw.Elapsed.minutes):$($sw.Elapsed.seconds):$($sw.Elapsed.Milliseconds)"
}

DisplayStopwatch "Set up time" $overallStopwatch

$stopwatch  =  [system.diagnostics.stopwatch]::StartNew()

$iterations=0
while (1)
{
    $i = PopQueue
    $x=$i.x
    $y=$i.y

    $iterations++
    if ($iterations % 1000 -eq 0) { $iterations;
        DisplayStopwatch "Time for 1000 iterations" $stopwatch
        DisplayStopwatch "Overall time            " $overallStopwatch
        $stopwatch.Restart()
    }

    if ($x -eq $maxx -and $y -eq $maxy)
    {
        "Found end pos"
        break;
    }

    $d = $dist["$x,$y"]
    UpdateAdjacent $dist ($x-1) $y $d $maxx $maxy
    UpdateAdjacent $dist ($x+1) $y $d $maxx $maxy
    UpdateAdjacent $dist $x ($y-1) $d $maxx $maxy
    UpdateAdjacent $dist $x ($y+1) $d $maxx $maxy
}

"Result"
$dist["$maxx,$maxy"]

DisplayStopwatch "Total time" $overallStopwatch

#Answer: 2885
