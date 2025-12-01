$total=0
$list=@()
Get-Content "$PSScriptRoot\01.txt" | %{
    $list += $_
}

$p=50
foreach($line in $list)
{
    "------------------------"
    $dir=$line[0]
    $rot = [int]($line.Substring(1))
    $line
    "d: $dir, rot = $rot"
    $rot = $rot % 100
    if ($dir -eq "L")
    {
        $rot=100-$rot
    }
    $p+=$rot
    $p=[Math]::Abs($p % 100)
    "p: $p"
    if ($p -eq 0)
    {
        $total++
    }
}

"Result: $total"
# 1195
