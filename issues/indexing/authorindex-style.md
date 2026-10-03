# Author Index: Letter Headings

**Issue:** The author index has no letter headings (A, B, C, …) like the subject index does.
GK asked: "Should the author index have headings for each letter (like the subject index)?"
MF: would be nice, but wasn't sure how to do it.

## How the subject index does it

`latex/book.ist` passes style directives to `makeindex`:

```
heading_prefix  "{\\bfseries\\sffamily\\fbox{ "
heading_suffix  " }\\hrulefill}\\nopagebreak\n"
headings_flag   1
```

`headings_flag 1` tells makeindex to insert letter headings automatically; the
prefix/suffix style them to match the book design (bold sans-serif boxed letter
with a rule to the right).

## Why this doesn't transfer to the author index

The author index uses a completely different pipeline:
- The `authorindex` Perl script (`latex/authorindex`) reads `index.aux` and
  writes `index.ain` (LaTeX source for the author list).
- `\printauthorindex` in `after-body.tex` simply `\input`s that `.ain` file.
- The `authorindex` package (`authorindex.sty`) has **no letter heading support**
  at all — there are no options, hooks, or style files for this.

The `.ain` file already groups entries by first letter, separated by
`\indexspace` commands (inserted by the Perl script). So the grouping is done;
it just isn't labelled.

## Two approaches

### A. Post-process the `.ain` file (recommended)

After the Perl script runs in `make-authorindex.sh`, run a Perl one-liner that:
1. Reads `index.ain`
2. After each `\indexspace`, peeks at the first letter of the next `\item[Name,...]`
3. Inserts `\ailetterheading{X}` before that entry

Then define `\ailetterheading` in `after-body.tex` to match the subject index style:

```latex
\newcommand{\ailetterheading}[1]{%
  \par\medskip
  {\bfseries\sffamily\fbox{#1}\hrulefill}\nopagebreak\par\smallskip}
```

The Perl snippet (to add to `make-authorindex.sh` after the authorindex call):

```bash
# Insert letter headings into the .ain file
perl -i -0pe '
  s/\\indexspace\n(%[^\n]*\n)*\\item\[([A-Z{])/
    my $comment = $2;
    my $letter = ($comment eq "{") ? "0-9" : $comment;
    "\\indexspace\n\\ailetterheading{$letter}\n\\item[$comment"/ge
' index.ain
```

**Pros:** Simple LaTeX, robust, runs automatically as part of `--authorindex`.
**Cons:** The `.ain` file is regenerated each time authorindex runs, but the
post-processing step is part of the same script so it always runs together.

### B. LaTeX-only (no script changes)

Redefine `\item[##1]` inside `theauthorindex` in `after-body.tex` to track the
first letter of each entry and insert a heading when it changes. Avoids
modifying `make-authorindex.sh`, but extracting the first character from a LaTeX
argument is fiddly — particularly for the `{6140 Members}` entry whose argument
starts with a brace group.

## Status

Not yet implemented. Approach A is the recommended path.
The `{6140 Members}` entry (a numerical group citation) would appear under a
"0-9" heading or similar — handle as a special case in the Perl snippet.
