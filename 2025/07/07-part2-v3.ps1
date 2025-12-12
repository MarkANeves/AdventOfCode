$total=0
$map=@()
Get-Content "$PSScriptRoot\07.txt" | %{
    $map += $_
}

$maxX = $map[0].Length
$maxY = $map.Count  

$indexOfS=$map[0].IndexOf('S')
$beams=@{}
$beamCount=@{}

function AddBeam($x,$y) {
    $map[$y] = $map[$y].Substring(0, $x) + '|' + $map[$y].Substring($x + 1)
    $beams[$y]+=@($x)
}

AddBeam $indexOfS 1

function Render($a,$b,$n) {
    for ($y=0;$y -lt $maxY;$y++) {
        for ($x=0;$x -lt $maxX;$x++)
        {
            if ($x -eq $a -and $y -eq $b) {
                Write-Host '*' -NoNewline
            }
            else {
                $bc = GetBeamCount $x $y
                if ($bc -eq 0 -or $n -eq 1) {
                    Write-Host "$($map[$y][$x])" -NoNewline
                }
                else {
                    $bc = '{0:d2}' -f $bc
                    Write-Host " $bc" -NoNewline 
                }
            }
        }
        Write-Host ""
    }
}

function GetBeamCount($x,$y) {
    $key = ('{0:d3}' -f ($y))+'-'+('{0:d3}' -f $x)
    if ($beamCount.ContainsKey($key)) {
        return $beamCount[$key]
    }
    return 0
}

function IncBeamCount($x,$y,$c) {
    $key = ('{0:d3}' -f ($y))+'-'+('{0:d3}' -f $x)
    $beamCount[$key]+=$c
}

function SetBeamCount($x,$y,$c) {
    $key = ('{0:d3}' -f ($y))+'-'+('{0:d3}' -f $x)
    $beamCount[$key]=$c
}

for ($y=2;$y -lt $maxY;$y++) {
    for ($x=0;$x -lt $maxX;$x++) {
        $c = $map[$y][$x] 
        if ($c -eq '^') {
            if ($map[$y-1][$x] -eq '|') {
                if ($null -eq $beams[$y] -or -not($beams[$y].Contains($x-1))) {
                    AddBeam ($x-1) $y
                }
                if ($null -eq $beams[$y] -or -not($beams[$y].Contains($x+1))) {
                    AddBeam ($x+1) $y
                }
                $total+=1
            }
        }
        if ($c -eq '.') {
            if ($map[$y-1][$x] -eq '|') {
                AddBeam $x $y
            }
        }
    }
}
Render -1 -1 1
"Total: $total"
# 1533

IncBeamCount $indexOfS 1 1

for ($y=2;$y -lt $maxY;$y++) {
    for ($x=0;$x -lt $maxX;$x++) {
        $c = $map[$y][$x] 
        if ($c -eq '^') {
            if ($map[$y-1][$x] -eq '|') {
                $uc = GetBeamCount $x ($y-1)
                IncBeamCount ($x-1) $y $uc
                IncBeamCount ($x+1) $y $uc
            }
        }
        if ($c -eq '|') {
            if ($map[$y-1][$x] -eq '|') {
                $cn = GetBeamCount $x ($y-1)
                SetBeamCount $x $y $cn
            }

            $uc = $map[$y-1][$x]
            if ($map[$y][$x-1] -eq '^' -and $uc -eq '|') {
                $bc = GetBeamCount ($x-1) ($y-1)
                IncBeamCount $x $y $bc
            }
            if ($map[$y][$x+1] -eq '^' -and -$uc -eq '|') {
                $bc = GetBeamCount ($x+1) ($y-1)
                IncBeamCount $x $y $bc
            }
        }
    }
}

$last = ('{0:d3}' -f ($map.Count-1))+'-'
$last
$total = 0
"------------------------"
$keys = $beamCount.Keys | sort
foreach($k in $keys) {
    if ($k -like "*$last*") {
        $bc = $($beamCount[$k])
        "$k : $bc"
            $total += $bc
    }
}
"Total: $total"
# 10733529153890