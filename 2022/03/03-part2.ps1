$l=0
$score=0

Get-Content "$PSScriptRoot\03.txt" | %{
    if ($l % 3 -eq 0) {$lines=@()}
    $lines+=[string]$_

    if ($l % 3 -eq 2)
    {
        foreach($c in $lines[0].ToCharArray())
        {
            if ($lines[1].Contains($c) -and $lines[2].Contains($c))
            {
                $s = [int]([char]$c)-96
                if ($s -lt 0) { $s += 58}
                $score+=$s
                break
            }
        }
    }
    $l+=1
}
"score $score"
