$ErrorActionPreference="Stop"
$data=@()
Get-Content "$PSScriptRoot\14.txt" | %{$data+=$_}

$elMap=@{}
foreach ($line in $data)
{
    if ($line.Length -le 0) {continue}

    if ($line -match '(\w+).*->.(\w+)')
    {
        $elMap[$Matches[1]]=$Matches[2]
    }
    else {
        $pattern = $line
    }
}

$pairs=@{}
$letters=@{}
$letters["$($pattern[0])"]=1
1..($pattern.Length-1) | %{
    $i=$_
    $letters["$($pattern[$i])"]+=1
    $pairs["$($pattern[$i-1])$($pattern[$i])"]+=1
}
$pattern
$letters | ft -AutoSize
$pairs | ft -AutoSize

$stopwatch =  [system.diagnostics.stopwatch]::StartNew()

1..40 | %{
    $step=$_

    $newPairs=$pairs.Clone()

    foreach ($k in $pairs.Keys)
    {
        $kn = $pairs[$k]

        if ($kn -le 0) {continue}

        $el = $elMap[$k]

        $newPair1="$($k[0])$el"
        $newPair2="$el$($k[1])"

        $letters[$el]+=$kn
        $newPairs[$newPair1]+=$kn
        $newPairs[$newPair2]+=$kn
        $newPairs[$k]-=$kn
    }
    $pairs = $newPairs
}
"----------------"
$pairs | ft -AutoSize
$letters | ft -AutoSize

$max=($letters.Values | measure -Maximum).Maximum
$min=($letters.Values | measure -Minimum).Minimum

$max-$min
"$($stopwatch.Elapsed.hours):$($stopwatch.Elapsed.minutes):$($stopwatch.Elapsed.seconds):$($stopwatch.Elapsed.Milliseconds)"

