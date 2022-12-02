$rounds=@()

$scores=@{
    A=1
    B=2
    C=3
    X=1
    Y=2
    Z=3
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
    $total += $scores[$r.p2] + $result["$($r.p1)$($r.p2)"]
}
"Total"
$total