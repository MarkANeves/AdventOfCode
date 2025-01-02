. 'C:\Mark\Google Drive\Projects\AdventOfCode\2024\shared.ps1'

$StopWatch = new-object system.diagnostics.stopwatch
$StopWatch.Start()

$total=[int64]0

$designs=@()
$patterns=@()

Get-Content "$PSScriptRoot\19-test.txt" | %{
    $line = $_

    if ($line.Contains(','))
    {
        $designs = $line.split(",",[System.StringSplitOptions]::RemoveEmptyEntries)
        for($i=0;$i -lt $designs.Count;$i++)
        {
            $designs[$i] = $designs[$i].Trim()
        }
    }

    if (-not($line.Contains(',')) -and $line.Length -gt 0)
    {
        $patterns += $line
    }
}
$designs = $designs | sort
#$designs
"--------"
#$patterns

function isNotUnique($pattern, $designs, [int]$index, [int]$maxDesignLen, [ref]$NumCalls) {
    $NumCalls.Value++
    if ($NumCalls.Value % 100 -eq 0) {
        w2 "Num calls $($NumCalls.Value)"
    }

    if ($index -ge $designs.Count) {
        return $false
    }

    if ($pattern.Length -eq 0) {
        return $true
    }

    $isNotUnique=$false
    $des = $designs[$index]

    if ($des.Length -gt $maxDesignLen) {
        return isNotUnique $pattern $designs ($index+1) $maxDesignLen $NumCalls
    }

    if ($pattern.StartsWith($des))
    {
        w "Matched $des"        
        $isNotUnique = isNotUnique ($pattern.Substring($des.Length)) $designs 0 $maxDesignLen $NumCalls
    }

    if ($isNotUnique) {
        return $true
    }

    return isNotUnique $pattern $designs ($index+1) $maxDesignLen $NumCalls
}

function testAll($pattern, $designs, [int]$index, [ref]$matchCount, [ref]$numCalls)
{
    $NumCalls.Value++
    if ($NumCalls.Value % 1000 -eq 0) {
        w2 "Num calls $($NumCalls.Value) | matchCount: $($matchCount.Value)"
    }

    if ($index -ge $designs.Count) {
        return
    }

    if ($pattern.Length -eq 0) {
        $matchCount.Value++
        return
    }

    $des = $designs[$index]

    if ($pattern.StartsWith($des))
    {
        w "Matched $des"        
        testAll ($pattern.Substring($des.Length)) $designs 0 $matchCount $numCalls
    }
    
    testAll $pattern $designs ($index+1) $matchCount $numCalls
}


$designsToRemove=@()
$copyOfDesigns = copyArray $designs
# foreach ($p in $copyOfDesigns)
# {
#     if ($p.Length -eq 1) {
#         continue
#     }
#     w "Testing pattern $p"
#     rh "test"
#     $b = isNotUnique $p $designs 0 ($p.Length-1)
#     w "$p result: $b"
#     if ($b) {
#         w2 "Removing $p"
#         $designsToRemove+=$p
#         $designs = copyArray $designs $p
#     }
#     rh "Finished testing pattern"
# }

w "Designs to remove"
$designsToRemove
$newDesigns=@()
foreach($d in $designs)
{
    if (-not($designsToRemove.Contains($d)))
    {
        $newDesigns += $d
    }
}
"-----------"
#$newDesigns
$newDesignsTime = $StopWatch.Elapsed
w "designs to remove"

function getDesignsInPattern($pattern,$designs)
{
    $dInP=@()
    foreach($d in $designs)
    {
        if ($pattern.Contains($d)) {
            w "$pattern contains $d"
            $dInP += $d
        }
    }
    return $dInP
}

foreach($p in $patterns) {
    [System.GC]::Collect()
    rh "Next pattern"
    "~~~~~~~~~"
    "Testing $p"
    $designsInPattern = getDesignsInPattern $p $copyOfDesigns
    w2 "Designs in pattern: $designsInPattern : $($designsInPattern.Count)"
    rh "designs in pattern"
    $numMatches=0
    $NumCalls=0
    testAll $p $designsInPattern 0 ([ref]$numMatches) ([ref]$NumCalls)
    $total+=$numMatches
    "Num matches : $numMatches"
    "Total: $total"
}

$totalTime = $StopWatch.Elapsed

"Original designs: $($designs.Count)"
"New designs: $($newDesigns.Count) : Time taken = $($newDesignsTime.Minutes)m $($newDesignsTime.Seconds)s"
$diffTime = $totalTime-$newDesignsTime
"Patterns: $($patterns.Count) : Time takem = $($diffTime.Minutes)m $($diffTime.Seconds)s"
"Total Time taken = $($totalTime.Minutes)m $($totalTime.Seconds)s"

"Result:"
$total
# answer: 236
# 372 too high
# 225 too low