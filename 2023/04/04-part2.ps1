$result = 0

$cards=@{}
$cardNum=1
Get-Content "$PSScriptRoot\04.txt" | %{
"-----------------"
    $n=0
    $line = $_
    $line
    $numLists=$line.Split(":")[1].Split("|")

    $winningNumbers = $numLists[0].Split(" ", [StringSplitOptions]::RemoveEmptyEntries)
    $myNumbers = $numLists[1].Split(" ", [StringSplitOptions]::RemoveEmptyEntries)

    $myNumbers | %{
        $myNumber = $_
        if ($winningNumbers.Contains($myNumber))
        {
            "'$myNumber' is a winner"
            $n++
        }
    }
    "score $n"
    $cards[$cardNum]=[PSCustomObject]@{
        Score=$n
        Copies=1
    }

    $cardNum++
}
$numCards=$cardNum-1
$numCards
"+++++++++++++++"
1..$numCards | %{
    $cardNum = $_
    $card = $cards[$cardNum]
    if ($card.Score -gt 0)
    {
        ($cardNum+1)..($cardNum+$card.Score) | %{
            $cards[$_] | %{
                $_.Copies = $_.Copies + $card.Copies
            }
        }
    }
}
"+++++++++++++++"
$cards
"+++++++++++++++"
$cards.Values | %{
    $result += $_.Copies
}
"=============="
$result

#answer 6283755
