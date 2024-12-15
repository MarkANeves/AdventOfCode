
$total=[int64]0

$map=@()
$moves=""

$px=0
$py=0
$count=-1
Get-Content "$PSScriptRoot\15.txt" | %{
    $line = $_
    $count++
    If ($line.Length -gt 0) {
        if ($line[0] -eq "#") {
            $map += $line
            if ($line.IndexOf('@') -gt 0) {
                $px=$line.IndexOf('@')
                $py=$count
            }
        }
        else {
            $moves += $line
        }
    }
}
"map px=$px  py=$py"
$map
"--------"
"moves"
$moves

$w = $map[0].Length
$h = $map.Count

function getChar($x,$y)
{
    #"w: $w  h: $h"
    if ($x -lt 0 -or $x -ge $w) { return '#'}
    if ($y -lt 0 -or $y -ge $h) { return '#'}
    $map[$y][$x]
}

function setChar($c,$x,$y)
{
    #"w: $w  h: $h"
    if ($x -lt 0 -or $x -ge $w) { return }
    if ($y -lt 0 -or $y -ge $h) { return }
    $l=$map[$y]
    $left = $l.Substring(0,$x)
    $right = $l.Substring($x+1,$l.Length-$x-1)
    #"left: $left   right: $right"
    $map[$y]=$left+$c+$right
}

function moveRobotDir($cpx,$cpy,$dx,$dy)
{
    #"Moving dx=$dx dy=$dy cpx=$cpx  cpy=$cpy"
    $npx = $cpx + $dx
    $npy = $cpy + $dy
    $c = getChar $npx $npy

    if ($c -eq '#') { #"wall - can't move"; 
        return }

    if ($c -eq 'O') {
        moveRobotDir $npx $npy $dx $dy
    }

    $c = getChar $npx $npy

    if ($c -eq '.') {
        #"Can move"
        $t = getChar $cpx $cpy
        setChar $t $npx $npy
        setChar '.' $cpx $cpy
        return
    }

    #"Nothing happened"
}

function moveRobot($move) 
{
    if ($move -eq '<') {
        moveRobotDir $px $py -1 0
    }
    if ($move -eq '>') {
        moveRobotDir $px $py 1 0
    }
    if ($move -eq '^') {
        moveRobotDir $px $py 0 -1
    }
    if ($move -eq 'V') {
        moveRobotDir $px $py 0 1
    }
}

function findRobot
{
    $count=-1
    foreach($l in $map)
    {
        $count++
        if ($l.IndexOf('@') -gt 0) {
            $global:px = $l.IndexOf('@')
            $global:py = $count
            return
        }
    }
    throw "Can't find robot"
}

foreach($move in $moves.ToCharArray()) {
    "--------------------------"
    findRobot
    "Robot position px=$px py=$py"
    "Moving $move"
    moveRobot $move
    #$map
    #Read-Host "next move"
}

for($y=0;$y -lt $h;$y++) {
    for($x=0;$x -lt $w;$x++) {
        $c=getChar $x $y
        if ($c -eq 'O') {
            $total+=$x+($y*100)
        }
    }

}
$map
"Result:"
$total
# answer: 1436690