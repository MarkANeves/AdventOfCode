$ErrorActionPreference="stop"
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

$paths=@()
$map.Keys | %{
    $k = $_
    if ($k[2] -eq "A") {
        $paths += $k
    }
}
$paths
"num paths = $($paths.Length)"
$i=0
$end=$false
while (-not($end))
{
    #"----------------------------"
    if ($result % 100000 -eq 0) {
        "$result"
    }
    $result++
    $endInZ=0
    $d = $leftRight[$i]
    for ($j=0; $j -lt $paths.Length; $j++)
    {
        $k = $paths[$j]
        #"path $j $k"
        $node = $map[$k]

        if ($d -eq "L") {
            $k = $node[0]
        }
        else {
            $k = $node[1]
        }
        #"new path $k"
        $paths[$j] = $k

        if ($k[2] -eq "Z") {
            $endInZ++
        }
    }
    #"endInZ $endInZ"

    if ($endInZ -eq $paths.Length) {
        $end=$true
    }

    $i++
    if ($i -eq $leftRight.Length) {
        $i=0
    }   
    #sleep 1
}


"=============="
$result

#answer 16531