$ErrorActionPreference="Stop"
$global:data=Get-Content "$PSScriptRoot\20.txt"

$iea = $data[0]
$iea
$image=@{}
2..($data.Count-1) | %{
    $y=$_-2
    $data[$y+2]
    0..($data[$_].Length-1) | % {
        $x=$_
        $p = $data[$y+2][$_]
        if ($p -eq '#')
        {
            $image["$x,$y"]=1
        }
    }
}
$ox=$x
$oy=$y

$margin=4
$numIterations=50

$minx=$miny=-$margin
$maxx=$x+$margin
$maxy=$y+$margin

function CalcIndex($image,$px,$py)
{
    $index=0
    ($py-1)..($py+1) | %{
        $y=$_
        ($px-1)..($px+1) | %{
            $x=$_
            if ($image.ContainsKey("$x,$y"))
            {
                $index=($index -shl 1)+1
            }
            else {
                $index=($index -shl 1)+0
            }
        }
    }
    #$index = [convert]::ToInt32($index,2)
    return $index
}

function DisplayStopwatch($msg,$sw)
{
    "$msg : $($sw.Elapsed.hours):$($sw.Elapsed.minutes):$($sw.Elapsed.seconds):$($sw.Elapsed.Milliseconds)"
}

$overallstopwatch  =  [system.diagnostics.stopwatch]::StartNew()
$itstopwatch  =  [system.diagnostics.stopwatch]::StartNew()

1..$numIterations | %{
    $itNum=$_
    $itstopwatch.Restart()
    "++++++++++++++$itNum+++++++++"
    $image2 = $image.Clone()
    $miny..$maxy | %{
        $y=$_
        $minx..$maxx | %{
            $x=$_
            $i=CalcIndex $image $x $y
            $p=$iea[$i]
            if ($p -eq '#')
            {
                $image2["$x,$y"] = 1
            }
            else
            {
                $image2.Remove("$x,$y")
            }
        }
    }

    $miny..$maxy | %{
        $y=$_
        $line=""
        $minx..$maxx | %{
            $x=$_
            if ($image2.ContainsKey("$x,$y"))
            {
                $line+='#'
            }
            else {
                $line+='.'
            }
        }
        $line
    }
    $image2.Values | measure
    DisplayStopwatch "$itNum" $itstopwatch
    DisplayStopwatch "Overall" $overallstopwatch

    $minx-=$margin
    $miny-=$margin
    $maxx+=$margin
    $maxy+=$margin
    $image = $image2
}

$numPixels=0
-$numIterations..($oy+$numIterations) | %{
    $y=$_
    $line=""
    -$numIterations..($ox+$numIterations) | %{
        $x=$_
        if ($image.ContainsKey("$x,$y"))
        {
            $line+='#'
            $numPixels++
        }
        else {
            $line+='.'
        }
    }
    $line
}
"num pixels: $numPixels"
DisplayStopwatch "Overall" $overallstopwatch

#6725 too big
#5607 too big
#5072 too low
#5419 correct!

# Part 2
#20253 too big