$total=0

function New-Node($name) {
    return [PSCustomObject]@{
        name = $name
        children = @()
    }
}

$nodes=@()
$nodesMap=@{}

Get-Content "$PSScriptRoot\11.txt" | %{
    $_ -match '(.*):(.*)' | Out-Null
    $name=$Matches[1].Trim()
    if (-not($nodesMap.ContainsKey($name))) {
        $node = New-Node $name
        $nodes += $node
        $nodesMap[$name] = $node
    }
    $node = $nodesMap[$name]
    foreach ($child in $Matches[2].Split(' ',[System.StringSplitOptions]::RemoveEmptyEntries)) {

        if (-not($nodesMap.ContainsKey($child))) {
            $childNode = New-Node $child
            $nodes += $childNode
            $nodesMap[$child] = $childNode
        }

        $childNode = $nodesMap[$child]
        $node.children += $childNode
    }
}

function Traverse {
    param(
        [object]$node,
        [ref]$t
    )

    if ($node.name -eq "out") {
        Write-Host "Hit out"
        $t.Value++
        return
    }

    foreach($childNode in $node.children) {
        if ($childNode.name -eq "you") {
            throw "** Child is you"
        }
        Traverse $childNode $t
    }
}

$total = 0
$root = $nodesMap["you"]
Traverse $root ([ref]$total)

"Total: $total"
# 431