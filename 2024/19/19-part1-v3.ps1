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
$designs
"--------"
$patterns

function isNotUnique($pattern, $designs, [int]$index, [int]$maxDesignLen) {
    if ($index -ge $designs.Count) {
        return $false
    }

    if ($pattern.Length -eq 0) {
        return $true
    }

    $isNotUnique=$false
    $des = $designs[$index]

    if ($des.Length -gt $maxDesignLen) {
        return isNotUnique $pattern $designs ($index+1) $maxDesignLen
    }

    if ($pattern.StartsWith($des))
    {
        w "Matched $des"        
        $isNotUnique = isNotUnique ($pattern.Substring($des.Length)) $designs 0 $maxDesignLen
    }

    if ($isNotUnique) {
        return $true
    }

    return isNotUnique $pattern $designs ($index+1) $maxDesignLen
}

$designsToRemove=@()
foreach ($p in $designs)
{
    if ($p.Length -eq 1) {
        continue
    }
    w "Testing pattern $p"
    rh "test"
    $b = isNotUnique $p $designs 0 ($p.Length-1)
    w "$p result: $b"
    if ($b) {
        w2 "Removing $p"
        $designsToRemove+=$p
    }
    rh "Finished testing pattern"
}

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
$newDesigns
$newDesignsTime = $StopWatch.Elapsed
w "designs to remove"

foreach($p in $patterns) {
    rh "Next pattern"
    "~~~~~~~~~"
    "Testing $p"
    if (isNotUnique $p $newDesigns 0 ($p.Length-1)) {
        "YES"
        $total++
    }
    else {
        "NO"
    }
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