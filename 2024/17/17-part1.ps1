$total=[int64]0

$A=729
$B=0
$C=0
$program=0,1,5,4,3,0

$A=37293246
$B=0
$C=0
$program=2,4,1,6,7,5,4,4,1,7,0,3,5,5,3,0

#If register C contains 9, the program 2,6 would set register B to 1.
#$C=9
#$program=2,6

#If register A contains 10, the program 5,0,5,1,5,4 would output 0,1,2.
#$A=10
#$program=5,0,5,1,5,4

#If register A contains 2024, the program 0,1,5,4,3,0 would output 4,2,5,6,7,7,7,7,3,1,0 and leave 0 in register A
# $A=2024; $B=0; $C=0
# $program=0,1,5,4,3,0

#If register B contains 29, the program 1,7 would set register B to 26.
#$B=29
#$program=1,7

#If register B contains 2024 and register C contains 43690, the program 4,0 would set register B to 44354.
# $B=2024
# $C=43690
# $program=4,0

function getComboOperand($v) {
    if ($v -ge 0 -and $v -le 3){
        return $v
    }
    if ($v -eq 4){
        return $A
    }
    if ($v -eq 5){
        return $B
    }
    if ($v -eq 6){
        return $C
    }
    throw "combo op : $v"
}

$p=0
$running=$true
while ($running) {

    $opcode = $program[$p++]

    if ($opcode -eq 0) {
        $operand = $program[$p++]
        $d = getComboOperand $operand
        $d = [Math]::Pow(2,$d)
        $div = ($A/$d)
        $A = [Math]::Floor($div)
    }

    if ($opcode -eq 1) {
        $operand = $program[$p++]
        $B = $B -bxor $operand
    }

    if ($opcode -eq 2) {
        $operand = $program[$p++]
        $d = getComboOperand $operand
        $B = $d % 8
    }

    if ($opcode -eq 3) {
        $operand = $program[$p++]
        if ($A -ne 0)
        {
            $p = $operand
        }
    }

    if ($opcode -eq 4) {
        $operand = $program[$p++]
        $B = $B -bxor $C
    }

    if ($opcode -eq 5) {
        $operand = $program[$p++]
        $d = getComboOperand $operand
        $d = $d % 8
        Write-Host "$d," -NoNewline
    }

    if ($opcode -eq 6 ) {
        $operand = $program[$p++]
        $d = getComboOperand $operand
        $d = [Math]::Pow(2,$d)
        $B = [Math]::Floor($A/$d)
    }

    if ($opcode -eq 7 ) {
        $operand = $program[$p++]
        $d = getComboOperand $operand
        $d = [Math]::Pow(2,$d)
        $C = [Math]::Floor($A/$d)
    }

    if ($p -ge $program.Count) {
        $running = $false
    }

}
Write-Host ""

Write-Host "A:$A"
Write-Host "B:$B"
Write-Host "C:$C"
"Result:"
$total
# answer: 1,5,0,1,7,4,1,0,3