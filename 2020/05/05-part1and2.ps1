
$codes=@()
Get-Content "$PSScriptRoot\05.txt" | %{$codes+=$_}

$highest=0
$seatIds=@()
foreach($code in $codes)
{
    $minRow=0
    $maxRow=127
    $minCol=0
    $maxCol=7

    foreach($c in [char[]]$code)
    {
        if ($c -eq "F") {$maxRow = ((($maxRow-$minRow)+1)/2)-1+$minRow}
        if ($c -eq "B") {$minRow = ((($maxRow-$minRow)+1)/2)+$minRow}

        if ($c -eq "L") {$maxCol = ((($maxCol-$minCol)+1)/2)-1+$minCol}
        if ($c -eq "R") {$minCol = ((($maxCol-$minCol)+1)/2)+$minCol}
    }

    $seatId = ($minRow*8)+$minCol
    if ($seatId -gt $highest) {$highest=$seatId}
    $seatIds+=$seatId
}
"Part 1: Highest seat ID is $highest"


$prev=0;$current=0
$seatIds = $seatIds | sort
foreach($seatId in $seatIds)
{
    if ($prev -eq 0) {$prev=$seatId;continue}
    else {
        $current=$seatId
        if ($current-$prev -gt 1) {"Part 2: My seat is $($prev+1)";break}
        $prev=$current
    }
}