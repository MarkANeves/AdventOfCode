$data=@()
Get-Content "$PSScriptRoot\07.txt" | %{$data+=$_}

$crabPos=@()
$data.Split(',') | %{$crabPos+=[int]$_}

$minPos = ($crabPos | measure -Minimum).Minimum
$maxPos = ($crabPos | measure -Maximum).Maximum

$minCost=999999
$cheapestPos=$maxPos+1
for ($p=$minPos;$p -le $maxPos;$p++)
{
    $cost=0
    $crabPos | %{ $cost+= [Math]::Abs($_ - $p) }
    if ($cost -lt $minCost)
    {
        $minCost=$cost
        $cheapestPos=$p
    }
}
$minCost
$cheapestPos
