# 2026-10-26: after snub-nose.ps1, replace the robust weights plot on slide 62 of both decks with the
# re-rendered figs/ch14/fig-peng-robmlm-plot-1.png, labeled "SnubNose" (was "HookNose").
# Same place, size and z-order; also refreshes the copy used by the section 5 header artwork.
# Saves the decks. PowerPoint must be closed. Already applied: do NOT re-run on the current decks.
$img = "C:\R\Projects\Vis-MLM-book\figs\ch14\fig-peng-robmlm-plot-1.png"
Copy-Item $img "C:\R\Projects\Vis-MLM-book\talks\images\section-headers\section5-robust-weights.png" -Force

$app = New-Object -ComObject PowerPoint.Application
foreach ($d in "Vis-MLM-talk.pptx", "Vis-MLM-talk4.pptx") {
  $pres = $app.Presentations.Open("C:\R\Projects\Vis-MLM-book\talks\$d", $false, $false, $false)
  $s = $pres.Slides.Item(62)
  if ($s.Shapes.Title.TextFrame.TextRange.Text -notmatch "^Robust MLMs") { throw "$d slide 62 is not the robust MLM slide" }
  $old = $s.Shapes.Item("Picture 3")
  $new = $s.Shapes.AddPicture($img, 0, -1, $old.Left, $old.Top, $old.Width, $old.Height)
  $new.AlternativeText = $old.AlternativeText
  while ($new.ZOrderPosition -gt $old.ZOrderPosition) { $new.ZOrder(3) }    # 3 = msoSendBackward
  $old.Delete()
  $new.Name = "Picture 3"
  $pres.Save()
  $s.Export("C:\Users\friendly\AppData\Local\Temp\claude\C--R-Projects-Vis-MLM-book\60ea4978-1136-4423-9282-96c48d816286\scratchpad\slide62-$($d -replace '\.pptx$','').png", "PNG", 1280, 720)
  "{0}: Picture 3 replaced at Z{1}" -f $d, $new.ZOrderPosition
  $pres.Close()
}
$app.Quit()
