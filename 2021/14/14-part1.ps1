$ErrorActionPreference="Stop"
$data=@()
Get-Content "$PSScriptRoot\14.txt" | %{$data+=$_}

$pairs=@{}
foreach ($line in $data)
{
    if ($line.Length -le 0) {continue}

    if ($line -match '(\w+).*->.(\w+)')
    {
        $pairs[$Matches[1]]=$Matches[2]
    }
    else {
        $pattern = $line
    }
}

$stopwatch =  [system.diagnostics.stopwatch]::StartNew()

1..10 | %{
    $step=$_
    $i=0

    $newpattern="$($pattern[0])"
    for ($i=0;$i -lt $pattern.Length-1;$i++)
    {
        foreach ($pairkey in $pairs.Keys) {
            $p="$($pattern[$i])$($pattern[$i+1])"
            $e = $pairs[$p]
            if ($e.Length -gt 0)
            {
                $newpattern+="$e$($pattern[$i+1])"
                #"p: $p  e:$e  newpattern:$newpattern"
                break;
            }
        }
    }
    "step: $step  len:$($newpattern.Length)"
    "$($stopwatch.Elapsed.hours):$($stopwatch.Elapsed.minutes):$($stopwatch.Elapsed.seconds):$($stopwatch.Elapsed.Milliseconds)"
    $pattern=$newpattern
}

$elCount=@{}
foreach ($el in $pairs.Values)
{
    $l=$pattern.Length
    $pattern=$pattern.Replace($el,"")
    $c = $l-$pattern.Length
    if ($c -gt 0){
        $elCount[$el]=$c
    }
}
$max=($elCount.Values | measure -Maximum).Maximum
$min=($elCount.Values | measure -Minimum).Minimum

$max-$min
"$($stopwatch.Elapsed.hours):$($stopwatch.Elapsed.minutes):$($stopwatch.Elapsed.seconds):$($stopwatch.Elapsed.Milliseconds)"
