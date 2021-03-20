$rules=@()
Get-Content "$PSScriptRoot\07.txt" | %{$rules+=$_}

$containedIn =@{}
foreach ($rule in $rules)
{
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
        "'$innerBagNum''$innerBag'"

        if ($innerBag)
        {
            if (-not($containedIn.ContainsKey($innerBag))) { $containedIn[$innerBag] = @() }

            $containedIn[$innerBag] += $bag
        }
    }

    "------------------------"

}

function ListParentBags ($bag,$containedIn,$parentBags) {
    
    if ($containedIn.ContainsKey($bag))
    {
        foreach ($containerBag in $containedIn[$bag])
        {
            $parentBags[$containerBag]+=1
            ListParentBags $containerBag $containedIn $parentBags
        }
    }
}

$parentBags=@{}
ListParentBags "shiny gold bag" $containedIn $parentBags
$parentBags
$parentBags.Count