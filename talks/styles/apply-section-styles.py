"""Add the soft section title layouts (sec0-sec5) to Vis-MLM-talk4.pptx and apply them.

Uses the colors and title box of make-title-styles.py (--set sections). For each talk section,
adds soft versions of the three content layouts (Title Only, Title and Content, Two Content),
named e.g. "Two Content · sec3", then moves every slide of that section that uses one of those
layouts onto its section's version. Title, section header and blank slides, and the backup
section, keep their layouts.

  sec0  Introduction, Why a romance in many dimensions?
  sec1  1. Ellipses everywhere          sec2  2. Multivariate juicers
  sec3  3. Elliptical insights          sec4  4. The HE plot framework
  sec5  5. Checking multivariate models, Closing

Run from the project root with the deck closed:
  python talks/styles/apply-section-styles.py [-o out.pptx]     (default: rewrite the deck)
Don't run it twice on the same deck: it would add a second set of layouts.
"""

import argparse
import importlib.util
import re
import shutil
import tempfile
import zipfile
from pathlib import Path

spec = importlib.util.spec_from_file_location("mts", Path(__file__).with_name("make-title-styles.py"))
mts = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mts)

DECK = Path("talks/Vis-MLM-talk4.pptx")
CFG = mts.SETS["sections"]


def section_key(name):
    if name.startswith(("Introduction", "Why")):
        return "0"
    if name.startswith("Closing"):
        return "5"
    m = re.match(r"(\d)\.", name)
    return m.group(1) if m else None          # Backup: unchanged


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("-o", "--out", type=Path, default=DECK)
    out = ap.parse_args().out

    tmp = Path(tempfile.mkdtemp())
    u = tmp / "u"
    with zipfile.ZipFile(DECK) as z:
        z.extractall(u)

    master = mts.read(u / "ppt/slideMasters/slideMaster1.xml")
    if re.search(r"· sec\d", "".join(mts.read(f) for f in (u / "ppt/slideLayouts").glob("*.xml"))):
        raise SystemExit("the deck already has the sec layouts")

    layout_of = {}
    for key, col in CFG["groups"].items():
        style = CFG["label"].format(key)
        spPr = mts.title_spPr(col, alpha=22000, line=col)
        lst = mts.title_lstStyle("tx1")
        for base, bname in mts.BASE_LAYOUTS.items():
            layout_of[(key, base)] = mts.add_layout(u, base, f"{bname} · {style}", spPr, lst)

    pres = mts.read(u / "ppt/presentation.xml")
    rels = mts.read(u / "ppt/_rels/presentation.xml.rels")
    file_of = {}
    for rel in re.findall(r"<Relationship [^>]*>", rels):
        t = re.search(r'Target="(?:/ppt/)?slides/(slide\d+\.xml)"', rel)
        if t:
            file_of[re.search(r'Id="([^"]+)"', rel).group(1)] = t.group(1)
    rid_of_id = {i: r for i, r in re.findall(r'<p:sldId id="(\d+)" r:id="(rId\d+)"', pres)}

    changed = {}
    for name, body in re.findall(r'<p14:section name="([^"]*)"[^>]*>(.*?)</p14:section>', pres, re.S):
        key = section_key(name)
        if key is None:
            continue
        for sid in re.findall(r'<p14:sldId id="(\d+)"', body):
            f = file_of[rid_of_id[sid]]
            rp = u / f"ppt/slides/_rels/{f}.rels"
            r = mts.read(rp)
            base = re.search(r"slideLayouts/(slideLayout\d+\.xml)", r).group(1)
            if (key, base) in layout_of:
                mts.write(rp, r.replace(f"slideLayouts/{base}", f"slideLayouts/{layout_of[(key, base)]}"))
                changed[key] = changed.get(key, 0) + 1

    tmp_out = tmp / "out.pptx"
    with zipfile.ZipFile(DECK) as zi, zipfile.ZipFile(tmp_out, "w", zipfile.ZIP_DEFLATED) as zo:
        names = set(str(p.relative_to(u)).replace("\\", "/") for p in u.rglob("*") if p.is_file())
        for info in zi.infolist():
            zo.write(u / info.filename, info.filename)
            names.discard(info.filename)
        for n in sorted(names):
            zo.write(u / n, n)
    shutil.copy(tmp_out, out)
    shutil.rmtree(tmp)
    print(f"wrote {out}: {len(layout_of)} layouts added; slides moved per section: {changed}")


if __name__ == "__main__":
    main()
