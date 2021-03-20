$rules=@()
Get-Content "$PSScriptRoot\07.txt" | %{$rules+=$_}

$bagContent =@{}
foreach ($rule in $rules)
{
    "#####################"
    $rule -match "(.*bag).*contain" | out-null
    $bag = $Matches[1].Trim()
    "'$bag'"

    $rule -match "contain(.*)" | out-null
    $containList = $Matches[1].Split(',')
    foreach ($contain in $containList)
    {
        $contain -match "(\d+)\s+(.*bag)" | Out-Null
        $innerBagNum = $Matches[1]
        $innerBag = $Matches[2]

        if ($innerBag)
        {
            $bagDetails = [PSCustomObject]@{numBags=[int]$innerBagNum;bag=$innerBag}
            $bagDetails

            if (-not($bagContent.ContainsKey($bag))) { $bagContent[$bag] = @() }

            $bagContent[$bag] += $bagDetails
        }
    }

    "------------------------"

}

function CountInnerBags($bag,$bagContent)
{
    if (-not($bagContent[$bag]))
    {
        return 0
    }

    $total=0

    foreach ($bagDetails in $bagContent[$bag])
    {
        $numInnerBags = CountInnerBags $bagDetails.bag $bagContent
        $n=$bagDetails.numBags
        $total += $n+($n * $numInnerBags)
    }

    return $total
}

CountInnerBags "shiny gold bag" $bagContent
