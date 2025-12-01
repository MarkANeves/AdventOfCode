
$total=[int64]0

$map=@()

$count=-1
Get-Content "$PSScriptRoot\16.txt" | %{
    $line = $_
    $count++
    If ($line.Length -gt 0) {
        if ($line[0] -eq "#") {
            $map += $line
            if ($line.IndexOf('S') -gt 0) {
                $px=$line.IndexOf('S')
                $py=$count
            }
        }
        else {
            $moves += $line
        }
    }
}
$w = $map[0].Length
$h = $map.Count

$map
"map px=$px  py=$py  w=$w  h=$h"
Read-Host "map"
"--------"


function getChar($x,$y)
{
    #"w: $w  h: $h"
    if ($x -lt 0 -or $x -ge $w) { return '#'}
    if ($y -lt 0 -or $y -ge $h) { return '#'}
    $map[$y][$x]
}

function setChar($c,$x,$y)
{
    #"w: $w  h: $h"
    if ($x -lt 0 -or $x -ge $w) { return }
    if ($y -lt 0 -or $y -ge $h) { return }
    $l=$map[$y]
    $left = $l.Substring(0,$x)
    $right = $l.Substring($x+1,$l.Length-$x-1)
    #"left: $left   right: $right"
    $map[$y]=$left+$c+$right
}

$routeId=0
function newRoute($x,$y,$d) 
{
    $r = [PSCustomObject]@{
        id = $global:routeId++
        x = $x
        y = $y
        d = $d
        score = 0
        visited = @{}
        finished = $false
        foundEnd = $false
    }
    return $r
}

function copyRoute($r)
{
    $nr          = newRoute $r.x $r.y $r.d
    $nr.score    = $r.score
    $nr.finished = $r.finished
    $nr.foundEnd = $r.foundEnd
    foreach($k in $r.visited.Keys) {
        $nr.visited[$k] = $r.visited[$k]
    }

    return $nr
}

function recordLocation($r)
{
    $key = ($r.y *1000) + $r.x
    $r.visited[$key] = 1
    # [PSCustomObject]@{
    #     x = $r.x
    #     y = $r.y
    # }
}

function hasVisited($r,$x,$y)
{
    $key = ($y *1000) + $x
    #$key ="$x-$y"
    return $r.visited.ContainsKey($key)
}

function canTurnLeft($r)
{
    if ($r.d -eq 'N') {
        $dx = -1; $dy = 0
    }
    if ($r.d -eq 'S') {
        $dx = 1; $dy = 0
    }
    if ($r.d -eq 'E') {
        $dx = 0; $dy = -1
    }
    if ($r.d -eq 'W') {
        $dx = 0; $dy = 1
    }

    $x = $r.x+$dx
    $y = $r.y+$dy
    if (hasVisited $r $x $y) {
        return $false
    }

    $c = getChar $x $y
    return -not($c -eq '#')
}

function canTurnRight($r)
{
    if ($r.d -eq 'N') {
        $dx = 1; $dy = 0
    }
    if ($r.d -eq 'S') {
        $dx = -1; $dy = 0
    }
    if ($r.d -eq 'E') {
        $dx = 0; $dy = 1
    }
    if ($r.d -eq 'W') {
        $dx = 0; $dy = -1
    }

    $x = $r.x+$dx
    $y = $r.y+$dy
    if (hasVisited $r $x $y) {
        return $false
    }
    
    $c = getChar $x $y
    return -not($c -eq '#')
}

function turnLeft($r)
{
    if ($r.d -eq 'N') {
        $r.x--
        $r.d = 'W'
    }
    elseif ($r.d -eq 'S') {
        $r.x++
        $r.d = 'E'
    }
    elseif ($r.d -eq 'E') {
        $r.y--
        $r.d = 'N'
    }
    elseif ($r.d -eq 'W') {
        $r.y++
        $r.d = 'S'
    }
    $r.score += 1001
    #"$($r.id) turned left - recording location"
    recordLocation $r
}

function turnRight($r)
{
    if ($r.d -eq 'N') {
        $r.x++
        $r.d = 'E'
    }
    elseif ($r.d -eq 'S') {
        $r.x--
        $r.d = 'W'
    }
    elseif ($r.d -eq 'E') {
        $r.y++
        $r.d = 'S'
    }
    elseif ($r.d -eq 'W') {
        $r.y--
        $r.d = 'N'
    }
    $r.score += 1001
    #"$($r.id) turned right - recording location"
    recordLocation $r
}

