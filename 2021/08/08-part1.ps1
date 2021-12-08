$data=@()
Get-Content "$PSScriptRoot\08.txt" | %{$data+=$_}

$easyDigits=0
foreach($line in $data)
{
    $digits = $line.Split('|')
    $digits = $digits[1].Split(' ',[System.StringSplitOptions]::RemoveEmptyEntries)
    $digits | % {
        $l=$_.Length
        if ($l -eq 2 -or $l -eq 4 -or $l -eq 3 -or $l -eq 7)
        {
            $easyDigits++
        } 
    }
}
$easyDigits
