# 2026-10-22: a "Skip this" button, bottom left of slide 59 (section 5 header, "Checking multivariate
# models"). In slide show, clicking it jumps to the Summary slide (63), skipping section 5. The link is
# by slide ID (322), so it survives slides being moved. Clicking anywhere else advances as usual.
# Saves the deck. PowerPoint must be closed. Already applied: do NOT re-run on the current deck.
$deck = "C:\R\Projects\Vis-MLM-book\talks\Vis-MLM-talk4.pptx"

function BGR($hex) { $r = [Convert]::ToInt32($hex.Substring(1,2),16); $g = [Convert]::ToInt32($hex.Substring(3,2),16); $b = [Convert]::ToInt32($hex.Substring(5,2),16); $r + 256*$g + 65536*$b }

$app  = New-Object -ComObject PowerPoint.Application
$pres = $app.Presentations.Open($deck, $false, $false, $false)
$s = $pres.Slides.Item(59)
$target = $pres.Slides.FindBySlideID(322)
if ($s.Shapes.Title.TextFrame.TextRange.Text -ne "Checking multivariate models") { throw "slide 59 is not the section 5 header" }
if ($target.Shapes.Title.TextFrame.TextRange.Text -notmatch "^Summary") { throw "slide ID 322 is not Summary" }

# 5 = msoShapeRoundedRectangle
$b = $s.Shapes.AddShape(5, 14, 506, 96, 24)
$b.Name = "Skip button"
$b.Fill.ForeColor.RGB = (BGR "#FFFFFF"); $b.Fill.Transparency = 0.35
$b.Line.ForeColor.RGB = (BGR "#3A4A5C"); $b.Line.Weight = 0.75
$b.Shadow.Visible = 0
$tf = $b.TextFrame
$tf.MarginLeft = 4; $tf.MarginRight = 4; $tf.MarginTop = 0; $tf.MarginBottom = 0
$tf.WordWrap = 0
$r = $tf.TextRange
$r.Text = "Skip this " + [char]0x23ED
$r.Font.Name = "Aptos"; $r.Font.Size = 13; $r.Font.Color.RGB = (BGR "#3A4A5C")
$r.ParagraphFormat.Alignment = 2

# 1 = ppMouseClick, 7 = ppActionHyperlink; SubAddress "slideID,slideIndex,title"
$a = $b.ActionSettings(1)
$a.Action = 7
$a.Hyperlink.SubAddress = "{0},{1},{2}" -f $target.SlideID, $target.SlideIndex, "Summary"
$a.Hyperlink.ScreenTip = "Skip to the Summary"

$pres.Save()
$s.Export("C:\Users\friendly\AppData\Local\Temp\claude\C--R-Projects-Vis-MLM-book\60ea4978-1136-4423-9282-96c48d816286\scratchpad\slide59.png", "PNG", 1280, 720)
"link: " + $a.Hyperlink.SubAddress
$pres.Close(); $app.Quit()
