
files <- list.files(".", "*.qmd") |> print()

misword <- spelling::spell_check_files(files)


