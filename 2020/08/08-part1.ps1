$program=@()
Get-Content "$PSScriptRoot\08.txt" | %{$program+=$_}

$instructions=@()
foreach($i in $program)
{
    $i -match "(\S+)\s+(.*)" | Out-Null
    $opCode=$Matches[1]
    $param=[int]$Matches[2]
    $instructions += [PSCustomObject]@{opCode=$opCode;param=$param;run=$false}

}
#$instructions

$acc=$pc=0
while (1)
{
    $i = $instructions[$pc]
    if ($i.run)
    {
        break
    }
    $i.run=$true
    switch ($i.OpCode) {
        "acc" { $acc+=$i.param;$pc+=1;break }
        "jmp" { $pc+=$i.param;break }
        "nop" { $pc+=1;break;}
        Default {$pc+=1; break}
    }
}
$acc
$pc