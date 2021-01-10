. "$PSScriptRoot\graphics.ps1"

$ErrorActionPreference= "Inquire"

$tilesToFlip = @()
$tilesToFlip += "sesenwnenenewseeswwswswwnenewsewsw"
$tilesToFlip += "neeenesenwnwwswnenewnwwsewnenwseswesw"
$tilesToFlip += "seswneswswsenwwnwse"
$tilesToFlip += "nwnwneseeswswnenewneswwnewseswneseene"
$tilesToFlip += "swweswneswnenwsewnwneneseenw"
$tilesToFlip += "eesenwseswswnenwswnwnwsewwnwsene"
$tilesToFlip += "sewnenenenesenwsewnenwwwse"
$tilesToFlip += "wenwwweseeeweswwwnwwe"
$tilesToFlip += "wsweesenenewnwwnwsenewsenwwsesesenwne"
$tilesToFlip += "neeswseenwwswnwswswnw"
$tilesToFlip += "nenwswwsewswnenenewsenwsenwnesesenew"
$tilesToFlip += "enewnwewneswsewnwswenweswnenwsenwsw"
$tilesToFlip += "sweneswneswneneenwnewenewwneswswnese"
$tilesToFlip += "swwesenesewenwneswnwwneseswwne"
$tilesToFlip += "enesenwswwswneneswsenwnewswseenwsese"
$tilesToFlip += "wnwnesenesenenwwnenwsewesewsesesew"
$tilesToFlip += "nenewswnwewswnenesenwnesewesw"
$tilesToFlip += "eneswnwswnwsenenwnwnwwseeswneewsenese"
$tilesToFlip += "neswnwewnwnwseenwseesewsenwsweewe"
$tilesToFlip += "wseweeenwnesenwwwswnew"

#$tilesToFlip = @()
#$tilesToFlip += "esew" 
#$tilesToFlip += "nwwswee"



#$tilesToFlip = @()
#Get-Content 'C:\Mark\Google Drive\Projects\AdventOfCode\2020\24\input.txt' | %{$tilesToFlip += $_}

#$tilesToFlip = @()
#$tilesToFlip += "neeseswwnwe"

$tileMap=@{}

function newTile($hash,$x,$y)
{
    $newTile = [PSCustomObject]@{
        id = $tileMap.Count
        black = $false
        numFlips=0
        hash=$hash
        x=$x
        y=$y
    }
    return $newTile
}

$yDelta = [Math]::Sqrt(1-(0.5*0.5)) # The amount y changes on a diagonal move

function MovePos($dir,[ref]$xref,[ref]$yref)
{
    if     ($dir -eq "e")  { $xref.value+=1;}
    elseif ($dir -eq "w")  { $xref.value-=1;}
    elseif ($dir -eq "ne") { $xref.value+=0.5; $yref.value+=$yDelta }
    elseif ($dir -eq "se") { $xref.value+=0.5; $yref.value-=$yDelta }
    elseif ($dir -eq "nw") { $xref.value-=0.5; $yref.value+=$yDelta }
    elseif ($dir -eq "sw") { $xref.value-=0.5; $yref.value-=$yDelta }
    else {throw "Unknown dir '$dir'"}
}

function TileHash($x,$y)
{
    $hash = "$([int]($x*100000)) : $([int]($y*100000))"
    return $hash
}

function AddTileToMap($x,$y)
{
    $hash = TileHash $x $y
    $tile = $tileMap[$hash]
    if ($null -eq $tile)
    {
        $tile = newTile $hash $x $y
        $tileMap.Add($hash,$tile)
    }
    return $tile
}



foreach ($directions in $tilesToFlip)
{
    $directions
    $x=$y=0
    $tile=AddTileToMap $x $y
    $dir=""
    foreach($c in [char[]]$directions)
    {
        if ($c -eq "n" -or $c -eq "s")
        {
            $dir = $c
            continue
        }

        $dir += $c
        #$dir
        MovePos $dir ([ref]$x) ([ref]$y)
        $tile=AddTileToMap $x $y
        renderTileMap $tileMap
        $dir=""
    }
    if ($dir) {throw "what?"}

    $tile = AddTileToMap $x $y
    $tile.black = -not($tile.black)
    $tile.numFlips++
    renderTileMap $tileMap
    ""
}

