$total=0
$list1=@()
$list2=@()
Get-Content "$PSScriptRoot\01.txt" | %{
    $line = $_
    $line -match "(\d+)\s+(\d+)" | Out-Null
    $list1 += $matches[1]
    $list2 += $matches[2]
}

$list1 = $list1 | sort
$list2 = $list2 | sort

for($i=0;$i -lt $list1.count;$i++) {
    $d=[Math]::Abs($list1[$i]-$list2[$i])
    "$($list1[$i]) : $($list2[$i]) : $d"
    $total += $d
}

"Result:"
$total
