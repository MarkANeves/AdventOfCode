$total=0

Get-Content "$PSScriptRoot\03.txt" | %{
    $line = $_
    $line
    $r=$true
    while ($r) {
        "-----------------------"
        $r=$line -match "mul\((\d+),(\d+)\)"
        if ($r)
        {
            $matches
            $i=$line.IndexOf($matches[0])

            $line = $line.Substring($i + $matches[0].Length)
            "i: $i newline = $line"

            $total += [int]$matches[1] * [int]$matches[2]
            "total: $total"
        }
    }
}

"Result:"
$total
# answer: 184511516
