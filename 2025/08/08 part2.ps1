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
$file="08-test.txt"
$file="08.txt"
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

function Test-AnswerFound($ba,$bb,$boxes,$circuits) {
    if ($circuits.Count -ne 1) {
        return $false
    }

    foreach ($bk in $boxes.Keys) {
        if ($boxes[$bk].circuit -lt 0) {
            return $false
        }
    }
    Write-Host ''
    d $ba
    d $bb
    Write-Host "Answer: $($ba.X * $bb.X)"
    return $true
}

$circuitId=1
$circuits=@{}
for ($i=0;$i -lt $dists.Count;$i++) {
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
        if (Test-AnswerFound $boxA $boxB $boxes $circuits) {
            return
        }
    }
    elseif ($boxB.circuit -lt 0) {
        $boxB.circuit = $boxA.circuit
        $circuits[$boxA.circuit] += ,$boxB
        if (Test-AnswerFound $boxA $boxB $boxes $circuits) {
            return
        }
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
        if (Test-AnswerFound $boxA $boxB $boxes $circuits) {
            return
        }
    }
}
# 2497445
