$total=0

function checkNums($nlist,$skip)
{
    $p=-1
    $dir=0
    $c=0
    $nc=0
    foreach($n in $nlist)
    {
        $nc++
        if ($nc -eq $skip)
        { Write-Host "Skipping n: $n";continue}

        $c++
        Write-Host "c : $c  n: $n   p: $p"
        if ($c -eq 2)
        {
            $d = $p - $n
            Write-Host "d: $d"
            if ($d -gt 0)        {   $dir=1 }
            if ($d -lt 0)        {   $dir=-1 }
            if ($d -eq 0) {$dir=0; Write-Host "fail dir=0";return $false}
            if ([Math]::Abs($d) -gt 3)
            { Write-Host "fail diff too big";return $false}
        }
        Write-Host "dir : $dir"

        if ($c -gt 2)
        {
            $newdir=0
            $d = $p - $n
            Write-Host "d: $d"
            if ($d -gt 0)        {   $newDir=1 }
            if ($d -lt 0)        {   $newDir=-1 }
            if ($d -eq 0) {$newDir=0;Write-Host "fail newdir=0";return $false}
            Write-Host "newdir : $newdir"

            if ($newdir -ne $dir) {Write-Host "fail dir change";return $false}

            if ([Math]::Abs($d) -gt 3)
            { Write-Host "fail diff too big";return $false}
            $dir=$newDir
        }
        $p=$n
        #Read-Host
    }
    return $true
}

$nums=@()
Get-Content "$PSScriptRoot\02.txt" | %{
    $nums=@()
    $line = $_
    # "origline: $line"
    while ($line)
    {
        $i=$line.IndexOf(' ')
        if ($i -gt 0){
            $n=[int]$line.Substring(0,$i)
            $line = $line.Substring($i+1)
        }
        else
        { $n = [int]$line;$line=""}
        $nums+=$n
    }

    # $nums -join ','
    # "-------------------"

    $r=$false
    for($skip=0;$skip -le $nums.Count;$skip++)
    {
        Write-Host "skip: $skip"
        $nums -join ','
        $r = checkNums $nums $skip
        "r: $r"
        "#################"
        if ($r) {$total++;$skip = $nums.Count + 5}
    }
    "++++++++++++++++++++++++++++++++++++"
    # if (-not($r))
    # {Read-Host "press a key"}
}

"Result:"
$total
# 274 too low
# 289 too low
# Answer 318