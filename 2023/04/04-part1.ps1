$result = 0

Get-Content "$PSScriptRoot\04.txt" | %{
"-----------------"
    $n=0
    $line = $_
    $line
    $numLists=$line.Split(":")[1].Split("|")

    $winningNumbers = $numLists[0].Split(" ", [StringSplitOptions]::RemoveEmptyEntries)
    $myNumbers = $numLists[1].Split(" ", [StringSplitOptions]::RemoveEmptyEntries)

    #$winningNumbers
    #$winningNumbers.Length
    $myNumbers | %{
        $myNumber = $_
        if ($winningNumbers.Contains($myNumber))
        {
            "'$myNumber' is a winner"
            if ($n -eq 0)
            {
                $n=1
            }
            else
            {
                $n=$n*2
            }
        }
    }
    "score $n"
    $result += $n
}

"=============="
$result

#answer 15268