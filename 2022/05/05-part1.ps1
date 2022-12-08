<#

    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 
#>

$stacks=@()
for ($i=0;$i -lt 3;$i++) { $stacks += [PSCustomObject]@{s=New-Object System.Collections.Stack}}
'Z','N'     | %{$stacks[0].s.Push($_)}
'M','C','D' | %{$stacks[1].s.Push($_)}
'P'         | %{$stacks[2].s.Push($_)}
$file="05-test.txt"

<#
        [H]     [W] [B]            
    [D] [B]     [L] [G] [N]        
[P] [J] [T]     [M] [R] [D]        
[V] [F] [V]     [F] [Z] [B]     [C]
[Z] [V] [S]     [G] [H] [C] [Q] [R]
[W] [W] [L] [J] [B] [V] [P] [B] [Z]
[D] [S] [M] [S] [Z] [W] [J] [T] [G]
[T] [L] [Z] [R] [C] [Q] [V] [P] [H]
 1   2   3   4   5   6   7   8   9 
 #>
$stacks=@()
for ($i=0;$i -lt 9;$i++) { $stacks += [PSCustomObject]@{s=New-Object System.Collections.Stack}}
$i=0
'T','D','W','Z','V','P'         | %{$stacks[0].s.Push($_)}
'L','S','W','V','F','J','D'     | %{$stacks[1].s.Push($_)}
'Z','M','L','S','V','T','B','H' | %{$stacks[2].s.Push($_)}
'R','S','J'                     | %{$stacks[3].s.Push($_)}
'C','Z','B','G','F','M','L','W' | %{$stacks[4].s.Push($_)}
'Q','W','V','H','Z','R','G','B' | %{$stacks[5].s.Push($_)}
'V','J','P','C','B','D','N'     | %{$stacks[6].s.Push($_)}
'P','T','B','Q'                 | %{$stacks[7].s.Push($_)}
'H','G','Z','R','C'             | %{$stacks[8].s.Push($_)}
$file="05.txt"

$stacks

Get-Content "$PSScriptRoot\$file" | %{
    if ($_ -match "move (\d+) from (\d+) to (\d+)")
    {
        $nm=$Matches[1]
        $from=$Matches[2]
        $to=$Matches[3]

        for ($i=0;$i -lt $nm;$i++)
        {
            $c = $stacks[$from-1].s.Pop()
            $stacks[$to-1].s.Push($c)
        }
    }
}
"--------------"
$result=""
for ($i=0;$i -lt $stacks.Count;$i++)
{
    $result+=$stacks[$i].s.Peek()
}
$result