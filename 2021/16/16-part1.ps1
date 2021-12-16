$ErrorActionPreference="Stop"
$global:data=Get-Content "$PSScriptRoot\16.txt"
$global:data
$global:bin=""

function ReadNextDigit
{
    if ($data.Length -eq 0)
    {
        throw "Run out of data"
    }

    $global:bin+=[convert]::ToString("0x$($data[0])",2).PadLeft(4,'0')
    $global:data=$data.Substring(1)
}

function ReadBits($numBits)
{
    while ($global:bin.Length -lt $numBits)
    {
        ReadNextDigit
    }

    $bits = $global:bin.Substring(0,$numBits)
    $n = [convert]::ToInt32($bits,2)
    $global:bin = $global:bin.Substring($numBits)
    return $n
}

function ReadLiteral
{
    $result=0
    $topBit=1
    while ($topBit -gt 0)
    {
        $n=ReadBits 5
        $topBit = $n -band 0x10
        $result = ($result*16) + ($n -band 0xf)
    }

    return $result
}

$sumVersions=0
try {
    while ($data.Length -gt 0)
    {
        $pv=ReadBits 3
        $pt=ReadBits 3
        $sumVersions+=$pv
        if ($pt -eq 4)
        {
            $l=ReadLiteral
            "literal: $l"
        }
        else {
            $i = ReadBits 1
            $subPacketBitLen = $numSubPackets = -1
            if ($i -eq 0) {
                $subPacketBitLen = ReadBits 15
            }
            else {
                $numSubPackets = ReadBits 11
            }
            "subPacketBitLen : $subPacketBitLen"
            "numSubPackets : $numSubPackets"
        }
    }
}
catch {
    Write-Host $_ -ForegroundColor Magenta    
}

"Sum of versions: $sumVersions"