$data=@()
Get-Content "$PSScriptRoot\05.txt" | %{$data+=$_}

$ventLines=@()
foreach($coordTxt in $data)
{
    $coordTxt -match "(\d+),(\d+)\D*(\d+),(\d+)" | Out-Null
    $sx=[int]$Matches[1]
    $sy=[int]$Matches[2]
    $ex=[int]$Matches[3]
    $ey=[int]$Matches[4]
    if (($sx -eq $ex) -or ($sy -eq $ey))
    {
        $coords = [PSCustomObject]@{sx=$sx;sy=$sy;ex=$ex;ey=$ey}
        $ventLines+=$coords
    }
}

$ventLines

$vlCount=@{}
foreach ($vl in $ventLines)
{
    if ($vl.sx -eq $vl.ex)
    {
        $sy=$vl.sy; $ey=$vl.ey;
        if ($sy -gt $ey) {$t=$sy;$sy=$ey;$ey=$t}
        for($i=$sy;$i -le $ey;$i++)
        {
            $key="$($vl.sx),$i"
            $vlCount[$key]++
        }
    }

    if ($vl.sy -eq $vl.ey)
    {
        $sx=$vl.sx; $ex=$vl.ex;
        if ($sx -gt $ex) {$t=$sx;$sx=$ex;$ex=$t}
        for($i=$sx;$i -le $ex;$i++)
        {
            $key="$i,$($vl.sy)"
            $vlCount[$key]++
        }
    }
}

$count=0
$vlCount.Values | %{if ($_ -ge 2) {$count++}}
$count