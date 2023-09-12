# Udi RA work on book

Here are just a few topics

## Quarto

* Start to become familiar with Quarto for a book project.  Docs: https://quarto.org/docs/guide/
	There's a lot here to digest, but it will be useful to me (& to you) for you to start to learn it.

## Book outline
* Review the book outline, in `working-text/book-outline.{md,html}`

## Hosting the book

* At some point, I'd like to be able to host an in-progress version of the book somewhere to invite 
  comments / edits from others. This would be for the HTML version. Check out these possibilities
  and advise me:
  
  + Github: If the `output_dir` setting is `docs`, this can be done on github, automatically copying
    to friendly.github.io/VisMLM-quarto.
	+ netlify is another possibility, and allows me, I think, to specify a custom domain name.
    I created an account for my username 'friendly' with a team 'datavisFriendly' and can add you to it.

## Styles & organization

* I'd like to figure out better styles and organization for the quarto project, and have been looking
	at some other books for guidance. In particular on the topics of:
	+ Parts: splitting the book into parts, done in the `_quarto.yaml` file
	+ Styles:  These are controlled by one or more `.css` or `.scss` files.

* Rohan Alexander, [Telling Stories with Data](https://github.com/RohanAlexander/telling_stories)
	+ Book: https://tellingstorieswithdata.com/, hosted at  https://rohanalexander.github.io/telling_stories/ 
  via `docs/` directory on github

* Emi Tanaka has a nice book project for her edible package, https://emitanaka.org/edibble-book/, with source
  at https://github.com/emitanaka/edibble-book
  + Uses `::: {.blockquote}` divs for quotations, rather than markdown `> quotation` blocks
  + Callout notes: Uses custom icons for callouts