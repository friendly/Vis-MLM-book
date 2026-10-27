# 2026-10-27: a small reference box, bottom left of slide 21 (visual thinning / effect order), pointing to
# Friendly & Kwan (2003), "Effect ordering for data displays". Text styled like the reference on slide 36
# (Aptos 12, journal and volume in italics, linked URL), in a rounded box tinted like the title box.
# Saves the deck. PowerPoint must be closed. Already applied: do NOT re-run on the current deck.
$deck = "C:\R\Projects\Vis-MLM-book\talks\Vis-MLM-talk.pptx"
$url  = "https://doi.org/10.1016/S0167-9473(02)00290-6"

$app  = New-Object -ComObject PowerPoint.Application
$pres = $app.Presentations.Open($deck, $false, $false, $false)
$s = $pres.Slides.Item(21)
$t = $s.Shapes.Title
if ($t.TextFrame.TextRange.Text -notmatch "^Visual thinning") { throw "slide 21 is not the visual thinning slide" }

# 5 = msoShapeRoundedRectangle; left edge with the bullets, below them, clear of the corrplot
foreach ($old in @($s.Shapes | Where-Object { $_.Name -eq "Effect order reference" })) { $old.Delete() }
$b = $s.Shapes.AddShape(5, 66, 455, 420, 50)
$b.Name = "Effect order reference"
$b.Adjustments.Item(1) = 0.12
$b.Fill.ForeColor.RGB = $t.Fill.ForeColor.RGB; $b.Fill.Transparency = [Math]::Max($t.Fill.Transparency, 0.5)
$b.Line.ForeColor.RGB = $t.Line.ForeColor.RGB; $b.Line.Weight = 0.75
$b.Shadow.Visible = 0
$tf = $b.TextFrame
$tf.WordWrap = -1; $tf.AutoSize = 1                     # shape grows to fit the text
$tf.MarginLeft = 7; $tf.MarginRight = 7; $tf.MarginTop = 4; $tf.MarginBottom = 4
$tf.VerticalAnchor = 3

$r = $tf.TextRange
$r.Text = ""
function Add-Run($text, [bool]$italic, $link) {
  $run = $tf.TextRange.InsertAfter($text)
  $run.Font.Name = "Aptos"; $run.Font.Size = 12; $run.Font.Color.RGB = 0x262626
  $run.Font.Italic = [int]$italic * -1
  if ($link) { $run.ActionSettings(1).Hyperlink.Address = $link }
}
Add-Run "Friendly & Kwan (2003). Effect ordering for data displays. " $false $null
Add-Run "Computational Statistics & Data Analysis" $true $null
Add-Run ", " $false $null
Add-Run "43" $true $null
Add-Run (", 509" + [char]0x2013 + "539.") $false $null
Add-Run ([string][char]11) $false $null          # line break, so the DOI is not split
Add-Run $url $false $url
$tf.TextRange.ParagraphFormat.Alignment = 1
# keep the box's bottom where it was put, now that it has auto-sized
$b.Top = 505 - $b.Height
"box L{0:N0} T{1:N0} W{2:N0} H{3:N0}" -f $b.Left, $b.Top, $b.Width, $b.Height

$pres.Save()
$s.Export("C:\Users\friendly\AppData\Local\Temp\claude\C--R-Projects-Vis-MLM-book\60ea4978-1136-4423-9282-96c48d816286\scratchpad\slide21.png", "PNG", 1280, 720)
$pres.Close(); $app.Quit()
