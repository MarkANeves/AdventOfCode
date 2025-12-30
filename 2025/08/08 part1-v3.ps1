$total=0

# create a 3d vector
function New-JunctionVox($X, $Y, $Z, $circuit) {
    return [PSCustomObject]@{
        K = "$X,$Y,$Z"
        X = [long]$X
        Y = [long]$Y
        Z = [long]$Z
        circuit = $circuit
    }
}

function Get-DistanceBetween($a,$b) {
    return [math]::Sqrt(([math]::Pow(($a.X - $b.X),2) + [math]::Pow(($a.Y - $b.Y),2) + [math]::Pow(($a.Z - $b.Z),2)))
}

function d($b) {
    Write-Host "K:$($b.K) X:$($b.X) Y:$($b.Y) Z:$($b.Z) c:$($b.circuit)"
}

$circuitId=-1
$boxes=@{}
$numToCheck=10;$file="08-test.txt"
$numToCheck=1000;$file="08.txt"
Get-Content "$PSScriptRoot\$file" | %{
    $_ -match "^(\d+),(\d+),(\d+)$" | Out-Null
    $box = New-JunctionVox -X $matches[1] -Y $matches[2] -Z $matches[3] -circuit $circuitId
    $boxes[$box.K] = $box
    $circuitId--
}

$dists=@{}
foreach ($keyA in $boxes.Keys) {
    Write-Host '.' -NoNewline
    $boxA = $boxes[$keyA]
    foreach ($keyB in $boxes.Keys) {
        if ($keyA -ne $keyB) {
            $boxB = $boxes[$keyB]
            $dist = Get-DistanceBetween $boxA $boxB
            $dists[$dist] = "$($boxA.K)|$($boxB.K)"
        }
    }
}
$sortedKeys = $dists.Keys | %{ [double]$_ } | sort    
Write-Host ''
Write-Host 'SortedKeys'

$circuitId=1
$circuits=@{}
for ($i=0;$i -lt $numToCheck;$i++) {
    Write-Host '.' -NoNewline
    $combo = $dists[$sortedKeys[$i]]
    $boxKeys = $combo.split('|')
    $boxA = $boxes[$boxKeys[0]]
    $boxB = $boxes[$boxKeys[1]]

    if ($boxA.circuit -lt 0 -and $boxB.circuit -lt 0) {
        $boxA.circuit = $circuitId
        $boxB.circuit = $circuitId
        $circuits[$circuitId] += ,$boxA
        $circuits[$circuitId] += ,$boxB
        $circuitId++
    }
    elseif ($boxA.circuit -lt 0) {
        $boxA.circuit = $boxB.circuit
        $circuits[$boxB.circuit] += ,$boxA
    }
    elseif ($boxB.circuit -lt 0) {
        $boxB.circuit = $boxA.circuit
        $circuits[$boxA.circuit] += ,$boxB
    }
    elseif ($boxA.circuit -eq $boxB.circuit) {
        # Write-Host "Same circuit, do nothing"
    }
    else {
        $cA = $boxA.circuit
        $cB = $boxB.circuit
        foreach($b in $circuits[$cA]) {
            $circuits[$cB] += ,$b
            $b.circuit = $cB
        }
        $circuits.Remove($cA)
    }
}
Write-Host ''

$counts = @()
foreach($k in $circuits.Keys) {
    Write-Host "k: $k - $($circuits[$k].Count)"
    $counts += $circuits[$k].Count
}

$total=1
$counts | sort -Descending | select -First 3 | %{ Write-Host $_;$total *= $_}

"Total: $total"
# 5130 - too low
# 38874 - too low!
# 131150 - the right answer!