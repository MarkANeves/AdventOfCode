$total=0
$list1=@()
$list2=@()
Get-Content "$PSScriptRoot\01.txt" | %{
    $line = $_
    $line -match "(\d+)\s+(\d+)" | Out-Null
    $list1 += $matches[1]
    $list2 += $matches[2]
}

for($i=0;$i -lt $list1.count;$i++) {
    $n=[int]$list1[$i]
    $c=0
    for($j=0;$j -lt $list1.count;$j++) {
        if ($list2[$j] -eq $n)
        { $c++}
    }
    "$n appears $c times: $($n*$c)"
    $total += $n * $c
}

"Result:"
$total
