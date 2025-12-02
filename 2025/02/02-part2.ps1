$total=[long]0
$content = Get-Content "$PSScriptRoot\02.txt"

$list=@()
$content.Split(",") | %{
    $list += $_.Trim()
}

function Test-Chunk($n,$s)
{
    #Write-Host "========================"
    $prevChunk = -1
    while ($n -gt 0)
    {
        $pw10 = [Math]::Pow(10,$s)
        #Write-Host " Pow10: $pw10"
        $chunk = $n % $pw10
        #Write-Host " Chunk: $chunk"
        $n = [long][Math]::Floor($n / $pw10)

        if ($prevChunk -ne -1)
        {
            if ($chunk -ne $prevChunk)
            {
                return 0
            }
        }
        $prevChunk = $chunk
    }
    if ($prevChunk.ToString().Length -ne $s)
    {
        return 0
    }
    return $prevChunk
}

foreach($range in $list)
{
    "----------------------------------------------------------------------------"
    "----------------------------------------------------------------------------"
    $count=0
    "Range: $range"
    $parts = $range.Split("-")
    $start = [long]$parts[0]
    $end = [long]$parts[1]
    "Range: $start - $end ($($end - $start))"
    for ($i=$start; $i -le $end; $i++)
    {
        $count++
        if ($count % 1000 -eq 0) {
            Write-Host "." -NoNewline
        }

        $len = $i.ToString().Length
        $halfLen = [int][Math]::Floor($len / 2)
        for ($j=1; $j -le $halfLen; $j++)
        {
            #"$i : Test $j sized chunks"
            $r = Test-Chunk $i $j
            if ($r -gt 0)
            {
                "`n****  MATCH! $i ($r) ****"
                #Read-Host "match"
                $total+=[long]$i
                break
            }   
        }
    }
    #read-host "Press Enter to continue"
}

"Total: $total"
# 65794984339
# 65795287369 was too high