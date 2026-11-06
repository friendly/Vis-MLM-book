# 2026-10-28: slide master body style, first level: the bullet symbols larger (120% of the text) and blue
# (#1F4E9A); the text itself stays 24pt, theme Text 1 (black). (A first version of this script had made the
# level-1 text 26pt blue; this one also puts that back.) Content placeholders on the slides inherit it;
# the Section Header layout has no bullets. Exports previews of a few slides.
# Saves the deck. PowerPoint must be closed. Already applied: do NOT re-run on the current deck.
$deck = "C:\R\Projects\Vis-MLM-book\talks\Vis-MLM-talk.pptx"
$out  = "C:\Users\friendly\AppData\Local\Temp\claude\C--R-Projects-Vis-MLM-book\60ea4978-1136-4423-9282-96c48d816286\scratchpad\master"
New-Item -ItemType Directory -Force $out | Out-Null
$blue = 0x1F + 256*0x4E + 65536*0x9A                   # BGR

$app  = New-Object -ComObject PowerPoint.Application
$pres = $app.Presentations.Open($deck, $false, $false, $false)
$m = $pres.SlideMaster
# the master's body placeholder (type 2) carries the body style (TextStyles(3) = ppBodyStyle)
$ph = @($m.Shapes | Where-Object { $_.Type -eq 14 -and $_.PlaceholderFormat.Type -eq 2 })[0]
$p = $ph.TextFrame.TextRange.Paragraphs(1)
$p.Font.Size = 24
$p.Font.Color.ObjectThemeColor = 13                     # msoThemeColorText1
$b = $p.ParagraphFormat.Bullet
$b.RelativeSize = 1.2
$b.Font.Color.RGB = $blue
$L = $m.TextStyles(3).Levels(1)
"body lvl1: {0}pt {1:X6}; bullet {2}x, colour {3:X6}" -f $L.Font.Size, $L.Font.Color.RGB, $b.RelativeSize, $b.Font.Color.RGB

$pres.Save()
foreach ($k in 2, 6, 9, 54, 63) { $pres.Slides.Item($k).Export((Join-Path $out ("slide-{0:D2}.png" -f $k)), "PNG", 1280, 720) }
$pres.Close(); $app.Quit()
