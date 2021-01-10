$numbers=@()
Get-Content "$PSScriptRoot\01.txt" | %{$numbers+= [int]$_}

# Part One
for ($i=0;$i -lt $numbers.Count;$i++)
{
    for ($j=0; $j -lt $numbers.Count;$j++)
    {
        if ($i -ne $j)
        {
            if ($numbers[$i]+$numbers[$j] -eq 2020)
            {
                Write-Host "Part 1: "$($numbers[$i]*$numbers[$j])
                $i=$j=$numbers.Count
            }
        }
    }
}
