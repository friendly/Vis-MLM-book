.PHONY: help html pdf

BOOK_PATH = pdf/index.pdf

help:  ## Display this help screen
  @echo -e "\033[1mAvailable commands:\033[0m\n"
@grep -E '^[a-z.A-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}' | sort

html: ## quarto render .
  quarto render . --to html

pdf: 
  quarto render . --to pdf