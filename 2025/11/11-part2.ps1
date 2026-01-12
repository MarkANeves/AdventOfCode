$total=0

function New-Node($name) {
    return [PSCustomObject]@{
        name = $name
        children = @()
        parents = @()
    }
}

$nodesMap=@{}

Get-Content "$PSScriptRoot\11.txt" | %{
    $_ -match '(.*):(.*)' | Out-Null
    $name=$Matches[1].Trim()
    if (-not($nodesMap.ContainsKey($name))) {
        $node = New-Node $name
        $nodesMap[$name] = $node
    }
    $node = $nodesMap[$name]
    foreach ($childName in $Matches[2].Split(' ',[System.StringSplitOptions]::RemoveEmptyEntries)) {

        if (-not($nodesMap.ContainsKey($childName))) {
            $childNode = New-Node $childName
            $nodesMap[$childName] = $childNode
        }

        $childNode = $nodesMap[$childName]
        $childNode.parents += $node
        $node.children += $childNode
    }
}

$global:iterations=0
function Traverse {
    param(
        [object]$node,
        [string]$start,
        [string]$end,
        [ref]$t,
        $visited,
        $level,
        [ref]$hits
    )

    $global:iterations++;
    if ($global:iterations % 10000 -eq 0) {
        Write-host "$global:iterations $start $end level:$level t:$($t.Value)"
    }

    # Write-Host "-----------------------------------------"
    # Write-Host "node:$($node.name) level:$level $(($visited.GetEnumerator() | Sort-Object Value | ForEach-Object Key) -join ':') $(($visited.Values | sort) -join ':')"

    if ($node.name -eq $end) {
        $levelList = ($visited.Values | sort) -join ':'
        $nodeList = ($visited.GetEnumerator() | Sort-Object Value | ForEach-Object Key) -join ':'
        Write-Host "Hit '$end' level:$level $nodeList $levelList"
        $t.Value++
        if ($null -ne $hits) {
            $hits.Value += $nodeList
        }
        #Read-Host "PressEnter"

        # if ($visited.ContainsKey("dac") -and $visited.ContainsKey("fft"))
        # {
        #     Write-Host "Hit out $($t.Value) level:$level $(($visited.GetEnumerator() | Sort-Object Value | ForEach-Object Key) -join ':') $(($visited.Values | sort) -join ':')"
        # }

        return
    }

    $visited[$node.name] = $level

    foreach($childNode in $node.children) {
        $cn = $childNode.name
        if ($cn -eq $start) {
            Write-Host "** Child is start '$start' $($t.Value) $($visited.Count)"
            return
        }
        if ($visited.ContainsKey($cn)) {
            Write-Host "Already visited $cn"
            return
        }
        $newVisited = $visited.Clone()
        $newVisited[$cn] = $level+1
        Traverse $childNode $start $end $t $newVisited ($level+1) $hits
    }
}

function TraverseUp {
    param(
        [object]$node,
        [string]$start,
        [string]$end,
        [ref]$t,
        $visited,
        $level
    )

    $global:iterations++;
    if ($global:iterations % 10000 -eq 0) {
        Write-host "$global:iterations $start $end level:$level t:$($t.Value)"
    }

#    Write-Host "-----------------------------------------"
#    Write-Host "node:$($node.name) level:$level $(($visited.GetEnumerator() | Sort-Object Value | ForEach-Object Key) -join ':') $(($visited.Values | sort) -join ':')"

    if ($node.name -eq $end) {
        Write-Host "Hit '$end' level:$level $(($visited.GetEnumerator() | Sort-Object Value | ForEach-Object Key) -join ':') $(($visited.Values | sort) -join ':')"
        $t.Value++
        #Read-Host "PressEnter"

        # if ($visited.ContainsKey("dac") -and $visited.ContainsKey("fft"))
        # {
        #     Write-Host "Hit out $($t.Value) level:$level $(($visited.GetEnumerator() | Sort-Object Value | ForEach-Object Key) -join ':') $(($visited.Values | sort) -join ':')"
        # }

        return
    }

    $visited[$node.name] = $level

    foreach($parentNode in $node.parents) {
        $pn = $parentNode.name
        if ($pn -eq $start) {
            Write-Host "** Parent is start '$start' $($t.Value) $($visited.Count)"
            return
        }
        if ($visited.ContainsKey($pn)) {
            Write-Host "Already visited $pn"
            return
        }
        $newVisited = $visited.Clone()
        $newVisited[$pn] = $level+1
        TraverseUp $parentNode $start $end $t $newVisited ($level+1)
    }
}

$total = 0
#$root = $nodesMap["svr"]
#Traverse $root "dac" ([ref]$total) @{} 0

#$root = $nodesMap["dac"]
#Traverse $root "out" ([ref]$total) @{} 0
#10425

#$start="dac"; $end="out"
#$start="dac"; $end="fft"
#$start="fft"; $end="dac"
#$start="svr"; $end="fft"
$start="svr"; $end="out"
#$start="fft"; $end="out"
$root = $nodesMap[$start]
#Traverse $root $start $end ([ref]$total) @{} 0


# $start="fft"; $end="svr";$total=0
# $root = $nodesMap[$start]
# TraverseUp $root $start $end ([ref]$total) @{} 0
# Write-Host "$start to $end = $total"
# # 5842

# $start="dac"; $end="fft";$total=0
# $root = $nodesMap[$start]
# Traverse $root $start $end ([ref]$total) @{} 0
# Write-Host "$start to $end = $total"
# # 0

# $start="dac"; $end="out";$total=0
# $root = $nodesMap[$start]
# Traverse $root $start $end ([ref]$total) @{} 0
# Write-Host "$start to $end = $total"
# # 10425

# $start="fft"; $end="dac";$total=0
# $root = $nodesMap[$start]
# Traverse $root $start $end ([ref]$total) @{} 0
# Write-Host "$start to $end = $total"

# $start="fft"; $end="out";$total=0
# $root = $nodesMap[$start]
# Traverse $root $start $end ([ref]$total) @{} 0
# Write-Host "$start to $end = $total"

# $start="dac"; $end="fft";$total=0
# $root = $nodesMap[$start]
# TraverseUp $root $start $end ([ref]$total) @{} 0
# Write-Host "$start to $end = $total"

$start="dac"; $end="out";$total=0
$root = $nodesMap[$start]
$hits=@()
Traverse $root $start $end ([ref]$total) @{} 0 ([ref]$hits)
Write-Host "$start to $end = $total"

$hit=$hits[0]
while ($hit.Length -gt 3) {
    $nodeName = $hit.Substring(3)
    $hit = $hit.Substring(0,$hit.Length-4)

    $start=$nodeName; $end="out";$total=0
    $root = $nodesMap[$start]
    Write-Host "------------------------------------"
    Write-Host "$start to $end"
    Traverse $root $start $end ([ref]$total) @{} 0
    Write-Host "$start to $end = $total"
    Read-Host "Press enter"
}

"Total: $total"

function test([ref]$x) {
    $x.Value+="Hello"
    "---"
    $x.Value
    "---"
}

$y=@()
test ([ref]$y)
$y
