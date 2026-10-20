# Record of the 2026-10-20 section 2 header changes, via PowerPoint COM. Already applied: do NOT re-run on the current deck.
# Slide 23: teal radial background + banner of three figures from slides 25, 28, 29. Slide 24: title box in the section teal.
# Saves the deck and exports talks/images/slide23-final.png, slide24-final.png. PowerPoint must be closed.
$img  = "C:\R\Projects\Vis-MLM-book\talks\images"
$deck = "C:\R\Projects\Vis-MLM-book\talks\Vis-MLM-talk4.pptx"

function BGR($hex) { $r = [Convert]::ToInt32($hex.Substring(1,2),16); $g = [Convert]::ToInt32($hex.Substring(3,2),16); $b = [Convert]::ToInt32($hex.Substring(5,2),16); $r + 256*$g + 65536*$b }
$teal = BGR "#008080"

$app  = New-Object -ComObject PowerPoint.Application
$pres = $app.Presentations.Open($deck, $false, $false, $false)

# ---- slide 23: teal radial background + banner of three figures from the section
$s = $pres.Slides.Item(23)
$s.FollowMasterBackground = 0
$f = $s.Background.Fill
$f.TwoColorGradient(7, 1)
$f.ForeColor.RGB = (BGR "#F2F6F6"); $f.BackColor.RGB = (BGR "#8EC0C0")

# rotate (PCA) -> juice (biplot) -> go nonlinear (t-SNE); height 190 pt, centered
$plates = @(
  @("$img\section2-pca-original.png", 190, "Section 2 PCA illustration"),
  @("$img\section2-peng-biplot.png",  220, "Section 2 biplot illustration"),
  @("$img\section2-pca-tsne.png",     380, "Section 2 t-SNE illustration")
)
$h = 190; $gap = 22; $x = (960 - (190 + 220 + 380 + 2 * $gap)) / 2
foreach ($p in $plates) {
  $pic = $s.Shapes.AddPicture($p[0], 0, -1, $x, 14, $p[1], $h)
  $pic.Name = $p[2]
  $pic.Line.Visible = -1; $pic.Line.ForeColor.RGB = (BGR "#3A3A3A"); $pic.Line.Weight = 0.75
  $pic.Shadow.Visible = -1; $pic.Shadow.Blur = 8; $pic.Shadow.OffsetX = 2; $pic.Shadow.OffsetY = 3
  $pic.Shadow.Transparency = 0.6; $pic.Shadow.ForeColor.RGB = 0
  $x += $p[1] + $gap
}

# ---- slide 24: title box in the section's teal style (as on slides 25-30)
$b = $pres.Slides.Item(24).Shapes.Item("TextBox 9")
$b.Fill.Visible = -1; $b.Fill.ForeColor.RGB = $teal; $b.Fill.Transparency = 0.78
$b.Line.Visible = -1; $b.Line.ForeColor.RGB = $teal; $b.Line.Weight = 1.5
$b.TextFrame.TextRange.Font.Color.RGB = 0
$pres.Save()
$pres.Slides.Item(23).Export("$img\slide23-final.png", "PNG", 1920, 1080)
$pres.Slides.Item(24).Export("$img\slide24-final.png", "PNG", 1920, 1080)

$pres.Close(); $app.Quit()
