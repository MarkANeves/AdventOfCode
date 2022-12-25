
function TestChunk($chunk)
{
    $letters=@{}
    $chunk.ToCharArray() | %{
        $letters[$_] += 1
    }
    $max = ($letters.Values | Measure-Object -Maximum).Maximum
    return ($max -eq 1)
}

function Solve($line)
{
    $i=0
    while ($true)
    {
        $chunk=$line.Substring($i,14)
        if (TestChunk($chunk))
        {
            Write-Host "Answer part 2: '$($i+14)'"
            return
        }
        $i++
    }
}

Get-Content "$PSScriptRoot\06.txt" | %{
    "----------------"
    $_
    Solve $_
}
