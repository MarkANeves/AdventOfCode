. "$PSScriptRoot\..\..\shared.ps1"

Read-Host "DOES NOT WORK!"

$poly = @()
$maxx=0
$maxy=0
Get-Content "$PSScriptRoot\09.txt" | %{
    $_ -match "(\d+),(\d+)" | Out-Null
    $x=[int]$matches[1]
    $y=[int]$matches[2]
    $poly += ,@($x,$y);
    if ($x -gt $maxx) {
        $maxx = $x
    }
    if ($y -gt $maxy) {
        $maxy = $y
    }
}
$maxx+=4
$maxy+=4

function Render() {
    for ($y=0;$y -lt $maxy;$y++) {
        for ($x=0;$x -lt $maxx;$x++) {
            $point = $x,$y
            if (Test-PointInPolygon -Point $point -Polygon $poly -IncludeBoundary) {
                Write-Host "*" -NoNewline
            }
            else {
                Write-Host "." -NoNewline
            }
        }
        Write-Host ''
    }
}

function GetOtherCornerPoints($p1,$p2) {

    $rect=@()
    $x3 = $p1[0]+($p2[0]-$p1[0])
    $y3 = $p1[1]
    $rect+=,@($x3,$y3)
    $x4 = $p1[0]
    $y4 = $p1[1]+($p2[1]-$p1[1])
    $rect+=,@($x4,$y4)

    return $rect
}

function wp($p) {
    Write-Host "($($p[0]),$($p[1]))"
}

$max=0
for ($i=0;$i -lt $poly.Count;$i++)
{
    Write-Host "Iteration $i"
    for ($j=0;$j -lt $poly.Count;$j++)
    {
        if ($i -eq $j) {
            break
        }

        $p1 = $poly[$i]
        $p2 = $poly[$j]
        #wp $p1
        #wp $p2

        $rect = GetOtherCornerPoints $p1 $p2

        # foreach ($p in $rect)
        # {
        #     wp $p
        # }

        if ((Test-PointInPolygon -Point $rect[0] -Polygon $poly -IncludeBoundary) -and
            (Test-PointInPolygon -Point $rect[1] -Polygon $poly -IncludeBoundary)) {

            $xdiff = [math]::Abs($poly[$i][0]-$poly[$j][0])+1
            $ydiff = [math]::Abs($poly[$i][1]-$poly[$j][1])+1

            $area = $xdiff * $ydiff
            if ($max -lt $area){
                $max = $area
            }
        }
    }
}

"Answer: $max"
# 4581960734 - too high
# 4581960734