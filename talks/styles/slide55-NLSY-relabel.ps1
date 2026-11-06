# 2026-10-28: slide 55: replace the NLSY HE plot with the redrawn talks/images/NLSY-HE-overall.png (ellipse
# labels label.cex = 2.2), at the same place, size and z-order.
# Saves the deck. PowerPoint must be closed. Already applied: do NOT re-run on the current deck.
$deck = "C:\R\Projects\Vis-MLM-book\talks\Vis-MLM-talk.pptx"
$img  = "C:\R\Projects\Vis-MLM-book\talks\images\NLSY-HE-overall.png"

$app  = New-Object -ComObject PowerPoint.Application
$pres = $app.Presentations.Open($deck, $false, $false, $false)
$s = $pres.Slides.Item(55)
$old = $s.Shapes.Item("NLSY HE overall")
$new = $s.Shapes.AddPicture($img, 0, -1, $old.Left, $old.Top, $old.Width, $old.Height)
while ($new.ZOrderPosition -gt $old.ZOrderPosition) { $new.ZOrder(3) }
$old.Delete()
$new.Name = "NLSY HE overall"
$new.AlternativeText = "NLSY-HE-overall.png"
"L{0:N0} T{1:N0} W{2:N0} H{3:N0}" -f $new.Left, $new.Top, $new.Width, $new.Height
$pres.Save()
$s.Export("C:\Users\friendly\AppData\Local\Temp\claude\C--R-Projects-Vis-MLM-book\60ea4978-1136-4423-9282-96c48d816286\scratchpad\slide55.png", "PNG", 1280, 720)
$pres.Close(); $app.Quit()
