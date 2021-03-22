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
$numInstructions=$instructions.Count
"Num instructions: $numInstructions"

function CopyInstructions($instructions)
{
    $newInstructions=@()
    foreach ($i in $instructions)
    {
        $newI = [PSCustomObject]@{opCode=$i.opCode;param=$i.param;run=$false}
        $newInstructions+=$newI
    }
    return $newInstructions
}

function ChangeNextJmpNop($inst,$pc)
{
    while ($inst[$pc].opCode -ne "nop" -and $inst[$pc].opCode -ne "jmp")
    {
        $pc+=1
    }
    if ($inst[$pc].opCode -eq "jmp")
    {
        $inst[$pc].opCode = "nop"
    }
    else 
    {
        $inst[$pc].opCode = "jmp"
    }

    return $pc+1
}

$nextJmpNop=0
while (1)
{
    "$nextJmpNop"
    $newInst=CopyInstructions $instructions
    $nextJmpNop = ChangeNextJmpNop $newInst $nextJmpNop
    $acc=$pc=0
    while (1)
    {
        $i = $newInst[$pc]
        if ($i.run -or $pc -eq $numInstructions)
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
    if ($pc -eq $numInstructions)
    {
        "Ran last instruction: acc = $acc"
        break
    }
    
}
