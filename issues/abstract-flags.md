# Abstract Flags — Items for Author Review

Drafting decisions in `chapter-abstracts.md` worth a second look from Michael (Step 7 of `abstract-plan.md`). Add to this file as later batches raise new items; delete items once resolved.

## Chapters 1-3 (drafted 2026-07-06)

- Nothing worth flagging

## Chapters 4–6 (drafted 2026-07-07)

- **Ch 6: no R package name in the abstract** — the Step 5 checklist wants "R" plus at least one package name in every abstract, but Ch 6 features no package prominently (ggplot2, dplyr, nestedLogit play bit parts). The abstract uses lm() and glm() as the search terms instead, which matches how people search for this material; for strict compliance, "nestedLogit" could be added to the nested-dichotomies sentence.
- **Ch 6 is thinner than its neighbors** — the Regression / ANOVA / ANCOVA sections of `06-linear_models.qmd` are commented out in the source, so the abstract covers only what is actually there (GLM framework, model formulas, model matrices, contrast coding). If those sections are written before the metadata goes to CRC, revisit this abstract.

## Chapters 7–9 (drafted 2026-07-07)

- **Ch 8: "Scheffe" written without the accent** — the plan's no-special-characters rule for metadata systems; confirm CRC's systems can't handle "Scheffé", otherwise restore it.
- **Ch 9: "Where's Waldo" motif kept** — distinctive, searchable phrasing tied to the Friendly & Kwan (2009) framing; drop if it reads as too informal for publisher metadata.
- **Ch 7: closing sentence states that Duncan's equal-slopes conclusion is overturned** by the two influential cases — check this is the emphasis wanted, since the chapter frames it as a diagnostic lesson rather than a substantive claim about the sociology.
- **Ch 9: datasets described, not named** — "gas mileage ... automobile size and power" instead of the `cars` dataset (name too generic to help search); "Longley's classic collinear economic time series" does name Longley. Confirm this trade-off.

## Chapters 10–12 (drafted 2026-07-07)

- **Ch 10: "T-squared (T^2)" plain-text fallback** — per the plan's no-special-characters rule; same question as the Ch 8 Scheffe flag — if CRC's metadata systems handle Unicode, "T²" would read better.
- **Ch 11: only two of eight datasets named** — the chapter uses dogfood, Parenting, AddHealth, Plastic, MockJury, NLSY, schooldata, and Rohwer; the abstract names only NLSY and Rohwer (the most searchable) to stay within the word limit. Swap in others if different emphasis is wanted.
- **Ch 12: "iris data" named prominently** — the chapter's own History Corner discusses the eugenics controversy around this dataset; it is kept in the abstract because it is a top search term for discriminant analysis, but confirm you want it as the flagship example in publisher metadata.
- **Ch 11 vs Ch 12 overlap** — both abstracts mention MANOVA, MMRA, MANCOVA, and the Rohwer paired-associate data, since the chapters share examples. Ch 11 is framed around model theory/testing and Ch 12 around HE-plot visualization so they rank for different queries, but check they read as distinct.
- **Ch 10: banknote data described, not named** — "genuine from counterfeit Swiss banknotes" rather than `mclust::banknote` (the descriptive phrase is what people search); `mathscore` is named even though the data are fictitious.

## Chapters 13–15 (drafted 2026-07-07)

- **Ch 15 heading is "Chapter 15" for `21-discrim.qmd`** — per `_quarto.yml`, where `15-case-studies.qmd` is commented out of the chapter list (it becomes the HTML-only Appendix). Confirm this matches the final rendered numbering CRC will see, and decide whether the Appendix (Case Studies) gets its own abstract — that open question from `abstract-plan.md` is still unresolved.
- **Ch 15: "flipped MANOVA" phrase kept** — the chapter's own coinage for the LDA/MANOVA relationship; distinctive and memorable, but drop if too informal for publisher metadata.
- **Ch 14: "the mysterious Case 9" motif kept** — mirrors the chapter's section title "The Mysterious Case 9"; same informality question as the Ch 9 "Where's Waldo" flag.
- **Ch 14: no R function named for robust estimation** — the abstract says M-estimation is "implemented in the heplots package" without naming `robmlm()`; add the function name if function-level search terms are wanted (the plan's Step 2 mentions function-level concepts as searchable).
- **Ch 13: "Box's M" written without the script M** — the chapter typesets it as $\mathcal{M}$; plain "Box's M test" is used per the no-special-characters rule and matches how people actually search.
- **Ch 13: Friendly & Sigal (2018) framing uncredited** — the chapter follows that paper closely, but the plan's no-citations rule keeps it out of the abstract. Fine for metadata; noted in case you want the paper's vocabulary checked against the abstract.

## Appendix — Case Studies (drafted 2026-07-07, in `abstract-case-studies.md`)

- **Kept in a separate file** (`issues/abstract-case-studies.md`) per Michael's instruction, since the plan's open question — does the HTML-only Appendix get an abstract in the CRC metadata at all? — is still unresolved. If yes, move the abstract into `chapter-abstracts.md` (heading "Appendix", after Chapter 15) before regenerating the `.docx`; the word-count script only checks `chapter-abstracts.md`, so it will pick the abstract up automatically once merged (169 words as drafted).
- **Heading labeled "Appendix"** with no letter — the user's request called it "Appendix A", but nothing in `_quarto.yml` or the chapter source assigns a letter (it is the book's only appendix). Add "A" to the heading if CRC's metadata uses lettered appendix labels.
- **Hartman dissertation uncredited** — the case study is Laura Hartman's (2016) York University Ph.D. research, but the plan's no-citations rule keeps names out; the study is described generically as "a clinical study". Confirm this is acceptable, or whether CRC metadata should credit the source.
- **Clinical terms named plainly** — "schizophrenia" and "schizoaffective disorder" are used as search keywords, since practitioners searching for MANOVA examples in clinical psychology will use them; confirm you are comfortable with the diagnostic terms in publisher metadata.
- **Only the NeuroCog example's methods enumerated in full** — the SocialCog analysis contributes the outlier/model-checking story (the chapter's own punchline); its four measures (managing emotions, theory of mind, externalizing bias, personalizing bias) are omitted for the word limit.