$numBlackTiles = $tileMap.values.GetEnumerator() | ? black | measure | select -ExpandProperty count
"Num black tiles : $numBlackTiles"

renderTileMap $tileMap

$tileMap.values.GetEnumerator() | ? numFlips -eq 0 | measure | select -ExpandProperty count
$tileMap.values.GetEnumerator() | ? numFlips -eq 1 | measure | select -ExpandProperty count
$tileMap.values.GetEnumerator() | ? numFlips -eq 2 | measure | select -ExpandProperty count
$tileMap.values.GetEnumerator() | ? numFlips -gt 2 | measure | select -ExpandProperty count

"----------------------------"

function IsAdjacentTileBlack ($tile,$dir)
{
    $x=$tile.x
    $y=$tile.y
    MovePos $dir ([ref]$x) ([ref]$y)
    $hash = TileHash $x $y
    $adjtile = $tileMap[$hash]
    if ($adjtile)
    {
        return $adjtile.black
    }

    return $false
}

function CountAdjacentBlackTiles($tile)
{
    $adjacentBlackTiles = 0
    if (IsAdjacentTileBlack $tile "w")  { $adjacentBlackTiles+=1}
    if (IsAdjacentTileBlack $tile "nw") { $adjacentBlackTiles+=1}
    if (IsAdjacentTileBlack $tile "ne") { $adjacentBlackTiles+=1}
    if (IsAdjacentTileBlack $tile "e")  { $adjacentBlackTiles+=1}
    if (IsAdjacentTileBlack $tile "se") { $adjacentBlackTiles+=1}
    if (IsAdjacentTileBlack $tile "sw") { $adjacentBlackTiles+=1}

    return $adjacentBlackTiles
}

# $tile = $tileMap["10000 : 0"]
# CountAdjacentBlackTiles $tile

# $tile = $tileMap["0 : 0"]
# CountAdjacentBlackTiles $tile

"--------------------------------"

function GetAllQualifyingBlackTiles
{
    $qualifyingBlackTiles=@()
    foreach($tile in $tileMap.Values.GetEnumerator())
    {
        if ($tile.black)
        {
            $numAdjBlackTiles = CountAdjacentBlackTiles $tile
            if (($numAdjBlackTiles -eq 0) -or ($numAdjBlackTiles -gt 2))
            {
                $qualifyingBlackTiles += $tile
            }
        }
    }

    return $qualifyingBlackTiles
}

function GetAllQualifyingWhiteTiles
{
    $qualifyingWhiteTiles=@()
    foreach($tile in $tileMap.Values.GetEnumerator())
    {
        if (-not($tile.black))
        {
            $numAdjBlackTiles = CountAdjacentBlackTiles $tile
            if ($numAdjBlackTiles -eq 2)
            {
                $qualifyingWhiteTiles += $tile
            }
        }
    }

    return $qualifyingWhiteTiles
}

# $qBlack = GetAllQualifyingBlackTiles
# "########################"
# $qWhite = GetAllQualifyingWhiteTiles
# "------------------------"
# $tile=$tileMap.values.GetEnumerator() | ? id -eq 1
# $tile.black=$true
# $qBlack2 = GetAllQualifyingBlackTiles
# $qWhite2 = GetAllQualifyingWhiteTiles
# "------------------------"
# $tile=$tileMap.values.GetEnumerator() | ? id -eq 3; $tile.black=$true
# $tile=$tileMap.values.GetEnumerator() | ? id -eq 4; $tile.black=$true
# $qBlack3 = GetAllQualifyingBlackTiles
# $qWhite3 = GetAllQualifyingWhiteTiles

$tileMap.values.GetEnumerator() | select x,y,@{Name='C'; Expression={if($_.black){"B"}else{"W"}}} | ConvertTo-Csv -NoTypeInformation |Out-File 'C:\Mark\Google Drive\Projects\AdventOfCode\2020\24\coords.csv'

for ($day=1;$day -le 100; $day++)
{
    $blackTiles = GetAllQualifyingBlackTiles
    $whiteTiles = GetAllQualifyingWhiteTiles

    $blackTiles | %{$_.black = $false}
    $whiteTiles | %{$_.black = $true}

    $numBlackTiles = $tileMap.values.GetEnumerator() | ? black | measure | select -ExpandProperty count
    "-------------------"
    "Day $day"
    "Num black tiles : $numBlackTiles"
    renderTileMap $tileMap
}

"end"