function moveForward($r)
{
    #"moving $($r.id) forward - d = $($r.d)"
    if ($r.finished) {
        #"moveForward $($r.id) - finished"
        return
    }

    if ($r.d -eq 'N') {
        $r.y--
    }
    if ($r.d -eq 'S') {
        $r.y++
    }
    if ($r.d -eq 'E') {
        $r.x++
    }
    if ($r.d -eq 'W') {
        $r.x--
    }

    if (hasVisited $r $r.x $r.y)
    {
        #"moveForward $($r.id) - hasVisted - finished"
        $r.finished = $true
        return
    }

    #"moveForward $($r.id) recording location"
    recordLocation $r
    $r.score++

    $c = getChar $r.x $r.y
    if ($c -eq '#') {
        #"moveForward $($r.id) - hit a wall - finished"
        $r.finished = $true
        $r.foundEnd = $false
    }
    elseif ($c -eq 'E') {
        #"moveForward $($r.id) - FOUND END - finished"
        $r.finished = $true
        $r.foundEnd = $true
    }
}

function displayRoute($r)
{
    "Displaying $($r.id) score=$($r.score)"
    
    for ($y=0;$y -lt $h;$y++) {
        for ($x=0;$x -lt $w;$x++) {
            if ($r.x -eq $x -and $r.y -eq $y) {
                Write-Host "O" -NoNewline
            }
            elseif (hasVisited $r $x $y) {
                Write-Host "+" -NoNewline
            }
            else {
                $c = getChar $x $y
                Write-Host $c -NoNewline
            }
        }
        Write-Host ""
    }
}

function displayAllRoutes {
    foreach($r in $routes) {
        if ($r.foundEnd) {
            '+++++++++++++++++++++++++++++++++++++'
            '+++++++++++++++++++++++++++++++++++++'
            displayRoute $r
        }
        if ($r.finished) {
            "$($r.id) has finished"
            continue
        }
    }
}

function getLowestScore
{
    $lowestScore = [int]::MaxValue
    foreach($r in $routes) {
        if ($r.foundEnd -and $r.score -lt $lowestScore)
        {
            $lowestScore = $r.score
        }
    }

    return $lowestScore
}

function removeHighScores
{
    $lowestScore = getLowestScore
    foreach($r in $routes)
    {
        if ($r.score -ge $lowestScore)
        {
            #"Eliminating $($r.id) score=$($r.score)  lowestScore=$lowestScore"
            $r.finished = $true
            #Read-Host "Eliminated"
        }
    }
}

function countFinished
{
    $count=0
    foreach($r in $routes)
    {
        if ($r.finished)
        {
            $count++
        }
    }
    return $count
}
function countFound
{
    $count=0
    foreach($r in $routes)
    {
        if ($r.foundEnd)
        {
            $count++
        }
    }
    return $count
}

$routes=@()
$route = newRoute $px $py 'E'
recordLocation $route

#displayRoute $route
#Read-Host "display first route"

function allFinished
{
    $count=0
    foreach($r in $routes)
    {
        if ($r.finished) {
            $count++
        }
    }

    #Write-Host "allFinished: count=$count  num routes=$($routes.Count)"
    return ($routes.Count -eq $count)
}

function removeFinished
{
    $newRoutes=@()
    foreach($r in $global:routes)
    {
        if (-not($r.finished) -or $r.foundEnd)
        {
            $newRoutes += $r
        }
    }

    $global:routes = $newRoutes
}

$routes += $route
while (-not(allFinished)) {
    #Write-Host "." -NoNewline
    "==============================="
    "routes count: $($routes.count)"
    "routes finished: $(countFinished)"
    "routes found: $(countFound)"
    removeHighScores
    removeFinished

    #displayAllRoutes
    #read-host "Displaying all routes"

    foreach($r in $routes)
    {
        if ($r.finished) {
            #"$($r.id) Finish"
            $finishedCount++
            continue
        }

        if (canTurnLeft $r)
        {
            #"$($r.id) can turn left"
            $nr = copyRoute $r

            # "^^^^^^^^^^^^^^^"
            # displayRoute $nr
            # Read-Host "Copied"

            turnLeft $nr

            # displayRoute $nr
            # Read-Host "After turned left"

            $routes += $nr
        }

        if (canTurnRight $r)
        {
            #"$($r.id) can turn right"
            $nr = copyRoute $r

            # "^^^^^^^^^^^^^^^"
            # displayRoute $nr
            # Read-Host "Copied"

            turnRight $nr

            # displayRoute $nr
            # Read-Host "After turned right"

            $routes += $nr
        }

        moveForward $r
    }
}

foreach($r in $routes)
{
    if ($r.foundEnd) {
        "---------------"
        $r
    }
}
$total = getLowestScore
"Result:"
$total
# answer: 