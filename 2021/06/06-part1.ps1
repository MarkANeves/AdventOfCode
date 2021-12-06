$data=@()
Get-Content "$PSScriptRoot\06.txt" | %{$data+=$_}

$fish=@{}
$numFish=0
$data.Split(',') | %{$fish[$numFish++]=[int]$_}
$fish.Values -join ','
$numFish
$stopwatch =  [system.diagnostics.stopwatch]::StartNew()
for ($days=1;$days -le 80;$days++)
{
    $stopwatch.Restart()
    for ($i=$numFish-1;$i -ge 0;$i--)
    {
        $fish[$i]--;
        if ($fish[$i] -lt 0)
        {
            $fish[$i] = 6;
            $fish[$numFish++]=8
        }
    }
    "Day $days : $($fish.Count) : $($stopwatch.Elapsed.hours):$($stopwatch.Elapsed.minutes):$($stopwatch.Elapsed.seconds):$($stopwatch.Elapsed.Milliseconds)"
}
$fish.Count