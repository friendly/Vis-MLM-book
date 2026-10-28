# 2026-10-28: slide 51 ("HE plots: Effect scaling vs. Significance scaling") had the two HE plots as one
# picture (talks/images/peng-HE-signif.png, two panels from talks/R/peng-HE-plots.R). Replace it with the two
# halves as separate pictures (peng-HE-signif-1-effect.png, -2-signif.png: magick -crop 1500x1500 of the
# 3000x1500 original), each in the place and at the size of its panel; the significance-scaling plot fades
# in on a click.
# Saves the deck. PowerPoint must be closed. Already applied: do NOT re-run on the current deck.
$deck = "C:\R\Projects\Vis-MLM-book\talks\Vis-MLM-talk.pptx"
$imgs = "C:\R\Projects\Vis-MLM-book\talks\images\peng-HE-signif-1-effect.png",
        "C:\R\Projects\Vis-MLM-book\talks\images\peng-HE-signif-2-signif.png"
$names = "HE effect scaling", "HE significance scaling"

$app  = New-Object -ComObject PowerPoint.Application
$pres = $app.Presentations.Open($deck, $false, $false, $false)
$s = $pres.Slides.Item(51)
if ($s.Shapes.Title.TextFrame.TextRange.Text -notmatch "^HE plots: Effect scaling") { throw "slide 51 is not 'HE plots: Effect scaling vs. Significance scaling'" }
$old = @($s.Shapes | Where-Object { $_.Type -eq 13 -and $_.AlternativeText -eq "peng-HE-signif.png" })[0]
if (-not $old) { throw "two-panel picture not found on slide 51" }
$L = $old.Left; $T = $old.Top; $w = $old.Width / 2; $h = $old.Height
$z = $old.ZOrderPosition
$old.Delete()

$pics = for ($i = 0; $i -lt 2; $i++) {
  $p = $s.Shapes.AddPicture($imgs[$i], 0, -1, $L + $i * $w, $T, $w, $h)
  $p.Name = $names[$i]
  $p.AlternativeText = Split-Path -Leaf $imgs[$i]
  while ($p.ZOrderPosition -gt $z + $i) { $p.ZOrder(3) }    # 3 = msoSendBackward: where the old picture was
  $p
}
# 10 = msoAnimEffectFade, 1 = msoAnimTriggerOnPageClick
$e = $s.TimeLine.MainSequence.AddEffect($pics[1], 10, 0, 1)
$e.Timing.Duration = 0.5

foreach ($p in $pics) { "{0}: L{1:N0} T{2:N0} W{3:N0} H{4:N0} Z{5}" -f $p.Name, $p.Left, $p.Top, $p.Width, $p.Height, $p.ZOrderPosition }
"animations: " + $s.TimeLine.MainSequence.Count
$pres.Save()
$s.Export("C:\Users\friendly\AppData\Local\Temp\claude\C--R-Projects-Vis-MLM-book\60ea4978-1136-4423-9282-96c48d816286\scratchpad\slide51.png", "PNG", 1280, 720)
$pres.Close(); $app.Quit()
