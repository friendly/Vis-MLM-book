# Record of how the slide 5 section-header design was applied (2026-10-20), via PowerPoint COM.
# Already applied: do NOT re-run on the current deck (the overlay it deletes is gone, and it would
# add a second set of hearts). Kept as a template for the other section headers.
# Saves the deck. PowerPoint must be closed. (Renders are not kept; export from the deck when needed.)
$deck = "C:\R\Projects\Vis-MLM-book\talks\Vis-MLM-talk4.pptx"

function BGR($hex) { $r = [Convert]::ToInt32($hex.Substring(1,2),16); $g = [Convert]::ToInt32($hex.Substring(3,2),16); $b = [Convert]::ToInt32($hex.Substring(5,2),16); $r + 256*$g + 65536*$b }

$app  = New-Object -ComObject PowerPoint.Application
$pres = $app.Presentations.Open($deck, $false, $false, $false)
$s = $pres.Slides.Item(5)

# illustration: unfaded, thin frame, soft shadow
$s.Shapes.Item("Flatland illustration softening overlay").Delete()
$pic = $s.Shapes.Item("Section 0 Flatland illustration")
$pic.Line.Visible = -1; $pic.Line.ForeColor.RGB = (BGR "#3A3A3A"); $pic.Line.Weight = 0.75
$pic.Shadow.Visible = -1; $pic.Shadow.Blur = 8; $pic.Shadow.OffsetX = 2; $pic.Shadow.OffsetY = 3
$pic.Shadow.Transparency = 0.6; $pic.Shadow.ForeColor.RGB = 0

# radial background
$f = $s.Background.Fill
$f.TwoColorGradient(7, 1)
$f.ForeColor.RGB = (BGR "#F2F3F6"); $f.BackColor.RGB = (BGR "#8EA1C2")

# subtitles: dark slate instead of muted gray
$s.Shapes.Item("Text Placeholder 2").TextFrame.TextRange.Font.Color.RGB = (BGR "#2F3B52")

# hearts rising toward the upper right, smaller and fainter as they go
$hearts = @(
  @(690, 318, 32,  -12, 0.05),
  @(756, 296, 27,    8, 0.20),
  @(813, 276, 22,  -10, 0.35),
  @(862, 258, 17,   12, 0.50),
  @(900, 243, 13,   -8, 0.65),
  @(930, 232,  9,   10, 0.78)
)
$i = 0
foreach ($h in $hearts) {
  $i++
  $sh = $s.Shapes.AddShape(21, $h[0], $h[1], $h[2], $h[2] * 0.9)   # msoShapeHeart
  $sh.Name = "Romance heart $i"
  $sh.Rotation = $h[3]
  $sh.Fill.ForeColor.RGB = (BGR "#C8435A"); $sh.Fill.Transparency = $h[4]
  $sh.Line.Visible = 0
}

$pres.Save()
$pres.Close(); $app.Quit()
