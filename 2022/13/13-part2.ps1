$list=@()
Get-Content "$PSScriptRoot\13.txt" | %{
    if ($_)
    {
        $list += $_
    }
}
$list+="[[2]]"
$list+="[[6]]"

function Test-InRightOrder($left,$right)
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
            $result = Test-InRightOrder @($l) $r
        }
        elseif ($rt -eq 'Int64') {
            $result = Test-InRightOrder $l @($r)
        }
        else {
            $result = Test-InRightOrder $l $r
        }

        if ($result -ne 0){
            return $result
        }
    }

    return 0;
}

function InRightOrder($left,$right)
{
    $left  = $left  | ConvertFrom-Json
    $right = $right | ConvertFrom-Json

    if ($null -eq $left)  {$left=@()}
    if ($null -eq $right) {$right=@()}

    if ($left.GetType().Name  -eq "Int64"){$left=@($left)}
    if ($right.GetType().Name -eq "Int64"){$right=@($right)}

    $res = Solve $left $right

    if ($res -le 0) {return $true} else {return $false}
}

$swapped = $true
while ($swapped)
{
    $swapped = $false
    for ($i=0;$i -lt ($list.Count-1);$i++)
    {
        if (-not(InRightOrder $list[$i] $list[$i+1]))
        {
            $x=$list[$i]
            $list[$i]=$list[$i+1]
            $list[$i+1]=$x
            $swapped = $true
        }
    }
}

for($i=0;$i -lt $list.Count;$i++)
{
    if ($list[$i] -eq "[[2]]") {$i1=$i+1}
    if ($list[$i] -eq "[[6]]") {$i2=$i+1}
}
$i1
$i2
"Answer: $($i1*$i2)"
