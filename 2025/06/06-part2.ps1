$total = [long]0

$lines = Get-Content "$PSScriptRoot\06.txt"
for ($i=0;$i -lt $lines.Count;$i++) {
    $lines[$i] += ' '
}

$numbers=@{}
$ops=@{}

$bucket=-1
while ($lines[0] -match '\d+') {
    $bucket++
    $div=0
    $dividerFound = $false
    while (-not $dividerFound) {
        $numSpaces=0
        for ($i=0;$i -lt $lines.Count;$i++)
        {
            if ($lines[$i][$div] -eq ' ') {
                $numSpaces++
            }
        }
        if ($numSpaces -eq $lines.Count) { break}
        $div++
    }

    for ($c=0;$c -lt $div;$c++) {
        $num=""
        for ($i=0;$i -lt $lines.Count;$i++) {
            $char = $lines[$i][$c]
            if ($char -eq '+' -or $char -eq '*') {
                $ops[$bucket] = $char
            }
            else {
                $num += $char 
            }
        }
        $numbers[$bucket] += ,[long]$num
    }

    for ($i=0;$i -lt $lines.Count;$i++) {
        $lines[$i] = $lines[$i].Substring($div+1)
    }
}

for ($i=0;$i -lt $ops.Count;$i++) {
    if ($ops[$i] -eq "+") {
        $sum = 0
        foreach($n in $numbers[$i]) { $sum += $n}
        $total += $sum
    }
    elseif ($ops[$i] -eq "*") {
        $product = 1
        foreach($n in $numbers[$i]) { $product *= $n}
        $total += $product
    }
}

"Total: $total"
# 10951882745757
