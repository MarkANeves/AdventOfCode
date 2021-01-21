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

function CheckYear($pc,$field,$min,$max)
{
    if ($pc -match "$field\:(\d+)")
    {
        $by = $Matches[1]
        if ($by -ge $min -and $by -le $max)
        {
            return $true
        }
    }
    return $false
}

function CheckHeight($pc)
{
    if ($pc -match 'hgt:(\d+)cm|hgt:(\d+)in')
    {
        $hcm = $Matches[1]
        $hin = $Matches[2]

        if ($hcm -ge 150 -and $hcm -le 193) {return $true}
        if ($hin -ge 59  -and $hin -le 76)  {return $true}
    }
    return $false
}

function CheckHairColour($pc)
{
    if ($pc -match 'hcl:#([a-f0-9]*)')
    {
        $hc=$Matches[1]
        if ($hc.length -eq 6)
        {
            return $true
        }
    }
    return $false
}

function CheckEyeColour($pc)
{
    if ($pc -match 'ecl:')
    {
        return ($pc -match 'ecl:amb(\s+|$)|ecl:blu(\s+|$)|ecl:brn(\s+|$)|ecl:gry(\s+|$)|ecl:grn(\s+|$)|ecl:hzl(\s+|$)|ecl:oth(\s+|$)')
    }

    return $false
}

function CheckPassportId($pc)
{
    if ($pc -match 'pid:(\d*)')
    {
        $id=$Matches[1]
        if ($id.length -eq 9)
        {
            return $true
        }
    }
    return $false
}

function CheckCountryId($pc)
{
    if ($pc -match 'cid:')
    {
        return $true
    }
    return $false
}

$count=0
foreach($passport in $passports)
{
    $fields=@{}
    $passportChunks = $passport.split(" ",[System.StringSplitOptions]::RemoveEmptyEntries)
    foreach($pc in $passportChunks)
    {
        if (CheckYear $pc 'byr' 1920 2002) { $fields.Add('byr',0) }
        if (CheckYear $pc 'iyr' 2010 2020) { $fields.Add('iyr',0) }
        if (CheckYear $pc 'eyr' 2020 2030) { $fields.Add('eyr',0) }

        if (CheckHeight $pc)     { $fields.Add('hgt',0) }
        if (CheckHairColour $pc) { $fields.Add('hcl',0) }
        if (CheckEyeColour $pc)  { $fields.Add('ecl',0) }
        if (CheckPassportId $pc) { $fields.Add('pid',0) }
        if (CheckCountryId $pc)  { $fields.Add('cid',0) }
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
