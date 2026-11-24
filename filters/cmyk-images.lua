--[[
cmyk-images.lua -- use CMYK copies of raster images in PDF output

CRC requires CMYK for print. The converted copies live in images-cmyk/, made by
issues/image-quality/convert-images-cmyk.R, mirroring the source paths:

  images/foo.jpg               -> images-cmyk/foo.jpg   (JPEG can hold CMYK)
  images/foo.png               -> images-cmyk/foo.pdf   (PNG can't: wrapped as PDF)
  images/foo.png  (neutral)    -> images-cmyk/foo.png   (grayscale)
  figs/ch04/bar.png            -> images-cmyk/figs/ch04/bar.pdf

For LaTeX/PDF output only, each image path is replaced by the first of
images-cmyk/<path> or images-cmyk/<path with .pdf> that exists; otherwise it
is left alone (RGB original). HTML output is never touched.

Handles pandoc Image elements (markdown images and knitr::include_graphics())
and raw LaTeX \includegraphics{...}, in case knitr emits LaTeX directly.

Wired up in _quarto.yml under format: pdf: filters:.
See issues/image-quality/cmyk-next-steps.md.
--]]

local CMYK_DIR = "images-cmyk/"

local function exists(path)
  local f = io.open(path, "rb")
  if f then f:close(); return true end
  return false
end

-- project root, to turn absolute paths (e.g. from here::here()) into relative ones
local cwd = pandoc.system.get_working_directory():gsub("\\", "/")

local cache = {}

local function cmyk_path(src)
  if cache[src] ~= nil then return cache[src] or nil end
  local rel = src:gsub("\\", "/")
  if rel:sub(1, #cwd + 1):lower() == (cwd .. "/"):lower() then
    rel = rel:sub(#cwd + 2)
  end
  rel = rel:gsub("^%./", "")
  local result = false
  if rel:match("^images/") or rel:match("^figs/") then
    local base = CMYK_DIR .. rel:gsub("^images/", "")
    local as_pdf = base:gsub("%.[^./]+$", ".pdf")
    if exists(base) then
      result = base
    elseif as_pdf ~= base and exists(as_pdf) then
      result = as_pdf
    end
  end
  cache[src] = result
  return result or nil
end

local function is_latex()
  return quarto.doc.is_format("latex") or quarto.doc.is_format("pdf")
end

local function fix_raw(el)
  if not el.format:match("latex") and not el.format:match("tex") then return nil end
  local changed = false
  local text = el.text:gsub("(\\includegraphics%s*%b[]%s*{)([^}]+)(})", function(pre, path, post)
    local new = cmyk_path(path)
    if new then changed = true; return pre .. new .. post end
  end)
  text = text:gsub("(\\includegraphics%s*{)([^}]+)(})", function(pre, path, post)
    local new = cmyk_path(path)
    if new then changed = true; return pre .. new .. post end
  end)
  if changed then el.text = text; return el end
end

if not is_latex() then return {} end

return {
  {
    Image = function(el)
      local new = cmyk_path(el.src)
      if new then el.src = new; return el end
    end,
    RawBlock = fix_raw,
    RawInline = fix_raw,
  }
}
