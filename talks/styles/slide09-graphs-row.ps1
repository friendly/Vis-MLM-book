# 2026-11-04: slide 9 ("MLM problem: easy to fit, hard to see"): a "Graphs:" row under the
# model-type table (a picture) and the green arrow: large green check marks under the two q=1
# columns, large red "?" under the two q>1 columns.
# Column centres are measured from the table picture (Picture 3, L478 W467).
# Re-runnable: deletes any earlier "Graphs *" shapes first. PowerPoint must be closed.
# Run:  powershell -File talks\styles\slide09-graphs-row.ps1
$deck = Join-Path (Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)) "Vis-MLM-talk.pptx"
$app  = New-Object -ComObject PowerPoint.Application
$pres = $app.Presentations.Open($deck, $false, $false, $false)
$s = $pres.Slides.Item(9)
if ($s.Shapes.Title.TextFrame.TextRange.Text -notmatch "^MLM problem") { throw "slide 9 is not the MLM problem slide" }
foreach ($old in @($s.Shapes | Where-Object { $_.Name -like "Graphs*" })) { $old.Delete() }

$top = 426          # just below the green arrow (T391 H31)
$green = 0x50B000   # BGR for RGB(0,176,80)
$red   = 0x0000C0   # BGR for RGB(192,0,0)

function Add-Mark($name, $text, $cx, $color) {
  $w = 60
  $b = $s.Shapes.AddTextbox(1, $cx - $w/2, $top, $w, 50)
  $b.Name = $name
  $tf = $b.TextFrame; $tf.WordWrap = 0; $tf.AutoSize = 0
  $tf.MarginLeft = 0; $tf.MarginRight = 0; $tf.MarginTop = 0; $tf.MarginBottom = 0
  $tr = $tf.TextRange; $tr.Text = $text
  $tr.ParagraphFormat.Alignment = 2   # center
  $tr.Font.Name = "Segoe UI Symbol"; $tr.Font.Size = 36; $tr.Font.Bold = -1
  $tr.Font.Color.RGB = $color
}

# label, right-aligned so it ends just left of the first q=1 column
$lab = $s.Shapes.AddTextbox(1, 470, $top + 8, 92, 30)
$lab.Name = "Graphs label"
$lab.TextFrame.WordWrap = 0
$lab.TextFrame.TextRange.Text = "Graphs:"
$lab.TextFrame.TextRange.ParagraphFormat.Alignment = 3   # right
$lab.TextFrame.TextRange.Font.Name = "Aptos"; $lab.TextFrame.TextRange.Font.Size = 20
$lab.TextFrame.TextRange.Font.Bold = -1; $lab.TextFrame.TextRange.Font.Color.RGB = 0x262626

$check = [string][char]0x2714
Add-Mark "Graphs check quant q=1"    $check 628 $green
Add-Mark "Graphs ? quant q>1"        "?"    722 $red
Add-Mark "Graphs check discrete q=1" $check 816 $green
Add-Mark "Graphs ? discrete q>1"     "?"    910 $red

$pres.Save()
$s.Export((Join-Path $env:TEMP "slide9.png"), "PNG", 1280, 720)
$pres.Close()
if ($app.Presentations.Count -eq 0) { $app.Quit() }
"slide 9 graphs row added; preview: $env:TEMP\slide9.png"
