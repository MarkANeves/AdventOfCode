$ErrorActionPreference="Stop"
$global:data=Get-Content "$PSScriptRoot\22.txt"

$cubes=@()
foreach ($line in $data)
{
    $line -match '(\w+).*x=(-*\d+)..(-*\d+),y=(-*\d+)..(-*\d+),z=(-*\d+)..(-*\d+)'

    $cube=[PSCustomObject]@{
        on = $Matches[1] -eq "on"
        x1=[int]$Matches[2]
        x2=[int]$Matches[3]
        y1=[int]$Matches[4]
        y2=[int]$Matches[5]
        z1=[int]$Matches[6]
        z2=[int]$Matches[7]
    }
    if (     $cube.x1 -ge -50 -and $cube.x2 -le 50 `
        -and $cube.y1 -ge -50 -and $cube.y2 -le 50 `
        -and $cube.z1 -ge -50 -and $cube.z2 -le 50) 
    {
        $cubes+=$cube
    }
}

$cubeMap=@{}
$cubes | %{
    "-----------------$(get-date)"
    $cube=$_
    $cube.x1..$cube.x2 | %{
        $x=$_
        $cube.y1..$cube.y2 | %{
            $y=$_
            $cube.z1..$cube.z2 | %{
                $z=$_
                $k="$x,$y,$z"
                if ($cube.on)
                {
                    $cubeMap[$k]=1
                }
                else {
                    $cubeMap.Remove($k)
                }
            }
        }
    }
}

$cubeMap.Keys | measure
