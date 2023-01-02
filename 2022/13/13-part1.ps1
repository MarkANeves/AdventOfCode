$listsLeft=@()
$listsRight=@()
$inputs=@()
Get-Content "$PSScriptRoot\13.txt" | %{
    if ($_)
    {
        $inputs += $_
        if ($inputs.Count -eq 2)
        {
            $listsLeft+=$inputs[0]
            $listsRight+=$inputs[1]
            $inputs=@()
        }
    }
}

function Solve($left,$right)
{
    $lt = $left.GetType().Name
    $rt = $right.GetType().Name
    if ($lt -ne 'Object[]' -or $rt -ne 'Object[]')
    {
        throw "Wrong types ($lt) ($rt)"
    }

    $result=0
    $maxl = $left.Count
    $maxr = $right.Count
    $max = $maxl
    if ($max -lt $maxr){
        $max = $maxr
    }

    for ($i=0;$i -lt $max;$i++)
    {
        if ($i -ge $maxl) {return -1}
        if ($i -ge $maxr) {return  1}

        $l = $left[$i]
        $r = $right[$i]
        $lt = $l.GetType().Name
        $rt = $r.GetType().Name

        if ($lt -eq 'Int64' -and $rt -eq 'Int64')
        {
            if ($l -lt $r) {return -1}
            if ($l -gt $r) {return  1}
        }
        elseif ($lt -eq 'Int64') {
            $result = Solve @($l) $r
        }
        elseif ($rt -eq 'Int64') {
            $result = Solve $l @($r)
        }
        else {
            $result = Solve $l $r
        }

        if ($result -ne 0){
            return $result
        }
    }

    return 0;
}

$sum=0

for ($i=0;$i -lt $listsLeft.Count;$i++)
{
    "--------"
    $listsLeft[$i]
    $listsRight[$i]

    $left2  = $listsLeft[$i]  | ConvertFrom-Json
    $right2 = $listsRight[$i] | ConvertFrom-Json

    if ($null -eq $left2)  {$left2=@()}
    if ($null -eq $right2) {$right2=@()}

    if ($left2.GetType().Name  -eq "Int64"){$left2=@($left2)}
    if ($right2.GetType().Name -eq "Int64"){$right2=@($right2)}

    $res2 = Solve $left2 $right2

    if     ($res2 -lt 0) {$res2="Right order"; $sum+= $i+1}
    elseif ($res2 -gt 0) {$res2="NOT Right order"}

    "Result $i : $res2"
}

"Answer: $sum"