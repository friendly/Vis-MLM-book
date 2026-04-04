# GitHub & Quarto Skills for Yibo

Skills and practice tasks for working on the *Visualizing Multivariate Data and Models in R*
book project. Work through these roughly in order — each stage builds on the previous one.

See the section **Handy References** at the end, but https://happygitwithr.com is your best source to get started.

This document is written in simple markdown, which is a good way to communicate on project work.
(In RStudio, the Render button can convert it to HTML, PDF, ...)

---

## Stage 1 — Git & GitHub basics (do this on your own practice repos)

Before touching the book repository, get comfortable with the Git workflow on a low-stakes
sandbox of your own.

**Skills to develop:**

- Create a GitHub account. Your userid here will be your GitHub "home", and you can use it for all your work, beyond what you do with me, so choose something wisely.
- On your local machine, configure Git with your name and email
- Understand the core Git concepts: repository, commit, push, pull, clone
- Know the everyday cycle: *pull → edit → stage → commit → push*
- Read a commit history and understand what each commit changed

**Practice tasks:**

1. Create a new **public** GitHub repository called `git-practice` (add a README when prompted).
2. Clone it to your laptop using RStudio: *File → New Project → Version Control → Git*.
3. Edit the README (add a sentence about yourself), then commit and push from the RStudio Git pane, or use the terminal panel to issue git commands, e.g.,

```
git add .
git commit "added a photo of me"
git push
```

4. Make three more small commits (add a file, change it, delete it) so you can see a real history
   on GitHub.
5. On GitHub, click on a commit to read the diff — get comfortable reading what changed.

**Personal repo**

GitHub has the convention that your landing page, e.g., `https://github.com/{userid}` can be customized by creating a project repo with that name.
E.g., mine is https://github.com/friendly, and the source for this is in an RStudio project, `C:\R\projects\friendly`.
This is an easy way to organize your work and advertise yourself.

Practice your GitHub skills by creating your own.


---

## Stage 2 — Branching and pull requests

The book repo, https://github.com/friendly/Vis-MLM-book/ uses branches to keep in-progress work separate from the stable main copy on the `master` branch.
This is the single most important workflow habit to build.

**Skills to develop:**

- Create and switch between branches
- Understand why branches exist (parallel work, review before merging)
- Open a pull request (PR) on GitHub and read/respond to review comments
- Merge a PR and delete the branch afterwards

**Practice tasks:**

1. In your `git-practice` repo, create a branch called `add-notes` (in RStudio: Git pane →
   the branch button, top right).
2. Add a new file `notes.md` with a few lines, commit it on that branch, and push.
3. On GitHub, open a pull request from `add-notes` → `main`. Write a short description.
4. Merge the PR on GitHub, then back in RStudio pull `main` and confirm the file is there.
5. Delete the `add-notes` branch both on GitHub and locally.

---

## Stage 3 — Collaborating on an existing repo (the book project)

Once the above feels natural, you're ready to work on the actual book repository.

**Skills to develop:**

- Clone a repo you've been given access to
- Always pull before starting work (avoid merge conflicts)
- Work on a branch named for your task, never directly on `master`
- Write clear, descriptive commit messages
- Recognize and resolve a simple merge conflict

**Practice tasks:**

1. Accept the GitHub collaborator invitation for the book repo and clone it.
2. Before any editing session, always do: Git pane → Pull (blue down-arrow).
3. Create a branch named something like `yibo/fix-typos-ch02` for a specific task.
4. Make a small edit (fix a typo or add a comment) in one `.qmd` file, commit, and push.
5. Open a PR for review — don't merge it yourself until it has been reviewed.

**Commit message conventions to follow:**

- Start with a verb: *Fix*, *Add*, *Update*, *Remove*
- Be specific: `Fix typo in Chapter 3 intro` not `edits`
- One logical change per commit — don't bundle unrelated edits

---

## Stage 4 — Quarto book basics

**Skills to develop:**

- Understand the role of `_quarto.yml` (book structure, chapter order, output settings)
- Know how `.qmd` files are structured (YAML header, markdown, code chunks)
- Render the book locally: `quarto render` in the Terminal, or the Render button in RStudio
- Understand chunk options: `echo`, `warning`, `fig-cap`, `label`, cross-references (`@fig-`, `@tbl-`)
- Know where rendered output goes (`docs/` or `_book/`) and that these files are not hand-edited

**Practice tasks:**

1. Open `_quarto.yml` and read the chapter list — find where a chapter you've been assigned sits.
2. Open one chapter `.qmd` and render just that file (*Render* button in RStudio) to see the HTML.
3. Add a simple code chunk to your practice file with a `label` and `fig-cap`, render, and check
   the caption appears.
4. Render the whole book from the Terminal (`quarto render`) and browse the output.

---

## Handy references

- [Happy Git and GitHub for the useR](https://happygitwithr.com) — the best practical intro,
  written for R users (free online)
- [Quarto documentation](https://quarto.org/docs/books/) — books section especially
- [Pro Git book](https://git-scm.com/book/en/v2), chapters 1–3 — deeper background if needed

---

## Summary checklist

| Skill | Done? |
|---|---|
| GitHub account + Git configured | |
| Clone, commit, push (own repo) | |
| Branch, PR, merge (own repo) | |
| Clone book repo, pull before editing | |
| Work on a branch, open PR for review | |
| Render a single `.qmd` file locally | |
| Render the full book locally | |
