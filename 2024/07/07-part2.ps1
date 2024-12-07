

function addCombine($src,[int]$level,[int]$max)
{
    if ($level -eq $max) {return}

    if ($level -eq 0)
    {
        for($i=0;$i -lt $src.Length;$i++)
        {
            $global:combResult += $src[$i]
        }
        addCombine $src ($level+1) $max
        return        
    }

    $comb=@()
    for($i=0;$i -lt $src.Length;$i++)
    {
        foreach($v in $global:combResult)
        {
            $comb += $v+$src[$i]
        }
    }
    $global:combResult = $comb
    addCombine $src ($level+1) $max
}

$total=0
$lines=@()
$comboMap=@{}

$count=0
Get-Content "$PSScriptRoot\07.txt" | %{
    $count++
    "$($count) ============================"

    $nums=@()
    $line = $_
    $lines+=$line

    $testVal = [int64]$line.Substring(0,$line.IndexOf(':'))
    $testVal
    $line = $line.Substring($line.IndexOf(':')+1)
    $line.Split(' ',[System.StringSplitOptions]::RemoveEmptyEntries) | %{$nums+=[int64]$_}

    $nums -join " : "
    $numsC = $nums.Count
    "Num numbers: $numsC"

    $combResult=@()

    if ($comboMap.ContainsKey($numsC))
    {
        Write-Host "Key found"
        $combResult = $comboMap[$numsC]
    }
    else {
        addCombine "+*|" 0 ($numsC-1)
        "Num combos : $($combResult.Count)"
        $comboMap[$numsC] = $combResult
    }

    $combocount=0
    foreach ($opCombo in $combResult)
    {
        $combocount++
        if ($combocount % 1000 -eq 0)
        {Write-Host "." -NoNewline}
        $eval = [int64]0
        $opIndex=-1

        foreach($n in $nums)
        {
            if ($opIndex -ge 0)
            {
                $c = $opCombo[$opIndex]
                if ($c -eq "+"){
                    $eval += [int64]$n
                }
                elseif ($c -eq "*") {
                    $eval *= [int64]$n
                }
                else {
                    $eval = [int64]("$eval"+"$n")
                }
            }
            else {
                $eval= $n
            }
            $opIndex++
        }

        #"eval: $eval : $testVal"
        if ($eval -eq $testVal)
        {
            $total += $eval
            Write-Host "******************** FOUND!"
            break
        }
    }
    Write-Host ""
}

"Result:"
$total
# answer: 162042343638683
