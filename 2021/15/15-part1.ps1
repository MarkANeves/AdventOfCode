$ErrorActionPreference="Stop"
$data=@()
# ONLY WORKS ON TEST DATA
Get-Content "$PSScriptRoot\15.txt" | %{$data+=$_}

$maxx=$data[0].Length
$maxy=$data.Length

$pos=@{}
1..$maxy | %{
    $y = $_
    1..$maxx | %{
        $x = $_
        $pos["$x,$y"]=[int]"$($data[$y-1][$x-1])"
        
        # $pos["$x,$y"]=[PSCustomObject]@{
        #     n=[int]"$($data[$y-1][$x-1])"
        # }
    }
}
#$pos

$minPathTotal=0;
2..$maxx | %{ $minPathTotal+=$pos["$_,1"]}
2..$maxy | %{ $minPathTotal+=$pos["$maxx,$_"]}
$minPathTotal


function FindPath ($x,$y,$path)
{
    $path += $pos["$x,$y"]

    if ($x -eq $maxx -and $y -eq $maxy)
    {
        #$path -join ','
        $total = ($path | measure -Sum).Sum
        if ($total -lt $global:minPathTotal)
        {
            "NEW LOWEST! $total"
            $global:minPathTotal=$total
        }
        return
    }

    $total = ($path | measure -Sum).Sum

    if ($total -ge $global:minPathTotal)
    {
        return
    }

    $newPath = $path.Clone()
    if ($x -lt $maxx) { FindPath ($x+1) $y $newPath}
    if ($y -lt $maxy) { FindPath $x ($y+1) $newPath}
    #if ($x -gt 1)     { FindPath ($x-1) $y $newPath}
    #if ($y -gt 1)     { FindPath $x ($y-1) $newPath}
}

$path=@()
FindPath 2 1 $path
"---"
FindPath 1 2 $path