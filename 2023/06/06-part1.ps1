$result = 0
$times=@()
$distances=@()
Get-Content "$PSScriptRoot\06.txt" | %{

    if ($_ -match "Time:(.*)") {
        "Time "+$Matches[1]
        $Matches[1].Split(" ", [StringSplitOptions]::RemoveEmptyEntries) | %{
            $times += [int]$_
        }
    }

    if ($_ -match "Distance:(.*)") {
        "Distance "+$Matches[1]
        $Matches[1].Split(" ", [StringSplitOptions]::RemoveEmptyEntries) | %{
            $distances += [int]$_
        }
    }
}

$times
$distances
$result = 1
for ($i=0; $i -lt $times.Length; $i++) {
    $t = $times[$i]
    "------$t"
    $dToBeat = $distances[$i]
    $numWins = 0
    for ($j=1; $j -le $t; $j++) {
        $d = $j * ($t-$j)
        if ($d -gt $dToBeat) {
            "win: $j : $d"
            $numWins++
        }
    }
    $result *= $numWins
}
"=============="
$result

#answer 840336