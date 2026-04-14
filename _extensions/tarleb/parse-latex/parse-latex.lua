--- parse-latex.lua – parse and replace raw LaTeX snippets
---
--- Copyright: © 2021–2024 Albert Krewinkel
--- License: MIT – see LICENSE for details

-- Makes sure users know if their pandoc version is too old for this
-- filter.
PANDOC_VERSION:must_be_at_least '2.9'

-- Only run this filter for HTML output. For LaTeX/PDF output the raw TeX
-- snippets must be passed through unchanged so XeLaTeX can expand them.
-- The original guard was `FORMAT:match 'latex'`, but Quarto's PDF build
-- pipeline may pass a FORMAT value that does not contain "latex" (e.g. "pdf"
-- or a Quarto-internal format), allowing the filter to run and incorrectly
-- expand custom macros like \ixd{} into multi-line \index{} calls — which
-- pandoc then wraps with %, commenting out following .\footnote{} openers.
if not FORMAT:match 'html' then
  return {}
end

-- Parse and replace raw TeX blocks, leave all other raw blocks
-- alone.
function RawBlock (raw)
  if raw.format:match 'tex' then
    return pandoc.read(raw.text, 'latex').blocks
  end
end

-- Parse and replace raw TeX inlines, leave other raw inline
-- elements alone.
function RawInline(raw)
  if raw.format:match 'tex' then
    return pandoc.utils.blocks_to_inlines(
      pandoc.read(raw.text, 'latex').blocks
    )
  end
end
