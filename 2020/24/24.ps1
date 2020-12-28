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

$tilesToFlip = @()
$tilesToFlip += "esew" 
$tilesToFlip += "nwwswee"

$tileList=@()

function newTile([ref]$tileListRef)
{
    $newTile = [PSCustomObject]@{
        ne = $null
        e  = $null
        se = $null
        sw = $null
        w  = $null
        nw = $null
        black = $false
        id = $tileListRef.Value.Count+1
    }

    $tileListRef.value+=$newTile
    return $newTile
}

function addTile($tile,$dir,[ref]$tileListRef)
{
    $newTile = newTile $tileListRef
    if ($dir -eq "sw") 
    { 
        $newTile.ne=$tile; $tile.sw = $newTile;  
        
        if ($tile.w)  
        { 
            $newTile.nw = $tile.w; $tile.w.se = $newTile
            if ($tile.w.sw)
            {
                $newTile.w = $tile.w.sw; $tile.w.sw.e = $newTile
                if ($tile.w.sw.se)
                {
                    $newTile.sw = $tile.w.sw.se; $tile.w.sw.se.ne = $newTile
                    if ($tile.w.sw.se.e)
                    {
                        $newTile.se = $tile.w.sw.se.e; $tile.w.sw.se.e.nw = $newTile
                        if ($tile.w.sw.se.e.ne)
                        {
                            $newTile.e = $tile.w.sw.se.e.ne; $tile.w.sw.se.e.ne.w = $newTile
                        }
                    }
                }
            } 
        }

        if ($tile.se)  
        { 
            $newTile.e = $tile.se; $tile.se.w = $newTile
            if ($tile.se.sw)
            {
                $newTile.se = $tile.se.sw; $tile.se.sw.nw = $newTile
                if ($tile.se.sw.w)
                {
                    $newTile.sw = $tile.se.sw.w; $tile.se.sw.w.ne = $newTile
                    if ($tile.se.sw.w.nw)
                    {
                        $newTile.w = $tile.se.sw.w.nw; $tile.se.sw.w.nw.e = $newTile
                        if ($tile.se.sw.w.nw.ne)
                        {
                            $newTile.nw = $tile.se.sw.w.nw.ne; $tile.se.sw.w.nw.ne.se = $newTile
                        }
                    }
                }
            } 
        }
    }
    
    if ($dir -eq "ne")
    { 
        $tile.ne = $newTile; $newTile.sw=$tile; $newTile.w  = $tile.nw; $newTile.se = $tile.e
        if ($tile.e)  { $tile.e.nw = $newTile }
        if ($tile.nw) { $tile.nw.e = $newTile }
    }

    if ($dir -eq "e")  
    { 
        $tile.e  = $newTile; $newTile.w= $tile; $newTile.sw = $tile.se; $newTile.nw = $tile.ne 
        if ($tile.ne) { $tile.ne.se = $newTile }
        if ($tile.se) { $tile.se.ne = $newTile }
    }

    if ($dir -eq "w")  
    { 
        $tile.w  = $newTile; $newTile.e= $tile; $newTile.se = $tile.sw; $newTile.ne = $tile.nw 
        if ($tile.nw) { $tile.nw.sw = $newTile }
        if ($tile.sw) { $tile.sw.nw = $newTile }
    }

    if ($dir -eq "se") 
    { 
        $tile.se = $newTile; $newTile.nw=$tile; $newTile.ne = $tile.e;  $newTile.w  = $tile.sw 
        if ($tile.e)  { $tile.e.sw = $newTile }
        if ($tile.sw) { $tile.sw.e = $newTile }
    }

    if ($dir -eq "nw") 
    { 
        $tile.nw = $newTile; $newTile.se=$tile; $newTile.e  = $tile.ne; $newTile.sw = $tile.w  
        if ($tile.w)  { $tile.w.ne = $newTile }
        if ($tile.ne) { $tile.ne.w = $newTile }
    }
    return $newTile
}

function getTile($tile,$dir,[ref]$tileListRef)
{
    if ($dir -eq "ne") { $result = $tile.ne }
    if ($dir -eq "e")  { $result = $tile.e  }
    if ($dir -eq "se") { $result = $tile.se }
    if ($dir -eq "sw") { $result = $tile.sw }
    if ($dir -eq "w")  { $result = $tile.w  }
    if ($dir -eq "nw") { $result = $tile.nw }

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
        $tile=getTile $currentTile $dir ([ref]$tileList)
        $currentTile = $tile
        $dir=""
    }
    $currentTile.black = -not($currentTile.black)
}

$tileList | ? black | measure
