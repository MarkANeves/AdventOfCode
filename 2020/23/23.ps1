function crabPicks($cups,$currentCup)
{
    $pick = @()
    $indexOfCurrentCup = $cups.IndexOf($currentCup)
    if ($indexOfCurrentCup -lt 0) {throw "Can't find current cup $destinationCup"}

    for ($i=0;$i -lt 3;$i++)
    {
        $j = ($indexOfCurrentCup+1+$i) % $cups.Length
        $pick += $cups[$j]
    }

    $result=[PSCustomObject]@{
        CrabPick = $pick
        CupsLeft = @()
    }
    
    $cups | ?{-not($pick -eq $_)} | %{$result.CupsLeft += $_}

    return $result
}

function getDestinationCup($cupsLeft,$crabPick,$currentCup,$min,$max)
{
    $destinationCup = $currentCup
    while (1)
    {
        $destinationCup--;
        if ($destinationCup -lt $min)
        {
            $destinationCup = $max
        }

        if ($cupsLeft -eq $destinationCup)
        {
            return $destinationCup
        }
    }
}

function insertCups($cupsLeft,$crabPick,$destinationCup)
{
    $indexOfDestinationCup = $cupsLeft.IndexOf($destinationCup)

    if ($indexOfDestinationCup -lt 0) {throw "Can't find destination cup $destinationCup"}

    $left=$cupsLeft[0..$indexOfDestinationCup]
    $right=$crabPick + $cupsLeft[($indexOfDestinationCup+1)..1000]
    return $left+$right
}

$cups= 3,8,9,1,2,5,4,6,7
$cups= 4,9,6,1,3,8,5,2,7
$max=$cups | measure -max | select -ExpandProperty Maximum
$min=$cups | measure -min | select -ExpandProperty Minimum
$currentCup=$cups[0]

for ($i=0;$i -lt 100;$i++)
{
    "--------------------"
    "Current Cup: $currentCup : " + ($cups -join ",")
    $cp = crabPicks $cups $currentCup
    "Crab picks: "+($cp.CrabPick -join ",")
    "Cups left: "+ ($cp.CupsLeft -join ",")
    $destinationCup = getDestinationCup $cp.CupsLeft $cp.CrabPick $currentCup $min $max
    "dest: $destinationCup"
    $newCups=insertCups $cp.CupsLeft $cp.CrabPick $destinationCup
    "new cups: " + ($newCups -join ",")

    $indexOfCurrentCup=$cp.CupsLeft.IndexOf($currentCup)
    $indexOfNextCup=($indexOfCurrentCup+1) % ($cp.CupsLeft.Length)
    $currentCup=$cp.CupsLeft[$indexOfNextCup]
    "Next Cup: $currentCup"
    $cups = $newCups
}

"##########################"
$indexOfOne = $cups.IndexOf(1)
$result = ""
for ($i=0;$i -lt ($cups.Length-1);$i++)
{
    $c = ($indexOfOne+1+$i) % $cups.Length
    $result += $cups[$c]
}
$result
$currentCup

