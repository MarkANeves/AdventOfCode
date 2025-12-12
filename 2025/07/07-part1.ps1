$total=0
$map=@()
Get-Content "$PSScriptRoot\07-test.txt" | %{
    $map += $_
}

$maxX = $map[0].Length
$maxY = $map.Count  

$x=$map[0].IndexOf('S')
$beams=@{}

function AddBeam($x,$y) {
    $map[$y] = $map[$y].Substring(0, $x) + '|' + $map[$y].Substring($x + 1)
    $beams[$y]+=@($x)
}

AddBeam $x 1

function Render {
    for ($y=0;$y -lt $maxY;$y++) {
        for ($x=0;$x -lt $maxX;$x++)
        {
            Write-Host $map[$y][$x] -NoNewline
        }
        Write-Host ""
    }
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
        "x:$x  y:$y  c:$c"
        #Render
        #Read-Host "Press a key"
    }
}
Render
"Total: $total"
# 1533