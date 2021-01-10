
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

# Part Two
for ($i=0;$i -lt $numbers.Count;$i++)
{
    for ($j=0; $j -lt $numbers.Count;$j++)
    {
        for ($k=0; $k -lt $numbers.Count;$k++)
        {
            if ($i -ne $j -and $i -ne $k -and $j -ne $k)
            {
                if ($numbers[$i]+$numbers[$j]+$numbers[$k] -eq 2020)
                {
                    Write-Host "Part Two: "$($numbers[$i]*$numbers[$j]*$numbers[$k])
                    $i=$j=$k=$numbers.Count
                }
            }
        }
    }
}