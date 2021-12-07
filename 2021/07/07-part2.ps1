$stopwatch =  [system.diagnostics.stopwatch]::StartNew()
$data=@()
Get-Content "$PSScriptRoot\07.txt" | %{$data+=$_}

$crabPos=@()
$data.Split(',') | %{$crabPos+=[int]$_}

$minPos = ($crabPos | measure -Minimum).Minimum
$maxPos = ($crabPos | measure -Maximum).Maximum

function Cost($d)
{
    $cost=0
    1..$d | %{$cost+=$_}
    return $cost
}

$costLookup=@()
$costLookup+=0
1..$maxPos | %{ $costLookup += Cost $_}

"$($stopwatch.Elapsed.hours):$($stopwatch.Elapsed.minutes):$($stopwatch.Elapsed.seconds):$($stopwatch.Elapsed.Milliseconds)"

$minCost=[int64]::MaxValue
$cheapestPos=$maxPos+1
for ($p=$minPos;$p -le $maxPos;$p++)
{
    $cost=0
    $crabPos | %{ $cost+= $costLookup[[Math]::Abs($_ - $p)] }
    if ($cost -lt $minCost)
    {
        $minCost=$cost
        $cheapestPos=$p
    }
}
$stopwatch.Stop()

$minCost
$cheapestPos

"$($stopwatch.Elapsed.hours):$($stopwatch.Elapsed.minutes):$($stopwatch.Elapsed.seconds):$($stopwatch.Elapsed.Milliseconds)"
