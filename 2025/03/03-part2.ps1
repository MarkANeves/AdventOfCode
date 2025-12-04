$total=0
$list=@()
Get-Content "$PSScriptRoot\03.txt" | %{
    $list += $_
}

foreach($line in $list)
{
    $len=$line.Length
    $nums=""
    $numsCount=0
    $maxPos=-1
    while ($numsCount -lt 12)
    {
        $max=0
        for ($i=$maxPos+1; $i -le $len-(12-$numsCount); $i++)
        {
            $n=([int]$line[$i])-48
            if ($n -gt $max)
            {
                $max=$n
                $maxPos=$i
            }
        }
        $nums += $max
        $numsCount++
    }
    $total+=[long]$nums
}

"Result: $total"
# 169347417057382
