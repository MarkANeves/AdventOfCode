$directionsSrc=@()
Get-Content "$PSScriptRoot\02.txt" | %{$directionsSrc+=$_}

$directions=@()
foreach ($d in $directionsSrc) {
    $d -match '(\S*).*(\d+)' | out-null
    $dir = [PSCustomObject]@{
        command = $matches[1]
        x = [int]$matches[2]
    }
    $directions+=$dir
}

$hpos=0
$depth=0
$aim=0
foreach ($d in $directions)
{
    switch ($d.command)
    {
        "forward" {$hpos+=$d.x;$depth+=$aim*$d.x; break}
        "down"    {$aim+=$d.x; break}
        "up"      {$aim-=$d.x; break}
    }
}
$hpos
$depth
$hpos * $depth
