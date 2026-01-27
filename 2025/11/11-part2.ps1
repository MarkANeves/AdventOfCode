$total=0

function New-Node($name) {
    return [PSCustomObject]@{
        name = $name
        children = @()
        parents = @()
    }
}

$nodesMap=@{}

function ReadInput([ref]$nodesMap) {
    $nm=@{}
    Get-Content "$PSScriptRoot\11.txt" | %{
        $_ -match '(.*):(.*)' | Out-Null
        $name=$Matches[1].Trim()
        if (-not($nm.ContainsKey($name))) {
            $node = New-Node $name
            $nm[$name] = $node
        }
        $node = $nm[$name]
        foreach ($childName in $Matches[2].Split(' ',[System.StringSplitOptions]::RemoveEmptyEntries)) {

            if (-not($nm.ContainsKey($childName))) {
                $childNode = New-Node $childName
                $nm[$childName] = $childNode
            }

            $childNode = $nm[$childName]
            $childNode.parents += $node
            $node.children += $childNode
        }
    }
    $nodesMap.Value = $nm
}

ReadInput ([ref]$nodesMap)

function RemoveChildNode([ref]$nmap,$nodeName,$childName) {
    #nodeName: $nodeName, childName: $childName"
    $newChildren=@()
    foreach($c in $nmap.Value[$nodeName].children) {
        #"c.name: $($c.name)"
        if ($c.name -ne $childName) {
            #"Adding to child list"
            $newChildren += $c
        }
    }

    $nmap.Value[$nodeName].children = $newChildren
}

function RemoveNodeFromMap([ref]$nmap,$nodeName) {
    #"======================================"
    #"Removing $nodeName from nmap"
    #$parentList = $nmap.Value[$nodeName].parents.name -join ','
    #"Parents: $parentList"
    foreach($p in $nmap.Value[$nodeName].parents) {
        if ($nmap.Value.ContainsKey($p.name )) {
            RemoveChildNode $nmap $p.name $nodeName
        }
    }
    $nodesMap.Remove($nodeName)
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
    if ($global:iterations % 100000 -eq 0) {
        Write-Host '.' -NoNewline
    }
    if ($global:iterations % 1000000 -eq 0) {
        Write-host "`nIteration: $global:iterations $start $end level:$level t:$($t.Value)"
        $levelList = ($visited.Values | sort) -join ':'
        $nodeList = ($visited.GetEnumerator() | Sort-Object Value | ForEach-Object Key) -join ':'
        Write-Host "Node name:$($node.name) level:$level $nodeList $levelList"
    }

    # Write-Host "-----------------------------------------"
    # Write-Host "node:$($node.name) level:$level $(($visited.GetEnumerator() | Sort-Object Value | ForEach-Object Key) -join ':') $(($visited.Values | sort) -join ':')"

    if ($node.name -eq $end) {
        $levelList = ($visited.Values | sort) -join ':'
        $nodeList = ($visited.GetEnumerator() | Sort-Object Value | ForEach-Object Key) -join ':'
        #Write-Host "Hit '$end' level:$level $nodeList $levelList"
        $t.Value++
        if ($null -ne $hits) {
            $hits.Value += $nodeList
        }
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
            #Write-Host "$cn can reach $end"
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
        #Write-Host "Hit '$end' level:$level $(($visited.GetEnumerator() | Sort-Object Value | ForEach-Object Key) -join ':') $(($visited.Values | sort) -join ':')"
        $t.Value++
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
Read-Host "Data read"

$timer = [Diagnostics.Stopwatch]::StartNew()
$totals=@()

# Count the routes from svr to fft, but go up the tree as it's quicker
$total = 0
$start="fft"; $end="svr";$total=0
$root = $nodesMap[$start]
TraverseUp $root $start $end ([ref]$total) @{} 0
Write-Host "$start to $end = $total" -ForegroundColor Green
$totals+=$total
# 5842

# This proves you can't get to fft from dac
# $start="dac"; $end="fft";$total=0
# $root = $nodesMap[$start]
# Traverse $root $start $end ([ref]$total) @{} 0
# Write-Host "$start to $end = $total"
# # 0

# Find out how many routes from dac to out
$total = 0
$start="dac"; $end="out";$total=0
$root = $nodesMap[$start]
Traverse $root $start $end ([ref]$total) @{} 0
Write-Host "$start to $end = $total" -ForegroundColor Green
$totals+=$total
# 10425

function Ancestors($node,[ref]$ancestors) {
    if ($node.parents.Count -lt 1) {
        return
    }

    foreach ($p in $node.parents) {
        if (-not($ancestors.Value.Contains($p.name))) {
            $ancestors.Value += $p.name
            Ancestors $p $ancestors
        }
    }
}

# Find all the nodes that can reach dac, and then delete the nodes that can't
$dacAncestors=@()
$node = $nodesMap["dac"]
$dacAncestors += "dac"
Ancestors $node ([ref]$dacAncestors)

$keys = $nodesMap.Keys | sort
foreach($nk in $keys)
{
    if (-not($dacAncestors.Contains($nk)))
    {
        #Write-Host "Deleting $nk"
        RemoveNodeFromMap ([ref]$nodesMap) $nk
    }
}

# Now we have far less nodes, this is actually doable with brute force
# Count routes from fft to dac
$start="fft"; $end="dac";$total=0
$root = $nodesMap[$start]
Traverse $root $start $end ([ref]$total) @{} 0
Write-Host "$start to $end = $total" -ForegroundColor green
$totals+=$total
# 5885737

$timer.Stop()
$e = $timer.Elapsed
"Took $($e.Hours):$($e.Minutes):$($e.Seconds)"
#Took 0:41:21

# Multiply the three results together
$total=1;$totals | %{$total*=$_}
"Total: $total"
# Answer: 358458157650450
