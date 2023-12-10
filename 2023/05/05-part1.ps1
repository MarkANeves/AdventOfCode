$result = 0

$lines=@()
Get-Content "$PSScriptRoot\05.txt" | %{ $lines += $_ }

$seeds=@()
$lines[0].Split(" ") | %{if ($_ -match "(\d+)") { $seeds+=[int64]$matches[1] }}
#$seeds

$mapList=@()
for ($i=1; $i -lt $lines.Length; $i++)
{
    if ($lines[$i] -match "(\w+)-to-(\w+)"){
        $mapSrc = $matches[1]
        $mapDest = $matches[2]
        #"$mapSrc to $mapDest"
        $map = [PSCustomObject]@{
            Name = "$mapSrc to $mapDest"
            MapSrc = $mapSrc
            MapDest = $mapDest
            MapRanges = @()
        }
        $i++
        while ($lines[$i] -match "(\d+) (\d+) (\d+)"){
            $mapRange = [PSCustomObject]@{
                Dest = [int64]$matches[1]
                Src  = [int64]$matches[2]
                Len  = [int64]$matches[3]
            }
            $map.MapRanges += $mapRange
            $i++
        }
        $mapList += $map
    }
}
#$mapList

$mappedValues=@()

$seeds | %{
    #sleep 1
    "+++++++++++++++++++++++"
    $v = $_
    $mapList | %{
        Write-Host "---------------"
        Write-Host "Map $($_.Name)"
        $v = mapValue $v $_
    }
    $mappedValues += $v
    "+++++++++++++++++++++++"
}

function mapValue($v,$map)
{
    $mappedV = $null
    $map.MapRanges | %{
        if (-not($mappedV))
        {
            $srcStart = $_.Src
            $srcEnd = $srcStart + $_.Len
            #Write-Host "srcStart: $srcStart | srcEnd: $srcEnd"
            if ($v -ge $srcStart -and $v -le $srcEnd)
            {
                Write-Host "$v is in map $($map.Name)"
                $d = $v - $srcStart
                $mappedV = $_.Dest + $d
                Write-Host "mappedV: $mappedV"
            }
        }
    }
    if ($mappedV)
    {
        #Write-Host "mapped: $mappedV"
        return $mappedV
    }
    else {
        #Write-Host "not mapped: $v"
        return $v
    }
}

"=============="
$mappedValues = $mappedValues | sort
$mappedValues[0]

#answer 621354867