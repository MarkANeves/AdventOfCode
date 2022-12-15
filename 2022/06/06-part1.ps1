
function TestBuffer($b)
{
    if ($b[0] -ne $b[1] -and $b[0] -ne $b[2] -and $b[0] -ne $b[3] `
    -and $b[1] -ne $b[2] -and $b[1] -ne $b[3] `
    -and $b[2] -ne $b[3])
    {
        return $true
    }
    return $false
}

function Solve($line)
{
    $buffer=".",".",".",".";

    $i=0
    $found=$false
    $line.ToCharArray() | %{
        $i++
        $buffer[0] = $buffer[1]
        $buffer[1] = $buffer[2]
        $buffer[2] = $buffer[3]
        $buffer[3] = $_
        #$buffer -join ","
        
        if ($i -ge 4 -and (TestBuffer $buffer) -and -not($found))
        {
            "Answer: $i"
            $found=$true
        }
    }
}

Get-Content "$PSScriptRoot\06.txt" | %{
    $_
    Solve $_
}
