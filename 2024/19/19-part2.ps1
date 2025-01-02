using namespace System.Collections.Generic

. 'C:\Mark\Google Drive\Projects\AdventOfCode\2024\shared.ps1'

$StopWatch = new-object system.diagnostics.stopwatch
$StopWatch.Start()

$total=[int64]0

$designs=@()
$patterns=@()

Get-Content "$PSScriptRoot\19.txt" | %{
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
$originalDesigns = copyArray $designs
#$designs
"--------"
#$patterns

function isNotUnique($pattern, $designs, [int]$index, [int]$maxDesignLen, [ref]$matchlist) {
    if ($index -ge $designs.Count) {
        return $false
    }

    if ($pattern.Length -eq 0) {
        return $true
    }

    $isNotUnique=$false
    $des = $designs[$index]

    if ($des.Length -gt $maxDesignLen) {
        return isNotUnique $pattern $designs ($index+1) $maxDesignLen $matchlist
    }

    if ($pattern -eq "bbrb") {
        rh "Found $pattern"
    }

    if ($pattern.StartsWith($des))
    {
        w "Matched $des with $pattern"
        $isNotUnique = isNotUnique ($pattern.Substring($des.Length)) $designs 0 $maxDesignLen $matchlist

        if ($isNotUnique) {
            $matchlist.Value += $des
        }
    }

    if ($isNotUnique) {
        return $true
    }

    return isNotUnique $pattern $designs ($index+1) $maxDesignLen $matchlist
}

$designsToRemove=@()
$copyOfDesigns = copyArray $designs
foreach ($p in $copyOfDesigns)
{
    if ($p.Length -eq 1) {
        continue
    }
    w2 "------------------"
    w2 "Testing pattern $p"
    rh "test"
    $matchList=@()
    $b = isNotUnique $p $designs 0 ($p.Length-1) ([ref]$matchList)
    w "$p result: $b"
    if ($b) {
        w2 "Removing $p"
        w2 "Match list"
        [array]::Reverse($matchList)
        $matchList
        rh "Next design"
        $designsToRemove+=$p
        $designs = copyArray $designs $p
    }
    rh "Finished testing pattern"
}

# w "Designs to remove"
# $designsToRemove
# $newDesigns=@()
# foreach($d in $designs)
# {
#     if (-not($designsToRemove.Contains($d)))
#     {
#         $newDesigns += $d
#     }
#     else {
#         1/0
#     }
# }
# "-----------"
# $newDesigns
# w "designs to remove"
#$newDesigns=$designs
$newDesignsTime = $StopWatch.Elapsed

foreach($p in $patterns) {
    rh "Next pattern"
    "~~~~~~~~~"
    "Testing $p"
    $matchList=@()
    if (isNotUnique $p $designs 0 ($p.Length-1) ([ref]$matchList)) {
        "YES"
        [array]::Reverse($matchList)
        $matchList -join ','
        $total++
    }
    else {
        "NO"
    }
}

function commaSequence($seedList,$lists,$depth,$prevCount)
{
    if ($depth -eq 0) {
        return $lists
    }

    $c=$lists.Count
    for ($i=$prevCount;$i -lt $c;$i++) {
        $l = $lists[$i]
        foreach($s in $seedList) {
            if ($l[$l.Count-1] -lt $s) {
                $newList=[List[int]]@()
                $l | %{$newList.Add($_)}
                $newList.Add($s)
                if ($newList.Count -lt 8) {
                    $lists.Add($newList)
                    if ($lists.Count % 10000 -eq 0) {
                        w2 "Lists: $($lists.Count)"
                    }
                }
            }
        }
    }
    commaSequence $seedList $lists ($depth-1) $c
}

$seedList=1..30
$lists=[List[List[int]]]@()
$seedList| %{
    $lists.Add($_)
}

$x = commaSequence $seedList $lists ($seedList.Count-1) 0
"x count: $($x.Count)"

foreach($l in $x) {
    $l -join ','
}
"x count: $($x.Count)"



$totalTime = $StopWatch.Elapsed

"Original designs: $($originalDesigns.Count)"
"New designs: $($designs.Count) : Time taken = $($newDesignsTime.Minutes)m $($newDesignsTime.Seconds)s"
$diffTime = $totalTime-$newDesignsTime
"Patterns: $($patterns.Count) : Time takem = $($diffTime.Minutes)m $($diffTime.Seconds)s"
"Total Time taken = $($totalTime.Minutes)m $($totalTime.Seconds)s"

"Result:"
$total
# answer: 236
# 372 too high
# 225 too low