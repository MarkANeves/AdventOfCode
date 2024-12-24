function readhost($s)
{
    #Read-Host $s | Out-Null
}

function w($s)
{
   # Write-Host $s
}
function w2($s)
{
   Write-Host $s
}

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
$designs = $designs | sort
$designs
"--------"
$patterns

$maxLen=0

$designsLenMap=@{}
for($i=0;$i -lt $designs.Count;$i++) {
    $len = $designs[$i].Length
    if (-not($designsLenMap.ContainsKey($len))) {
        $designsLenMap[$len] = @()
    }
    $designsLenMap[$len] += $designs[$i]
    if ($len -gt $maxLen) {
        $maxLen = $len
    }
}

function countdeisgnsMap {
    $c=0
    foreach($k in $designsLenMap.Keys) {
        $c += $designsLenMap[$k].Count
    }
    return $c
}

$designsLenMap
Write-Host "Designs len map count: $(countdeisgnsMap)"
read-Host "DesignsLenMap"

# for each design shorter that the origin in length order
#   split each split node by the design, removing blanks
#    add to split nodes
# Is list of split nodes empty?
# if yes it can be made up of other 

function canBeMade($design,$designsLenMap) {
    w "-----------"
    w "canBeMade $design"
    $len = $design.Length
    #if ($len -gt $maxLen) {
    #    $len = $maxLen+1
    #}
    $totalSplits=@()
    $totalSplits+=$design

    for ($l=$len-1;$l -gt 0;$l--) {
        $dOfLen = $designsLenMap[$l]
        w "Designs of length $l : $dOfLen"
        foreach ($d in $dOfLen) {
            $newSplits=@()
            $dlen = $d.Length
            foreach($splitNode in $totalSplits) {
                w "Current split node: $splitNode"
                $splitNodeLen = $splitNode.Length

                #if ($splitNodeLen -ge $dlen) {
                    $splits = $splitNode.Split($d,[System.StringSplitOptions]::RemoveEmptyEntries)
                #}
                #else {
                #    w "***** Skipping split"
                #    $splits = $splitNode
                #}
                w "$splitNode splits with $d into $splits"
                foreach($s in $splits) {
                    $newSplits += $s
                }
                readHost "Next split node"
            }
            $totalSplits = $newSplits
            w "Current total split nodes: $totalSplits"
        }
        readHost "Next len"
    }

    $numSplits = $totalSplits.Count
    w2 "Final total splits ($numSplits): $totalSplits"

    readHost "Finished splitting"
    return ($numSplits -eq 0)
}

# foreach($k in $designsLenMap.Keys | sort -Descending) {
#     foreach($d in $designsLenMap[$k]) {
#         w "++++++++ Design"
#         "d: $d"
#         $r = canBeMade $d $designsLenMap
#         if ($r)
#         {
#             "+++++++++++++++++++++"
#             $len = $d.Length
#             "Removing $d (len:$len) from $($designsLenMap[$len])"
#             "Before"
#             $designsLenMap[$len]
#             "After"
#             $dlist = $designsLenMap[$len]
#             $newdlist=@()
#             for ($i=0;$i -lt $dlist.Length;$i++)
#             {
#                 if ($dlist[$i] -ne $d) {
#                     $newdlist += $dlist[$i]
#                 }
#             }
#             $designsLenMap[$len] = $newdlist
#             $designsLenMap[$len]
#             readHost "Just removed $d from map"
#         }
#         else {
#             w "$d CAN NOT BE REMOVED!"
#         }
#     }
# }

"-----------------"
"-----------------"
"-----------------"
"new designs Len Map"
$designsLenMap
Write-Host "Designs len map count: $(countdeisgnsMap)"
Read-Host "DESIGNS REDUCED"

foreach($p in $patterns) {
    read-Host "Next pattern"
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
# 225 too low