# Naming the unusual penguins: 283, 10 and 35

Analysis: `R/penguin/names/penguin-names.R` (run from the project root); figures from `penguin-names-figs.R`. Data: `heplots::peng`, 333 birds; case
numbers are row numbers, as in the book.

## The question

The book and the talk name two of the three "noteworthy" birds, the cases with the largest Mahalanobis
D² on the four measures (Ch 4, `fig-peng-cqplot`):

| Case | Species, sex | Current name | Why |
|---|---|---|---|
| 283 | Chinstrap, female | **Cyrano** | very long bill; name from Cara Thompson's useR! 2022 poster ([Level Up Your Labels](https://www.cararthompson.com/talks/user2022/)), cited as `@Thompson2022` |
| 10 | Adelie, male | **Hook Nose** | "very short and curved bill": bill depth read as curvature |
| 35 | Adelie, male | (none) | Ch 5: "probably much heavier than most and has short flippers" |

The vignettes (`R/penguin/peng-bill-size-shape-altviews.qmd`, `R/penguin/body-flipper.qmd`, and the
blog posts made from them) replace the four measures with variables that mean something:

- **bill size** = log L + log D, the area of the bill's profile;
- **bill shape** = log L − log D, i.e. L / D: long and slender (high) or short and stubby (low);
- **body size** = log F + log M/3;
- **stoutness** = log M/3 − log F: heavy (high) or light (low) for one's flipper length.

Within species these four are nearly uncorrelated, except bill size with body size (r = 0.70), so each bird's
oddity can be traced to one or two of them. The question here is whether the names fit what makes each bird
unusual.

## What the data say

### Measures as recorded, against their own species and sex

| Case | Bill length | Bill depth | L / D | Flipper | Mass | M/F³ (g/cm³) |
|---|---|---|---|---|---|---|
| 283 Chinstrap f | **58.0** (mean 46.6) | 17.8 (17.6) | **3.26** (2.65) | **181** (192) | 3700 (3527) | **0.62** (0.50) |
| 10 Adelie m | **34.6** (40.4) | **21.1** (19.1) | **1.64** (2.12) | 198 (192) | 4400 (4043) | 0.57 (0.57) |
| 35 Adelie m | 39.8 (40.4) | 19.1 (19.1) | 2.08 (2.12) | **184** (192) | **4650** (4043) | **0.75** (0.57) |

Means for the bird's species and sex are in parentheses. M/F³ is the raw form of stoutness, with F in cm.

### Standardized within species, in the vignettes' variables

z-scores within species; in brackets, the rank of |z| among all 333 birds (1 = most extreme).

| Case | bill size | bill shape | body size | stoutness |
|---|---|---|---|---|
| 283 | 1.19 | **3.80** [2] | −1.24 | **2.50** [6] |
| 10 | 0.26 | **−3.43** [3] | 1.56 | 0.47 |
| 35 | 0.62 | −0.20 | 0.71 | **2.78** [3] |

Which variable carries each bird's within-species D² (squared z, using the pooled within-species SD):

| Case | bill size | bill shape | body size | stoutness | D² within species (rank) | D² ignoring species (rank) |
|---|---|---|---|---|---|---|
| 283 | 1.5 | **10.5** | 1.6 | **5.4** | 23.6 (1) | 27.8 (1) |
| 10 | 0.1 | **16.0** | 2.6 | 0.3 | 19.2 (2) | 13.3 (2) |
| 35 | 0.4 | 0.1 | 0.6 | **11.2** | 11.5 (9) | 12.4 (3) |

(The squared z's don't sum exactly to D², because bill size and body size are correlated.)

### Reading it

- **283 is unusual for the *shape* of her bill, not just its length.** Her L / D of 3.26 is far above every
  other Chinstrap (the next is 2.93) and is above the *Gentoo* means (3.15 for males, 3.20 for females). She has a
  Gentoo's bill on a Chinstrap's body. She is also the stoutest Chinstrap (very short flippers for her mass),
  which is the second, smaller part of her D².
  **Cyrano still fits**: a long, slender nose is exactly the point of Cyrano.

