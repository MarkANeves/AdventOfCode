$data=@()
Get-Content "$PSScriptRoot\04.txt" | %{$data+=$_}

$numbers=@()
$data[0].Split(',') | %{$numbers+=[int]$_}

function GetBoard($data,$i)
{
    $board=[PSCustomObject]@{
        numbers = @()
    }
    for ($row=0;$row -lt 5;$row++)
    {
        $col=0
        $data[$i+$row].Replace('  ',' ').Split(' ',[System.StringSplitOptions]::RemoveEmptyEntries) | %{
            $num=[PSCustomObject]@{
                n = [int]$_;
                row = $row;
                col = $col++;
                marked=[bool]0
            }
            $board.numbers +=$num
        }
    }
    return $board
}

$allBoards=@()
for ($i=1;$i -le $data.Count;$i++)
{
    if ($data[$i].Length -le 0) {continue}
    $allBoards += GetBoard $data $i
    "-----------"
    while($data[$i].Length -gt 0) {$i++}
}

function MarkNumbers($board,$num)
{
    foreach ($bn in $board.numbers)
    {
        if ($bn.n -eq $num) {$bn.marked = $true}
    }
}

function HasCompleteRowOrColumn($board)
{
    $rows=@{}
    $cols=@{}
    foreach ($bn in $board.numbers)
    {
        if ($bn.marked)
        {
            $rows[$bn.row]+=1
            $cols[$bn.col]+=1
        }
    }
    $rows.Values | %{if ($_ -eq 5) {return $true}}
    $cols.Values | %{if ($_ -eq 5) {return $true}}
    return $false
}

foreach($num in $numbers)
{
    foreach ($board in $allBoards)
    {
        #"---- $num"
        MarkNumbers $board $num
        $win = HasCompleteRowOrColumn $board
        #$win
        if ($win) {break;}
    }
    "win $win"
    if ($win) {
        "Winning number: $num"
        "Winning board:"
        #$board
        $sum = ($board.numbers | ? marked -eq $false | select -ExpandProperty n| measure -sum).Sum
        "result: $($sum * $num)"
        break;
    }
}