$ErrorActionPreference="Stop"
$data=@()
Get-Content "$PSScriptRoot\12.txt" | %{$data+=$_}
function Connect($cm,$s,$e)
{
    if (-not($cm.Contains($s)))
    {
        $cm[$s]=[PSCustomObject]@{
            connections = @()
            visited=$false
            small = $s.ToLower() -ceq $s
        }
    }
    $cm[$s].connections += $e
}

$cavemap=@{}
foreach ($line in $data)
{
    $tunnel=$line.Split('-')
    Connect $cavemap $tunnel[0] $tunnel[1]
    Connect $cavemap $tunnel[1] $tunnel[0]
}

$count=0
function Visit($cm,$s,$path,$paths)
{
    if ($s -eq "end")
    {
        Write-Host $path
        $paths += $path
        $Global:count++
        return
    }

    if ($s -eq "start")
    {
        $path = "start"
    }

    foreach ($c in $cm[$s].connections)
    {
        if ($cm[$c].small -and $path.Contains($c))
        {
            continue
        }
        Visit $cm $c "$path,$c" $paths
    }
}

$paths=@()
Visit $cavemap "start" "" $paths
$count
