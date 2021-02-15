
$forms=@()
Get-Content "$PSScriptRoot\06.txt" | %{$forms+=$_}

$groups=@()
$group=@{}
foreach ($answers in $forms)
{
    if (-not($answers))
    {
        $groups+=$group
        $group=@{}
        continue
    }

    foreach($answer in [char[]]$answers)
    {
        $group[$answer]=1
    }
}

if ($group) { $groups+=$group}

$groups.values | measure -Sum | select -ExpandProperty Sum