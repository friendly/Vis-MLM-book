# Record of adding slide 19 "Thinking about Penguin variables" (2026-10-20), via PowerPoint COM. Already applied:
# do NOT re-run on the current deck (it would add the slide again).
# Inserted after slide 18 (Simpson's paradox), with slide 18's layout ("Title Only · sec1"): text above two plots
# drawn by talks/R/peng-altviews.R (the blog post's Fig. 3 as separate images). No animation: MF adds the reveal
# of the size & shape plot and its two bullets ("Reveal text") in PowerPoint.
# Saves the deck. PowerPoint must be closed.
$img  = "C:\R\Projects\Vis-MLM-book\talks\images"
$deck = "C:\R\Projects\Vis-MLM-book\talks\Vis-MLM-talk4.pptx"

function AddText($s, $name, $l, $t, $w, $h, $paras, $size, $bullets) {
  $tb = $s.Shapes.AddTextbox(1, $l, $t, $w, $h)
  $tb.Name = $name
  $tb.TextFrame.WordWrap = -1
  $tr = $tb.TextFrame.TextRange
  $tr.Text = ($paras -join "`r")
  $tr.Font.Size = $size
  if ($bullets) { $tr.ParagraphFormat.Bullet.Visible = -1; $tr.ParagraphFormat.Bullet.Character = 8226; $tr.IndentLevel = 1
                  $tb.TextFrame.Ruler.Levels(1).FirstMargin = 0; $tb.TextFrame.Ruler.Levels(1).LeftMargin = 16 }
  $tr.ParagraphFormat.SpaceAfter = 4
  $tb
}
function Bold($tb, $word) { $r = $tb.TextFrame.TextRange.Find($word); if ($r) { $r.Font.Bold = -1 } }

$app  = New-Object -ComObject PowerPoint.Application
$pres = $app.Presentations.Open($deck, $false, $false, $false)
if ($pres.Slides.Item(18).Shapes.Title.TextFrame.TextRange.Text -notmatch "^Simpson") { throw "slide 18 is not the Simpson's paradox slide" }

$s = $pres.Slides.AddSlide(19, $pres.Slides.Item(18).CustomLayout)
$s.Shapes.Title.TextFrame.TextRange.Text = "Thinking about Penguin variables"

$intro  = @("Bill length & depth are two measurements of one object: the bill",
            "Re-express them as Size = L x D and Shape = L / D")
$reveal = @(("On log scales, a 45" + [char]0x00B0 + " rotation: same data, same multivariate tests"),
            "Simpson's paradox disappears: species differ in shape; within species, bills vary in size")
$t1 = AddText $s "Intro text" 70 98 820 52 $intro 18 $true
$t2 = AddText $s "Reveal text" 70 150 820 52 $reveal 18 $true
foreach ($w in "Size", "Shape") { Bold $t1 $w }
Bold $t2 "45"; Bold $t2 "disappears"

$sz = 300; $top = 208; $left = (960 - 2 * $sz - 40) / 2
$p1 = $s.Shapes.AddPicture("$img\peng-altviews-1-length-depth.png", 0, -1, $left, $top, $sz, $sz)
$p2 = $s.Shapes.AddPicture("$img\peng-altviews-2-size-shape.png", 0, -1, $left + $sz + 40, $top, $sz, $sz)
$p1.Name = "Length depth plot"; $p2.Name = "Size shape plot"

$null = AddText $s "Source" 66 500 400 25 @("Blog: friendly.github.io/blog/posts/2026-10-peng-altviews") 11 $false
$s.HeadersFooters.SlideNumber.Visible = -1    # AddSlide does not show the slide number by itself

$pres.Save()
$pres.Close(); $app.Quit()
