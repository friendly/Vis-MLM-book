# Record of a 2026-10-20 change, via PowerPoint COM: the subtitle color of the "Section Header" layout,
# from the theme's muted gray (tx1 at 82% tint) to dark slate #2F3B52, the color used on slide 5.
# Slides 23, 31, 44, 57 inherit it; slide 5 (#2F3B52) and slide 10 (black) set their own color.
# Saves the deck and exports renders of the affected slides. PowerPoint must be closed.
$deck = "C:\R\Projects\Vis-MLM-book\talks\Vis-MLM-talk4.pptx"
$out  = "C:\R\Projects\Vis-MLM-book\talks\images"

function BGR($hex) { $r = [Convert]::ToInt32($hex.Substring(1,2),16); $g = [Convert]::ToInt32($hex.Substring(3,2),16); $b = [Convert]::ToInt32($hex.Substring(5,2),16); $r + 256*$g + 65536*$b }

$app  = New-Object -ComObject PowerPoint.Application
$pres = $app.Presentations.Open($deck, $false, $false, $false)

$layout = $pres.Slides.Item(23).CustomLayout
if ($layout.Name -ne "Section Header") { throw "slide 23 layout is '$($layout.Name)'" }
$ph = $layout.Shapes.Item("Text Placeholder 2")
$ph.TextFrame.TextRange.Font.Color.RGB = (BGR "#2F3B52")

$pres.Save()
foreach ($n in 23, 31, 44, 57) { $pres.Slides.Item($n).Export("$out\section-header-slide$n.png", "PNG", 1920, 1080) }
$pres.Close(); $app.Quit()
