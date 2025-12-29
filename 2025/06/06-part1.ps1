$total = [long]0

$lines = Get-Content "$PSScriptRoot\06.txt"

$numbers=@{}
$ops=@{}

$bucket=-1
while ($lines[0] -match '\d+') {
    $bucket++
    for ($i=0;$i -lt $lines.Count;$i++) {
        if ($lines[$i] -match "(\s*\d+)")
        {
            $numbers[$bucket] += ,[long]$Matches[1]
            $lines[$i] = $lines[$i].Substring($Matches[1].Length)
        }
        elseif ($lines[$i] -match "(\s*\+|\s*\*)") {
            $ops[$bucket] = $Matches[1].Replace(' ','')
            $lines[$i] = $lines[$i].Substring($Matches[1].Length)
        }
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
# 5733696195703
