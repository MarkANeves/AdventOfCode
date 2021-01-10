$passwords=@()
$passwords+="1-3 a: abcde"
$passwords+="1-3 b: cdefg"
$passwords+="2-9 c: ccccccccc"

$passwords=@()
Get-Content "$PSScriptRoot\02.txt" | %{$passwords+=$_}

$passwordPolicies=@()
foreach ($pw in $passwords) {
    $pw -match '(\d+)-(\d+)\s*(\w):\s*(\w+)' | out-null
    $pp = [PSCustomObject]@{
        letter = $matches[3]
        min = [int]$matches[1]
        max = [int]$matches[2]
        pw = $matches[4]
    }
    $passwordPolicies+=$pp
}

$validPws=@()
foreach ($pp in $passwordPolicies)
{
    $pw=$pp.pw
    $i = $pp.min-1
    $j = $pp.max-1
    $n = 0
    if ($pw[$i] -eq $pp.letter) { $n++}
    if ($pw[$j] -eq $pp.letter) { $n++}
    if ($n -eq 1    )
    {
        $validPws+=$pp
    }
}

$validPws.Count