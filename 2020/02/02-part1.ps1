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
    $numLetters=0
    foreach($c in [char[]]$pp.pw)
    {
        if ($c -eq $pp.letter) { $numLetters++}
    }
    if ($numLetters -ge $pp.min -and $numLetters -le $pp.max)
    {
        $validPws+=$pp
    }
}

$validPws.Count