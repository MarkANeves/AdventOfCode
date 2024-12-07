$total=0

$lines=@()
$mapAfter = @{}
$inputFile = "$PSScriptRoot\05.txt"

Get-Content $inputFile | %{
    "----------------"
    $line = $_
    $lines+=$line
    $line

    if ($line -match '(\d+)\|(\d+)') {
        $a = $matches[1]
        $b = $matches[2]
        "a: $a  b: $b"

        if (-not($mapAfter.ContainsKey($a)))
        {
            $mapAfter[$a] = @()
        }
        $mapAfter[$a] += $b 
    }
}

function checkNums($muns) {
    $p=-1
    $fail=$false
    for ($i=0;$i -lt $nums.Count;$i++)
    {
        $n = [int]$nums[$i]
        if ($p -eq -1)
        {
            $p = $n
            continue
        }

        if ($mapAfter.ContainsKey("$n") -and $mapAfter["$n"].Contains("$p"))
        {
            $fail=$true
            break
        }

        $p=$n
    }

    return $fail
}
"%%%%%%%%%%%%%%%%%%%%%%%%%%%"

Get-Content $inputFile | %{
    "----------------"
    $line = $_
    if ($line -match '(\d+),(\d+)') {
        $nums = $line.Split(',')
        $nums -join " : "

        $fail=checkNums $nums
        while ($fail) {
            $fail= checkNums $nums

            if (-not($fail)) {
                $middle = [int]$nums[[Math]::Floor($nums.Count / 2)]
                $total += $middle
                break
            }
            else {
                $p=-1            
                for ($i=0;$i -lt $nums.Count;$i++) {
                    $nums -join " : "

                    $n = [int]$nums[$i]
                    if ($p -eq -1)
                    {
                        $p = $n
                        continue
                    }
            
                    if ($mapAfter.ContainsKey("$n") -and $mapAfter["$n"].Contains("$p"))
                    {
                        $nums[$i] = "$p"
                        $nums[$i-1] = "$n"
                    }
                    else {
                        $p=$n
                    }
                }           
            }

        }
    }
}

"Result:"
$total
# 3539 too high
# answer: 3062
