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

function PathEnd($pathNum)
{
    $endInZ=$false
    $count=0
    $i=0

    while (-not($endInZ))
    {
        $d = $leftRight[$i]
        $count++
        $k = $paths[$pathNum]
        $node = $map[$k]
        #"count $count, path $pathNum, k $k, node $node"

        if ($d -eq "L") {
            $k = $node[0]
        }
        else {
            $k = $node[1]
        }
        #"new path $k"
        $paths[$pathNum] = $k

        if ($k[2] -eq "Z") {
            $endInZ=$true
        }
        $i++
        if ($i -eq $leftRight.Length) {
            $i=0
        }   
        #sleep 1
    }

    return $count
}

$result=[Int64]1
PathEnd(0)
PathEnd(1)
PathEnd(2)
PathEnd(3)
PathEnd(4)
PathEnd(5)


"=============="
$result

#answer 16531
# 35132135790338602601552467