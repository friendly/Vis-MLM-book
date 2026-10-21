# Moving the talks out of the public book repo

Notes written 2026-10-21. Nothing here has been done yet.

**Goal:** the working material in `talks/` should no longer be visible in the public book repo (`friendly/Vis-MLM-book`). A new public repo, `friendly/Vis-MLM-talks`, holds only the finished slides (`.pptx`) and a PDF of each, so a stable link can go on the slides, in the book, on the blog, etc.

## Where things stand

- `friendly/Vis-MLM-book` is **public**, and `talks/` has been in it since 2024-02-29 (commit `5133fa64`): 75 commits touch it, 53 of them commit a `.pptx`.

- `talks/` is about 48 MB on disk (the current deck is 32 MB). Every version of every file is still in the git history, about 1.3 GB in all, which is most of the repo's 1.36 GB on GitHub.

- The R scripts in `talks/R/` and `talks/styles/peng-dark-figs.R` are run from the book's project root and `source("R/penguin/penguin-colors.R")`. So the working material is easiest to keep *inside* the book's project folder, not in a separate project.

- `.gitignore` already has `~$.*`, so PowerPoint lock files never get committed.

## Plan: three pieces

1. **Public `Vis-MLM-talks`**: only the slides and PDFs, plus a README.

2. **Private `Vis-MLM-talks-work`**: everything now in `talks/` (notes, scripts, images, styles, the working deck), with its history.

3. **Book repo**: stop tracking `talks/`, and optionally purge it from the history.

### 1. The public repo, `friendly/Vis-MLM-talks`

Suggested layout, one folder per talk:

```
Vis-MLM-talks/
  README.md                    # list of talks: date, venue, title, links to PDF and PPTX
  2026-11-Utrecht/
    Vis-MLM-Utrecht-2026.pdf
    Vis-MLM-Utrecht-2026.pptx
```

- Create it with `gh repo create friendly/Vis-MLM-talks --public --description "Slides for talks on Visualizing Multivariate Data and Models in R"`, then clone it somewhere outside the book project, e.g. `C:\R\Projects\Vis-MLM-talks`.

- **Link to put on the slides:** `https://github.com/friendly/Vis-MLM-talks`. Short, and it doesn't break when files are renamed or a new talk is added. Direct file links also work, e.g. `https://github.com/friendly/Vis-MLM-talks/blob/main/2026-11-Utrecht/Vis-MLM-Utrecht-2026.pdf` (GitHub shows PDFs in the browser).

- Optional: turn on GitHub Pages for the repo to get `https://friendly.github.io/Vis-MLM-talks/` with a simple index page. Not needed for a start.

- **Large files.** GitHub refuses files over 100 MB and warns over 50 MB; the deck is 32 MB, so it's fine, but every update adds another full copy to the history. Two ways to keep the public repo small:

  - Commit the PDF and PPTX only for the *final* version of each talk (once, after the talk is given, or once just before it), not every draft. This is the simplest.

  - Or attach them to a **GitHub Release** instead of committing them (`gh release create utrecht-2026 Vis-MLM-Utrecht-2026.pdf Vis-MLM-Utrecht-2026.pptx --title "Utrecht, 6 Nov 2026"`). Release files don't bloat the git history, and can be replaced with `gh release upload --clobber`. The link would be `https://github.com/friendly/Vis-MLM-talks/releases`.

- **Making the PDF.** In PowerPoint: File > Export > Create PDF/XPS, Options: leave "Include hidden slides" off (so the backup slides 65-81 are left out); include speaker notes or not, as wanted. Or via COM, with PowerPoint closed:

  ```powershell
  $app  = New-Object -ComObject PowerPoint.Application
  $pres = $app.Presentations.Open("C:\R\Projects\Vis-MLM-book\talks\Vis-MLM-talk4.pptx", $true, $false, $false)
  # 2 = ppFixedFormatTypePDF, 2 = ppFixedFormatIntentPrint; hidden slides not printed by default
  $pres.ExportAsFixedFormat("C:\R\Projects\Vis-MLM-talks\2026-11-Utrecht\Vis-MLM-Utrecht-2026.pdf", 2, 2)
  $pres.Close(); $app.Quit()
  ```

  The PDF shows only the first frame of the animated GIFs (pollen, grand tour, PCA by springs, PCA to t-SNE, the measurement-error GIFs) and the final state of click animations such as slide 19. Possibly add a line on those slides' notes, or a link from the README to the book's HTML version where the animations play.

- **The public PPTX** should probably be a copy with the hidden backup slides deleted and speaker notes either kept or stripped (decide: the notes are useful to others, but are written as private cues). The `.pptx` still has the backup slides otherwise, which is harmless but larger.

