$ErrorActionPreference="Stop"
$global:data=Get-Content "$PSScriptRoot\24.txt"

$progs=@()
$vars=@{}
$vars["x"]=0
$vars["y"]=0
$vars["z"]=0

foreach ($line in $data)
{
    $line -match '(\w+) (\w+) *(.*)' | Out-Null
    $instr = $Matches[1]
    $param1 = $Matches[2]
    $param2 = $Matches[3]

    $command = [PSCustomObject]@{
        instr = $instr
        param1 = $param1
        param2 = $param2
        value = $null
        line = $line
    }

    if ($param2 -match '^(-*\d+)$')
    {
        $command.value = [int]$Matches[1]
    }

    if  ($instr -eq "inp")
    {
        $prog = [PSCustomObject]@{
            commands  = @()
        }
        $progs += $prog
   }
   $prog.commands+=$command
}

$overallstopwatch  =  [system.diagnostics.stopwatch]::StartNew()
$itstopwatch  =  [system.diagnostics.stopwatch]::StartNew()

function DisplayStopwatch($msg,$sw)
{
    "$msg : $($sw.Elapsed.hours):$($sw.Elapsed.minutes):$($sw.Elapsed.seconds):$($sw.Elapsed.Milliseconds)"
}

function ExecuteInp($prog,$cmd,$i)
{
    $var = $cmd.param1
    $vars[$var]=$i
}

function ExecuteAdd($prog,$cmd)
{
    $var = $cmd.param1
    if ($null -eq $cmd.value) {
        $b = $vars[$cmd.param2]
    }
    else {
        $b = $cmd.value
    }
    $a = $vars[$var]
    $v = $a + $b 
    $vars[$var]=$v
}

function ExecuteMul($prog,$cmd)
{
    $var = $cmd.param1
    if ($null -eq $cmd.value) {
        $b = $vars[$cmd.param2]
    }
    else {
        $b = $cmd.value
    }
    $a = $vars[$var]
    $v = $a * $b 
    $vars[$var]=$v
}
function ExecuteDiv($prog,$cmd)
{
    $var = $cmd.param1
    if ($null -eq $cmd.value) {
        $b = $vars[$cmd.param2]
    }
    else {
        $b = $cmd.value
    }
    $a = $vars[$var]
    $v = [Math]::Floor($a / $b)
    $v2 = [int]($a / $b)
    if ($a -lt 0 -or $b -lt 0)
    {
        throw "$a : $b"
    }
    # if ($v -ne $v2)
    # {
    #     throw "$a : $b   $v : $v2"
    # }
    $vars[$var]=$v
}
function ExecuteMod($prog,$cmd)
{
    $var = $cmd.param1
    if ($null -eq $cmd.value) {
        $b = $vars[$cmd.param2]
    }
    else {
        $b = $cmd.value
    }
    $a = $vars[$var]
    $v = $a % $b
    $vars[$var]=$v
}
function ExecuteEql($prog,$cmd)
{
    $var = $cmd.param1
    if ($null -eq $cmd.value) {
        $b = $vars[$cmd.param2]
    }
    else {
        $b = $cmd.value
    }
    $a = $vars[$var]
    $v = 0
    if ($a -eq $b)
    {
        $v=1
    }
    $vars[$var]=$v
}
function ExecuteProg($prog,$i)
{
    foreach($cmd in $prog.commands)
    {
        #Write-Host $cmd.line
        switch ($cmd.instr)
        {
            "inp" {ExecuteInp $prog $cmd $i; break}
            "add" {ExecuteAdd $prog $cmd; break}
            "mul" {ExecuteMul $prog $cmd; break}
            "div" {ExecuteDiv $prog $cmd; break}
            "mod" {ExecuteMod $prog $cmd; break}
            "eql" {ExecuteEql $prog $cmd; break}
            default { 
                throw "Unknown instr '$($cmd.instr)'"
                break
            }
        }
    }
}

# 1..9 | %{
#     $w=$_
#     0..(26*10) | %{
#         $initz=$_
#         $vars["z"]=$initz
#         ExecuteProg $progs[12] $w
#         $z=$vars["z"]
#         $y=$vars["y"]
#         if ($z -eq 10)
#         {
#             "w:$w initz:$initz z:$z y:$y"
#         }
#     }
# }

# $initzsets=@{}
# $initzsets[0]=,0

# 0..12 | %{
#     $prognum=$_
#     $initzsets[$prognum+1]=@()
#     1..9 | %{
#         $w=$_
#         $initzsets[$prognum] | %{
#             $initz=$_
#             $vars["z"]=$initz
#             ExecuteProg $progs[$prognum] $w
#             $z=$vars["z"]
#             #if ($z -lt (26*100))
#             #{
#                 $initzsets[$prognum+1] += $z
#             #}
#         }
#     }
#     $initzsets[$prognum+1] = $initzsets[$prognum+1] | sort -Unique
#     $initzsets[$prognum+1]
# }



$NumZToTry=26*100
$NumZToTryInc=50
$failed=$true
while ($failed)
{
    $resultZSets=@{}
    $resultZSets[13]=@{}
    $resultZSets[13]["0"]=1
    for ($prognum=13;$prognum -ge 1;$prognum--)
    {
        "--------$NumZToTry-------"
        "Program $($prognum-1)"
        if (-not($resultZSets.ContainsKey($prognum-1)))
        {
            $resultZSets[$prognum-1]=@{}
        }
        1..9 | %{
            $w=$_
            0..$NumZToTry | %{
                $initz=$_
                $vars["z"]=$initz
                ExecuteProg $progs[$prognum] $w
                $z=$vars["z"]
                if ($resultZSets[$prognum].ContainsKey("$z"))
                {
                    $resultZSets[$prognum-1]["$initz"] = 1
                }
            }
        }
        ($resultZSets[$prognum-1].Keys | measure -Maximum -Minimum).Count
        DisplayStopwatch "Iteration" $itstopwatch
        $itstopwatch.Restart()
        DisplayStopwatch "Overall  " $overallstopwatch

        if ($resultZSets[$prognum-1].Keys.Count -eq 0)
        {
            $NumZToTry+=$NumZToTryInc
            "FAIL!!!!"
            Start-Sleep 2
            "##########################################"
            break
        }
    }
    if ($resultZSets[0].Keys.Count -gt 0)
    {
        $failed=$false
    }
}
"Success!"