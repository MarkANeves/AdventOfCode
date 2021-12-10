$stopwatch =  [system.diagnostics.stopwatch]::StartNew()
$data=@()
Get-Content "$PSScriptRoot\10.txt" | %{$data+=$_}

$closed=")]}>"

$compScore=@{}
$compScore["("]=1
$compScore["["]=2
$compScore["{"]=3
$compScore["<"]=4

$compScores=@()

foreach ($line in $data)
{
    while (1)
    {
        $origlen = $line.Length
        $line = $line.Replace("()","")
        $line = $line.Replace("[]","")
        $line = $line.Replace("{}","")
        $line = $line.Replace("<>","")
        if ($line.Length -eq $origlen)
        {
            break
        }
    }
    $chars = $line.ToCharArray() 
    $chars | %{ if ($closed.Contains($_)) {continue}} # Corrupt

    [array]::Reverse($chars)
    $score=0
    $chars | %{$score=($score*5)+$compScore["$_"]}
    $compScores += $score
}
$compScores = $compScores | sort
$compScores[($compScores.Count-1)/2]

"$($stopwatch.Elapsed.hours):$($stopwatch.Elapsed.minutes):$($stopwatch.Elapsed.seconds):$($stopwatch.Elapsed.Milliseconds)"
