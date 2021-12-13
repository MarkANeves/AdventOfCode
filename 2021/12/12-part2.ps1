$ErrorActionPreference="Stop"
$data=@()
Get-Content "$PSScriptRoot\12.txt" | %{$data+=$_}

function Connect($cm,$s,$e)
{
    if (-not($cm.Contains($s)))
    {
        $cm[$s]=[PSCustomObject]@{
            connections = @()
            small = $s.ToLower() -ceq $s
        }
    }
    $cm[$s].connections += $e
}

$cavemap=@{}
foreach ($line in $data)
{
    $tunnel=$line.Split('-')

    if ($tunnel[1] -ne "start")
    {
        Connect $cavemap $tunnel[0] $tunnel[1]
    }

    if ($tunnel[0] -ne "start")
    {
        Connect $cavemap $tunnel[1] $tunnel[0]
    }
}

function ContainsTwoSmall($path)
{
    $numSmall=@{}
    $path.Split(',') | %{
        if ($_.ToLower() -ceq $_){
            $numSmall[$_]+=1
        }
    }
    $containsTwo = $false
    $numSmall.Values | %{
        if ($_ -eq 2) {$containsTwo= $true;}
    }
    return $containsTwo
}

$count=0
function Visit($cm,$s,$path)
{
    if ($s -eq "end")
    {
        $Global:count++
        if ($Global:count % 1000 -eq 0) { Write-Host "$Global:count" }
        return
    }

    if ($s -eq "start")
    {
        $path = "start"
    }

    foreach ($c in $cm[$s].connections)
    {
        if ($cm[$c].small)
        {
            if ($path.Contains($c) -and (ContainsTwoSmall $path))
            {
                continue
            }
        }
        Visit $cm $c "$path,$c"
    }
}

Visit $cavemap "start" ""
$count
