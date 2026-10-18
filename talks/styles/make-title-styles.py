"""Build title-box layout variants for the talk deck, as a demo PPTX in talks/styles/.

Starts from Vis-MLM-talk4.pptx (same master, theme and fonts) and adds slide layouts whose
title placeholder is a filled box with rounded corners, in three treatments:

  navy   dark blue fill, white text (the usual style)
  solid  book part color fill, white text
  soft   book part color at low opacity, thin outline in the same color, black text

Part colors are the book's (latex/part-colors.tex). Talk sections map onto book parts:
  I   Orienting ideas      blue    Introduction, Why many dimensions
  II  Exploratory methods  teal    Ellipses everywhere, Juicers
  III Univariate LMs       green   Elliptical insights
  IV  Multivariate LMs     orange  HE plots, Checking models

Each treatment is made for the three layouts the talk uses for content slides (Title Only,
Title and Content, Two Content). The demo slides show four talk slides, one per part, each
in the navy, solid and soft versions. To apply a style to a slide: Home > Layout.

Two sets (--set):
  parts     title-styles.pptx: navy, plus solid and soft in the four book part colors (above)
  sections  section-styles.pptx: solid and soft in one color per talk section, sec0-sec5,
            on a cool-to-warm sequence (data -> models) that keeps the book part colors
            where the sections line up with book parts:
              sec0  Why many dimensions (+ intro)   navy
              sec1  Ellipses everywhere            blue
              sec2  Juicers                        teal    (Part II)
              sec3  Elliptical insights            green   (Part III)
              sec4  HE plots                       orange  (Part IV)
              sec5  Checking models (+ closing)    brick red

Run from the project root:  python talks/styles/make-title-styles.py --set sections
"""

import argparse
import re
import shutil
import subprocess
import sys
import tempfile
import zipfile
from pathlib import Path

SRC = Path("talks/Vis-MLM-talk4.pptx")
SKILL = Path("C:/Users/friendly/.claude/skills/synced/d4f299d0-ea06-4af2-9f3b-0d0eec61d09b_5a3381b1-aabd-4407-99cd-237b03fc6820/pptx/scripts")

NAVY = "1F3864"
SETS = {
    "parts": dict(
        out=Path("talks/styles/title-styles.pptx"),
        groups={"I": "0000BF",      # xcolor blue, a little darker
                "II": "008080",     # teal
                "III": "267342",
                "IV": "CC6600"},
        label="Part {}",
        treatments=["navy", "solid", "soft"],
        # demo: (talk4 slide file, group)
        demo=[("slide6.xml", "I"), ("slide16.xml", "II"), ("slide32.xml", "III"), ("slide58.xml", "IV")]),
    "sections": dict(
        out=Path("talks/styles/section-styles.pptx"),
        groups={"0": NAVY,
                "1": "2E5EAA",      # blue
                "2": "008080",      # teal (book Part II)
                "3": "267342",      # green (book Part III)
                "4": "CC6600",      # burnt orange (book Part IV)
                "5": "A33B2B"},     # brick red
        label="sec{}",
        treatments=["solid", "soft"],
        demo=[("slide6.xml", "0"), ("slide16.xml", "1"), ("slide27.xml", "2"),
              ("slide32.xml", "3"), ("slide49.xml", "4"), ("slide58.xml", "5")]),
}
BASE_LAYOUTS = {"slideLayout6.xml": "Title Only",
                "slideLayout2.xml": "Title and Content",
                "slideLayout4.xml": "Two Content"}

# title box: a bit wider than the master's so the text lines up with the body text,
# and shorter, so the box does not crowd the content below
X, Y, CX, CY = 609600, 274320, 10972800, 777240


def title_spPr(fill, alpha=None, line=None):
    a = f'<a:alpha val="{alpha}"/>' if alpha else ""
    ln = (f'<a:ln w="19050"><a:solidFill><a:srgbClr val="{line}"><a:alpha val="60000"/></a:srgbClr></a:solidFill></a:ln>'
          if line else '<a:ln><a:noFill/></a:ln>')
    return (f'<p:spPr><a:xfrm><a:off x="{X}" y="{Y}"/><a:ext cx="{CX}" cy="{CY}"/></a:xfrm>'
            f'<a:prstGeom prst="roundRect"><a:avLst><a:gd name="adj" fmla="val 18000"/></a:avLst></a:prstGeom>'
            f'<a:solidFill><a:srgbClr val="{fill}">{a}</a:srgbClr></a:solidFill>{ln}</p:spPr>')


