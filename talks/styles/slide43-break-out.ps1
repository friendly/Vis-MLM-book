# 2026-10-27: slide 43 ("Generalized ridge trace plots") was one picture, a screenshot of an old Beamer
# slide (text + two plots). Rebuild it: the text as an editable text box (math as Unicode, Cambria Math),
# and the two plots as separate pictures cut from the book's Fig 9.12 (figs/ch09/fig-longley-plot-ridge-1.png:
# talks/images/longley-ridge-unemployed.png, -population.png), a little larger than before.
# The old screenshot is kept, hidden (Selection Pane: "Old Beamer screenshot"). Caption "Figure 9.12"
# styled like the one on slide 44.
# Saves the deck. PowerPoint must be closed. Already applied: do NOT re-run on the current deck.
$deck = "C:\R\Projects\Vis-MLM-book\talks\Vis-MLM-talk.pptx"
$imgs = "C:\R\Projects\Vis-MLM-book\talks\images\longley-ridge-unemployed.png",
        "C:\R\Projects\Vis-MLM-book\talks\images\longley-ridge-population.png"

function BGR($hex) { $r = [Convert]::ToInt32($hex.Substring(1,2),16); $g = [Convert]::ToInt32($hex.Substring(3,2),16); $b = [Convert]::ToInt32($hex.Substring(5,2),16); $r + 256*$g + 65536*$b }
$red = BGR "#E8221B"

$app  = New-Object -ComObject PowerPoint.Application
$pres = $app.Presentations.Open($deck, $false, $false, $false)
$s = $pres.Slides.Item(43)
if ($s.Shapes.Title.TextFrame.TextRange.Text -notmatch "^Generalized ridge trace") { throw "slide 43 is not 'Generalized ridge trace plots'" }
foreach ($sh in @($s.Shapes | Where-Object { $_.Name -in "Ridge trace text", "Caption" -or $_.Name -like "Fig 9.12 *" })) { $sh.Delete() }
$old = @($s.Shapes | Where-Object { $_.Name -in "Picture 3", "Old Beamer screenshot" })[0]
$old.Name = "Old Beamer screenshot"
$old.Visible = 0

# --- text ---------------------------------------------------------------------------------------
# no hats: Unicode combining hats are misplaced in every font tried (Cambria Math, Cambria, Times, Aptos,
# Segoe UI); add them with PowerPoint's equation editor if wanted
$beta = [char]::ConvertFromUtf32(0x1D6FD)             # math italic beta
$kk   = [char]::ConvertFromUtf32(0x1D458)             # math italic k
$Sig  = [string][char]0x03A3
$tb = $s.Shapes.AddTextbox(1, 66, 92, 830, 130)
$tb.Name = "Ridge trace text"
$tf = $tb.TextFrame
$tf.WordWrap = -1; $tf.AutoSize = 1
$tf.TextRange.Text = ""
function Add-Run($text, $color, [bool]$math, [bool]$sub = $false) {
  $run = $tf.TextRange.InsertAfter($text)
  $run.Font.Name = $(if ($math) { "Cambria Math" } else { "Aptos" })
  $run.Font.Size = 18; $run.Font.Italic = 0
  $run.Font.Subscript = $(if ($sub) { -1 } else { 0 })
  $run.Font.Color.RGB = $(if ($color) { $color } else { 0x262626 })
}
function Add-Bk { Add-Run $beta $null $true; Add-Run $kk $null $true $true }
# paragraph 1
Add-Run "Rather than plotting just the univariate trajectories of " $null $false
Add-Bk
Add-Run " vs. " $null $false
Add-Run $kk $null $true
Add-Run ", plot the covariance " $null $false
Add-Run "ellipsoids" $red $false
Add-Run " of " $null $false
Add-Run $Sig $null $true; Add-Run $kk $null $true $true
Add-Run (" " + [char]0x2261 + " Var(") $null $true; Add-Bk; Add-Run ")" $null $true
Add-Run " over the same range of " $null $false
Add-Run $kk $null $true
Add-Run "`r" $null $false
# bullets
Add-Run "Centers of the ellipsoids are " $null $false
Add-Bk
Add-Run (" " + [char]0x2013 + " same info as in the univariate plot`r") $null $false
Add-Run "Can see how change in one coefficient is related to changes in others`r" $null $false
Add-Run "Relative size & shape of ellipsoids shows " $null $false
Add-Run "directly" $red $false
Add-Run " the effect on precision" $null $false

$tr = $tf.TextRange
$tr.ParagraphFormat.SpaceAfter = 4
for ($i = 2; $i -le 4; $i++) {
  $p = $tr.Paragraphs($i)
  $p.ParagraphFormat.Bullet.Visible = -1
  $p.ParagraphFormat.Bullet.Character = 8226
  $p.IndentLevel = 1
  $p.ParagraphFormat.Bullet.RelativeSize = 1
}
$r2 = $tb.TextFrame.Ruler
$r2.Levels(1).FirstMargin = 18; $r2.Levels(1).LeftMargin = 36
$tr.Paragraphs(1).ParagraphFormat.Bullet.Visible = 0
# paragraph 1 has no bullet and no hanging indent: give it its own indent via a negative first-line?
# simpler: put paragraph 1 flush left by using IndentLevel 1 settings only for bullets (Ruler applies to
# all level-1 text), so use TextFrame2 per-paragraph indents instead
$t2 = $tb.TextFrame2.TextRange
$t2.Paragraphs(1).ParagraphFormat.LeftIndent = 0;  $t2.Paragraphs(1).ParagraphFormat.FirstLineIndent = 0
for ($i = 2; $i -le 4; $i++) { $t2.Paragraphs($i).ParagraphFormat.LeftIndent = 36; $t2.Paragraphs($i).ParagraphFormat.FirstLineIndent = -18 }
$t2.Paragraphs(1).ParagraphFormat.SpaceAfter = 8

# --- the two plots ----------------------------------------------------------------------------------
$top = $tb.Top + $tb.Height + 6
$h = 522 - $top                                       # down to the bottom, beside the caption
$w = $h * 1350 / 1200
$gap = 24
$left = ($pres.PageSetup.SlideWidth - (2 * $w + $gap)) / 2
$i = 0
foreach ($img in $imgs) {
  $p = $s.Shapes.AddPicture($img, 0, -1, $left + $i * ($w + $gap), $top, $w, $h)
  $p.Name = "Fig 9.12 " + @("Unemployed", "Population")[$i]
  $i++
}

# --- caption, like slide 44's -------------------------------------------------------------------------
$ref = $pres.Slides.Item(44).Shapes.Item("TextBox 4")
$cap = $s.Shapes.AddTextbox(1, $ref.Left, $ref.Top, 60, $ref.Height)
$cap.Name = "Caption"
$cap.TextFrame.WordWrap = 0
$cap.TextFrame.TextRange.Text = "Figure 9.12"
$cap.TextFrame.TextRange.Font.Name = $ref.TextFrame.TextRange.Font.Name
$cap.TextFrame.TextRange.Font.Size = $ref.TextFrame.TextRange.Font.Size
$cap.TextFrame.TextRange.Font.Color.RGB = $ref.TextFrame.TextRange.Font.Color.RGB

"text H{0:N0}; plots T{1:N0} W{2:N0} H{3:N0} (old panels were about 290 wide)" -f $tb.Height, $top, $w, $h
$pres.Save()
$s.Export("C:\Users\friendly\AppData\Local\Temp\claude\C--R-Projects-Vis-MLM-book\60ea4978-1136-4423-9282-96c48d816286\scratchpad\slide43.png", "PNG", 1280, 720)
$pres.Close(); $app.Quit()
