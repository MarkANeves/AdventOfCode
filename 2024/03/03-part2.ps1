$total=0

$do=$true
Get-Content "$PSScriptRoot\03.txt" | %{
    "####################################"
    $line = $_
    $line
    #Read-Host
    $r=$true
    $continue = $true
    while ($continue) {
        $continue = $false
        $ir = [int]::MaxValue
        $ido = [int]::MaxValue
        $idont = [int]::MaxValue

        "-----------------------"
        $line
        $r=$line -match "mul\((\d+),(\d+)\)"
        if ($r) {
            $a = [int]$matches[1]
            $b = [int]$matches[2]
            $ir=$line.IndexOf($matches[0])
            $irLen = $matches[0].Length
        }

        $doFound=$line -match "do\(\)"
        if ($doFound)
        {
            $ido = $line.IndexOf($matches[0])
            $idoLen = $matches[0].Length
        }

        $dontFound=$line -match "don't\(\)"
        if ($dontFound)
        {
            $idont = $line.IndexOf($matches[0])
            $idontLen = $matches[0].Length
        }

        if ($r -and $ir -lt $ido -and $ir -lt $idont)
        {
            "found mul $a and $b"
            $line = $line.Substring($ir + $irLen)
            $continue = $true

            if ($do){
                $total += $a * $b
            }
            else {
                "!!!DID NOT MUL"
            }
        }

        if ($doFound -and $ido -lt $ir -and $ido -lt $idont) {
            "Found do"
            $continue = $true
            $do = $true
            $line = $line.Substring($ido + $idoLen)
        }

        if ($dontFound -and $idont -lt $ir -and $idont -lt $ido) {
            "found dont"
            $continue = $true
            $do = $false
            $line = $line.Substring($idont + $idontLen)
        }

        "r: $r  ir: $ir  irLen: $irLen  a: $a  b: $b  mul: $($a*$b)"
        "doFound: $doFound  ido: $ido  idoLen: $idoLen"
        "dontFound: $dontFound  idont: $idont  idontLen: $idontLen"
        "do: $do"
        "total: $total"
        "newline: $line"
        "continue: $continue"

        #Read-Host
    }
}

"Result:"
$total
# answer: 90044227
