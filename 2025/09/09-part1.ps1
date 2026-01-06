$poly = @()
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
$poly

$max=0
for ($i=0;$i -lt $poly.Count;$i++)
{
    for ($j=0;$j -lt $poly.Count;$j++)
    {
        if ($i -eq $j) {
            break
        }
        
        $xdiff = [math]::Abs($poly[$i][0]-$poly[$j][0])+1
        $ydiff = [math]::Abs($poly[$i][1]-$poly[$j][1])+1

        $area = $xdiff * $ydiff
        if ($max -lt $area){
            $max = $area
        }

    }
}

"Answer: $max"
# 4776487744