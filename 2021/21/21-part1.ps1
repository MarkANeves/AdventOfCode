$ErrorActionPreference="Stop"
$global:data=Get-Content "$PSScriptRoot\21.txt"

$data[0] -match 'Player 1 starting position: (\d)'
$player1pos = [int]$Matches[1]
$data[1] -match 'Player 2 starting position: (\d)'
$player2pos = [int]$Matches[1]

$dice=1
$diceThrows=0
function RollDice
{
    $sum =$global:dice++; if ($global:dice -gt 100) { $global:dice=1}
    $global:diceThrows++
    $sum+=$global:dice++; if ($global:dice -gt 100) { $global:dice=1}
    $global:diceThrows++
    $sum+=$global:dice++; if ($global:dice -gt 100) { $global:dice=1}
    $global:diceThrows++

    return $sum
}

$player1score=0
$player2score=0

while (1)
{
    $d=RollDice
    $player1pos += $d % 10
    if ($player1pos -gt 10) {$player1pos = ($player1pos % 10)}
    $player1score += $player1pos
    if ($player1score -ge 1000)
    {
        "player 1 wins: $player1score"
        "result: $($diceThrows * $player2score)"
        break
    }

    $d=RollDice
    $player2pos += $d % 10
    if ($player2pos -gt 10) {$player2pos = ($player2pos % 10)}
    $player2score += $player2pos
    if ($player2score -ge 1000)
    {
        "player 2 wins: $player2score"
        "result: $($diceThrows * $player1score)"
        break
    }
    "Player 1 score: $player1score"
    "Player 2 score: $player2score"
}

