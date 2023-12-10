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
    #Write-Host $diffs
    $r += $diffs[0]
    #Write-Host $r
    if (-not($allZero)) {

        GetHistory $diffs $r
    }
    else {
        $r
    }
}

Get-Content "$PSScriptRoot\09.txt" | %{
    "-----------------"
    $line = $_
    $line

    $nums=@()
    $line.Split(" ",[System.StringSplitOptions]::RemoveEmptyEntries) | %{
        $nums += [Int64]$_
    }

    $r=@()
    $r+=$nums[0]
    $r=GetHistory $nums $r
    "r $r"
    $a=0
    for ($i=$r.Length-1; $i -ge 1; $i--) {
        "$($r[$i-1])-$a = $($r[$i-1]-$a)"
         $a = $r[$i-1]-$a
    }
    "a $a"
    $result += $a
    #sleep 1
}

"=============="
$result

#answer 971