def title_lstStyle(text):
    return (f'<a:lstStyle><a:lvl1pPr><a:defRPr><a:solidFill><a:schemeClr val="{text}"/></a:solidFill>'
            f'</a:defRPr></a:lvl1pPr></a:lstStyle>')


def styles(cfg):
    """(style name, spPr, lstStyle) for every layout variant of a set."""
    out = [("Navy", title_spPr(NAVY), title_lstStyle("bg1"))] if "navy" in cfg["treatments"] else []
    for key, col in cfg["groups"].items():
        label = cfg["label"].format(key)
        out.append((f"{label} solid", title_spPr(col), title_lstStyle("bg1")))
        out.append((f"{label} soft", title_spPr(col, alpha=22000, line=col), title_lstStyle("tx1")))
    return out


def read(p):
    return p.read_text(encoding="utf-8")


def write(p, s):
    p.write_text(s, encoding="utf-8", newline="")


def add_layout(u, base, name, spPr, lst):
    """Copy a layout, restyle its title placeholder and register it with the master."""
    lay_dir = u / "ppt/slideLayouts"
    n = max(int(re.search(r"\d+", f.name).group()) for f in lay_dir.glob("slideLayout*.xml")) + 1
    new = f"slideLayout{n}.xml"
    x = read(lay_dir / base)
    x = re.sub(r'<p:cSld name="[^"]*"', f'<p:cSld name="{name}"', x, count=1)
    m = re.search(r'<p:sp>(?:(?!</p:sp>).)*?<p:ph type="title".*?</p:sp>', x, re.S)
    sp = m.group(0)
    sp2 = re.sub(r"<p:spPr/>|<p:spPr>.*?</p:spPr>", spPr, sp, count=1, flags=re.S)
    sp2 = re.sub(r"<a:lstStyle/>|<a:lstStyle>.*?</a:lstStyle>", lst, sp2, count=1, flags=re.S)
    x = x.replace(sp, sp2)
    x = re.sub(r'\s+preserve="1"', "", x)
    x = x.replace("<p:sldLayout ", '<p:sldLayout preserve="1" ', 1)
    write(lay_dir / new, x)
    shutil.copy(lay_dir / "_rels" / f"{base}.rels", lay_dir / "_rels" / f"{new}.rels")

    ct = u / "[Content_Types].xml"
    write(ct, read(ct).replace("</Types>",
          f'<Override PartName="/ppt/slideLayouts/{new}" '
          f'ContentType="application/vnd.openxmlformats-officedocument.presentationml.slideLayout+xml"/></Types>'))

    mrels_p = u / "ppt/slideMasters/_rels/slideMaster1.xml.rels"
    mrels = read(mrels_p)
    rid = "rId" + str(max(int(r) for r in re.findall(r'Id="rId(\d+)"', mrels)) + 1)
    write(mrels_p, mrels.replace("</Relationships>",
          f'<Relationship Id="{rid}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout" '
          f'Target="../slideLayouts/{new}"/></Relationships>'))

    m_p = u / "ppt/slideMasters/slideMaster1.xml"
    mx = read(m_p)
    pres = read(u / "ppt/presentation.xml")
    used = [int(i) for i in re.findall(r'<p:sldLayoutId id="(\d+)"', mx)] + \
           [int(i) for i in re.findall(r'<p:sldMasterId id="(\d+)"', pres)]
    mx = mx.replace("</p:sldLayoutIdLst>", f'<p:sldLayoutId id="{max(used) + 1}" r:id="{rid}"/></p:sldLayoutIdLst>')
    write(m_p, mx)
    return new


