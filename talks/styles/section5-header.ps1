# Record of the 2026-10-20 section 5 header change (slide 57), via PowerPoint COM. Already applied: do NOT re-run on the current deck.
# Brick-red radial background + banner of three figures from slides 58 and 60 (outliers, influence, robust weights).
# Saves the deck. PowerPoint must be closed. (Renders are not kept; export from the deck when needed.)
$img  = "C:\R\Projects\Vis-MLM-book\talks\images\section-headers"
$deck = "C:\R\Projects\Vis-MLM-book\talks\Vis-MLM-talk4.pptx"

function BGR($hex) { $r = [Convert]::ToInt32($hex.Substring(1,2),16); $g = [Convert]::ToInt32($hex.Substring(3,2),16); $b = [Convert]::ToInt32($hex.Substring(5,2),16); $r + 256*$g + 65536*$b }

$app  = New-Object -ComObject PowerPoint.Application
$pres = $app.Presentations.Open($deck, $false, $false, $false)
$s = $pres.Slides.Item(57)

# brick-red radial background, from the sec5 title boxes (#A33B2B)
$s.FollowMasterBackground = 0
$f = $s.Background.Fill
$f.TwoColorGradient(7, 1)
$f.ForeColor.RGB = (BGR "#F7F3F2"); $f.BackColor.RGB = (BGR "#D5A79F")

# outliers (distance plot) -> influence (bubble plot) -> robust estimation (weights), as in the subtitle
$h = 200; $gap = 22
$plates = @(
  @("$img\section5-distance-plot.png",  200, "Section 5 distance plot illustration"),
  @("$img\section5-influence-plot.png", 200, "Section 5 influence plot illustration"),
  @("$img\section5-robust-weights.png", 280, "Section 5 robust weights illustration")
)
$x = (960 - (200 + 200 + 280 + 2 * $gap)) / 2
foreach ($p in $plates) {
  $pic = $s.Shapes.AddPicture($p[0], 0, -1, $x, 14, $p[1], $h)
  $pic.Name = $p[2]
  $pic.Line.Visible = -1; $pic.Line.ForeColor.RGB = (BGR "#3A3A3A"); $pic.Line.Weight = 0.75
  $pic.Shadow.Visible = -1; $pic.Shadow.Blur = 8; $pic.Shadow.OffsetX = 2; $pic.Shadow.OffsetY = 3
  $pic.Shadow.Transparency = 0.6; $pic.Shadow.ForeColor.RGB = 0
  $x += $p[1] + $gap
}

$pres.Save()
$pres.Close(); $app.Quit()
