$ErrorActionPreference="Stop"
$data=@()
Get-Content "$PSScriptRoot\15.txt" | %{$data+=$_}

$maxx=$data[0].Length
$maxy=$data.Length

$front = $null

function AddToQueue($priority,$k,$x,$y)
{
    $newitem=[PSCustomObject]@{
        priority = $priority
        x = $x
        y = $y
        next = $null
    }

    if ($null -eq $global:front) {$global:front = $newitem; return}

    $i = $global:front
    while ($null -ne $i)
    {
        if ($i.priority -ge $newitem.priority)
        {
            $newitem.next = $i
            if ($null -ne $last)
            {
                $last.next = $newitem
            }
            if ($global:front -eq $i)
            {
                $global:front = $newitem
            }
            return
        }

        $last = $i
        $i = $i.next
    }

    $last.next = $newitem
}

function PopQueue
{
    $first = $Global:front
    $global:front = $Global:front.next
    return $first
}

$dist=@{}
$weight=@{}
1..$maxy | %{
    $y = $_
    1..$maxx | %{
        $x = $_
        $k = "$x,$y"
        $dist[$k]=[int]::MaxValue
        $weight[$k]=[int]"$($data[$y-1][$x-1])"
    }
}
$dist["1,1"]=0
AddToQueue 0 "1,1" 1 1

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

$stopwatch =  [system.diagnostics.stopwatch]::StartNew()

$iterations=0
while (1)
{
    $i = PopQueue
    $x=$i.x
    $y=$i.y

    $iterations++
    if ($iterations % 1000 -eq 0) { $iterations;
        "$($stopwatch.Elapsed.hours):$($stopwatch.Elapsed.minutes):$($stopwatch.Elapsed.seconds):$($stopwatch.Elapsed.Milliseconds)"
        $stopwatch.Restart()
    }

    if ($x -eq $maxx -and $y -eq $maxy)
    {
        break;
    }

    $d = $dist["$x,$y"]
    UpdateAdjacent $dist ($x-1) $y $d $maxx $maxy
    UpdateAdjacent $dist ($x+1) $y $d $maxx $maxy
    UpdateAdjacent $dist $x ($y-1) $d $maxx $maxy
    UpdateAdjacent $dist $x ($y+1) $d $maxx $maxy
}

"Result:"
$dist["$maxx,$maxy"]