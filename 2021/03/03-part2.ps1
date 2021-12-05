$binStrs=@()
Get-Content "$PSScriptRoot\03.txt" | %{$binStrs+=$_}

$binNums=@()
$binStrs | %{$binNums+=[convert]::ToInt32($_,2)}

#$numNumbers = $binStrs.Count
$maxBits =($binStrs | %{$_.Length} | measure -Maximum).Maximum

function RemoveForOxygenGeneratorRating($nums,$mask)
{
    $nums | % {if ($_ -band $mask) { $numOnes++}else{$numZeros++}}
    if ($numOnes -ge $numZeros) {$v=$mask}else{$v=0}

    $newNums=@()
    $nums | % {
        if (($_ -band $mask) -eq $v) { 
            $newNums+=$_
        }
    }
    return $newNums
}

for ($p=$maxBits-1;$p -ge 0 -and $binNums.Count -gt 1;$p--)
{
    $binNums=RemoveForOxygenGeneratorRating $binNums ([Math]::Pow(2,$p))
    #"------"
    #$binNums|%{[convert]::ToString($_,2)}
}
$oxygenGeneratorRating=$binNums[0]
$oxygenGeneratorRating

$binNums=@()
$binStrs | %{$binNums+=[convert]::ToInt32($_,2)}

function RemoveForCO2ScrubberRating($nums,$mask)
{
    $nums | % {if ($_ -band $mask) { $numOnes++}else{$numZeros++}}
    if ($numOnes -ge $numZeros) {$v=0}else{$v=$mask}

    $newNums=@()
    $nums | % {
        if (($_ -band $mask) -eq $v) { 
            $newNums+=$_
        }
    }
    return $newNums
}

for ($p=$maxBits-1;$p -ge 0 -and $binNums.Count -gt 1;$p--)
{
    $binNums=RemoveForCO2ScrubberRating $binNums ([Math]::Pow(2,$p))
    #"------"
    #$binNums|%{[convert]::ToString($_,2)}
}
$CO2ScrubberRating=$binNums[0]
$CO2ScrubberRating

"Life support rating: $($oxygenGeneratorRating*$CO2ScrubberRating)"