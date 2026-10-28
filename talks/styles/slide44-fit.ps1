# Slide 44 ("A low-rank view of ridge regression"): the Fig 9.16 pairs plot ran off the bottom of the
# slide and covered the slide number. Scale it (and the red dim5/dim6 highlight box) to 405 pt high,
# keeping the top-right corner fixed, so it ends above the slide number.
# PowerPoint must be closed. Run:  powershell -File talks\styles\slide44-fit.ps1
$deck = Join-Path (Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)) "Vis-MLM-talk.pptx"
$app  = New-Object -ComObject PowerPoint.Application
$pres = $app.Presentations.Open($deck, $false, $false, $false)
$s    = $pres.Slides.Item(44)
$pic  = $s.Shapes.Item("Fig 9.16 PCA pairs")
$box  = $s.Shapes.Item("Rectangle 3")

$right = $pic.Left + $pic.Width
$top   = $pic.Top
$f     = 405 / $pic.Height
foreach ($sh in @($pic, $box)) {
  $r = $right - ($sh.Left + $sh.Width)
  $t = $sh.Top - $top
  $sh.Width  = $sh.Width * $f
  $sh.Height = $sh.Height * $f
  $sh.Left   = $right - $r * $f - $sh.Width
  $sh.Top    = $top + $t * $f
}

$pres.Save(); $pres.Close()
if ($app.Presentations.Count -eq 0) { $app.Quit() }
"slide 44 figure scaled by {0:N3}" -f $f
