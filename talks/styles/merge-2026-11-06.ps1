# 2026-11-06: resolve the Vis-MLM-talk.pptx merge conflict (laptop bc796cbf + 4d80b957 vs. desktop
# origin/master). Starts from the remote (desktop) deck and re-applies the laptop-only edits:
#  - slide 5 notes: "visual and analysis tools" -> "visual tools" (remote already fixed the typos)
#  - slide 6: "Flatland" in italics
#  - slide 18: "slopes & covariances" in dark red
#  - slide 19: penguin picture larger (W203, as on the laptop), behind the text
#  - slide 9: Graphs: row, via slide09-graphs-row.ps1 (run separately afterwards)
# Slides 9 (code font), 27 and 29: remote versions kept.
# Usage: powershell -File merge-2026-11-06.ps1 <deck.pptx>   (PowerPoint closed; deck is modified)
param([Parameter(Mandatory)][string]$deck)
$app  = New-Object -ComObject PowerPoint.Application
$pres = $app.Presentations.Open((Resolve-Path $deck).Path, $false, $false, $false)

function Find-Text($slide, $text) {
  foreach ($sh in $slide.Shapes) { if ($sh.HasTextFrame) {
    $r = $sh.TextFrame.TextRange.Find($text); if ($r) { return $r } } }
  throw "'$text' not found on slide $($slide.SlideIndex)"
}

# slide 5 notes
$notes = $pres.Slides.Item(5).NotesPage.Shapes.Placeholders.Item(2).TextFrame.TextRange
$r = $notes.Find("visual and analysis tools")
if ($r) { $null = $r.Replace("visual and analysis tools", "visual tools") } else { "notes 5: phrase not found (already done?)" }

# slide 6
(Find-Text $pres.Slides.Item(6) "Flatland").Font.Italic = -1

# slide 18
(Find-Text $pres.Slides.Item(18) "slopes & covariances").Font.Color.RGB = 0x0000C0

# slide 19
$pic = $pres.Slides.Item(19).Shapes.Item("Picture 9")
$pic.LockAspectRatio = -1
$pic.Width = 203; $pic.Left = 758; $pic.Top = 86
$pic.ZOrder(1)   # msoSendToBack

$pres.Save(); $pres.Close()
if ($app.Presentations.Count -eq 0) { $app.Quit() }
"merged edits applied to $deck"
