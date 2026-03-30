# Quarto help wanted

I'm working on a new book, [Visualizing Multivariate Data and Models in R](https://github.com/friendly/Vis-MLM-book) using Quarto
to be published by CRC Press and am running into a considerable number of problems trying to produce a LaTeX/PDF version.
I'm looking for someone I can hire on a short contract basis to help with this.

For background, I wrote a previous book [Discrete Data Analysis with R](https://www.taylorfrancis.com/books/mono/10.1201/b19022/discrete-data-analysis-michael-friendly-david-meyer);
see the [online version](http://euclid.psych.yorku.ca/www/psy6136/ClassOnly/VCDR/book2.pdf)
using `.Rnw` format, where I was able to customize the CRC Press `krantz.cls` style considerably to achieve a nice looking book, that I could supply in camera-ready format,
complete with visual tables of contents and indices for Subject, Author, Examples.

In the new book, using Quarto, I can easily produce an HTML version and publish this to a [GitHub site](https://friendly.github.io/Vis-MLM-book/),
but I can't even get a LaTeX/PDF version to build reliably. 

NB: There is a Quarto-CRC starter at: https://github.com/bgreenwell/quarto-crc

## Problems I need help with

* I'm using Windows 10, where MikTeX was always my LaTeX system. I was able to install LaTeX packages into a `localtexmf` directory and be prompted by MikTeX to install/update packages. 
  Quarto doesn't seem to support MikTeX for this purpose, but prefers `tinytex` based on the TexLive distribution. I don't know how to set this up.
  
* I have ideas for the book design in LaTeX that go beyond what is provided by the default `krantz.cls` style. These include extensive use of 
color in the text, custom section headers and callouts, ...

* HTML and PDF output: CRC Press allows me to have an online version of the book and there I can include, e.g., animated GIF images that would not be part of the printed version.
I need some help with setting things up so that some text and figures can be done differently in the HTML and PDF versions.