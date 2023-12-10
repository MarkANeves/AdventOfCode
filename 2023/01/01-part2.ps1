$total=0
$nums = @{}
$nums["one"] = 1
$nums["two"] = 2
$nums["three"] = 3
$nums["four"] = 4
$nums["five"] = 5
$nums["six"] = 6
$nums["seven"] = 7
$nums["eight"] = 8
$nums["nine"] = 9

Get-Content "$PSScriptRoot\01.txt" | %{
    $line = $_
    $orig=$line
    $n=0
    while ($line.Length -gt 0)
    {
        $found=$false
        if ($line[0] -ge "0" -and $line[0] -le "9")
        {
            if ($n -eq 0)
            {
                $first=[int]$line[0]-48
                $n++
            }
            else {
                $last=[int]$line[0]-48
                $n++
            }
            $line = $line.Substring(1)
            $found=$true
            continue
        }

        foreach($k in $nums.Keys)
        {
            if ($line.StartsWith($k))
            {
                if ($n -eq 0)
                {
                    $first=$nums[$k]
                    $n++
                }
                else {
                    $last=$nums[$k]
                    $n++
                }
                $line = $line.Substring(1)
                $found=$true
                #break;
            }
        }
        if (-not($found))
        {
            $line = $line.Substring(1)
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
    "-------------"
    $orig
    $v=($first*10)+$last
    "$first : $last : $v"
    if ($v -gt 99 -or $v -lt 10)
    {
        throw "$v"
    }
    $total+=$v
    $first= $null
}
$total

#54489 too high
