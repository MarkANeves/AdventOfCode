$rounds=@()

$scores=@{
    A=1 
    B=2 
    C=3 
    X=1 # rock
    Y=2 # paper
    Z=3 # scissors
}

$result=@{
    AX=3
    AY=6
    AZ=0
    BX=0
    BY=3
    BZ=6
    CX=6
    CY=0
    CZ=3
}

$choice=@{
    AX="Z"
    AY="X"
    AZ="Y"
    BX="X"
    BY="Y"
    BZ="Z"
    CX="Y"
    CY="Z"
    CZ="X"
}

Get-Content "$PSScriptRoot\02.txt" | %{
    $_ -match '(\S).*(\S)' | out-null
    $r = [PSCustomObject]@{
        p1 = $matches[1]
        p2 = $matches[2]
    }
    $rounds+=$r
}

$total=0
foreach($r in $rounds)
{
    $c = $choice["$($r.p1)$($r.p2)"]
    $total += $scores[$c] + $result["$($r.p1)$c"]
}
"Total"
$total