
$total=[int64]0

$map = @()
$foundMap = @{}

Get-Content "$PSScriptRoot\10.txt" | %{
    $line = $_
    $map += $line
}
Write-Host ""
$map
$mapw = $map[0].Length
$maph = $map.Count

function getHeight($x,$y){
    if ($x -lt 0 -or $x -ge $mapw) {
        return -100;
    }

    if ($y -lt 0 -or $y -ge $maph) {
        return -100;
    }

    return [int]$map[$y][$x]-48
}

function addFound($tc,$x,$y) {
    $key = "$tc : $x : $y"
    if (-not($foundMap.ContainsKey($key)))
    {
        $foundMap[$key] = 1
    }
    else {
        $foundMap[$key]++
    }
}

function findPeaks($tc,$x,$y)
{
    $h = getHeight $x $y
    if ($h -eq 9)
    {
        addFound $tc $x $y
        return
    }

    $up    = getHeight ($x+0) ($y-1)
    $down  = getHeight ($x+0) ($y+1)
    $left  = getHeight ($x-1) ($y+0)
    $right = getHeight ($x+1) ($y+0)

    if ($h -eq $up-1) {
        findPeaks $tc ($x+0) ($y-1)
    }

    if ($h -eq $down-1) {
        findPeaks $tc ($x+0) ($y+1)
    }

    if ($h -eq $left-1) {
        findPeaks $tc ($x-1) ($y+0)
    }

    if ($h -eq $right-1) {
        findPeaks $tc ($x+1) ($y+0)
    }
}

$tc=0
for ($y=0;$y -lt $maph;$y++)
{
    for ($x=0;$x -lt $mapw;$x++)
    {
        $v = getHeight $x $y
        #Write-Host "$v : " -NoNewline
        if ($v -eq 0) {
            findPeaks $tc $x $y
            $tc++
            #break
        }
    }
    Write-Host ""
}
$foundMap | sort name2

foreach($v in $foundMap.Values)
{   
    $total+=$v
}

"Result:"
$total
# answer: 
