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
        Write-Host $cmd.line
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

$resultZs=@{}
$resultZs[-1]=@{}
$resultZs[-1]["0"]=0

0..13 | %{
    $prognum=$_
    $resultZs[$prognum]=@{}
    "-----------$prognum-----------"
    "Count: "+($resultZs[$prognum-1].Values | measure).Count
    1..9 | %{
        $w=$_
        $vals = $resultZs[$prognum-1].Values | sort | select -First 300
        foreach($z in $vals)
        {
            $vars["z"]=[int]$z
            ExecuteProg $progs[$prognum] $w
            $z=$vars["z"]
            $resultZs[$prognum]["$z"]=$z
        }
    }
    if ($prognum -eq 13)
    {
        $resultZs[13].Values -join ','
        $resultZs[13].Values | measure -Minimum -Maximum
    }
}