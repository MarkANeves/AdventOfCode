$count=0
Get-Content "$PSScriptRoot\04.txt" | %{

    $_ -match "(\d+)-(\d+),(\d+)-(\d+)" | Out-Null

    $a=[int]$Matches[1]
    $b=[int]$Matches[2]
    $c=[int]$Matches[3]
    $d=[int]$Matches[4]

    #$_,$a,$b,$c,$d

    if (($c -ge $a -and $d -le $b) -or ($a -ge $c -and $b -le $d))
    {
        #"------------Found"
        $count++
    }
}

"Result: $count"
