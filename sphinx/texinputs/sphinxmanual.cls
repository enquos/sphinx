%
% sphinxmanual.cls for Sphinx (http://sphinx-doc.org/)
%

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{sphinxmanual}[2016/10/12 v1.5 Document class (Sphinx manual)]

\ifx\directlua\undefined\else
% if compiling with lualatex 0.85 or later load compatibility patch issued by
% the LaTeX team for older packages relying on \pdf<name> named primitives.
    \IfFileExists{luatex85.sty}{\RequirePackage{luatex85}}{}
\fi

% chapters starting at odd pages (overridden by 'openany' document option)
\PassOptionsToClass{openright}{\sphinxdocclass}

% 'oneside' option overriding the 'twoside' default
\newif\if@oneside
\DeclareOption{oneside}{\@onesidetrue}
% Pass remaining document options to the parent class.
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{\sphinxdocclass}}
\ProcessOptions\relax

% Defaults two-side document
\if@oneside
% nothing to do (oneside is the default)
\else
\PassOptionsToClass{twoside}{\sphinxdocclass}
\fi

\LoadClass{\sphinxdocclass}

% Set some sane defaults for section numbering depth and TOC depth.  You can
% reset these counters in your preamble.
%
\setcounter{secnumdepth}{2}
\setcounter{tocdepth}{1}

% Change the title page to look a bit better, and fit in with the fncychap
% ``Bjarne'' style a bit better.
%
\renewcommand{\maketitle}{%
  \let\spx@tempa\relax
  \ifHy@pageanchor\def\spx@tempa{\Hy@pageanchortrue}\fi
  \hypersetup{pageanchor=false}% avoid duplicate destination warnings
  \begin{titlepage}%
    \let\footnotesize\small
    \let\footnoterule\relax
    \noindent\rule{\textwidth}{1pt}\ifsphinxpdfoutput\newline\null\fi\par
    \ifsphinxpdfoutput
      \begingroup
      % These \defs are required to deal with multi-line authors; it
      % changes \\ to ', ' (comma-space), making it pass muster for
      % generating document info in the PDF file.
      \def\\{, }%
      \def\and{and }%
      \pdfinfo{
        /Author (\@author)
        /Title (\@title)
      }%
      \endgroup
    \fi
    \begin{flushright}%
      \sphinxlogo
      \py@HeaderFamily
      {\Huge \@title \par}
      {\itshape\LARGE \py@release\releaseinfo \par}
      \vfill
      {\LARGE
        \begin{tabular}[t]{c}
          \@author
        \end{tabular}
        \par}
      \vfill\vfill
      {\large
       \@date \par
       \vfill
       \py@authoraddress \par
      }%
    \end{flushright}%\par
    \@thanks
  \end{titlepage}%
  \setcounter{footnote}{0}%
  \let\thanks\relax\let\maketitle\relax
  %\gdef\@thanks{}\gdef\@author{}\gdef\@title{}
  \if@openright\cleardoublepage\else\clearpage\fi
  \spx@tempa
}

\newcommand{\sphinxtableofcontents}{%
  \pagenumbering{roman}%
  \pagestyle{plain}%
  \begingroup
    \parskip \z@skip
    \tableofcontents
  \endgroup
  % before resetting page counter, let's do the right thing.
  \if@openright\cleardoublepage\else\clearpage\fi
  \pagenumbering{arabic}%
  \ifdefined\fancyhf\pagestyle{normal}\fi
}

% This is needed to get the width of the section # area wide enough in the
% library reference.  Doing it here keeps it the same for all the manuals.
%
\renewcommand*\l@section{\@dottedtocline{1}{1.5em}{2.6em}}
\renewcommand*\l@subsection{\@dottedtocline{2}{4.1em}{3.5em}}

% Fix the bibliography environment to add an entry to the Table of
% Contents.
% For a report document class this environment is a chapter.
%
% Note: \phantomsection is required for TeXLive 2009
% http://tex.stackexchange.com/questions/44088/when-do-i-need-to-invoke-phantomsection#comment166081_44091
\newenvironment{sphinxthebibliography}[1]{%
  \if@openright\cleardoublepage\else\clearpage\fi
  \phantomsection
  \begin{thebibliography}{1}%
  \addcontentsline{toc}{chapter}{\bibname}}{\end{thebibliography}}

% Same for the indices.
% The memoir class already does this, so we don't duplicate it in that case.
%
\@ifclassloaded{memoir}
 {\newenvironment{sphinxtheindex}{\begin{theindex}}{\end{theindex}}}
 {\newenvironment{sphinxtheindex}{%
    \if@openright\cleardoublepage\else\clearpage\fi
    \phantomsection
    \begin{theindex}%
    \addcontentsline{toc}{chapter}{\indexname}}{\end{theindex}}}
