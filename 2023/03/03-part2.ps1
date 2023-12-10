$result = 0
$lineNum = 0

$numPositions=@()
$symbolPositions=@()
$gears=@{}

Get-Content "$PSScriptRoot\03.txt" | %{
"-----------------"
    $line = $_
    $line
    
    $pos=0
    while ($pos -lt $line.Length)
    {
        $numStr=""
        while ($line[$pos] -ge "0" -and $line[$pos] -le "9")
        {
            $numStr+=$line[$pos++]
        }
        $numPos=$pos-$numStr.Length
        if ($numStr) {
            "$numStr : $numPos : $lineNum"
            $numPositions+=[PSCustomObject]@{
                lineNum=$lineNum
                numPos=$numPos
                len=$numStr.Length
                num=[int]$numStr
            }
        }

        if ($line[$pos] -ne "." -and $pos -lt $line.Length)
        {
            "symbol "+$line[$pos]+" : "+$pos+" : "+$lineNum
            $symbolPositions+=[PSCustomObject]@{
                lineNum=$lineNum
                pos=$pos
                sym=$line[$pos]
            }
        }

        $pos++
    }
    $lineNum++
}

foreach ($np in $numPositions)
{
    "^^^^^^"
    foreach ($sp in $symbolPositions)
    {
        if ($sp.lineNum -eq $np.lineNum -or $sp.lineNum -eq $np.lineNum+1 -or $sp.lineNum -eq $np.lineNum-1)
        {
            $spPos=$sp.pos
            $minPos = $np.numPos-1
            $maxPos = $np.numPos+$np.len

            #"symbolPos: $spPos, minPos: $minPos, maxPos: $maxPos"
            if ($spPos -ge $minPos -and $spPos -le $maxPos)
            {
                if ($sp.sym -eq "*")
                {
                    "found: $($np.num)"
                    $key="$($sp.lineNum) : $($sp.pos) : $($sp.sym)"
                    "next to $key"
                    $gears[$key] += @($np.num)
                }
            }
        }
    }
}

"++++++++++++++"
$gears.Keys | %{
    $values = $gears[$_]
    if ($values.Length -eq 2)
    {
        $result += $values[0] * $values[1]
    }
}
"=============="
$result

#answer 512794