### 2. The private working repo

Keep `talks/` where it is on disk (so the R scripts still run from the book root), but make it its own git repo, ignored by the book repo.

**Keeping the history** (recommended): extract `talks/` with its history from the book repo, using `git filter-repo` (`pip install git-filter-repo`), in a throw-away clone:

```bash
git clone https://github.com/friendly/Vis-MLM-book.git /c/tmp/talks-extract
cd /c/tmp/talks-extract
git filter-repo --subdirectory-filter talks     # keeps only talks/, moved to the top level
gh repo create friendly/Vis-MLM-talks-work --private --source . --push
```

That history includes all 53 versions of the decks (about 1.3 GB), which GitHub will accept for a private repo but is slow to clone. To keep the history of the notes and scripts but drop the old decks, add `--strip-blobs-bigger-than 20M` to the `filter-repo` call. That removes *every* version of the large files, the current deck included, so copy the current `.pptx` back in and commit it afterwards. Or start the private repo from scratch (`git init` in `talks/`, one commit) and rely on the book repo's history up to the move for anything older.

**Then put it in place**, on each machine (desktop and laptop):

1. In the book repo: add `talks/` to `.gitignore`, then `git rm -r --cached talks` and commit ("Move talks/ to a private repo"). The files stay on disk.

2. In `talks/`: `git init`, `git remote add origin https://github.com/friendly/Vis-MLM-talks-work.git`, `git fetch`, `git reset origin/main` (or `master`) so the working files line up with the extracted history without being overwritten. Check `git status` shows nothing unexpected.

3. On the other machine: after pulling the book repo, `talks/` will be *deleted* by the pull (git removes files that the commit stops tracking, unless they're modified locally). Simplest: on that machine, clone the private repo into `talks/` after pulling: `git clone https://github.com/friendly/Vis-MLM-talks-work.git talks`.

RStudio's Git pane will show only the book repo; the nested `talks/` repo needs the command line or a separate RStudio project (`talks/talks.Rproj`; but then set the working directory to the book root when running the R scripts, or change them to use `here::here()`, whose root is the book because of `Vis-MLM-book.Rproj`).

**Alternative without a second private repo:** move `talks/` to Dropbox (e.g. `C:\Dropbox\R\talks\Vis-MLM`), which syncs between machines. Simpler, but loses version history going forward and the R scripts' `source("R/penguin/...")` paths would need changing.

### 3. Removing `talks/` from the book repo's history (optional)

Step 2 stops tracking `talks/` from now on, but everything up to that commit is still public in the history (old commits, `git log -- talks`, GitHub's file browser at old SHAs). If that matters, rewrite the history:

```bash
# in a fresh clone of Vis-MLM-book, after step 2 is committed and pushed
git filter-repo --path talks --invert-paths
git remote add origin https://github.com/friendly/Vis-MLM-book.git   # filter-repo removes the remote
git push --force --all && git push --force --tags
```

Consequences, all worth weighing first:

- **Every commit SHA changes.** All existing clones (desktop, laptop, anyone who forked) must be re-cloned, not pulled. Any SHAs written in notes (e.g. `talk4-notes.md`, `issues/*.md`, memory files) stop pointing anywhere.

- The repo shrinks from about 1.36 GB to well under 100 MB, which makes clones much faster: the main practical benefit.

- GitHub keeps the old objects reachable for a while (cached views, PR refs); a fully clean purge needs a request to GitHub Support. Forks keep the old history.

- `docs/` (GitHub Pages) is unaffected apart from a rebuild after the force push.

- Do it when both machines are in sync and nothing is uncommitted; run a `git fsck` and a book render afterwards.

If the talks material is only mildly sensitive (it's slides and notes for a public talk), steps 1-2 are probably enough, and step 3 can be done later, mainly for the size reduction.

## Order of work

1. Create the public `Vis-MLM-talks` repo with a README; add the Utrecht PDF/PPTX once the deck is final, and put its URL on the title or closing slide (slide 63, "Book, code and packages", is the natural place).

2. Extract `talks/` to the private `Vis-MLM-talks-work` repo; untrack `talks/` in the book repo; set it up on both machines.

3. Decide later on purging the book repo's history.

## Loose ends

- `talks/README.md` and `talk4-notes.md` refer to "the git history" for deleted decks (talk3, the original 70-slide deck). After the move, that means the private repo's history (if extracted with history) or the book repo's history before the move (gone if step 3 is done).

- The book's `CLAUDE.md` doesn't mention `talks/`; add a line pointing to the two new repos, so future sessions know where the talks went.

- `docs/` does not link to anything in `talks/` (checked 2026-10-21), so the book site is unaffected.
