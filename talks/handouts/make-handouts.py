"""Build two printable handouts of the talk from export-slides.ps1's output (slides/*.png, notes.json):

  handout-2x2.pdf     four slides per page, 2 x 2, landscape
  handout-notes.pdf   portrait; each slide small at the left with its speaker notes beside it

Writes the .tex files and runs xelatex on each. Run from this folder:  python make-handouts.py
"""
import json
import re
import subprocess
from datetime import date
from pathlib import Path

HERE = Path(__file__).resolve().parent
PAPER = "letterpaper"
FONT = "Calibri"

slides = json.loads((HERE / "notes.json").read_text(encoding="utf-8"))
talk = re.sub(r"\s+", " ", slides[0]["title"]).strip() or "Talk"
stamp = date.today().strftime("%Y-%m-%d")

SPECIAL = {"\\": r"\textbackslash{}", "&": r"\&", "%": r"\%", "$": r"\$", "#": r"\#", "_": r"\_",
           "{": r"\{", "}": r"\}", "~": r"\textasciitilde{}", "^": r"\textasciicircum{}"}


def tex(s):
    s = s.replace("", "→")              # Symbol-font arrow pasted into the notes
    return "".join(SPECIAL.get(ch, ch) for ch in s)


def paras(s):
    parts = [p.strip() for p in re.split(r"[\r\n\v]+", s) if p.strip()]
    return r"\par ".join(tex(p) for p in parts)


def preamble(geometry, landscape=False):
    return rf"""\documentclass[10pt]{{article}}
\usepackage[{PAPER}{",landscape" if landscape else ""},{geometry}]{{geometry}}
\usepackage{{fontspec}}
\setmainfont{{{FONT}}}
\usepackage{{graphicx,xcolor,fancyhdr}}
\definecolor{{frame}}{{gray}}{{0.6}}
\setlength{{\fboxsep}}{{0pt}}\setlength{{\fboxrule}}{{0.4pt}}
\setlength{{\parindent}}{{0pt}}
\pagestyle{{fancy}}\fancyhf{{}}
\renewcommand{{\headrulewidth}}{{0pt}}
\fancyfoot[L]{{\footnotesize\color{{gray}} {tex(talk)}}}
\fancyfoot[R]{{\footnotesize\color{{gray}} {stamp}\quad page \thepage}}
\newcommand{{\slide}}[2]{{{{\color{{frame}}\fbox{{\includegraphics[width=\dimexpr#1-0.8pt\relax]{{slides/slide-#2.png}}}}}}}}
\begin{{document}}
"""


def two_by_two():
    w = "4.9in"
    cells = []
    for s in slides:
        k = f"{s['slide']:02d}"
        cells.append(rf"\begin{{minipage}}[t]{{{w}}}\slide{{{w}}}{{{k}}}\par\vspace{{2pt}}"
                     rf"{{\footnotesize\color{{gray}} {s['slide']}}}\end{{minipage}}")
    body = []
    for i in range(0, len(cells), 4):
        page = cells[i:i + 4]
        rows = [page[j:j + 2] for j in range(0, len(page), 2)]
        body.append(r"\centering" + "\n\n\\vspace{0.25in}\n\n".join(r"\hfill ".join(r) + r"\hfill\null" if len(r) == 1 else r" \hfill ".join(r) for r in rows))
        body.append(r"\newpage")
    return preamble("margin=0.45in,bottom=0.6in", landscape=True) + "\n".join(body) + "\n\\end{document}\n"


def notes_pages():
    w = "3.0in"
    rows = []
    for s in slides:
        k = f"{s['slide']:02d}"
        note = paras(s["notes"]) or r"\textcolor{gray}{(no notes)}"
        rows.append(rf"""\begin{{minipage}}[t]{{{w}}}\vspace{{0pt}}\slide{{{w}}}{{{k}}}\end{{minipage}}\hfill
\begin{{minipage}}[t]{{4.15in}}\vspace{{0pt}}{{\small\textbf{{{s['slide']}.\ {tex(s['title'])}}}\par\vspace{{3pt}}}}
{{\small\setlength{{\parskip}}{{3pt}} {note}\par}}\end{{minipage}}
\par\vspace{{8pt}}{{\color{{frame}}\hrule}}\vspace{{8pt}}""")
    return preamble("margin=0.6in,bottom=0.75in") + "\n".join(rows) + "\n\\end{document}\n"


for name, text in [("handout-2x2", two_by_two()), ("handout-notes", notes_pages())]:
    (HERE / f"{name}.tex").write_text(text, encoding="utf-8")
    r = subprocess.run(["xelatex", "-interaction=nonstopmode", "-halt-on-error", f"{name}.tex"],
                       cwd=HERE, capture_output=True, text=True, encoding="utf-8", errors="replace")
    pages = re.search(r"Output written on .*\((\d+) pages?", r.stdout)
    print(f"{name}.pdf:", f"{pages.group(1)} pages" if pages else "FAILED\n" + r.stdout[-1500:])
