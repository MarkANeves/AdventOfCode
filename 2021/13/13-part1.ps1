$ErrorActionPreference="Stop"
$data=@()
Get-Content "$PSScriptRoot\13.txt" | %{$data+=$_}

$minx= [int32]::MaxValue
$miny= [int32]::MaxValue
$maxx=-[int32]::MaxValue
$maxy=-[int32]::MaxValue

$image=@{}
$folds=@()
foreach ($line in $data)
{
    if ($line.Length -eq 0) { continue }

    $coords = $line.Split(',')

    if ($coords.Count -eq 2)
    {
        $image[$line]="#"
        $x=[int]$coords[0]
        $y=[int]$coords[1]
        if ($x -lt $minx) {$minx = $x}
        if ($x -gt $maxx) {$maxx = $x}
        if ($y -lt $miny) {$miny = $y}
        if ($y -gt $maxy) {$maxy = $y}
    }
    else
    {
        $line -match 'fold along (.)=(\d+)' | out-null
        $folds+="$($Matches[1]):$($Matches[2])"
    }
}
"minx: $minx  maxx:$maxx"
"miny: $miny  maxx:$maxy"

$fold = $folds[0]

"Fold: $fold"
if ($fold[0] -eq "y")
{
    $foldy = [int]($fold.Split(':'))[1] + 1
    $oy=$foldy-1
    $foldy..$maxy | % {
        $y = $_
        $oy--
        #"y:$y  oy:$oy"
        $minx..$maxx | %{
            $x=$_

            if ($image["$x,$y"] -eq "#")
            {
                $image["$x,$oy"] = "#"
            }
        }
    }
    $maxy=$foldy-2
}
else
{
    $foldx = [int]($fold.Split(':'))[1] + 1
    $ox=$foldx-1
    $foldx..$maxx | % {
        $x = $_
        $ox--
        #"x:$x  ox:$ox"
        $miny..$maxy | %{
            $y=$_

            if ($image["$x,$y"] -eq "#")
            {
                $image["$ox,$y"] = "#"
            }
        }
    }
    $maxx=$foldx-2
}

$dots=0
$miny..$maxy | %{
    $y=$_
    #$line=""
    $minx..$maxx | %{
        $x = $_
        #if ($image.ContainsKey("$x,$y")) { $line +='#'} else { $line+="."}
        if ($image["$x,$y"] -eq '#') {$dots +=1}
    }
    #$line
}
"Dots: $dots"