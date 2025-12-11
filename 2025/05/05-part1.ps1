$total=0
$ranges=@()
$ids=@()
$insertRanges=$true
Get-Content "$PSScriptRoot\05.txt" | %{
    if ($_ -eq "") {
        $insertRanges=$false
    }
    elseif ($insertRanges) {
        $_ -match "^(\d+)-(\d+)$" | Out-Null
        $ranges += @{s=[long]$matches[1];e=[long]$matches[2]}
    }
    else {
        $ids += [long]$_
    }
}

foreach ($id in $ids) {
    $found=$false
    foreach ($range in $ranges) {
        if ($id -ge $range.s -and $id -le $range.e -and -not $found) {
            $found=$true
            $total++
        }
    }
}
"Total: $total"
# 775