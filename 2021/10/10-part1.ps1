$data=@()
Get-Content "$PSScriptRoot\10test.txt" | %{$data+=$_}

$open="([{<"

$pair=@{}
$pair[")"]="("
$pair["]"]="["
$pair["}"]="{"
$pair[">"]="<"

$charScore=@{}
$charScore[")"]=3
$charScore["]"]=57
$charScore["}"]=1197
$charScore[">"]=25137

$score=0
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
            if ($c -ne $pair["$_"])
            {
                $score+=$charScore["$_"]
                continue
            }
        }
    }
}
$score
