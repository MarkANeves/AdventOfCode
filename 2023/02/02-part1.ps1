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
    $impossible=$false
    while ($line.Length -gt 0 -and -not($impossible))
    {
        $segment=$line.Substring(0,$line.IndexOf(";"))
        $segment

        $segment -split "," | %{
            $_ -match "(\d+) (\S+)" | Out-Null
            $numCol=[int]$Matches[1]
            $colour=$Matches[2]
            $maxCol=$totals[$colour]
            "$numCol : $colour : $maxCol"
            if ($numCol -gt $maxCol)
            {
                $impossible=$true
                "impossible"
            }
        }
        $line=$line.Substring($segment.Length+1)

    }
    if (-not($impossible))
    {
        $result+=$id
    }
}
"=============="
$result

#answer 3099