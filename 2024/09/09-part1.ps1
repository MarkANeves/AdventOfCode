
$total=[int64]0

$disk = @()

$currentId=0
$space=$false
$count=0
Get-Content "$PSScriptRoot\09.txt" | %{
    $line = $_
    
    foreach($c in $line.ToCharArray())
    {
        $count++
        if ($count % 100 -eq 0) { Write-Host "$count : " -NoNewline}

        $nc = ([int]$c)-48
        if ($space) {
            for ($i=0;$i -lt $nc;$i++) {
                $disk += -1
            }
        }
        else {
            for ($i=0;$i -lt $nc;$i++) {
                $disk += $currentId
            }
            $currentId++
        }
        $space = -not($space)
    }
}
Write-Host ""

function displayDisk($disk)
{
    foreach($n in $disk)
    {
        if ($n -lt 0) {
            Write-Host '.' -NoNewline
        }
        else {
            Write-Host $n -NoNewline
        }
    }
    Write-Host ""
}

#displayDisk $disk
"disk count: $($disk.Count)"

$e=$disk.Count-1
for($i=0;$i -lt $disk.Count -and $i -lt $e;$i++) {
    if ($disk[$i] -ge 0) {
        continue
    }
    else {
        while ($disk[$e] -lt 0) {
            $e-=1
        }
        $disk[$i]=$disk[$e]
        $disk[$e]=-1
    }
    #displayDisk $disk
    #Read-Host
}

$total=0
"disk count: $($disk.Count)"
for($i=0;$i -lt $disk.Count;$i++)
{
    if ($disk[$i] -lt 0){
        continue
    }

    $n=[int64]$i * [int64]$disk[$i]
    $total+=[int64]$n
}

"Result:"
$total
# answer: 
# 6384018292784 too low
# 6384282084737 too high
# 6384282084737
# 6384282084737
# 6384282084737