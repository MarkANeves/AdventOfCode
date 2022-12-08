$items=@{}
$listOfLetters=@()

Get-Content "$PSScriptRoot\03.txt" | %{
    $line=[string]$_
    if ($line.Length % 2 -ne 0) {throw "uneven"}
    $left = $line.Substring(0,$line.Length/2)
    $right = $line.Substring($line.Length/2)

    foreach($c in $left.ToCharArray())
    {
        if ($right.Contains($c))
        {
            if ($items.ContainsKey($c))
            {
                $items[$c]+=1
            }
            else {
                $items.Add($c,0)
            }
            $listOfLetters+=$c
            break
        }
    }
}
$listOfLetters
$sum=0
foreach ($k in $listOfLetters)
{
    $c = [int]([char]$k)-96
    if ($c -lt 0) { $c += 58}
    "$c $k"
    $sum+=$c
}
$sum
