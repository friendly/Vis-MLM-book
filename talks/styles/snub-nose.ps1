# 2026-10-26: rename case 10 "Hook Nose" -> "Snub Nose" in both talk decks (see issues/penguin-names.md).
# Text on slides 34, 35 (plot labels), 61, 62 (bullets) and the slide 34 notes. The picture on slide 62
# (the robust weights plot, with "HookNose" drawn in) is replaced separately, after the book re-renders it.
# Saves the decks. PowerPoint must be closed. Already applied: do NOT re-run on the current decks.
$decks = "C:\R\Projects\Vis-MLM-book\talks\Vis-MLM-talk.pptx", "C:\R\Projects\Vis-MLM-book\talks\Vis-MLM-talk4.pptx"
$titles = @{ 34 = "^Multivariate outliers"; 35 = "^Outliers hide"; 61 = "^Who are the influential"; 62 = "^Robust MLMs" }

function Fix-Shapes($shapes) {
  $n = 0
  foreach ($sh in $shapes) {
    if ($sh.Type -eq 6) { $n += Fix-Shapes $sh.GroupItems; continue }      # msoGroup
    if (-not $sh.HasTextFrame) { continue }
    $tr = $sh.TextFrame.TextRange
    while ($tr.Text -match "Hook Nose") { $null = $tr.Replace("Hook Nose", "Snub Nose"); $n++ }
  }
  $n
}

$app = New-Object -ComObject PowerPoint.Application
foreach ($deck in $decks) {
  $pres = $app.Presentations.Open($deck, $false, $false, $false)
  foreach ($k in 34, 35, 61, 62) {
    $s = $pres.Slides.Item($k)
    if ($s.Shapes.Title.TextFrame.TextRange.Text -notmatch $titles[$k]) { throw "$deck slide $k is not the expected slide" }
    $n = Fix-Shapes $s.Shapes
    # notes: the slide 34 note also explains the old name
    foreach ($sh in $s.NotesPage.Shapes) {
      if (-not $sh.HasTextFrame) { continue }
      $tr = $sh.TextFrame.TextRange
      if ($tr.Text -match "largest curvature") { $null = $tr.Replace("largest curvature", "stubbiest bill (short and deep)") }
      while ($tr.Text -match "Hook Nose") { $null = $tr.Replace("Hook Nose", "Snub Nose"); $n++ }
    }
    "{0} slide {1}: {2} replaced" -f (Split-Path $deck -Leaf), $k, $n
  }
  $pres.Save(); $pres.Close()
}
$app.Quit()
