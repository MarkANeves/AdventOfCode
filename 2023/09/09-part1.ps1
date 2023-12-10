$ErrorActionPreference="stop"
$result = 0

function GetHistory($nums, $r)
{
    $diffs=@()
    $allZero = $true
    for ($i=1; $i -lt $nums.Length; $i++)
    {
        $d = $nums[$i] - $nums[$i-1]
        $diffs += $d
        if ($d -ne 0) {
            $allZero = $false
        }
    }
    Write-Host $diffs
    if (-not($allZero)) {
        GetHistory $diffs ($r + $diffs[$diffs.Length-1])
    }
    else {
        $r
    }
}

Get-Content "$PSScriptRoot\09-test.txt" | %{
    "-----------------"
    $line = $_
    $line

    $nums=@()
    $line.Split(" ",[System.StringSplitOptions]::RemoveEmptyEntries) | %{
        $nums += [Int64]$_
    }


    $r=GetHistory $nums ($nums[$nums.Length-1])
    "r $r"
    $result += $r
    #sleep 1
}

"=============="
$result

#answer 1725987467