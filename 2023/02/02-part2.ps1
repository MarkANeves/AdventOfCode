$totals=@{}
$totals+=@{ "red" = 12 }
$totals+=@{ "green" = 13 }
$totals+=@{ "blue" = 14 }
$totals

$result = 0
Get-Content "$PSScriptRoot\02.txt" | %{
"-----------------"
    $line = $_+";"
    $line
    $line -match "Game (\d+):" | Out-Null
    $id=$Matches[1]
    $line = $line.Substring($line.IndexOf(":")+1)
    $setMax=@{}
    while ($line.Length -gt 0)
    {
        $segment=$line.Substring(0,$line.IndexOf(";"))
        $segment

        $segment -split "," | %{
            $_ -match "(\d+) (\S+)" | Out-Null
            $numCol=[int]$Matches[1]
            $colour=$Matches[2]
            $maxCol=$totals[$colour]
            "$numCol : $colour : $maxCol"
            $currentMax=$setMax[$colour]
            "$colour : currentMax=$currentMax"
            if ($numCol -gt $currentMax)
            {
                $setMax[$colour]=$numCol
                "new max for $colour = $numCol"
            }
        }
        "*************"
        $setMax
        "*************"
        $line=$line.Substring($segment.Length+1)
    }
    "+++++++++++++++++++"
    $power=1
    $setMax.Values | %{$power*=$_}
    "id: $id : power : $power"
    $result+=$power
    "+++++++++++++++++++"

}
"=============="
$result

# answer 72970