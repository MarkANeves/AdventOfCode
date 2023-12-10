$result = 0
$times=@()
$distances=@()
Get-Content "$PSScriptRoot\06.txt" | %{

    if ($_ -match "Time:(.*)") {
        "Time "+$Matches[1].Replace(" ", "")
        $Matches[1].Replace(" ", "").Split(" ", [StringSplitOptions]::RemoveEmptyEntries) | %{
            $times += [int64]$_
        }
    }

    if ($_ -match "Distance:(.*)") {
        "Distance "+$Matches[1].Replace(" ", "")
        $Matches[1].Replace(" ", "").Split(" ", [StringSplitOptions]::RemoveEmptyEntries) | %{
            $distances += [int64]$_
        }
    }
}

$times
$distances
$result = 1
for ($i=0; $i -lt $times.Length; $i++) {
    $t = $times[$i]
    #"------$t"
    $dToBeat = $distances[$i]
    $numWins = 0
    for ($j=1; $j -le $t; $j++) {
        if ($j % 100000 -eq 0) {
            "$j : $($j/$t)"
        }
        $d = $j * ($t-$j)
        if ($d -gt $dToBeat) {
            #"win: $j : $d"
            $numWins++
        }
    }
    $result *= $numWins
}
"=============="
$result

#answer 840336