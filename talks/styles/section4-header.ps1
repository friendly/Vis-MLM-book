# Record of the 2026-10-20 section 4 header change (slide 44), via PowerPoint COM. Already applied: do NOT re-run on the current deck.
# Orange radial background + banner "data ellipses -> HE plot -> canonical HE plot" with arrows between, as on slide 46.
# Saves the deck. PowerPoint must be closed. (Renders are not kept; export from the deck when needed.)
$img  = "C:\R\Projects\Vis-MLM-book\talks\images"
$deck = "C:\R\Projects\Vis-MLM-book\talks\Vis-MLM-talk4.pptx"

function BGR($hex) { $r = [Convert]::ToInt32($hex.Substring(1,2),16); $g = [Convert]::ToInt32($hex.Substring(3,2),16); $b = [Convert]::ToInt32($hex.Substring(5,2),16); $r + 256*$g + 65536*$b }
$orange = BGR "#CC6600"

$app  = New-Object -ComObject PowerPoint.Application
$pres = $app.Presentations.Open($deck, $false, $false, $false)
$s = $pres.Slides.Item(44)

# orange radial background, from the sec4 title boxes (#CC6600)
$s.FollowMasterBackground = 0
$f = $s.Background.Fill
$f.TwoColorGradient(7, 1)
$f.ForeColor.RGB = (BGR "#F7F4F1"); $f.BackColor.RGB = (BGR "#E4C09E")

# data ellipses -> HE plot -> canonical HE plot, with arrows between (as on slide 46)
# two are talk figures in images/; the HE plot is the left (effect scaling) half of images/peng-HE-signif.png
$h = 200; $gap = 50
$plates = @(
  @("$img\peng-HE-overview-1-ellipses.png",             189, "Section 4 data ellipses illustration"),
  @("$img\section-headers\section4-peng-HE-effect.png", 200, "Section 4 HE plot illustration"),
  @("$img\peng-candisc-HE.png",                         250, "Section 4 canonical HE illustration")
)
$x = (960 - (189 + 200 + 250 + 2 * $gap)) / 2
$i = 0
foreach ($p in $plates) {
  $pic = $s.Shapes.AddPicture($p[0], 0, -1, $x, 14, $p[1], $h)
  $pic.Name = $p[2]
  $pic.Line.Visible = -1; $pic.Line.ForeColor.RGB = (BGR "#3A3A3A"); $pic.Line.Weight = 0.75
  $pic.Shadow.Visible = -1; $pic.Shadow.Blur = 8; $pic.Shadow.OffsetX = 2; $pic.Shadow.OffsetY = 3
  $pic.Shadow.Transparency = 0.6; $pic.Shadow.ForeColor.RGB = 0
  $x += $p[1]
  $i++
  if ($i -lt $plates.Count) {
    $a = $s.Shapes.AddShape(33, $x + 10, 14 + $h / 2 - 11, $gap - 20, 22)   # msoShapeRightArrow
    $a.Name = "Section 4 arrow $i"
    $a.Fill.ForeColor.RGB = $orange; $a.Line.Visible = 0
  }
  $x += $gap
}

$pres.Save()
$pres.Close(); $app.Quit()
