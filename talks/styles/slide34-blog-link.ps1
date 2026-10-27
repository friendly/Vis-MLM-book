# 2026-10-27: a link on slide 34 (multivariate outliers: which penguins are unusual?) to the blog post
# "Palmer Penguins Cry Out: 'Call Me by My Name'" (2026-10-25), in an outlined box with no fill,
# centered in the strip between the captions and the figure label.
# Saves the deck. PowerPoint must be closed. Already applied: do NOT re-run on the current deck.
$deck = "C:\R\Projects\Vis-MLM-book\talks\Vis-MLM-talk.pptx"
$url  = "https://friendly.github.io/blog/posts/2026-10-peng-names/"

$app  = New-Object -ComObject PowerPoint.Application
$pres = $app.Presentations.Open($deck, $false, $false, $false)
$s = $pres.Slides.Item(34)
if ($s.Shapes.Title.TextFrame.TextRange.Text -notmatch "^Multivariate outliers") { throw "slide 34 is not the multivariate outliers slide" }
foreach ($old in @($s.Shapes | Where-Object { $_.Name -eq "Blog link" })) { $old.Delete() }

$b = $s.Shapes.AddTextbox(1, 66, 472, 600, 22)
$b.Name = "Blog link"
$b.Fill.Visible = 0
$b.Line.Visible = -1; $b.Line.ForeColor.RGB = 0x8C8C8C; $b.Line.Weight = 0.75
$tf = $b.TextFrame
$tf.WordWrap = 0; $tf.AutoSize = 1
$tf.MarginLeft = 7; $tf.MarginRight = 7; $tf.MarginTop = 3; $tf.MarginBottom = 3
$tf.TextRange.Text = ""
function Add-Run($text, [bool]$italic, $link) {
  $run = $tf.TextRange.InsertAfter($text)
  $run.Font.Name = "Aptos"; $run.Font.Size = 12; $run.Font.Color.RGB = 0x262626
  $run.Font.Italic = [int]$italic * -1
  if ($link) { $run.ActionSettings(1).Hyperlink.Address = $link }
}
Add-Run "Blog: " $false $null
Add-Run ("Palmer Penguins Cry Out: " + [char]0x201C + "Call Me by My Name" + [char]0x201D) $true $null
Add-Run "   " $false $null
Add-Run $url $false $url
# center on the slide, between the bottom captions and the "Figure" label
$b.Left = ($pres.PageSetup.SlideWidth - $b.Width) / 2
$b.Top  = 498 - $b.Height
"box L{0:N0} T{1:N0} W{2:N0} H{3:N0}" -f $b.Left, $b.Top, $b.Width, $b.Height

$pres.Save()
$s.Export("C:\Users\friendly\AppData\Local\Temp\claude\C--R-Projects-Vis-MLM-book\60ea4978-1136-4423-9282-96c48d816286\scratchpad\slide34.png", "PNG", 1280, 720)
$pres.Close(); $app.Quit()
