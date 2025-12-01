$total=0

$lines=@()

Get-Content "$PSScriptRoot\04.txt" | %{
    $line = $_
    $a = $line.ToCharArray()
    [array]::($a)
    $line = $a -join ''
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
        # M.M
        # .A.
        # S.S

        $s1 =  getChar $lines ($x+0) ($y+0)
        $s1 += getChar $lines ($x+1) ($y+1)
        $s1 += getChar $lines ($x+2) ($y+2)

        $s2 =  getChar $lines ($x+2) ($y+0)
        $s2 += getChar $lines ($x+1) ($y+1)
        $s2 += getChar $lines ($x+0) ($y+2)
        #"s1: $s1   s2: $s2  x: $x   y: $y"
        if ($s1 -eq "MAS" -and $s2 -eq "MAS") { $total++}

        # M.S
        # .A.
        # M.S
        $s1 =  getChar $lines ($x+0) ($y+0)
        $s1 += getChar $lines ($x+1) ($y+1)
        $s1 += getChar $lines ($x+2) ($y+2)

        $s2 =  getChar $lines ($x+0) ($y+2)
        $s2 += getChar $lines ($x+1) ($y+1)
        $s2 += getChar $lines ($x+2) ($y+0)
        #"s1: $s1   s2: $s2  x: $x   y: $y"
        if ($s1 -eq "MAS" -and $s2 -eq "MAS") { $total++}

        # S.M
        # .A.
        # S.M
        $s1 =  getChar $lines ($x+2) ($y+2)
        $s1 += getChar $lines ($x+1) ($y+1)
        $s1 += getChar $lines ($x+0) ($y+0)

        $s2 =  getChar $lines ($x+2) ($y+0)
        $s2 += getChar $lines ($x+1) ($y+1)
        $s2 += getChar $lines ($x+0) ($y+2)
        #"s1: $s1   s2: $s2  x: $x   y: $y"
        if ($s1 -eq "MAS" -and $s2 -eq "MAS") { $total++}

        # S.S
        # .A.
        # M.M
        $s1 =  getChar $lines ($x+2) ($y+2)
        $s1 += getChar $lines ($x+1) ($y+1)
        $s1 += getChar $lines ($x+0) ($y+0)

        $s2 =  getChar $lines ($x+0) ($y+2)
        $s2 += getChar $lines ($x+1) ($y+1)
        $s2 += getChar $lines ($x+2) ($y+0)
        #"s1: $s1   s2: $s2  x: $x   y: $y"
        if ($s1 -eq "MAS" -and $s2 -eq "MAS") { $total++}

    }
    Write-Host "." -NoNewline
}
Write-Host ""

"Result:"
$total
# answer: 1737
