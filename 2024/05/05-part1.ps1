$total=0

$mapAfter = @{}

Get-Content "$PSScriptRoot\05.txt" | %{
    "----------------"
    $line = $_
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

    if ($line -match '(\d+),(\d+)') {
        $nums = $line.Split(',')
        $nums -join " : "

        $p=-1
        $fail=$false
        for ($i=0;$i -lt $nums.Count;$i++)
        {
            $n = [int]$nums[$i]
            if ($p -eq -1)
            {
                $p = $n
                "first: $n"
                continue
            }
            "$i'th : $n  p: $p"

            if ($mapAfter.ContainsKey("$n") -and $mapAfter["$n"].Contains("$p"))
            {
                "$p is after $n  FAIL"
                $fail=$true
                break
            }

            $p=$n
        }

        if (-not($fail)) {
            "line : $line is GOOOD"
            $middle = [int]$nums[[Math]::Floor($nums.Count / 2)]
            "middle: $middle : $([int]($nums.Count / 2)): count: $([System.Math]::Floor($nums.Count / 2))"
            $total += $middle
        }
    }
}

"Result:"
$total
# answer: 5948
