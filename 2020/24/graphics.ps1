<#
     <path fill="#482816" stroke="#000" stroke-width="1.5" stroke-opacity="null" d="m698.9725,541.50227 l21.49999,-43l57.33331,0l21.49999,43l-21.49999,43l-57.33331,0l-21.49999,-43z" id="svg_2" transform="rotate(90 749.13916015625,541.5022583007814) "/>
     <path fill="#FFAAB8" stroke="#000" stroke-width="1.5" stroke-opacity="null" d="m6.9725,541.50227   l21.49999,-43l57.33331,0l21.49999,43l-21.49999,43l-57.33331,0l-21.49999,-43z" id="svg_3" transform="rotate(90 57.1391487121581,541.5022583007814) "/>
     <path fill="#FF0000" stroke="#000" stroke-width="1"   stroke-opacity="null" d="m0,0         l21.49999,-43l57.33331,0l21.49999,43l-21.49999,43l-57.33331,0l-21.49999,-43z" id="svg_4" transform="rotate(90 55.1391487121582,53.502269744873054) "/>
     <path fill="#FFDFB8" stroke="#000" stroke-width="1.5" stroke-opacity="null" d="m692.9725,59.50227  l21.49999,-43l57.33331,0l21.49999,43l-21.49999,43l-57.33331,0l-21.49999,-43z" id="svg_5" transform="rotate(90 743.13916015625,59.50226974487311) "/>
     <path fill="#FFDFB8" stroke="#000" stroke-width="1.5" stroke-opacity="null" d="m692.9725,59.50227  l21.49999,-43l57.33331,0l21.49999,43l-21.49999,43l-57.33331,0l-21.49999,-43z" id="svg_5" transform="rotate(90 743.13916015625,59.50226974487311) "/>
#>

function prefix
{
'<html>
<!-- <style type="text/css">
    svg { margin:0px;border:10px solid black;}
</style> -->
<body>

<h1>My first SVG</h1>

<svg width="800" height="600" viewBox="-300 -350 800 600" xmlns="http://www.w3.org/2000/svg">
    <!-- Created with Method Draw - http://github.com/duopixel/Method-Draw/ -->
   
    <g transform="scale(1,-1)">
     <title>Layer 1</title>
'
}

function postfix
{
'    </g>
   </svg>

</body>
</html>
'
}

function circle($x,$y,$colour)
{
    "<circle cx=`"$x`" cy=`"$y`" r=`"25`" fill=`"$colour`" stroke=`"black`"/>`r`n"
}

function number($n,$x,$y,$colour, $r=180)
{
    $txt="<text xml:space=`"preserve`" "
    $txt+="x=`"$x`" y=`"$y`" "
    $txt+="transform=`"rotate(0,0,0) scale(1,-1)`""
    $txt+="text-anchor=`"start`" "
    $txt+="font-family=`"Helvetica, Arial, sans-serif`" "
    $txt+="font-size=`"14`" "
    $txt+="id=`"svg_6`" "
    $txt+="stroke-opacity=`"null`" stroke-width=`"0`" "
    $txt+="stroke=`"$colour`" fill=`"$colour`" "
    #$txt+="transform=`"rotate($r,$x,$y)`">$n</text>"
    #$txt+="transform=`"scale (1,-1)`" transform-origin=`"center`""
    $txt+=">$n</text>`r`n"

    return $txt
}

function renderTileMap($tileMap)
{
    $svg=prefix

    foreach($tile in $tileMap.Values.GetEnumerator())
    {
        $colour="white";$textcolour="black"
        if ($tile.black) {$colour="black";$textcolour="white"}
        $x=$tile.x * 60
        $y=$tile.y * 60
        $svg += circle $x $y $colour
        $svg += number $tile.Id $x $y $textcolour
    }

    $svg+=postfix

    $svg | Out-File "$PSScriptRoot\graphtest.svg" -Encoding ascii
}