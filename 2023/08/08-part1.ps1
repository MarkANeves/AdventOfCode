$result = 0

$lineNum=0
$map=@{}
Get-Content "$PSScriptRoot\08.txt" | %{
    $line = $_
    #$line
    $lineNum++

    if ($lineNum -eq 1) {
        $leftRight = $line
    }

    if ($line -match "(...) = \((...), (...)")
    {
        $k = $Matches[1]
        $l = $Matches[2]
        $r = $Matches[3]
        $map[$k] = @($l, $r)
    }
}

$i=0
$end=$false
$k="AAA"
while (-not($end))
{
    $result++
    $node = $map[$k]
    $d = $leftRight[$i]

    if ($d -eq "L") {
        $k = $node[0]
    }
    else {
        $k = $node[1]
    }
    if ($k -eq "ZZZ") {
        $end=$true
    }

    $i++
    if ($i -eq $leftRight.Length) {
        $i=0
    }
}


"=============="
$result

#answer 16531