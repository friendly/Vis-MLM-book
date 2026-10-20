# Record of the 2026-10-20 section 3 header change (slide 31), via PowerPoint COM. Already applied: do NOT re-run on the current deck.
# Green radial background + banner of three figures from slides 34, 37, 42, and Wally just after the title.
# Saves the deck. PowerPoint must be closed. (Renders are not kept; export from the deck when needed.)
$img  = "C:\R\Projects\Vis-MLM-book\talks\images\section-headers"
$deck = "C:\R\Projects\Vis-MLM-book\talks\Vis-MLM-talk4.pptx"

function BGR($hex) { $r = [Convert]::ToInt32($hex.Substring(1,2),16); $g = [Convert]::ToInt32($hex.Substring(3,2),16); $b = [Convert]::ToInt32($hex.Substring(5,2),16); $r + 256*$g + 65536*$b }

$app  = New-Object -ComObject PowerPoint.Application
$pres = $app.Presentations.Open($deck, $false, $false, $false)
$s = $pres.Slides.Item(31)

# green radial background, from the sec3 title boxes (#267342)
$s.FollowMasterBackground = 0
$f = $s.Background.Fill
$f.TwoColorGradient(7, 1)
$f.ForeColor.RGB = (BGR "#F3F6F4"); $f.BackColor.RGB = (BGR "#9DC0AA")

# outliers (penguin biplot, dims 3-4) -> measurement error (data & beta space) -> collinearity & ridge (ridge ellipses)
$h = 150; $gap = 22
$plates = @(
  @("$img\section3-peng-biplot-dim34.png", 162, "Section 3 outlier illustration"),
  @("$img\section3-data-beta-space.png",   315, "Section 3 measurement error illustration"),
  @("$img\section3-ridge-ellipses.png",    365, "Section 3 ridge illustration")
)
$x = (960 - (162 + 315 + 365 + 2 * $gap)) / 2
foreach ($p in $plates) {
  $pic = $s.Shapes.AddPicture($p[0], 0, -1, $x, 14, $p[1], $h)
  $pic.Name = $p[2]
  $pic.Line.Visible = -1; $pic.Line.ForeColor.RGB = (BGR "#3A3A3A"); $pic.Line.Weight = 0.75
  $pic.Shadow.Visible = -1; $pic.Shadow.Blur = 8; $pic.Shadow.OffsetX = 2; $pic.Shadow.OffsetY = 3
  $pic.Shadow.Transparency = 0.6; $pic.Shadow.ForeColor.RGB = 0
  $x += $p[1] + $gap
}

# Wally, walking just after the title (he appears on slides 32, 34, 39)
$w = $s.Shapes.AddPicture("$img\section3-wally.wmf", 0, -1, 500, 196, 52, 52)
$w.Name = "Section 3 Wally"
$w.PictureFormat.TransparentBackground = -1; $w.PictureFormat.TransparencyColor = (BGR "#FFFFFF")
# the drawing has a thin gray border line along its left and top edges; crop it off
$w.PictureFormat.CropLeft = 2; $w.PictureFormat.CropTop = 2; $w.PictureFormat.CropRight = 1; $w.PictureFormat.CropBottom = 1

$pres.Save()
$pres.Close(); $app.Quit()
