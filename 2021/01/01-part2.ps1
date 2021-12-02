$numbers=@()
Get-Content "$PSScriptRoot\01.txt" | %{$numbers+= [int]$_}

$prevSum=9999999999999
$numIncreased=0
for ($i=0;$i -le ($numbers.Count-3);$i++)
{
    $sum=$numbers[$i]+$numbers[$i+1]+$numbers[$i+2]
    if ($sum -gt $prevSum)
    {
        $numIncreased++
    }
    $prevSum=$sum
}
$numIncreased