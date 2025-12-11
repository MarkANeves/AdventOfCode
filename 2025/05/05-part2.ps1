$total=0
$ranges=@()
$processRange=$true
Get-Content "$PSScriptRoot\05.txt" | %{
    if ($_ -eq "") {
        $processRange=$false
    }
    if ($processRange) {
        $_ -match "^(\d+)-(\d+)$" | Out-Null
        $ranges += @{s=[long]$matches[1];e=[long]$matches[2]}
    }
}

function mergeRanges($r1, $r2) {
    if ($r2.e -lt $r1.s -or $r2.s -gt $r1.e) {
        return $null
    }

    $newr = @{s = [long][Math]::Min($r1.s, $r2.s); e = [long][Math]::Max($r1.e, $r2.e)}
    return $newr
}

function displayRanges($ranges)
{
    foreach ($r in $ranges) {
        "s: $($r.s) e: $($r.e)"
    }
}

$newRanges=@()
$merged=$true
while ($merged)
{
    $merged = $false
    for ($i=0;$i -lt $ranges.Count;$i++) {
        for ($j=0;$j -lt $ranges.Count;$j++) {
            if ($i -eq $j) {
                continue
            }
            if ($ranges[$i].s -eq -1 -or $ranges[$j].s -eq -1)
            {
                continue
            }
            $mr = mergeRanges $ranges[$i] $ranges[$j]
            if ($null -ne $mr) {
                $newRanges += $mr
                $merged = $true
                # These two have merged into a new range, so remove them
                $ranges[$i] = @{s=-1;e=-1}
                $ranges[$j] = @{s=-1;e=-1}
            }
        }
        if ($ranges[$i].s -ge 0) {
            # Didn't get merged so keep it
            $newRanges += $ranges[$i]
        }
        # Remove from next iteration
        $ranges[$i] = @{s=-1;e=-1}
    }
    $ranges = $newRanges
    $newRanges=@()
}
displayRanges $ranges
foreach ($r in $ranges) {
    $total+= ($r.e - $r.s) +1
}
"Total: $total"
# 350684792662845