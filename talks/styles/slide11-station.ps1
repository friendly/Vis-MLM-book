# 2026-10-22: new slide 11, a copy of slide 10 ("Seeing multivariate data") with the
# Penguin Statistical Research Station scene (talks/images/penguin-station-talk.jpg) as the picture.
# The scene is 2:1, so it fills the top 480 pt; the subtitle sits in a 60 pt snow-colored strip below.
# Title in the sky, upper right, as large as fits. Saves the deck. PowerPoint must be closed.
# Already applied: do NOT re-run on the current deck.
# Afterwards (same day): title centered in its box (Alignment = 2), and the old slide 10 hidden and
# moved to the end of the backup section, so the new slide became slide 10.
$deck = "C:\R\Projects\Vis-MLM-book\talks\Vis-MLM-talk4.pptx"
$img  = "C:\R\Projects\Vis-MLM-book\talks\images\penguin-station-talk.jpg"

function BGR($hex) { $r = [Convert]::ToInt32($hex.Substring(1,2),16); $g = [Convert]::ToInt32($hex.Substring(3,2),16); $b = [Convert]::ToInt32($hex.Substring(5,2),16); $r + 256*$g + 65536*$b }

$app  = New-Object -ComObject PowerPoint.Application
$pres = $app.Presentations.Open($deck, $false, $false, $false)
$s10 = $pres.Slides.Item(10)
if ($s10.Shapes.Title.TextFrame.TextRange.Text -ne "Seeing multivariate data") { throw "slide 10 is not 'Seeing multivariate data'" }

$s = $s10.Duplicate().Item(1)          # lands at 11, keeps layout, notes, transition
foreach ($n in "Rectangle 11", "Picture 12", "Rectangle 10", "Picture 4", "Picture 6") { $s.Shapes.Item($n).Delete() }

# background strip color: the snow along the bottom edge of the scene
$s.FollowMasterBackground = 0
$s.Background.Fill.Solid(); $s.Background.Fill.ForeColor.RGB = (BGR "#E3E4EE")

$p = $s.Shapes.AddPicture($img, 0, -1, 0, 0, 960, 480)
$p.Name = "Penguin station"
$p.ZOrder(1)                           # send to back

# title: in the sky right of the hut, above the bulletin board (x 485-950, y 6-160)
$t = $s.Shapes.Title
$t.Left = 480; $t.Top = 6; $t.Width = 472; $t.Height = 155
$tf = $t.TextFrame
$tf.AutoSize = 0; $tf.WordWrap = -1; $tf.VerticalAnchor = 1
$tf.MarginLeft = 0; $tf.MarginRight = 0; $tf.MarginTop = 0; $tf.MarginBottom = 0
$r = $tf.TextRange
$r.ParagraphFormat.Alignment = 3       # right
$r.ParagraphFormat.SpaceWithin = 0.85
$r.Font.Bold = -1
$r.Font.Color.RGB = (BGR "#1B2F4E")
$size = 80
do { $r.Font.Size = $size; $size -= 1 } while (($r.BoundHeight -gt 150) -or ($r.Lines().Count -gt 2) -or ($r.BoundWidth -gt 472))
$g = $t.TextFrame2.TextRange.Font.Glow
$g.Radius = 8; $g.Color.RGB = (BGR "#FFFFFF"); $g.Transparency = 0.35

# subtitle in the strip below the picture; slide number to its right
$sub = $s.Shapes.Item("Text Placeholder 2")
$sub.Left = 30; $sub.Top = 484; $sub.Width = 830; $sub.Height = 52
$sub.TextFrame.VerticalAnchor = 3
$sub.TextFrame.TextRange.Font.Size = 24
$sub.TextFrame.TextRange.Font.Color.RGB = (BGR "#1B2F4E")
$num = $s.Shapes.Item("Slide Number Placeholder 14")
$num.Left = 870; $num.Top = 496; $num.Width = 70

"title size: $($r.Font.Size); lines: $($r.Lines().Count); bound: $($r.BoundWidth) x $($r.BoundHeight)"
$pres.Save()
$s.Export("C:\Users\friendly\AppData\Local\Temp\claude\C--R-Projects-Vis-MLM-book\60ea4978-1136-4423-9282-96c48d816286\scratchpad\slide11.png", "PNG", 1920, 1080)
$pres.Close(); $app.Quit()
