# Record of the 2026-10-20 Closing-section colors, via PowerPoint COM. Already applied: do NOT re-run on the current deck
# (it would add a second set of "sec6" layouts).
# Slides 61-62 (Summary; Book, code and packages) move from their "sec5" layouts to gold "sec6" copies: title box
# fill #D4AF37 at 78% transparency, border #D4AF37. Slides 61, 62 and 63 (Questions?) get a very light gold background.
# Saves the deck. PowerPoint must be closed.
$deck = "C:\R\Projects\Vis-MLM-book\talks\Vis-MLM-talk4.pptx"

function BGR($hex) { $r = [Convert]::ToInt32($hex.Substring(1,2),16); $g = [Convert]::ToInt32($hex.Substring(3,2),16); $b = [Convert]::ToInt32($hex.Substring(5,2),16); $r + 256*$g + 65536*$b }
$gold  = BGR "#D4AF37"
$light = BGR "#FDF9EF"

$app  = New-Object -ComObject PowerPoint.Application
$pres = $app.Presentations.Open($deck, $false, $false, $false)

foreach ($n in 61, 62) {
  $s = $pres.Slides.Item($n)
  if ($s.CustomLayout.Name -notmatch "sec5") { throw "slide $n layout is '$($s.CustomLayout.Name)'" }
  $lay = $s.CustomLayout.Duplicate()
  $lay.Name = $s.CustomLayout.Name -replace "sec5", "sec6"
  $t = $lay.Shapes.Title
  $t.Fill.ForeColor.RGB = $gold; $t.Fill.Transparency = 0.78
  $t.Line.ForeColor.RGB = $gold
  $s.CustomLayout = $lay
}

foreach ($n in 61, 62, 63) {
  $s = $pres.Slides.Item($n)
  $s.FollowMasterBackground = 0
  $s.Background.Fill.Solid(); $s.Background.Fill.ForeColor.RGB = $light
}

$pres.Save()
$pres.Close(); $app.Quit()
