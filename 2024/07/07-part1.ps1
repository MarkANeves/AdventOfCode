
function Get-Permutations {
    [CmdletBinding()]
    param (
        [string] $prefix,
        [string] $word
    )
    if([string]::IsNullOrEmpty($word)){
        Write-Host $prefix -ForegroundColor Green
        #Add-Content -Path $fileName -Value $prefix
        $global:permResult += $prefix
    }else{
        for($i = 0; $i -lt $word.Length; $i++){
            $char = $word[$i]
            $newPrefix = $prefix + $char
            $newWord = $word.Substring(0, $i) + $word.Substring($i + 1)
            Write-Output("Character: {0} - Prefix: {1} - Word {2}" -f $char, $newPrefix, $newWord)
            Get-Permutations -prefix $newPrefix -word $newWord
        }
    }
}

#$permResult=@()
#Get-Permutations -prefix "" -word "+*+"
#$permResult


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

$count=0
Get-Content "$PSScriptRoot\07.txt" | %{
    $nums=@()
    $line = $_
    $lines+=$line

    $testVal = [int64]$line.Substring(0,$line.IndexOf(':'))
    $testVal
    $line = $line.Substring($line.IndexOf(':')+1)
    $line.Split(' ',[System.StringSplitOptions]::RemoveEmptyEntries) | %{$nums+=[int64]$_}

    $nums -join " : "

    $combResult=@()
    addCombine "+*" 0 ($nums.Count-1)

    $count++
    "$($count) ============================"
    foreach ($opCombo in $combResult)
    {
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
                else {
                    $eval *= [int64]$n
                }
            }
            else {
                $eval= $n
            }
            $opIndex++
        }

        if ($eval -eq $testVal)
        {
            $total += $eval
            Write-Host "******************** FOUND!"
            break
        }
    }
}


"Result:"
$total
# answer: 1260333054159
