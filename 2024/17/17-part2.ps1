$total=[int64]0

$A=729
$B=0
$C=0
$program=0,1,5,4,3,0

$A=37293246
$B=0
$C=0
$program=2,4,1,6,7,5,4,4,1,7,0,3,5,5,3,0

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

function calc($A,$B,$C,$program)
{
    $p=0
    $running=$true
    $result=@()
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
            #Write-Host "$d," -NoNewline
            $result+=$d
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

    return $result
}

function comparePrograms($p1,$p2)
{
    if ($p1.count -ne $p2.count) {
        return $false
    }
    for($i=0;$i -lt $p1.count;$i++){
        if ($p1[$i] -ne $p2[$i]) {
            return $false
        }
    }

    return $true
}

$A=37293246
$B=0
$C=0
$program=2,4,1,6,7,5,4,4,1,7,0,3,5,5,3,0

$A=2024
$B=0
$C=0
$program=0,3,5,4,3,0

$equal = $false
$A=0
while (-not($equal)) {
    $A++
    if ($A % 1000 -eq 0) {
        Write-Host "A: $A"
    }
    $r = calc $A $B $C $program
    $equal = comparePrograms $r $program
}

Write-Host "result: $($r -join ',')"

# answer: 1,5,0,1,7,4,1,0,3