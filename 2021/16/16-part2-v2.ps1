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

$global:id=0

function MakePacket
{
    $o=[PSCustomObject]@{
        id = $global:id++
        pv = -1
        pt = -1
        v = -1
        parent = $null
        children=@()
        i = -1
        packetBits = 0
        subPacketBits = -1
        childSubPacketBits = 0
        subPackets = -1
        childSubPackets = 0
    }
    return $o
}

function DisplayPacket($name,$pk)
{
    Write-Host "--------$name---------------"
    if ($null -eq $pk)
    {
        Write-Host "null"
    }
    else {
        Write-Host "id = $($pk.id)"
        Write-Host "pv = $($pk.pv)"
        Write-Host "pt = $($pk.pt)"
        Write-Host "v = $($pk.v)"
        Write-Host "parent = $($pk.parent)"
        Write-Host "Child count = $($pk.children.Count)"
        Write-Host "i  = $($pk.i)"
        Write-Host "subPacketBits = $($pk.subPacketBits)"
        Write-Host "childSubPacketBits = $($pk.childSubPacketBits)"
        Write-Host "subPackets = $($pk.subPackets)"
        Write-Host "childSubPackets = $($pk.childSubPackets)"
        Write-Host "packetBits = $($pk.packetBits)"
    }
}

function CalcValue($pk)
{
    if ($pk.pt -eq 4)
    {
        $pk.v = $pk.v
    }
    if ($pk.pt -eq 0)
    {
        $pk.v = ($pk.children.v | measure -Sum).Sum
    }
    if ($pk.pt -eq 1)
    {
        $p=1;$pk.children.v | %{$p=$_ * $p}
        $pk.v = $p
    }
    if ($pk.pt -eq 2)
    {
        $pk.v = ($pk.children.v | measure -Minimum).Minimum
    }
    if ($pk.pt -eq 3)
    {
        $pk.v = ($pk.children.v | measure -Maximum).Maximum
    }
    if ($pk.pt -eq 5)
    {
        if ($pk.children.Count -lt 2) {throw "not enough children"}
        if ($pk.children[0].v -gt $pk.children[1].v) { $pk.v=1 }else{ $pk.v=0 }
    }
    if ($pk.pt -eq 6)
    {
        if ($pk.children.Count -lt 2) {throw "not enough children"}
        if ($pk.children[0].v -lt $pk.children[1].v) { $pk.v=1 }else{ $pk.v=0 }
    }
    if ($pk.pt -eq 7)
    {
        if ($pk.children.Count -lt 2) {throw "not enough children"}
        if ($pk.children[0].v -eq $pk.children[1].v) { $pk.v=1 }else{ $pk.v=0 }
    }
}

function IsPacketComplete($pk)
{
    return $pk.pt -eq 4 `
           -or $pk.subPacketBits -eq $pk.childSubPacketBits `
           -or $pk.subPackets    -eq $pk.childSubPackets
}

function ReadPacketBits($pk,$numBits)
{
    $n = ReadBits $numBits
    $pk.packetBits+=$numBits
    return $n
}

function ReadPacketLiteral($pk)
{
    $pk.v = ReadLiteral
    $bl=[convert]::ToString($pk.v,16).Length * 5
    $pk.packetBits += $bl
}

function ReadNextPacket
{
    $pk = MakePacket

    $pk.pv=ReadPacketBits $pk 3
    $pk.pt=ReadPacketBits $pk 3

    if ($pk.pt -eq 4)
    {
        ReadPacketLiteral $pk
    }
    else {
        $pk.i = ReadPacketBits $pk 1
        if ($pk.i -eq 0)
        {
            $pk.subPacketBits = ReadPacketBits $pk 15
        }
        else 
        {
            $pk.subPackets = ReadPacketBits $pk 11
        }
    }

    return $pk
}

function AttachToParent($pk,$parent)
{
    if ($null -ne $parent)
    {
        $pk.parent = $parent
        $parent.children += $pk
        $parent.childSubPacketBits += $pk.packetBits + $pk.childSubPacketBits
        $parent.childSubPackets    += 1
    }
}

function ReadPackets($parent)
{
    if ($data.Length -le 0)
    {
        throw "Ran out of data"
    }

    $nextPk = ReadNextPacket

    while (-not(IsPacketComplete $nextPk))
    {
        ReadPackets $nextPk | Out-Null
    }

    AttachToParent $nextPk $parent

    CalcValue $nextPk
    return $nextPk
}

$root = ReadPackets $null
"Result: $($root.v)"

#Answer: 3408662834145
