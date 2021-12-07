$stopwatch =  [system.diagnostics.stopwatch]::StartNew()
$ErrorActionPreference="Stop"
$data=@()
Get-Content "$PSScriptRoot\06.txt" | %{$data+=$_}

$fish=@{}
$numFish=0
$data.Split(',') | %{$fish[$numFish++]=[int]$_}
#$fish.Values -join ','

$numDays=256

$days=@{}
for ($i=0;$i -lt $numFish;$i++)
{
    for ($d=$fish[$i]+1;$d -le $numDays;$d+=7)
    {
        $days[$d]+=1
    }
}

for ($d=1;$d -le $numDays;$d++)
{
    for ($i=$d+9;$i -le $numDays;$i+=7)
    {
        $days[$i    ] += $days[$d]
    }
}
$total=($days.Values |  measure -sum).Sum + $numFish

$stopwatch.Stop()
$total
"$($stopwatch.Elapsed.hours):$($stopwatch.Elapsed.minutes):$($stopwatch.Elapsed.seconds):$($stopwatch.Elapsed.Milliseconds)"
#for ($i=1;$i -le $numDays;$i++) { "Day $i : $($days[$i])"}
