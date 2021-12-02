$numbers=@()
Get-Content "$PSScriptRoot\01.txt" | %{$numbers+= [int]$_}

$prevNumber=99999999999
$numIncreased=0
foreach ($n in $numbers)
{
    if ($n -gt $prevNumber) { $numIncreased++}
    $prevNumber=$n
}
$numIncreased
