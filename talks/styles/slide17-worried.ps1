# 2026-10-27: a worried-face emoji (U+1F61F) in the title box of slide 17, "What if I'm not Normal?",
# right of the title text, as its own text box so the title itself is untouched.
# Saves the deck. PowerPoint must be closed. Already applied: do NOT re-run on the current deck.
$deck = "C:\R\Projects\Vis-MLM-book\talks\Vis-MLM-talk.pptx"

$app  = New-Object -ComObject PowerPoint.Application
$pres = $app.Presentations.Open($deck, $false, $false, $false)
$s = $pres.Slides.Item(17)
$t = $s.Shapes.Title
if ($t.TextFrame.TextRange.Text -notmatch "^What if I'm not Normal") { throw "slide 17 is not 'What if I'm not Normal?'" }

$b = $s.Shapes.AddTextbox(1, 0, 0, 50, 40)           # 1 = horizontal
$b.Name = "Worried face"
$tf = $b.TextFrame
$tf.WordWrap = 0; $tf.AutoSize = 1
$tf.MarginLeft = 0; $tf.MarginRight = 0; $tf.MarginTop = 0; $tf.MarginBottom = 0
$r = $tf.TextRange
$r.Text = [char]::ConvertFromUtf32(0x1F61F)
$r.Font.Name = "Segoe UI Emoji"; $r.Font.Size = 30
# right end of the title text, centered vertically in the title box
$end = $t.TextFrame.TextRange.BoundLeft + $t.TextFrame.TextRange.BoundWidth
$b.Left = $end + 10
$b.Top  = $t.Top + ($t.Height - $b.Height) / 2
"title text ends at {0:N0}; box right edge {1:N0}; emoji L{2:N0} T{3:N0} W{4:N0} H{5:N0}" -f $end, ($t.Left + $t.Width), $b.Left, $b.Top, $b.Width, $b.Height

$pres.Save()
$s.Export("C:\Users\friendly\AppData\Local\Temp\claude\C--R-Projects-Vis-MLM-book\60ea4978-1136-4423-9282-96c48d816286\scratchpad\slide17.png", "PNG", 1280, 720)
$pres.Close(); $app.Quit()
