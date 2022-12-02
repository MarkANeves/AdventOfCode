$elvesCalCount=@()
$elvesCalCount+=0

Get-Content "$PSScriptRoot\01.txt" | %{
    if ($_)
    {
        $elvesCalCount[$elvesCalCount.Length-1]+= [int]$_
    }
    else {
        $elvesCalCount+=0
    }
}

$sorted=$elvesCalCount | sort -Descending

"Part 1"
$sorted[0]

"Part 2"
$sorted[0]+$sorted[1]+$sorted[2]
