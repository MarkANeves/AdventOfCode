$data=@()
Get-Content "$PSScriptRoot\10.txt" | %{$data+=$_}

$open="([{<"

$openMatch=@{}
$openMatch[")"]="("
$openMatch["]"]="["
$openMatch["}"]="{"
$openMatch[">"]="<"

$closeMatch=@{}
$closeMatch["("]=")"
$closeMatch["["]="]"
$closeMatch["{"]="}"
$closeMatch["<"]=">"

$compScore=@{}
$compScore[")"]=1
$compScore["]"]=2
$compScore["}"]=3
$compScore[">"]=4

$compScores=@()

foreach ($line in $data)
{
    $stack = New-Object System.Collections.Stack
    $line.ToCharArray() | %{
        if ($open.Contains($_))
        {
            $stack.Push($_)
        }
        else {
            $c = $stack.Pop()
            if ($c -ne $openMatch["$_"])
            {
                continue
            }
        }
    }

    $completionScore=0
    while ($stack.Count -gt 0)
    {
        $c=$stack.Pop()
        $completionScore=($completionScore*5)+$compScore[$closeMatch["$c"]]
    }
    $compScores+=$completionScore
}
$compScores =$compScores | sort
$compScores[($compScores.Count-1)/2]
