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
foreach ($d in $directions)
{
    switch ($d.command)
    {
        "forward" {$hpos+=$d.x; break}
        "down"    {$depth+=$d.x; break}
        "up"      {$depth-=$d.x; break}
    }
}
$hpos
$depth
$hpos * $depth
