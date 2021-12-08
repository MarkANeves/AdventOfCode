$data=@()
Get-Content "$PSScriptRoot\08.txt" | %{$data+=$_}

$dataLines=@()
foreach($line in $data)
{
    $line = $line.Split('|')
    $dataLine = [PSCustomObject]@{
        signals = $line[0].Split(' ',[System.StringSplitOptions]::RemoveEmptyEntries)
        digits  = $line[1].Split(' ',[System.StringSplitOptions]::RemoveEmptyEntries)
    }
    $dataLines += $dataLine
}

function CountCharsInStr($chars,$str)
{
    $c=0
    $chars.ToCharArray() | %{ if ($str.Contains($_)) {$c++} }
    return $c
}

function sortstr($s)
{
    $x=$s.ToCharArray(); [array]::Sort($x);$x -join ''
}

$numPat=New-Object string[] 10

$total=0
0..($dataLines.Length-1) | % {
    $i=$_
    $dataLines[$i].signals | %{
        if ($_.Length -eq 2) {$numPat[1]= sortstr $_}
        if ($_.Length -eq 3) {$numPat[7]= sortstr $_}
        if ($_.Length -eq 4) {$numPat[4]= sortstr $_}
        if ($_.Length -eq 7) {$numPat[8]= sortstr $_}
    }

    $dataLines[$i].signals | %{
        $numSevenChars = CountCharsInStr $numPat[7] $_
        $numFourChars  = CountCharsInStr $numPat[4] $_

        if ($_.Length -eq 6)
        {
            if ($numSevenChars -eq 3 -and $numFourChars -eq 4) {$numPat[9] = sortstr $_}
            if ($numSevenChars -eq 3 -and $numFourChars -eq 3) {$numPat[0] = sortstr $_}
            if ($numSevenChars -eq 2 -and $numFourChars -eq 3) {$numPat[6] = sortstr $_}
        }

        if ($_.Length -eq 5)
        {
            if ($numSevenChars -eq 2 -and $numFourChars -eq 2) {$numPat[2] = sortstr $_}
            if ($numSevenChars -eq 3 -and $numFourChars -eq 3) {$numPat[3] = sortstr $_}
            if ($numSevenChars -eq 2 -and $numFourChars -eq 3) {$numPat[5] = sortstr $_}
        }
    }

    $n=0
    $dataLines[$i].digits | %{
        $d = sortstr $_
        0..9 | %{if ($numPat[$_] -eq $d) { $n = ($n*10)+[int]$_};}
    }
    $total+=$n
}
"Total: $total"
