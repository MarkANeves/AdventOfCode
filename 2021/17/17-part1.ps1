$ErrorActionPreference="Stop"
$global:data=Get-Content "$PSScriptRoot\17.txt"

$data -match 'target area: x=(.+)\.\.(.+), y=(.+)\.\.(.+)'

$targetArea = [PSCustomObject]@{
    minx = [int]$Matches[1]
    maxx = [int]$Matches[2]
    miny = [int]$Matches[3]
    maxy = [int]$Matches[4]
}

#$targetArea

function InTargetArea($x,$y,$ta)
{
    if ($x -ge $ta.minx -and $x -le $ta.maxx -and $y -ge $ta.miny -and $y -le $ta.maxy)
    {
        return $true
    }
    return $false
}

function PastTargetArea($x,$y,$ta)
{
    if ($x -gt $ta.maxx -or $y -lt $ta.miny)
    {
        return $true
    }
}

$maxyvel=[PSCustomObject]@{
    maxy = -1
    vx = -1
    vy = -1
}

-100..100 | %{
    $initvy = $_
    0..$targetArea.maxx | %{
        $initvx=$_
        $vx=$_
        $vy = $initvy
        $x=0
        $y=0
        $maxy=0
        while (1)
        {
            $x+=$vx
            $y+=$vy

            if ($y -gt $maxy)
            {
                $maxy=$y
            }
        
            if (InTargetArea $x $y $targetArea)
            {
                "Hit: x:$x y:$y : ($initvx,$initvy)"
                if ($maxy -gt $maxyvel.maxy)
                {
                    $maxyvel.maxy = $maxy
                    $maxyvel.vx = $initvx
                    $maxyvel.vy = $initvy
                }
                break;
            }
        
            if (PastTargetArea $x $y $targetArea)
            {
                break
            }
        
            if ($vx -ne 0) {$vx--}
            $vy--;
        }
    }
}

$maxyvel | ft -AutoSize
