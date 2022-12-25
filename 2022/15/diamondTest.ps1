$a=New-Object 'object[,]' 50,50

for ($x=0;$x -lt 50;$x++)
{
    for ($y=0;$y -lt 50;$y++)
    {
        $a[$x,$y]='.'
    }
}

$sy=25
$sx=25
$dist=14
0..($dist+1) | %{

    $y1 = $sy-$_
    $x1 = $sx-$dist + $_ -1
    $x2 = $sx+$dist - $_ +1
    $y2 = $sy+$_

    "$x1 $y1 : $x2    -    $x1 $y2 $x2"

    $a[$x1,$y1] = '#'
    $a[$x2,$y1] = '@'
    $a[$x1,$y2] = '='
    $a[$x2,$y2] = '+'
}

$a[$sx,$sy]=0
for ($x=0;$x -lt 50;$x++)
{
    $s=""
    for ($y=0;$y -lt 50;$y++)
    {
        $s+=$a[$x,$y]
    }
    $s
}