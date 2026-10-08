"""Split the three-panel Simpson's paradox figure (Fig 4.23) into one image per panel.

The panels of images/peng-simpsons.png (3000 x 1000 px, from R/penguin/penguins-simpsons.R)
each occupy an exact third of the width, so cropping at thirds gives three 1000 x 1000 images
that, placed side by side, reproduce the original. Used for a progressive reveal in the talk.

Run from the project root:  python talks/images/peng-simpsons-split.py
"""
from PIL import Image

src = Image.open("images/peng-simpsons.png")
w, h = src.size
names = ["ignoring", "by", "within"]
for i, name in enumerate(names):
    panel = src.crop((i * w // 3, 0, (i + 1) * w // 3, h))
    out = f"talks/images/peng-simpsons-{i + 1}-{name}.png"
    panel.save(out, dpi=(200, 200))
    print(out, panel.size)
