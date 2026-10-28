# 2026-10-28: the three Waldo pictures on slide 35 (Pictures 6, 13, 14: media image58.wmf) showed a white
# background. On slide 32 the same image has Set Transparent Color = white (a:clrChange FFFFFF -> alpha 0);
# apply the same here. Also copy slide 32's crop, which trims the thin frame lines at the image edges,
# keeping each picture's place and size; three times its right crop, as a line at the right edge still shows\n# against the coloured title box here.
# Saves the deck. PowerPoint must be closed. Already applied: do NOT re-run on the current deck.
$deck = "C:\R\Projects\Vis-MLM-book\talks\Vis-MLM-talk.pptx"

$app  = New-Object -ComObject PowerPoint.Application
$pres = $app.Presentations.Open($deck, $false, $false, $false)
$s = $pres.Slides.Item(35)
if ($s.Shapes.Title.TextFrame.TextRange.Text -notmatch "^Outliers hide") { throw "slide 35 is not 'Outliers hide in the smallest dimensions'" }
$ref = $pres.Slides.Item(32).Shapes.Item("Section 3 Wally").PictureFormat
foreach ($n in "Picture 6", "Picture 13", "Picture 14") {
  $sh = $s.Shapes.Item($n)
  $L = $sh.Left; $T = $sh.Top; $W = $sh.Width; $H = $sh.Height
  $pf = $sh.PictureFormat
  $pf.TransparencyColor = 0xFFFFFF
  $pf.TransparentBackground = -1
  $pf.CropLeft = $ref.CropLeft; $pf.CropTop = $ref.CropTop; $pf.CropRight = 3 * $ref.CropRight; $pf.CropBottom = $ref.CropBottom
  $sh.LockAspectRatio = 0
  $sh.Left = $L; $sh.Top = $T; $sh.Width = $W; $sh.Height = $H
  $sh.LockAspectRatio = -1
}
$pres.Save()
$s.Export("C:\Users\friendly\AppData\Local\Temp\claude\C--R-Projects-Vis-MLM-book\60ea4978-1136-4423-9282-96c48d816286\scratchpad\slide35.png", "PNG", 1280, 720)
$pres.Close(); $app.Quit()
