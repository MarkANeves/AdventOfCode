$total=0

$lines=@()

Get-Content "$PSScriptRoot\04.txt" | %{
    $line = $_
    $lines+=$line
}

function getChar($lines,$x,$y)
{
    $len = $lines[0].Length
    if ($x -lt 0) { return "."}
    if ($x -ge $len) { return "."}
    if ($y -lt 0) { return "."}
    if ($y -ge $len) { return "."}

    $l = $lines[$y]
    return $l[$x]
}

$len = $lines[0].Length
$h = $lines.Count
for ($y=0;$y -lt $h;$y++)
{
    for ($x=0;$x -lt $len;$x++)
    {
        $s = getChar $lines $x $y
        $s += getChar $lines ($x+1) $y
        $s += getChar $lines ($x+2) $y
        $s += getChar $lines ($x+3) $y
        if ($s -eq "XMAS") { $total++}

        $s = getChar $lines $x $y
        $s += getChar $lines ($x-1) $y
        $s += getChar $lines ($x-2) $y
        $s += getChar $lines ($x-3) $y
        if ($s -eq "XMAS") { $total++}

        $s = getChar $lines $x $y
        $s += getChar $lines $x ($y+1)
        $s += getChar $lines $x ($y+2)
        $s += getChar $lines $x ($y+3)
        if ($s -eq "XMAS") { $total++}

        $s = getChar $lines $x $y
        $s += getChar $lines $x ($y-1)
        $s += getChar $lines $x ($y-2)
        $s += getChar $lines $x ($y-3)
        if ($s -eq "XMAS") { $total++}

        $s = getChar $lines $x $y
        $s += getChar $lines ($x+1) ($y+1)
        $s += getChar $lines ($x+2) ($y+2)
        $s += getChar $lines ($x+3) ($y+3)
        if ($s -eq "XMAS") { $total++}

        $s = getChar $lines $x $y
        $s += getChar $lines ($x+1) ($y-1)
        $s += getChar $lines ($x+2) ($y-2)
        $s += getChar $lines ($x+3) ($y-3)
        if ($s -eq "XMAS") { $total++}

        $s = getChar $lines $x $y
        $s += getChar $lines ($x-1) ($y+1)
        $s += getChar $lines ($x-2) ($y+2)
        $s += getChar $lines ($x-3) ($y+3)
        if ($s -eq "XMAS") { $total++}

        $s = getChar $lines $x $y
        $s += getChar $lines ($x-1) ($y-1)
        $s += getChar $lines ($x-2) ($y-2)
        $s += getChar $lines ($x-3) ($y-3)
        if ($s -eq "XMAS") { $total++}
    }
    Write-Host "." -NoNewline
}
Write-Host ""

"Result:"
$total
# answer: 2358
