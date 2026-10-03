# Would ggview or showtext help with the DPI fixes?

Reviewed 2026-10-03, following [the Bluesky post Michael shared](https://bsky.app/profile/daxkellie.bsky.social/post/3mwujqatees2z). Checked the 69 entries in the [image-quality checklist](CMYK-checklist.md).

**ggview is an optional preview aid.** It shows a ggplot at its intended export dimensions and resolution, helping check text, legends, and spacing before saving. It also supports saving with those settings. It does not increase an existing image’s resolution; the actual fix is to regenerate the plot at sufficient dimensions or export it as vector artwork. See the [ggview documentation](https://github.com/idmn/ggview).

The two clearest remaining candidates are:

| Figure | Why ggview could help | Actual DPI fix |
|---|---|---|
| `mona-pca.png` | [R/PCA-MonaLisa.R](../../R/PCA-MonaLisa.R) builds the faceted ggplot as `p_out`. Previewing would help check its title and nine panel labels. | Save `p_out` explicitly at adequate dimensions. The current image is 630×912 px, about 144 effective print DPI; the script’s existing save line is marked as not working. |
| `ANCOVA-ex.png` | [R/ANCOVA-ex.R](../../R/ANCOVA-ex.R) creates two ggplots combined with patchwork. Previewing could help check legends, panel labels, and mean markers; verify the combined preview with the installed versions. | Save the combined plot explicitly at sufficient size. The current image is 1034×493 px, about 210 effective print DPI. A 5-inch-wide export at 300 DPI gives 1500 px, enough for its current placement. |

The two penguin outlier biplots could also benefit during future revisions, but their current files are already 1803×1665 px—about 470 effective print DPI. Both DPI checklist entries were marked resolved on 2026-10-03.

**No listed figure has a demonstrated need for adding showtext.** It handles font rendering. Matching its DPI to the export matters only when showtext is in use; the related [Chapter 5 tiny-text problem](../ch05-ggbiplot-problems.md) is already addressed.

Most remaining images need a better original, a fresh export from existing R/PowerPoint/vector sources, or a smaller print placement. Neither package replaces that work. Use ggview if it makes the two exports easier to inspect; ordinary `ggsave()` plus checking the saved image is also sufficient.

No figures were regenerated during this review. The two penguin biplot checklist entries were subsequently marked resolved based on the existing higher-resolution files.
