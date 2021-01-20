$data=@()
Get-Content "$PSScriptRoot\04.txt" | %{$data+=$_}

$passports=@()
$passport=""
foreach($line in $data)
{
    if ($line.Length -gt 0) {$passport+="$line "}
    else {$passports += $passport; $passport=""}    
} 
$passports+=$passport

$count=0
foreach($passport in $passports)
{
    $fields=@{}
    $passportChunks = $passport.split(" ",[System.StringSplitOptions]::RemoveEmptyEntries)
    foreach($pc in $passportChunks)
    {
        if ($pc -match '(...):')
        {
            $m=$Matches[1]
            if (-not($fields.ContainsKey($m)))
            {
                $fields.Add($m,0)
            }
        }
    }

    $valid=$false
    if ($fields.Count -eq 8) { $valid=$true}
    elseif ($fields.Count -eq 7 -and -not($fields.ContainsKey("cid"))) { $valid=$true}

    if ($valid)
    {
        $count++
    }
}
$count