- **10 is unusual for having the stubbiest bill of all 333 penguins**: L / D = 1.64, against 2.12 for Adelie
  males. The next stubbiest, case 65, has 1.76. His bill is both short (4th percentile among Adelies) and deep (97th).
  Bill shape accounts for 16 of his D² of 19. The rest of him is a large but ordinary Adelie male.
  **"Hook Nose" doesn't fit.** Depth is measured top to bottom at the base of the bill. It says how thick
  the bill is, not how curved. Nothing in the data measures a hook. His bill is short and thick, the opposite of
  Cyrano's: a snub nose.

- **35 has an ordinary bill and an unusual body.** His bill is average for an Adelie male in every
  respect. He is the **stoutest penguin in the data** (M/F³ = 0.75; next 0.69): one of the heaviest Adelies
  (4650 g, 97th percentile) on short flippers (184 mm, 14th percentile). Stoutness accounts for 11.2 of his
  D² of 11.5. Chapter 5's guess, "much heavier than most and has short flippers", is right.
  He is noteworthy mainly because the book's D² ignores species. Within species he ranks only 9th, behind
  cases such as 124 and 24. But on one interpretable dimension, he is the most extreme bird of all.

So the three birds are each extreme on a different one of the vignettes' variables. That makes a neat
story for the book and the talk:

| Case | Extreme on | Direction |
|---|---|---|
| 283 | bill shape | most slender (a Gentoo-shaped bill on a Chinstrap) |
| 10 | bill shape | most stubby, of all 333 |
| 35 | stoutness | stoutest, of all 333 |

## Name ideas

Cyrano is a famous *literary nose*. Keeping that pattern gives a set that reads as one family.

