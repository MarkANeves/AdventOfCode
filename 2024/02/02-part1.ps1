$total=0

Get-Content "$PSScriptRoot\02.txt" | %{
    $line = $_
    $origline=$line
    $p=-1
    $dir=0
    $failed=$false
    $c=0
    while ($line)
    {
        $i=$line.IndexOf(' ')
        if ($i -gt 0){
            $n=[int]$line.Substring(0,$i)
            $line = $line.Substring($i+1)
        }
        else
        { $n = [int]$line;$line=""}
        $n
        $line
        "-----------"
        "origLine: $origline"
        $c++
        "c : $c  n: $n   p: $p"

        if ($c -eq 2)
        {
            $d = $p - $n
            "d: $d"
            if ($d -gt 0)        {   $dir=1 }
            if ($d -lt 0)        {   $dir=-1 }
            if ($d -eq 0) {$failed=$true;$dir=0;"fail dir=0"}
            if ([Math]::Abs($d) -gt 3)
            { "fail diff too big"; $failed=$true}
        }
        "dir : $dir"

        if ($c -gt 2)
        {
            $newdir=0
            $d = $p - $n
            "d: $d"
            if ($d -gt 0)        {   $newDir=1 }
            if ($d -lt 0)        {   $newDir=-1 }
            if ($d -eq 0) {$failed=$true;$newDir=0;"fail newdir=0"}
            "newdir : $newdir"

            if ($newdir -ne $dir) {"fail dir change";$failed=$true}

            if ([Math]::Abs($d) -gt 3)
            { "fail diff too big"; $failed=$true}
            $dir=$newDir
        }
        $p=$n
        #Read-Host
    }
    if (-not($failed)) {$total++}
    "origline: $origline"
    #Read-Host "failed : $failed : next line"
    "########################"
}

"Result:"
$total
# Answer: 246
