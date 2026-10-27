# Export the talk deck for printed handouts: each slide as a PNG (slides/slide-NN.png) and the speaker
# notes as JSON (notes.json), for make-handouts.py. Read-only on the deck; PowerPoint must be closed.
# Hidden slides are skipped. Run from anywhere:  powershell -File talks\handouts\export-slides.ps1
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$deck = Join-Path (Split-Path -Parent $here) "Vis-MLM-talk.pptx"
$out  = Join-Path $here "slides"
New-Item -ItemType Directory -Force $out | Out-Null
Get-ChildItem $out -Filter "slide-*.png" | Remove-Item

$app  = New-Object -ComObject PowerPoint.Application
$pres = $app.Presentations.Open($deck, $true, $false, $false)
$notes = foreach ($s in $pres.Slides) {
  if ($s.SlideShowTransition.Hidden) { continue }
  $k = $s.SlideIndex
  $s.Export((Join-Path $out ("slide-{0:D2}.png" -f $k)), "PNG", 1920, 1080)
  $title = ""; if ($s.Shapes.HasTitle) { $title = $s.Shapes.Title.TextFrame.TextRange.Text }
  $text = ""
  foreach ($sh in $s.NotesPage.Shapes) { if ($sh.PlaceholderFormat.Type -eq 2) { $text = $sh.TextFrame.TextRange.Text } }
  [pscustomobject]@{ slide = $k; title = ($title -replace "[\r\v]+", " "); notes = $text }
}
$pres.Close(); $app.Quit()
$json = ConvertTo-Json @($notes) -Depth 3
[IO.File]::WriteAllText((Join-Path $here "notes.json"), $json, (New-Object Text.UTF8Encoding $false))
"{0} slides exported to {1}" -f @($notes).Count, $out
