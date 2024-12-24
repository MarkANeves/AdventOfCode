
$total=[int64]0

$designs=@()
$patterns=@()

Get-Content "$PSScriptRoot\19.txt" | %{
    $line = $_

    if ($line.Contains(','))
    {
        $designs = $line.split(",",[System.StringSplitOptions]::RemoveEmptyEntries)
        for($i=0;$i -lt $designs.Count;$i++)
        {
            $designs[$i] = $designs[$i].Trim()
        }
    }

    if (-not($line.Contains(',')) -and $line.Length -gt 0)
    {
        $patterns += $line
    }
}
$designs
"--------"
$patterns

$designsLenMap=@{}
for($i=0;$i -lt $designs.Count;$i++) {
    $len = $designs[$i].Length
    if (-not($designsLenMap.ContainsKey($len))) {
        $designsLenMap[$len] = @()
    }
    $designsLenMap[$len] += $designs[$i]
}

$designsLenMap
Read-Host "DesignsLenMap"

function canBeMade($design,$designsLenMap) {
    Write-Host "-----------"
    Write-Host "canBeMade $design"
    $len = $design.Length
    for ($i=$len-1;$i -gt 0;$i--)
    {
        foreach($d in $designsLenMap[$i]) {
            Write-Host "Removing($i) '$d'  p: $design"
            $design = $design.Replace($d,"")
            Write-Host "Removed '$d'  p: $design"
            #Read-Host "Replaced" | out-null

            if ($design.Length -eq 0 ) {
                #Read-Host "Can be made" | out-null
                return $true
            }
        }
    }
    #Read-Host "Cannot be made" | Out-Null
    return $false
}

foreach($d in $designs) {
    "d: $d"
    $r = canBeMade $d $designsLenMap
    if ($r)
    {
        "+++++++++++++++++++++"
        $len = $d.Length
        "Removing $d (len:$len) from $($designsLenMap[$len])"
        "Before"
        $designsLenMap[$len]
        "After"
        $dlist = $designsLenMap[$len]
        $newdlist=@()
        for ($i=0;$i -lt $dlist.Length;$i++)
        {
            if ($dlist[$i] -ne $d) {
                $newdlist += $dlist[$i]
            }
        }
        $designsLenMap[$len] = $newdlist
        $designsLenMap[$len]
        Read-Host "Just removed $d from map"
    }

}
"-----------------"
"new designs Len Map"
$designsLenMap

foreach($p in $patterns) {
    Read-Host "Next pattern"
    "~~~~~~~~~"
    "Testing $p"
    if (canBeMade $p $designsLenMap) {
        "YES"
        $total++
    }
    else {
        "NO"
    }
}

"Result:"
$total
# answer: 
# 372 too high