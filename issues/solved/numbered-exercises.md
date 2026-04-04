# How to create numbered excercises at the end of chapters?

In a book written as .Rnw, I defined exercises as a new form of a list environment, used
as `\begin{Exercises}` ... `\end{Exercises}` with each exercise introduced as an `\exercise` item.
Below it the LaTeX code and an example.

The importrant thing is that these are automatically numbered within each chapter, and they can be referenced.

How can I do something similar in Quarto?

**LaTeX code**

````
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define new list type for exercises
% from: http://tex.stackexchange.com/questions/196199/exercise-list-using-enumitem-how-control-indentation-and-labeling-of-sublists
% by: Daniel Wunderlich
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\usepackage{enumitem}      % this should be loaded in book.Rnw
%
\newlist{Exercises}{enumerate}{2}
% set list style parameters
\setlist[Exercises]{%
  label=\textbf{Exercise \thechapter.\arabic*}~,  % Label: Exercise Chapter.exercise
  ref=\thechapter.\arabic*, % References: Chapter.exercise (important!)
  align=left,               % Left align labels
  labelindent=0pt,          % No space betw. margin of list and label
  leftmargin=0pt,           % No space betw. margin of list and following lines
  itemindent=!,             % Indention of item computed automatically
  itemsep=3pt,
}

\newcommand{\exercise}{%
  \item\label{lab:\arabic{chapter}.\arabic{Exercisesi}}%      % Append label to item
  \setlist[enumerate, 1]{label=(\alph*),itemsep=0pt}          % Label for subexercises, but only within an exercise
}
````

**Example**
Here is an example of use:

````
\begin{Exercises}

\exercise The packages \pkg{vcd} and \pkg{vcdExtra} contain many data sets with some
examples of analysis and graphical display.  The goal of this exercise is to
familiarize yourself with these resources.

You can get a brief summary of
these using the function \func{datasets} from \pkg{vcdExtra}.  Use the following to get a list of
these with some characteristics and titles.
<<datasets>>=
ds <- datasets(package = c("vcd", "vcdExtra"))
str(ds, vec.len = 2)
@
  \begin{enumerate*}
    \item How many data sets are there altogether?  How many are there in each package?
    \item Make a tabular display of the frequencies by \code{Package} and \code{class}.
    \item Choose one or two data sets from this list, and examine their help files
    (e.g., \code{help(Arthritis)} or \code{?Arthritis}).  You can use, e.g.,
    \code{example(Arthritis)} to run the \R code for a given example.
  \end{enumerate*}

\exercise For each of the following data sets in the \Rpackage{vcdExtra}, identify which are response variable(s)
and which are explanatory. For factor variables, which are unordered (nominal) and which
should be treated as ordered? Write a sentence or two describing substantitive questions of interest for analysis
of the data. (\emph{Hint}: use 
\code{data(foo, package="vcdExtra")} to load, and \code{str(foo)}, 
  \code{help(foo)} to examine data set \code{foo}.)
  \begin{enumerate*}
    \item Abortion opinion data: \data{Abortion}
    \item Caesarian Births: \data{Caesar}
    \item Dayton Survey: \data{DaytonSurvey}
    \item Minnesota High School Graduates: \data{Hoyt}
  \end{enumerate*}

\end{Exercises}
```
