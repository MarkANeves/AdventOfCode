$total=0
$list=@()
Get-Content "$PSScriptRoot\03.txt" | %{
    $list += $_
}

foreach($line in $list)
{
    "------------------------"
    $line
    $len=$line.Length
    $max=0
    $maxPos=0
    for ($i=0; $i -lt $len-1; $i++)
    {
        $n=([int]$line[$i])-48
        if ($n -gt $max)
        {
            $max=$n
            $maxPos=$i
        }
    }
    "Max: $max at pos $maxPos"

    $max2=0
    $maxPos2=0
    for ($i=$maxPos+1; $i -lt $len; $i++)
    {
        $n=([int]$line[$i])-48
        if ($n -gt $max2)
        {
            $max2=$n
            $maxPos2=$i
        }
    }
    "Max2: $max2 at pos $maxPos2"

    $total+=($max*10)+$max2
}

"Result: $total"