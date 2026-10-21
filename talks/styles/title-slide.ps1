# Record of the 2026-10-21 title slide (slide 1) changes, via PowerPoint COM. Already applied: do NOT re-run on the current deck.
# Coral radial background (MF chose B-coral over azure and gold); the three thumbnails framed and shadowed as on the
# section headers, at one top edge and centered with equal gaps; the www icon moved onto the URL line, white made transparent.
# Saves the deck. PowerPoint must be closed.
$deck = "C:\R\Projects\Vis-MLM-book\talks\Vis-MLM-talk4.pptx"

function BGR($hex) { $r = [Convert]::ToInt32($hex.Substring(1,2),16); $g = [Convert]::ToInt32($hex.Substring(3,2),16); $b = [Convert]::ToInt32($hex.Substring(5,2),16); $r + 256*$g + 65536*$b }

$app  = New-Object -ComObject PowerPoint.Application
$pres = $app.Presentations.Open($deck, $false, $false, $false)
$s = $pres.Slides.Item(1)
if ($s.Shapes.Title.TextFrame.TextRange.Text -notmatch "^Visualizing Multivariate") { throw "slide 1 is not the title slide" }

# coral radial background: cream center, coral edges
$f = $s.Background.Fill
$f.TwoColorGradient(7, 1)
$f.ForeColor.RGB = (BGR "#FFF8F2"); $f.BackColor.RGB = (BGR "#F28C6B")

# thumbnails: top 25, equal 22 pt gaps, centered; 0.75 pt frame and soft shadow as on slide 5
$names = "Thumbnail: data ellipses", "Thumbnail: biplot", "Thumbnail: HE plot"
$w = 0; foreach ($n in $names) { $w += $s.Shapes.Item($n).Width }
$gap = 22; $x = (960 - ($w + 2 * $gap)) / 2
foreach ($n in $names) {
  $p = $s.Shapes.Item($n)
  $p.Top = 25; $p.Left = $x; $x += $p.Width + $gap
  $p.Line.Visible = -1; $p.Line.ForeColor.RGB = (BGR "#3A3A3A"); $p.Line.Weight = 0.75
  $p.Shadow.Visible = -1; $p.Shadow.Blur = 8; $p.Shadow.OffsetX = 2; $p.Shadow.OffsetY = 3
  $p.Shadow.Transparency = 0.6; $p.Shadow.ForeColor.RGB = 0
}

# www icon: off "Group" on the venue line, onto the URL line; white background transparent
$icon = $s.Shapes.Item("Picture 7")
$icon.Name = "www icon"
$icon.Top = 488
$icon.PictureFormat.TransparentBackground = -1; $icon.PictureFormat.TransparencyColor = (BGR "#FFFFFF")

$pres.Save()
$pres.Close(); $app.Quit()
