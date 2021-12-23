# Doesn't work - runs out of stack space

$ErrorActionPreference="Stop"
$global:data=Get-Content "$PSScriptRoot\21test.txt"

$data[0] -match 'Player 1 starting position: (\d)'
$player1pos = [int]$Matches[1]
$data[1] -match 'Player 2 starting position: (\d)'
$player2pos = [int]$Matches[1]

function MakeGame($p1pos,$p2pos,$p1score,$p2score)
{
    $game=[PSCustomObject]@{
        p1pos = $p1pos
        p2pos = $p2pos
        p1score = $p1score
        p2score = $p2score
    }
    return $game
}

$p1wins=0
$p2wins=0

function PlayGame($game,$diceRoll)
{
    $game.p1pos += $diceRoll % 10
    if ($game.p1pos -gt 10) {$game.p1pos = ($game.p1pos % 10)}
    $game.p1score += $game.p1pos
    if ($game.p1score -ge 21) {
        $global:p1wins++;
        return
    }

    $game.p2pos += $diceRoll % 10
    if ($game.p2pos -gt 10) {$game.p2pos = ($game.p2pos % 10)}
    $game.p2score += $game.p2pos
    if ($game.p2score -ge 21) {
        $global:p2wins++;
        return
    }

    $g = MakeGame $game.p1pos $game.p2pos $game.p1score $game.p2score
    PlayGame $g 1
    $g = MakeGame $game.p1pos $game.p2pos
    PlayGame $g 2
    $g = MakeGame $game.p1pos $game.p2pos
    PlayGame $g 3
}

$game = MakeGame $player1pos $player2pos 0 0
PlayGame $game 1
$game = MakeGame $player1pos $player2pos 0 0
PlayGame $game 2
$game = MakeGame $player1pos $player2pos 0 0
PlayGame $game 3
