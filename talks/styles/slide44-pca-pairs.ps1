# 2026-10-22: slide 44 "A low-rank view of ridge regression" duplicated. The first copy (44) shows
# Fig 9.16, the pairs() plot of the ridge ellipses in PCA space (talks/images/longley-pca-pairs.png,
# a 1600 px copy of figs/ch09/fig-longley-pca-pairs-1.png), in the same place and size as the biplot,
# without the "A biplot shows ..." bullet. The second copy (45) is the original, with the biplot (Fig 9.18).
# Saves the deck. PowerPoint must be closed. Already applied: do NOT re-run on the current deck.
$deck = "C:\R\Projects\Vis-MLM-book\talks\Vis-MLM-talk4.pptx"
$img  = "C:\R\Projects\Vis-MLM-book\talks\images\longley-pca-pairs.png"

$app  = New-Object -ComObject PowerPoint.Application
$pres = $app.Presentations.Open($deck, $false, $false, $false)
$s = $pres.Slides.Item(44)
if ($s.Shapes.Title.TextFrame.TextRange.Text -ne "A low-rank view of ridge regression") { throw "slide 44 is not the low-rank ridge slide" }

$null = $s.Duplicate()                 # the copy, at 45, keeps the biplot

$old = $s.Shapes.Item("Picture 3")
$p = $s.Shapes.AddPicture($img, 0, -1, $old.Left, $old.Top, $old.Width, $old.Height)
$p.Name = "Fig 9.16 PCA pairs"
$old.Delete()

# drop the biplot bullet (the third paragraph)
$tr = $s.Shapes.Item("Content Placeholder 2").TextFrame.TextRange
$para = $tr.Paragraphs(3)
if ($para.Text -notmatch "^A biplot") { throw "third bullet is not the biplot one" }
$tr.Characters($para.Start - 1, $para.Length + 1).Delete()   # with the paragraph break before it

$s.Shapes.Item("TextBox 4").TextFrame.TextRange.Text = "Figure 9.16"

$pres.Save()
foreach ($k in 44, 45) {
  $pres.Slides.Item($k).Export("C:\Users\friendly\AppData\Local\Temp\claude\C--R-Projects-Vis-MLM-book\60ea4978-1136-4423-9282-96c48d816286\scratchpad\slide$k.png", "PNG", 1280, 720)
}
"44 bullets: " + ($s.Shapes.Item("Content Placeholder 2").TextFrame.TextRange.Text -replace "`r", " / ")
"45 title: " + $pres.Slides.Item(45).Shapes.Title.TextFrame.TextRange.Text
$pres.Close(); $app.Quit()
