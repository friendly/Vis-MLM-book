# Slide 31 ("From PCA to t-SNE, animated"): tidy the text box.
#  - "t-SNE" -> "t" + U+2011 (non-breaking hyphen) + "SNE", so it no longer wraps as "t-/SNE"
#  - period after "groups"; blank line before "The data ellipses here ..." to match the other paragraphs
# PowerPoint must be closed. Run:  powershell -File talks\styles\slide31-text.ps1
$deck = Join-Path (Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)) "Vis-MLM-talk.pptx"
$app  = New-Object -ComObject PowerPoint.Application
$pres = $app.Presentations.Open($deck, $false, $false, $false)
$tr = $pres.Slides.Item(31).Shapes.Item("TextBox 5").TextFrame.TextRange

$nbh = [string][char]0x2011
do { $r = $tr.Replace("t-SNE", "t${nbh}SNE") } while ($r -ne $null)
$null = $tr.Replace("separation among groups", "separation among groups.")
$p6 = $tr.Paragraphs(6)
if ($p6.Text -like "The data ellipses*") { $null = $p6.InsertBefore("`r") }

$pres.Save(); $pres.Close()
if ($app.Presentations.Count -eq 0) { $app.Quit() }
"slide 31 text updated"
