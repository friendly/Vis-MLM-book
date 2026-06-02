# Chapter Summary: AI-tell scan

**Note on style:** These summaries intentionally use metaphorical, expansive language to convey enthusiasm for the topics. The goal is not to strip all color, but to catch phrases that read as generic AI boilerplate rather than the author's own voice, or that cross from enthusiastic into over-the-top.

**"revolutionize"** (Ch07) is a clear example of a word to cut regardless of style register — it's a red-flag AI superlative.

---

## Structural patterns across multiple files

These are the most recognizable AI signatures — cut wherever they appear:

1. **"Here are the essential takeaways/insights..."** boilerplate sentence before the bullet list — Ch06, Ch07, Ch10, Ch13. Delete; the bullets stand alone.

2. **Direct address** ("you can literally see...", "your best friends...") — Ch04, Ch07, Ch09, Ch12, Ch13. Academic prose uses "one" or passive voice, not "you." [MF: NO, I want to keep an active, personal voice]

3. **Simile closers** — final sentence recaps the chapter theme as a metaphor: "like navigating without a compass" (Ch07), "visual stories waiting to be told" (Ch13). These read as AI winding down rather than a real conclusion.

4. **"elegant"** applied to statistical methods — Ch06, Ch08, Ch10. Usually cut without loss.

5. **`•` bullet markers** instead of `*` — Ch05. Structural mismatch with all other summaries. [MF: DONE]

---

## File-by-file specifics (worst first)

### Ch09-summary.qmd (Collinearity) — most AI-flavored
- No `*` bullet markers; uses **bold sentence headers** — structural mismatch with every other summary file
- "Just like finding Waldo in a crowded illustration" — delete
- "The solution? **Tableplots**..." — rhetorical question trick
- "the troublemakers are lurking in those tiny eigenvalues" — "lurking"
- "It's geometry made actionable" — slogan
- "The genius of ridge regression" — "genius of"
- "collinearity problems **in style**" — "in style" is a prototypical AI closer
- **Action:** reformat as `*`-bulleted list; rewrite bold headers as lead phrases inside the bullets

### Ch05-summary.qmd (PCA and Biplots)
- "Welcome to the world of **multivariate juicers**---those magical tools that squeeze..." — opening line is the most AI of any file
- "like having X-ray vision for multivariate relationships!" — exclamation + cliché
- "These aren't just mathematical curiosities—they're essential tools" — AI pivot construction
- "magical tools", "journey from Flatland to Spaceland", "like adding helpful annotations to a map", "like organizing a messy bookshelf" [MF: leave as is]
- "Biplots are visualization gold, helping you view compressed N-dimensional data" → "Biplots display observations and variables in the same reduced space"
- "PCA is your geometric friend, helping you compress N-dimensional data" → "PCA finds the directions of maximum variance in your data"
- "The magic lies in the interpretation" --- drop phrase; the explanation that follows stands on its own
- "Outlier detection gets multidimensional power" → "Multivariate outliers can be invisible in any single variable"

### Ch07-summary.qmd (Regression Plots)
- "Here are the essential insights that will **revolutionize** how you understand" — **cut "revolutionize"**
- "magical plots perform visual surgery" — "magical" again
- "puppet masters controlling his key findings" — dramatic metaphor
- "regression modeling without visualization is like navigating without a compass" — stock AI simile
- "Influence diagnostics show potential trouble-makers" → "Influence diagnostics identify observations that distort model results"

### Ch13-summary.qmd (Equality of Covariance)
- "taken us on a journey from Box's famous row boat metaphor" — journey metaphor opener
- "Here are the essential insights that will transform how you think" — AI opener
- "visual stories waiting to be told, patterns waiting to be discovered, and insights illustrating the power of multivariate thinking" — triple parallel AI closer; last sentence can go
- "Small dimensions often hold big secrets" → "Small principal component dimensions often carry the most discriminating information"
- "Multiple measures tell richer stories" → "Multiple summary measures reveal different aspects of heterogeneity"
- "Levene meets MANOVA in beautiful harmony" → "A multivariate Levene test extends variance heterogeneity testing to HE plots"

### Ch12-summary.qmd (MLM Visualization)
- "Rather than navigate a confusing maze of tables of coefficients" — "confusing maze"
- "This isn't just dimension reduction---it's insight amplification" — AI pivot
- "turning the complexity of multivariate analysis into a comprehensible visual narrative" — closer
- "Canonical space is your secret weapon for high-dimensional visualization" → "Canonical space gives the most informative low-dimensional view of multivariate effects"
- "Visual hypothesis testing beats $p$-value hunting" → "HE plots make significance directly visible, without scanning tables of p-values"

### Ch04-summary.qmd (Multivariate Plots)
- "powerful engine for data exploration and discovery" — opener metaphor
- "Visual thinning is a superpower" — bold header, over the top
- "Data ellipses are a visualization Multi-Tool" — capitalized brand-name feel
- "like having X-ray vision" (same phrase as Ch04)
- "context matters" in bold — fine as content, but feels AI-stamped

### Ch10-summary.qmd (Hotelling's T²)
- "Here are the essential takeaways:" — delete
- "This elegant approach" — cut "elegant"
- "Hotelling's $T^2$ transforms multivariate complexity into univariate clarity" → "Hotelling's $T^2$ reduces a multivariate comparison to a single optimally-weighted composite"

### Ch03, Ch06, Ch08 — minor issues only
- **Ch03:** "absolutely essential", "The overarching message is clear:", "Talk about the dinosaur in the room!" (exclamation)
- **Ch06:** "The beauty lies in...", "unlocks the full power of", missing comma after "However" (line 40)
- **Ch08:** "you can **literally** see and manipulate" — cut "literally"

---

## Clean model to follow

**Ch11-summary.qmd** is the cleanest file — plain factual bullets, no metaphors, no "you", no simile closer. Reads like scholarly prose. Other files should move toward that register, while preserving the author's own metaphors and enthusiasm.
