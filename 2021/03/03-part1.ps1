$binStrs=@()
Get-Content "$PSScriptRoot\03.txt" | %{$binStrs+=$_}

$binNums=@()
$binStrs | %{$binNums+=[convert]::ToInt32($_,2)}

$numNumbers = $binStrs.Count
$maxBits =($binStrs | %{$_.Length} | measure -Maximum).Maximum

$gamma=0
for ($p=0;$p -lt $maxBits;$p++)
{
    $mask=[Math]::Pow(2,$p)
    $bitTotal=0;
    $binNums | %{if ($_ -band $mask){$bitTotal++}}
    if ($bitTotal -ge ($numNumbers/2))
    {
        $gamma += $mask
    }
}
$epsilon=$gamma -bxor [Math]::Pow(2,$maxBits)-1  

"gamma: $gamma, $([convert]::ToString($gamma,2))"
"epsilon: $epsilon, $([convert]::ToString($epsilon,2))"
"Power consumption: $($gamma * $epsilon)"