# 2026-10-28: a new slide 55, a copy of slide 54 ("Quantitative predictors: each effect is a line", school
# data, Fig 12.17) using the NLSY data instead, to show the overall test as in the book's Fig 12.16:
# talks/images/NLSY-HE-overall.png (from talks/R/NLSY-HE-overall.R), square, in the right column. The first
# bullet and its sub-bullets now describe the NLSY data; caption "Figure 12.16"; speaker notes rewritten.
# Slide 54 is left as it is (MF will delete it).
# Saves the deck. PowerPoint must be closed. Already applied: do NOT re-run on the current deck.
$deck = "C:\R\Projects\Vis-MLM-book\talks\Vis-MLM-talk.pptx"
$img  = "C:\R\Projects\Vis-MLM-book\talks\images\NLSY-HE-overall.png"

$app  = New-Object -ComObject PowerPoint.Application
$pres = $app.Presentations.Open($deck, $false, $false, $false)
$s0 = $pres.Slides.Item(54)
if ($s0.Shapes.Title.TextFrame.TextRange.Text -notmatch "^Quantitative predictors: each effect") { throw "slide 54 is not 'Quantitative predictors: each effect is a line'" }
$s = $s0.Duplicate().Item(1)                              # lands at 55

# replace a paragraph's text, keeping its paragraph mark and the formatting of its first character
function Set-Para($tr, $i, $text) {
  $p = $tr.Paragraphs($i)
  $n = $p.Length; if ($p.Text.EndsWith("`r")) { $n-- }
  $p.Characters(1, $n).Text = $text
}
$tr = $s.Shapes.Item("Content Placeholder 2").TextFrame.TextRange
Set-Para $tr 1 "NLSY data: 243 children from the National Longitudinal Survey of Youth"
Set-Para $tr 2 "Outcomes: reading, math"
Set-Para $tr 3 ("Predictors: father" + [char]0x2019 + "s income & education")

# the picture: square, as large as the right column allows, centered in it
$old = $s.Shapes.Item("Picture 3")
$colL = $old.Left; $colW = $old.Width
$z = $old.ZOrderPosition
$old.Delete()
$side = 360; $top = 125
$p = $s.Shapes.AddPicture($img, 0, -1, $colL + ($colW - $side) / 2, $top, $side, $side)
$p.Name = "NLSY HE overall"
$p.AlternativeText = "NLSY-HE-overall.png"
while ($p.ZOrderPosition -gt $z) { $p.ZOrder(3) }

$s.Shapes.Item("TextBox 4").TextFrame.TextRange.Text = "Figure 12.16"

$notes = @($s.NotesPage.Shapes | Where-Object { $_.PlaceholderFormat.Type -eq 2 })[0]
$notes.TextFrame.TextRange.Text = "The same ideas are available for multivariate multiple regression. " +
  "HE plot for reading and math scores in the NLSY data, predicted from father's income and education. " +
  "Each predictor has 1 df, so its H 'ellipse' collapses to a line: income relates mostly to math, education to both. " +
  "The green ellipse is the overall test that both coefficients are zero; the lines for the separate predictors always lie within it."

"slide {0}: picture L{1:N0} T{2:N0} W{3:N0} H{4:N0}" -f $s.SlideIndex, $p.Left, $p.Top, $p.Width, $p.Height
$pres.Save()
$s.Export("C:\Users\friendly\AppData\Local\Temp\claude\C--R-Projects-Vis-MLM-book\60ea4978-1136-4423-9282-96c48d816286\scratchpad\slide55.png", "PNG", 1280, 720)
$pres.Close(); $app.Quit()
