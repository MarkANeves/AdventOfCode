$total=[long]0
$content = Get-Content "$PSScriptRoot\02.txt"

$list=@()
$content.Split(",") | %{
    $list += $_.Trim()
}

foreach($range in $list)
{
    "------------------------"
    $count=0
    "Range: $range"
    $parts = $range.Split("-")
    $start = [long]$parts[0]
    $end = [long]$parts[1]
    "Range: $start - $end ($($end - $start))"
    for ($i=$start; $i -le $end; $i++)
    {
        $len = $i.ToString().Length
        if ($len % 2 -ne 0)
        {
            continue
        }
        $count++
        if ($count % 1000 -eq 0) {
            Write-Host "." -NoNewline
        }
        $mul = [Math]::Pow(10,($i.ToString().Length /2))
        #"i: $i   mul: $mul"
        $left = [long][Math]::Floor($i / $mul)
        $right = $i % $mul
        #" left: $left   right: $right"
        if ($left -eq $right)
        {
            $id = ($left * $mul) + $right
            "****  MATCH! $id ****"
            $total+=[long]$id
        }
    }
}

"Total: $total"
"Test: 1227775554"