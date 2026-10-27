# 2026-10-27: slide 29 ("Biplot: The data juicer") had a ggbiplot logo with a white background; replace it
# with talks/images/ggbiplot-logo.png (transparent, as on slide 28), at the same place, size and z-order.
# Saves the deck. PowerPoint must be closed. Already applied: do NOT re-run on the current deck.
$deck = "C:\R\Projects\Vis-MLM-book\talks\Vis-MLM-talk.pptx"
$img  = "C:\R\Projects\Vis-MLM-book\talks\images\ggbiplot-logo.png"

$app  = New-Object -ComObject PowerPoint.Application
$pres = $app.Presentations.Open($deck, $false, $false, $false)
$s = $pres.Slides.Item(29)
if ($s.Shapes.Title.TextFrame.TextRange.Text -notmatch "^Biplot: The data juicer") { throw "slide 29 is not 'Biplot: The data juicer'" }
$old = $s.Shapes.Item("Picture 6")
if ($old.Left -lt 700 -or $old.Top -gt 60) { throw "Picture 6 on slide 29 is not the logo" }

$new = $s.Shapes.AddPicture($img, 0, -1, $old.Left, $old.Top, $old.Width, $old.Height)
while ($new.ZOrderPosition -gt $old.ZOrderPosition) { $new.ZOrder(3) }    # 3 = msoSendBackward
$old.Delete()
$new.Name = "Picture 6"
$new.AlternativeText = "ggbiplot-logo.png"
"logo L{0:N1} T{1:N1} W{2:N1} H{3:N1} Z{4}" -f $new.Left, $new.Top, $new.Width, $new.Height, $new.ZOrderPosition

$pres.Save()
$s.Export("C:\Users\friendly\AppData\Local\Temp\claude\C--R-Projects-Vis-MLM-book\60ea4978-1136-4423-9282-96c48d816286\scratchpad\slide29.png", "PNG", 1280, 720)
$pres.Close(); $app.Quit()
