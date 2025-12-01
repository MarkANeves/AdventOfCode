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
    $clicks = [Math]::Floor([Math]::Abs($rot/100))

    $rot = $rot % 100

    if ($dir -eq "L")
    {
        if ($p-$rot -lt 0 -and $p -ne 0) {
            $clicks++
        }
        $rot=100-$rot
    }
    else {
        if ($p+$rot -gt 100) {
            $clicks++
        }
    }
    "Clicks: $clicks"

    $p+=$rot
    $p=$p % 100
    "p: $p"
    if ($p -eq 0)
    {
        $total++
    }
    $total+=$clicks
    "total: $total"
}

"Result: $total"
# 6770