def main(cfg):
    OUT = cfg["out"]
    tmp = Path(tempfile.mkdtemp())
    u = tmp / "u"
    with zipfile.ZipFile(SRC) as z:
        z.extractall(u)

    # new layouts
    layout_of = {}   # (style, base) -> new layout file
    for style, spPr, lst in styles(cfg):
        for base, bname in BASE_LAYOUTS.items():
            layout_of[(style, base)] = add_layout(u, base, f"{bname} \u00b7 {style}", spPr, lst)

    # demo slides: one copy of each per treatment
    keep = []        # (slide file, section)
    for src, part in cfg["demo"]:
        base = re.search(r"slideLayouts/(slideLayout\d+\.xml)", read(u / f"ppt/slides/_rels/{src}.rels")).group(1)
        label = cfg["label"].format(part)
        treats = cfg["treatments"]
        dests = [src]
        for _ in treats[1:]:        # duplicate before any layout is changed
            out = subprocess.run([sys.executable, str(SKILL / "add_slide.py"), str(u), src],
                                 capture_output=True, text=True, check=True).stdout
            dests.append(re.search(r"(slide\d+\.xml)", out.split("Created")[-1]).group(1))
        for dest, treat in zip(dests, treats):
            style = "Navy" if treat == "navy" else f"{label} {treat}"
            rp = u / f"ppt/slides/_rels/{dest}.rels"
            write(rp, read(rp).replace(f"slideLayouts/{base}", f"slideLayouts/{layout_of[(style, base)]}"))
            keep.append((dest, label))

    # slide list and sections: only the demo slides
    pres_p = u / "ppt/presentation.xml"
    rels = read(u / "ppt/_rels/presentation.xml.rels")
    rid_of = {}
    for rel in re.findall(r"<Relationship [^>]*>", rels):
        t = re.search(r'Target="(?:/ppt/)?slides/(slide\d+\.xml)"', rel)
        if t:
            rid_of[t.group(1)] = re.search(r'Id="([^"]+)"', rel).group(1)
    pres = read(pres_p)
    ids = dict((r, i) for i, r in re.findall(r'<p:sldId id="(\d+)" r:id="(rId\d+)"', pres))
    lst = "".join(f'<p:sldId id="{ids[rid_of[f]]}" r:id="{rid_of[f]}"/>' for f, _ in keep)
    pres = re.sub(r"<p:sldIdLst>.*?</p:sldIdLst>", f"<p:sldIdLst>{lst}</p:sldIdLst>", pres, flags=re.S)
    secs = ""
    for k, label in enumerate(cfg["label"].format(g) for g in cfg["groups"]):
        sl = "".join(f'<p14:sldId id="{ids[rid_of[f]]}"/>' for f, lab in keep if lab == label)
        secs += f'<p14:section name="{label}" id="{{6A1B2C3D-0000-4000-8000-00000000000{k + 1}}}"><p14:sldIdLst>{sl}</p14:sldIdLst></p14:section>'
    pres = re.sub(r"(<p14:sectionLst[^>]*>).*?(</p14:sectionLst>)", lambda m: m.group(1) + secs + m.group(2), pres, flags=re.S)
    write(pres_p, pres)

    for f, _ in keep:            # demo slides must be visible
        p = u / f"ppt/slides/{f}"
        write(p, read(p).replace(' show="0"', ""))

    subprocess.run([sys.executable, str(SKILL / "clean.py"), str(u)], check=True, capture_output=True)

    if OUT.exists():
        OUT.unlink()
    with zipfile.ZipFile(SRC) as zi, zipfile.ZipFile(OUT, "w", zipfile.ZIP_DEFLATED) as zo:
        names = set(str(p.relative_to(u)).replace("\\", "/") for p in u.rglob("*") if p.is_file())
        for info in zi.infolist():            # original order first ([Content_Types].xml leads)
            if info.filename in names:
                zo.write(u / info.filename, info.filename)
                names.discard(info.filename)
        for n in sorted(names):
            zo.write(u / n, n)
    shutil.rmtree(tmp)
    print(f"wrote {OUT}: {len(keep)} demo slides, {len(layout_of)} new layouts")


if __name__ == "__main__":

    ap = argparse.ArgumentParser()
    ap.add_argument("--set", choices=SETS, default="sections")
    main(SETS[ap.parse_args().set])
