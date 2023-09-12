# Quarto book examples

## E. Tanaka

## Banana-book

## Rohan Alexander, [Telling Stories with Data](https://github.com/RohanAlexander/telling_stories)

- Uses Quarto, but just the `engine: knitr`. 

      ---
      engine: knitr
      ---

- Book: https://tellingstorieswithdata.com/, hosted at  rohanalexander.github.io/telling_stories/ 
  via docs/
- HTML/PDF output
- Latex customization, good \index

      format:
        html:
          theme: 
            - cosmo
            - custom.scss
          callout-appearance: simple
        pdf:
          documentclass: krantz
          include-in-header: latex/preamble.tex
          include-before-body: latex/before_body.tex
          include-after-body: latex/after_body.tex
          keep-tex: true
          callout-appearance: simple

    
    
- CRC press: krantz.cls
- Conditional text for html vs pdf
      ::: {.content-visible when-format="pdf"}
      :::
      
      ::: {.content-visible unless-format="pdf"}
      :::


