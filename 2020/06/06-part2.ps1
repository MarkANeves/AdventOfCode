
$forms=@()
Get-Content "$PSScriptRoot\06.txt" | %{$forms+=$_}

$groups=@()
$numInGroups=@()
$group=@{}
$numInGroup=0
foreach ($answers in $forms)
{
    if (-not($answers))
    {
        $groups+=$group
        $numInGroups+=$numInGroup
        $group=@{}
        $numInGroup=0
        continue
    }

    $numInGroup+=1

    foreach($answer in [char[]]$answers)
    {
        $group[$answer]+=1
    }
}

if ($group) { $groups+=$group;$numInGroups+=$numInGroup}

$total=0
for ($i=0;$i -lt $groups.Count;$i++)
{
    foreach ($k in $groups[$i].Keys)
    {
        if ($groups[$i][$k] -eq $numInGroups[$i])
        {
            $total+=1
        }
    }
}
"Total: $total"