**283: keep "Cyrano".** The analysis supports it better than before: the bill is long *relative to its
depth*, not merely long. (The book's footnote already covers her being female.)

**10, for the short, thick bill:**

- **Socrates.** The most famous snub nose in history: Plato and Xenophon both describe it. It pairs with
  Cyrano as the opposite nose, and needs a one-line footnote, as Cyrano does.
- **Pug.** Needs no explanation; less in keeping with Cyrano.
- **Puffin.** Puffins have short, very deep bills, so the image is apt. But naming a penguin after another
  bird may confuse.

**35, for the stout body:**

- **Falstaff.** Shakespeare's fat knight: literary, like Cyrano, and instantly "stout".
- **Butterball**, **Tubby**: plainer alternatives.

My pick: **Cyrano, Socrates and Falstaff.** The long nose, the snub nose and the stout one. In the talk, the
contrast between the first two makes the point that it is the *shape* of the bill (L / D), not its length or
depth alone, that marks them out. This is the size and shape story of the vignette.

## Thompson's four birds

Cyrano's name comes from Cara Thompson's useR! 2022 poster, [*Level Up Your
Labels*](https://www.cararthompson.com/talks/user2022/) [@Thompson2022], a lesson in annotating plots.
Her plot, titled *"Perfectly proportional penguins - with a few exceptions!"*, shows flipper length against
bill length. Four text boxes name four birds. The code, kept in `R/penguin/peng-outliers.R`, finds them
by their bill and flipper lengths in `palmerpenguins::penguins`. Matched to the book's `heplots::peng`
(section 6 of `penguin-names.R`), they are:

| Nickname | Case (`peng`) | Row in `penguins` | Species, sex | Her label |
|---|---|---|---|---|
| The BFG | 124 | 130 | Adelie m | "Sitting comfortably within the cluster of Gentoos, this Adelie penguin defies the predictions of his species" |
| Tinkerbell | 304 | 315 | Chinstrap f | "The smallest penguin in the set defies the odds on weight for her species and flipper and bill length." |
| Average Joes | 166 | 172 | Gentoo m | "The Gentoos tend to stick to their trend, with very few outliers. Heavier penguins have longer flippers and longer bills." |
| Cyrano | 283 | 294 | Chinstrap f | "With an exceptionally long bill and the shortest flippers bar one among the Chinstraps" |

Case numbers differ between the two datasets because `peng` drops the 11 birds with missing values.

### As recorded

| Case | Bill length | Bill depth | L / D | Flipper | Mass | M/F³ |
|---|---|---|---|---|---|---|
| 124 BFG | **44.1** (40.4) | 18.0 (19.1) | 2.45 (2.12) | **210** (192) | 4000 (4043) | **0.43** (0.57) |
| 304 Tinkerbell | 46.9 (46.6) | **16.6** (17.6) | 2.83 (2.65) | 192 (192) | **2700** (3527) | **0.38** (0.50) |
| 166 Average Joe | 48.7 (49.5) | 15.1 (15.7) | 3.23 | 222 (222) | 5350 (5485) | 0.49 |
| 283 Cyrano | **58.0** (46.6) | 17.8 (17.6) | **3.26** (2.65) | **181** (192) | 3700 (3527) | **0.62** (0.50) |

Means for the bird's species and sex are in parentheses.

### In the vignettes' variables

z-scores within species, with the rank of |z| among all 333 birds in brackets, and the bird's D²:

| Case | bill size | bill shape | body size | stoutness | D² within (rank) | D² ignoring species (rank) |
|---|---|---|---|---|---|---|
| 124 BFG | 1.00 | 1.97 [12] | 1.98 [13] | −1.82 [22] | 15.8 (3) | 5.0 (89) |
| 304 Tinkerbell | −1.18 | 1.18 | −1.96 [14] | **−2.84 [1]** | 11.0 (10) | 10.5 (5) |
| 166 Average Joe | 0.29 | 0.31 | 0.69 | −0.17 | 0.6 (319) | 2.4 (250) |
| 283 Cyrano | 1.19 | **3.80 [2]** | −1.24 | 2.50 [6] | 23.6 (1) | 27.8 (1) |

### Reading her labels against the data

Thompson picked her birds by eye, from one 2D plot. All her readings check out, and the 4D analysis adds
something to each.

- **The BFG (124)** has the longest flippers of any Adelie (210 mm; rank 1 of 333 on |z| for flipper
  length) and a long bill (97th percentile). On bill length and flipper length alone, a discriminant
  analysis calls him a Gentoo with probability 0.97, so he does sit "comfortably within the cluster of
  Gentoos". But his bill is deep, as an Adelie's is, and in all four measures he isn't a Gentoo at all: the
  LDA calls him a Chinstrap, but only just (0.53). The book's D² ignoring species misses him (rank 89).
  **Within species he is the third most unusual bird in the data**, after Cyrano and case 10. His oddity is
  spread across a large body and a slender bill, with lean proportions (long flippers for his mass).
  "The BFG" (big, long-limbed, gentle) fits.

- **Tinkerbell (304)** is the lightest bird of all 333 (2700 g; next 2850). Her flippers and bill
  length are ordinary for a Chinstrap female, so she is light *for her size*. She is **the least stout penguin
  in the data** (M/F³ = 0.38, rank 1 on stoutness). She is the mirror image of case 35, the stoutest. Her
  bill is also shallow (3rd percentile in depth). "Tinkerbell" fits: small and light, and her D² ignoring
  species ranks 5th.

- **Average Joe (166)** is just that. His flipper length is exactly the Gentoo male mean, and his D²
  within species ranks 319 of 333. Thompson used him to stand for the Gentoo trend. He is the control
  case.

- **Cyrano (283)**: her label is exact. Her flippers, at 181 mm, are tied for second shortest among the
  Chinstraps (case 272 has 178). The analysis above adds that the long bill is slender, and the short
  flippers on an ordinary mass make her stout.

### Two families of names

Thompson's names are characters from fiction (Dahl, Barrie, Rostand) and describe a bird's body. The
names proposed above for 10 and 35 continue the theme. The full set of unusual birds, each extreme on a
different interpretable dimension:

| Case | Name | Extreme on | Named by |
|---|---|---|---|
| 283 | Cyrano | bill shape: most slender, for a Chinstrap | Thompson |
| 10 | (Hook Nose → Socrates?) | bill shape: most stubby, of all 333 | Friendly |
| 124 | The BFG | flipper length: longest Adelie; looks like a Gentoo in 2D | Thompson |
| 35 | (Falstaff?) | stoutness: stoutest, of all 333 | — |
| 304 | Tinkerbell | stoutness: least stout, and the lightest, of all 333 | Thompson |
| 166 | Average Joe | nothing (the control) | Thompson |

The pairs work: Cyrano and Socrates are the long nose and the snub nose; Falstaff and Tinkerbell are the
stoutest and the slightest.

### A blog post: "Palmer Penguins Cry Out: 'Call me by my name'"

Material for a post:

**Intro / framing**

It could start with a conversation or block quote, then explained among pengiuns: "Hey Bro, have you noticed that all these scientists
measured us up the wazoo, published papers, and our data is now famous and used for statistics and data
graphics? They don't even know our names, even with those tags on our flippers."

Could also say, "Why didn't they bother to give us the Big Five personality scales? Those orange
Adelies are often narcasistic extroverts, not very open to experience."

1. Thompson's poster, and how naming points makes a plot memorable.
  --> This was the impetus for me to think about a more general mechanism for labeling "interesting" points
  in plots done with `ggplots`, which was very nicely done throughout the `car` package.
  --> `heplots::noteworthy() --> attempts at `stat_noteworthy()`, still not as general as `car`, for the 
  wide variety of plots it works with.
  
2. How 2D views pick out some birds and miss others: the BFG looks like a Gentoo in her plot, but the book's
   D² ignoring species ranks him 89th. Within species he ranks 3rd.
3. The vignettes' variables (bill size and shape, body size and stoutness) show what makes each bird
   unusual, and whether its name fits. Hook Nose doesn't, which motivates the renaming.
4. The table above: one bird per extreme.

Figures (`penguin-names-figs.R`, in `figs/`):

- `names-thompson-view.png`: Thompson's view (flipper length vs bill length, point size for body mass), with
  all six birds labeled. The BFG sits among the Gentoos; Socrates and Falstaff look unremarkable here.
- `names-shape-stoutness.png`: bill shape against stoutness, as z-scores within species, with 68% and 95%
  ellipses. Each named bird lands at a different extreme: Cyrano to the right (and up), Socrates to the left,
  Falstaff at the top, Tinkerbell at the bottom, the BFG in the slender, lean corner, Average Joe at the center.

A caveat that shows in the second figure: within species, 10 is the second stubbiest bird, not the
first. That is a Gentoo male, case 183 (bill 44.4 × 17.3 mm, z = −3.93, against −3.43 for case 10). Case 10
has the lowest raw L / D (1.64) because Adelies have stubby bills to begin with. Case 183 is a candidate for
another name.

## Where the names appear, if they change

Book:

- `04-multivariate_plots.qmd:1815-1820`: introduces Cyrano and Hook Nose ("very short and curved bill"),
  with the Cyrano footnote.
- `04-multivariate_plots.qmd:3168` and `child/04-grand-tour.qmd:454`: Cyrano in the grand tour (no change).
- `05-pca-biplot.qmd:2339-2342`: Cyrano's "exceptionally long, straight bill"; case 10 "with a highly
  curved beak"; case 35 heavy with short flippers.
- `14-infl-robust.qmd:494`, `:621-622` (`name = c("HookNose", "Cyrano")`), `:636` ("Hook Nose (10) gets a weight of
  0.13").
- `R/penguin/peng-manova.R:159-160, 179-180` (`name = c("HookNose", "Cyrano")`).

Talk (`talks/Vis-MLM-talk.pptx` and `Vis-MLM-talk4.pptx`): the multivariate-outliers and smallest-dimensions
slides (labels and notes), and the influence and robust-MLM slides ("Hook Nose, an Adélie…",
"Hook Nose gets 0.13"). Slide numbers have changed since 2026-10-16; search the decks for "Hook".

If 35 gets a name, it could be added where the three are introduced (Ch 4) and in Ch 5, where the
biplot of dimensions 3-4 already explains him.
