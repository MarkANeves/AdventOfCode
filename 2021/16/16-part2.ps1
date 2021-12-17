$ErrorActionPreference="Stop"
$global:data=Get-Content "$PSScriptRoot\16.txt"
#$global:data
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

function MakePacket($pv,$pt)
{
    $o=[PSCustomObject]@{
        pv = $pv
        pt = $pt
        children=@()
        v = -1
        subPacketBitLen = -1
        numSubPackets = -1
        parent = $null
        bitLen = -1
    }
    return $o
}

function DisplayPacket($name,$pk)
{
    Write-Host "--------$name---------------"
    if ($null -eq $pk)
    {
        Write-Host "$null"
    }
    else {
        Write-Host "pv = $($pk.pv)"
        Write-Host "pt = $($pk.pt)"
        Write-Host "Child count = $($pk.children.Count)"
        Write-Host "v = $($pk.v)"
        Write-Host "subPacketBitLen = $($pk.subPacketBitLen)"
        Write-Host "numSubPackets = $($pk.numSubPackets)"
        Write-Host "parent = $($pk.parent)"
        Write-Host "bitLen = $($pk.bitLen)"
        Write-Host "data = $data"
    }
}

function CalcValue($pk)
{
    if ($pk.pt -eq 4)
    {
        $pk.v = [double]$pk.v
    }
    if ($pk.pt -eq 0)
    {
        $pk.v = [double]($pk.children.v | measure -Sum).Sum
    }
    if ($pk.pt -eq 1)
    {
        $p=1;$pk.children.v | %{$p=[double]$_ * [double]$p}
        $pk.v = [double]$p
    }
    if ($pk.pt -eq 2)
    {
        $pk.v = [double]($pk.children.v | measure -Minimum).Minimum
    }
    if ($pk.pt -eq 3)
    {
        $pk.v = [double]($pk.children.v | measure -Maximum).Maximum
    }
    if ($pk.pt -eq 5)
    {
        if ($pk.children[0].v -gt $pk.children[1].v) { $pk.v=1 }else{ $pk.v=0 }
    }
    if ($pk.pt -eq 6)
    {
        if ($pk.children[0].v -lt $pk.children[1].v) { $pk.v=1 }else{ $pk.v=0 }
    }
    if ($pk.pt -eq 7)
    {
        if ($pk.children[0].v -eq $pk.children[1].v) { $pk.v=1 }else{ $pk.v=0 }
    }
}

function ReadPackets($parent)
{
    if ($data.Length -lt 2)
    {
        return $parent
    }

    $nextPk = MakePacket -1 -1

    $nextPk.bitLen=0

    $nextPk.pv=ReadBits 3
    $nextPk.pt=ReadBits 3
    $nextPk.bitLen+=6

    if ($nextPk.pt -eq 4)
    {
        $l=ReadLiteral;
        $nextPk.v = $l
        $nextPk.bitLen += [convert]::ToString($l,16).Length * 5
    }
    else {
        $i = ReadBits 1
        $nextPk.bitLen+=1
        if ($i -eq 0)
        {
            $nextPk.subPacketBitLen = ReadBits 15
            $nextPk.bitLen+=15
        }
        else 
        {
            $nextPk.numSubPackets = ReadBits 11
            $nextPk.bitLen+=11
        }
    }

    if ($null -ne $parent)
    {
        $nextPk.parent = $parent
        $parent.children += $nextPk

        $parent.subPacketBitLen -= $nextPk.bitLen
        $parent.numSubPackets -=1

        CalcValue $parent
    }

    if ($nextpk.subPacketBitLen -gt 0 -or $nextPk.numSubPackets -gt 0)
    {
        ReadPackets $nextPk | Out-Null
    }

    if ($null -ne $parent)
    {
        if ($parent.subPacketBitLen -gt 0 -or $parent.numSubPackets -gt 0)
        {
            ReadPackets $parent | Out-Null
        }
        else {
            ReadPackets $parent.parent | Out-Null
        }
    }

    CalcValue $nextPk
    #DisplayPacket "finished" $nextPk

    return $nextPk
}

$root = ReadPackets $null
"Result: $($root.v)"
