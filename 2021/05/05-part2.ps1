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
    #if (($sx -eq $ex) -or ($sy -eq $ey))
    #{
        $coords = [PSCustomObject]@{sx=$sx;sy=$sy;ex=$ex;ey=$ey}
        $ventLines+=$coords
    #}
}

$ventLines

$vlCount=@{}
foreach ($vl in $ventLines)
{
    $sx=$vl.sx; $sy=$vl.sy; $ex=$vl.ex;$ey=$vl.ey;
    $dx=1*[Math]::Sign($ex-$sx);$dy=1*[Math]::Sign($ey-$sy)

    $ix=$sx; $iy=$sy
    $numPoints=[Math]::Abs($sx-$ex)
    if ($numPoints -eq 0) {$numPoints=[Math]::Abs($sy-$ey)}
    $numPoints++
    for ($i=0;$i -lt $numPoints;$i++)
    {
        $key="$ix,$iy"
        #$key
        $vlCount[$key]++
        $ix+=$dx;
        $iy+=$dy;
    }
}
$count=0
$vlCount.Values | %{if ($_ -ge 2) {$count++}}
$count