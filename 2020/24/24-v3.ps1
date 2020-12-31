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
#$tilesToFlip += "neeseswwnwe"

$tilesToFlip = @()
$c=Get-Content 'C:\Mark\Google Drive\Projects\AdventOfCode\2020\24\input.txt'
$c | %{$tilesToFlip += $_}

$tileList=@()
$tileMap=@{}

function newTile($hash, [ref]$tileListRef)
{
    $newTile = [PSCustomObject]@{
        hash=$hash
        black = $false
        id = $tileListRef.Value.Count
    }

    $tileListRef.Value += $newTile
    return $newTile
}

$x=0
$y=0
$h=[Math]::Sqrt(0.75)


function MovePos($dir,[ref]$xref,[ref]$yref)
{
    if ($dir -eq "e")  { $xref.value+=1;}
    if ($dir -eq "w")  { $xref.value-=1;}
    if ($dir -eq "ne") { $xref.value+=0.5; $yref.value+=$h }
    if ($dir -eq "se") { $xref.value+=0.5; $yref.value-=$h }
    if ($dir -eq "nw") { $xref.value-=0.5; $yref.value+=$h }
    if ($dir -eq "sw") { $xref.value-=0.5; $yref.value-=$h }
}

function TileHash($x,$y)
{
    $hash = "$([int]($x*10000)) : $([int]($y*10000))"
    return $hash
}

foreach ($directions in $tilesToFlip)
{
    $directions
    $x=$y=0
    $dir=""
    foreach($c in [char[]]$directions)
    {
        if ($c -eq "n" -or $c -eq "s")
        {
            $dir = $c
            continue
        }

        $dir += $c
        $dir
        MovePos $dir ([ref]$x) ([ref]$y)
        $dir=""
    }

    $hash = TileHash $x $y
    $tile = $tileMap[$hash]
    if ($null -eq $tile)
    {
        $tile = newTile $hash ([ref]$tileList)
        $tileMap.Add($hash,$tile)
    }
    $tile.black = -not($tile.black)
    $dir=""
}

$tileList | ? black | measure

"end"