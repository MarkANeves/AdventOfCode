$ErrorActionPreference="Stop"
$data=@()
Get-Content "$PSScriptRoot\25test.txt" | %{$data+=$_}

$maxx=$data[0].Length
$maxy=$data.Length

function DisplayArea($a)
{
    for ($y=0;$y -lt $a.Length;$y++) {
        $line=""
        for ($x=0;$x -lt $a[0].Length;$x++) {
            $line+=$a[$y][$x]
        }
        Write-Host $line
    }
}

function CloneArea($a)
{
    $na = $a.Clone()
    for ($y=0;$y -lt $a.Length;$y++) {
        $na[$y] = $a[$y].Clone()
    }
    return $na
}

function MoveEast($a1,$a2,$x,$y,$maxx)
{
    $x2 = ($x+1) % $maxx
    if ($a1[$y][$x2] -eq '.')
    {
        $a2[$y][$x2] = '>' 
        $a2[$y][$x]  = '.' 
        return 1
    }
    return 0
}
function MoveSouth($a1,$a2,$x,$y,$maxy)
{
    $y2 = ($y+1) % $maxy
    if ($a1[$y2][$x] -eq '.')
    {
        $a2[$y2][$x] = 'v' 
        $a2[$y][$x]  = '.' 
        return 1
    }
    return 0
}

$area = New-Object object[] $maxy;
0..($maxy-1) | %{
    $y=$_
    $area[$y] = New-Object char[] $maxx;
    0..($maxx-1) | %{
        $x=$_
        $area[$y][$x] = "$($data[$y][$x])"
    }
}

$newArea = CloneArea $area

$numSteps=0
while (1)
{
    $numSteps++
    $numChanged = 0

    # "++++++++++++++++++++++++++++++++++++++++++++++"
    # DisplayArea $area

    0..($maxy-1) | %{
        $y=$_
        0..($maxx-1) | %{
            $x=$_
            if ($area[$y][$x] -eq '>')
            {
                $numChanged+= MoveEast $area $newArea $x $y $maxx
            }
        }
    }

    # DisplayArea $area
    # "------------------"
    # DisplayArea $newArea

    $area = $newArea
    $newArea = CloneArea $area

    0..($maxy-1) | %{
        $y=$_
        0..($maxx-1) | %{
            $x=$_
            if ($area[$y][$x] -eq 'v')
            {
                $numChanged+= MoveSouth $area $newArea $x $y $maxy
            }
        }
    }

    "------$numSteps----$numChanged--------"
    DisplayArea $newArea
    "------$numSteps----$numChanged--------"

    $area = $newArea
    $newArea = CloneArea $area

    if ($numChanged -eq 0)
    {
        break
    }
}
"Num steps: $numSteps"