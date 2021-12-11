$ErrorActionPreference="Stop"
$data=@()
Get-Content "$PSScriptRoot\11.txt" | %{$data+=$_}

$octopusmap=New-Object object[] $data.Count

$lastIndex = $data[0].Length-1
$i=0
foreach ($line in $data)
{
    $octopusmap[$i] =@()
    0..$lastIndex| %{
        $octopusmap[$i] += [int]"$($line[$_])"
    }
    $i++
}

function IncEnergy($om,$x,$y,$mx,$my,$c)
{
    if ($x -lt 0 -or $x -gt $mx -or $y -lt 0 -or $y -gt $my)
    {
        return
    }

    if ($om[$y][$x] -eq 0)
    {
        return
    }

    $v=$om[$y][$x]+$c
    $om[$y][$x]=$v

    if ($v -gt 9)
    {
        $om[$y][$x]=0
        $global:numFlashes++
        IncEnergy $om ($x-1) $y $mx $my 1
        IncEnergy $om ($x+1) $y $mx $my 1
        IncEnergy $om $x ($y-1) $mx $my 1
        IncEnergy $om $x ($y+1) $mx $my 1

        IncEnergy $om ($x-1) ($y-1) $mx $my 1
        IncEnergy $om ($x+1) ($y-1) $mx $my 1
        IncEnergy $om ($x-1) ($y+1) $mx $my 1
        IncEnergy $om ($x+1) ($y+1) $mx $my 1
    }
}

$mx = $data[0].Length-1
$my = $data.Length-1

$numFlashes=0

1..100 | %{
    0..$my | % {
        $y=$_
        0..$mx | %{
            $x = $_
            $octopusmap[$y][$x]++
        }
    }

    0..$my | % {
        $y=$_
        0..$mx | %{
            $x = $_
            IncEnergy $octopusmap $x $y $mx $my 0
        }
    }
}
"Num flashes: $numFlashes"