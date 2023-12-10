$result = 0
$lineNum = 0

$numPositions=@()
$symbolPositions=@()

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
                "found: $($np.num)"
                $result+=$np.num
            }
        }
    }
}

"++++++++++++++"
$symbolPositions
"=============="
$result

#answer 512794