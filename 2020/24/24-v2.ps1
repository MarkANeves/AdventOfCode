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

$tilesToFlip = @()
$tilesToFlip += "neeseswwnwe"



$clockwiseNextTileMap     = @{ sw = "se"; w  = "sw"; nw = "w";  ne = "nw"; e  = "ne"; se = "e"; }
$clockwiseNextDirMap      = @{ sw = "w";  w  = "nw"; nw = "ne"; ne = "e";  e  = "se"; se = "sw";}

$anticlockwiseNextTileMap = @{ sw = "w";  w  = "nw"; nw = "ne"; ne = "e";  e  = "se"; se = "sw";}
$anticlockwiseNextDirMap  = @{ sw = "se"; w  = "sw"; nw = "e";  ne = "nw"; e  = "ne"; se = "e";}

$oppositeDirectionMap     = @{ sw = "ne"; w  = "e";  nw = "se"; ne = "sw"; e  = "w"; se = "nw";}

$tileList=@()

function newTile([ref]$tileListRef)
{
    $newTile = [PSCustomObject]@{
        links = @{}
        black = $false
        id = $tileListRef.Value.Count+1
    }

    $tileListRef.Value += $newTile
    return $newTile
}

function linkRoundTheClock($newTile,$tile,$dir,$nextTileMap,$nextDirMap)
{
    if ($null -eq $tile -or $newTile.links.Count -ge 6)
    {
        return
    }

    if (-not($tile.links.ContainsKey($dir)))
    {
        if ($newTile.links.ContainsKey($oppositeDirectionMap[$dir]))
        {
            $xyz=1
        }

        $tile.   links.Add($dir,                    $newTile)
        $newTile.links.Add($oppositeDirectionMap[$dir],$tile)
    }

    $nextTile = $tile.links[$nextTileMap[$dir]]
    $nextDir  = $nextDirMap[$dir]
    linkRoundTheClock $newTile $nextTile $nextDir $nextTileMap $nextDirMap   
}

function addTile($tile,$dir,[ref]$tileListRef)
{
    $newTile = newTile ([ref]$tileList)
    linkRoundTheClock $newTile $tile $dir $clockwiseNextTileMap     $clockwiseNextDirMap 
    linkRoundTheClock $newTile $tile $dir $anticlockwiseNextTileMap $anticlockwiseNextDirMap 

    return $newTile
}

function getTile($tile,$dir,[ref]$tileListRef)
{
    $result = $tile.links[$dir]

    if ($null -eq $result)
    {
        $result = addTile $tile $dir $tileListRef
    }

    return $result
}

$firstTile = newTile ([ref]$tileList)

foreach ($directions in $tilesToFlip)
{
    $directions
    $dir=""
    $currentTile=$firstTile
    foreach($c in [char[]]$directions)
    {
        if ($c -eq "n" -or $c -eq "s")
        {
            $dir = $c
            continue
        }

        $dir += $c
        $dir
        $tile=getTile $currentTile $dir ([ref]$tileList)
        $currentTile = $tile
        $dir=""
    }
    $currentTile.black = -not($currentTile.black)
}

$tileList | ? black | measure

"end"