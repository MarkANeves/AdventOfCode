$total=0
Get-Content "$PSScriptRoot\01.txt" | %{
    $line = $_
    $n=0
    foreach($c in $line.ToCharArray())
    {
        if ($c -ge "0" -and $c -le "9")
        {
            if ($n -eq 0)
            {
                $first=$c
                $n++
            }
            else {
                $last=$c
                $n++
            }
        }
    }
    if ($n -eq 0)
    {
        throw "no numbers found in $line"
    }
    if ($n -eq 1)
    {
        $last=$first
    }
    "$first : $last"
    $total+=$first+$last
    $first= $null
}
$total
