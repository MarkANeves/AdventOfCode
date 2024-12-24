Write-Host "Shared functions"

function rh($s)
{
    #Read-Host $s | Out-Null
}
function rh2($s)
{
    Read-Host $s | Out-Null
}

function w($s)
{
   #Write-Host $s
}
function w2($s)
{
   Write-Host $s
}

function copyArray($arr,$remove) {
    $newArr = @()
    foreach($e in $arr) {
        if ($null -eq $remove) {
            $newArr += $e
        }else {
            if ($e -ne $remove) {
                $newArr += $e
            }
        }
    }
    return $newArr
}