
% This work may be distributed and/or modified under the conditions of the 
% LaTeX Project Public License, either version 1.3 of this license or 
% (at your option) any later version. The latest version of this license is 
% in
%              http://www.latex-project.org/lppl.txt
%
% and version 1.3 or later is part of all distributions of LaTeX version 
% 2005/12/01 or later.
%
% This is a free LaTeX template from Typesetters.se. See tstextbook.tex 
% for an example of how to use this class.

% Uncomment these badness/fuzz lines to check extra warnings before full publish.

\hbadness=20000 \hfuzz=2000pt
\vbadness=20000 \vfuzz=2000pt

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{tstextbook}[2017/02/19 Free LaTeX text book template from Typesetters.se]
\LoadClass[11pt,onecolumn,titlepage,twoside,openany]{book}

% Language
%--------------------------------------------------------------------------
\RequirePackage[utf8]{inputenc}

% Geometry
%--------------------------------------------------------------------------
\RequirePackage[top=2.5cm,bottom=2.5cm,left=3cm,right=3cm,
                marginparwidth=1.1cm,marginparsep=2mm]{geometry}

% Fonts
%--------------------------------------------------------------------------
\RequirePackage{kpfonts}
\RequirePackage[T1]{fontenc}

% Colors
%--------------------------------------------------------------------------
\RequirePackage{xcolor}
\definecolor{tssteelblue}{RGB}{69,73,158}
\definecolor{tsorange}{RGB}{59,44,119}
\definecolor{tsorange2}{RGB}{53,30,84}
\definecolor{tsblue}{RGB}{82,110,181}
\definecolor{tsforestgreen}{RGB}{116,195,128}
\definecolor{tsyellow}{RGB}{236,210,57}
\definecolor{tsgrey}{RGB}{200,200,200}

% Graphics
%--------------------------------------------------------------------------
\RequirePackage{graphicx}
\graphicspath{{images/}}
\RequirePackage{tikz}
\RequirePackage[pages=some]{background}
\backgroundsetup{scale=1,color=black,opacity=1.0,angle=0,vshift=0.0cm,
contents={\includegraphics[width=\paperwidth]{images/NSPDE_FrontCover.png}}}

% Caption styling
%--------------------------------------------------------------------------
\usepackage[font={small,it}]{caption}

% Equation Spacing
%--------------------------------------------------------------------------
\expandafter\def\expandafter\normalsize\expandafter{%
  \normalsize  
  \setlength\abovedisplayskip{3ex}
  \setlength\belowdisplayskip{4ex}
  \setlength\abovedisplayshortskip{1.5ex}
  \setlength\belowdisplayshortskip{4ex}
}

% Header and footer styling
%--------------------------------------------------------------------------
\RequirePackage{fancyhdr}
\setlength{\headheight}{15.0pt}
\fancyhf{}
\fancyhead[LE,RO]{\bfseries\thepage}
\fancyhead[RE]{\it\sf\nouppercase{\rightmark}}
\fancyhead[LO]{\it\sf\nouppercase{\leftmark}}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}

% Section styling
%--------------------------------------------------------------------------
\RequirePackage{silence}
\WarningsOff*
\RequirePackage{sectsty}
\WarningsOn

\RequirePackage{etoolbox}
\patchcmd{\section}{\bfseries}{\bfseries\setcounter{probcounter}{1}}{}{}
\sectionfont{\sf\color{tsorange2}\sectionrule{0ex}{0pt}{-1ex}{1pt}}
\subsectionfont{\sf\color{tsorange2}\sectionrule{0ex}{0pt}{-1ex}{1pt}}

% Chapter styling
%--------------------------------------------------------------------------
\makeatletter

% Numbered chapters (with minitoc)
\renewcommand{\@makechapterhead}[1]{
  \begin{tikzpicture}[remember picture,overlay]
    \node at (current page.north west)
  {
    \begin{tikzpicture}[remember picture,overlay]
      % Background image
      \node[anchor=north west,inner sep=0pt] at (0,0)
           {\includegraphics[width=\paperwidth]{images/NSPDE_ChapterBanner.png}};
      % Chapter heading
      \draw[anchor=west, inner sep=0pt] (-0.1cm,-1.5cm) node
           [black,
            ultra thick,
            fill=tsorange!10,
            fill opacity=.6,
            inner sep=10pt]
           (0,0)
           {\parbox[t][1.6cm][t]{\paperwidth}
           {\huge\bfseries\sffamily\flushleft\thechapter. #1}};
      % Chapter contents
      \draw[anchor=west,inner sep=0pt] (8.8cm,-7cm) node
           [tsorange2,
            ultra thick,
            fill=white,
            fill opacity=.8,
            draw=tsorange,
            draw opacity=1,
            line width=1.5pt,
            rounded corners,
            inner sep=0pt]
           (0,0)
           {\hspace{1cm}\parbox[t][7.1cm][t]{11cm}
           {\vspace{-1cm}\huge\bfseries\sffamily\flushleft
            \textcolor{black}{\sffamily\hypersetup{hidelinks}\minitoc}}};
    \end{tikzpicture}
  };
\end{tikzpicture}
\vspace{7.5cm}
}

% Unnumbered chapters (without minitoc)
\renewcommand{\@makeschapterhead}[1]{
  \begin{tikzpicture}[remember picture,overlay]
    \node at (current page.north west)
  {
    \begin{tikzpicture}[remember picture,overlay]
      % Background image
      \node[anchor=north west,inner sep=0pt] at (0,0)
           {\includegraphics[width=\paperwidth]{images/NSPDE_ChapterBanner.png}};
      % Chapter heading
      \draw[anchor=west,inner sep=0pt] (-0.1cm,-1.5cm) node
           [black,
            ultra thick,
            fill=tsorange!10,
            fill opacity=.6,
            inner sep=10pt]
           (0,0)
           {\parbox[t][1.6cm][t]{\paperwidth}
           {\huge\bfseries\sffamily\flushleft #1}};
    \end{tikzpicture}
  };
\end{tikzpicture}
\vspace{9cm}
}

% Minitoc styling
%--------------------------------------------------------------------------
\RequirePackage{minitoc}
\setcounter{minitocdepth}{1}

\nomtcrule
\dominitoc[n]
\mtcsetoffset{minitoc}{0cm}
\renewcommand{\mtifont}{\large\sffamily}
\renewcommand{\mtcfont}{\small\sffamily}
\renewcommand{\mtcSfont}{\small\sffamily}
\renewcommand{\mtcSSfont}{\small\sffamily}
\renewcommand{\mtcSSSfont}{\small\sffamily}

% Table of contents styling
%--------------------------------------------------------------------------
\RequirePackage{color}
\RequirePackage{hyperref}
\hypersetup{
    colorlinks=true,    % make the links colored
    linkcolor=blue,     % color TOC links in blue
    urlcolor=blue,      % color URLs in blue
    linktoc=all,        % 'all' will create links for everything in the TOC
    citecolor=gray}     % color citations in gray

\RequirePackage{titletoc}
\setcounter{tocdepth}{1}

\titlecontents{chapter}[0cm]
{\addvspace{14pt}\large\sffamily\bfseries}
{\color{tsorange2}\contentslabel[\Large\thecontentslabel]{1.25cm}}{}
{\color{tsorange2}\normalsize\sffamily\bfseries
 \;\titlerule*[.5pc]{.}\;\thecontentspage}

\titlecontents{section}[0cm]
{\addvspace{6pt}\sffamily\bfseries}
{\contentslabel[\thecontentslabel]{1.25cm}}{}
{\color{black}\normalsize\sffamily\bfseries\hfill\thecontentspage}

\titlecontents{subsection}[0cm]
{\addvspace{-1pt}\sffamily}
{\small\contentslabel[\small\thecontentslabel]{1.25cm}}{}
{\small\sffamily\hfill\color{black}\thecontentspage}

% Front matter
%--------------------------------------------------------------------------
\newcommand{\tsbook}[4]{

\pagestyle{empty}

\def\@tstitle{#1}
\def\@tsauthor{#2}
\def\@tscoverdesign{#3}
\def\@tsyear{#4}

% Title page
%%%%% Default Option %%%%%
% \BgThispage
% \begin{center}
%   \color{black}
%   \Huge
%   \textsc{\@tstitle} \\[0.8cm]
%   \LARGE
%   \textsc{\@tsauthor} \\
% \end{center}

%%%%% Alternate Option %%%%%
\BgThispage
\null
\vfill

\pagebreak

% Copyright page
\null
\vfill
\begin{flushleft}
  \textbf{Free Textbook Template Access} \\
  \vspace{2mm}
  An unmodified version of the free template used to create this textbook 
  can be found at \href{https://www.typesetters.se/latex-textbook-template/}
                       {https://www.typesetters.se/latex-textbook-template/}. \\
  
  \vspace{7mm}                    
  \textbf{Creative Commons Licensing} \\
  \vspace{2mm}
  This work is licensed under a Creative Commons 
  Attribution-NonCommercial-ShareAlike 4.0 International License. \\
  
  \vspace{7mm}
  \begin{minipage}[t]{0.4\textwidth}
    \textbf{Cover design by \@tscoverdesign.}
  \end{minipage}\hfill
  \begin{minipage}[t]{0.4\textwidth}
  \begin{figure}[H]
  \begin{flushright}
    \vspace*{-13mm}
    \includegraphics[width=3cm]{images/CCLicense.pdf}
  \end{flushright}
  \end{figure}
  \end{minipage}
  
\end{flushleft}

% Table of contents
{\hypersetup{hidelinks} \tableofcontents}

\cleardoublepage
\pagestyle{fancy}
\thispagestyle{empty}
}

% Boxes for theorems
%--------------------------------------------------------------------------
\newenvironment{boxtheorem}
{\begin{tcolorbox}
[enhanced jigsaw,breakable,pad at break*=1mm,
 colback=black!5,colframe=tssteelblue]}
{\end{tcolorbox}}

\newenvironment{boxdefinition}
{\begin{tcolorbox}
[enhanced jigsaw,breakable,pad at break*=1mm,
 colback=tsyellow!10!white,boxrule=0pt,frame hidden,
 borderline west={1.5mm}{-2mm}{tsforestgreen}]}
{\end{tcolorbox}}

\newenvironment{boxengapps}
{\begin{tcolorbox}
[enhanced jigsaw,breakable,pad at break*=1mm,
 colback=tsyellow!10!white,boxrule=0pt,frame hidden,
 borderline west={1.5mm}{-2mm}{tsblue}]}
{\end{tcolorbox}}

\newenvironment{boxexercise}
{\begin{tcolorbox}
[enhanced jigsaw,breakable,pad at break*=1mm,
 colback=tsyellow!20,boxrule=0pt,frame hidden]}
{\end{tcolorbox}}

\newenvironment{boxproblem}
{\begin{tcolorbox}
[enhanced jigsaw,breakable,pad at break*=1mm,
 colback=tsorange!25,boxrule=0pt,frame hidden]}
{\end{tcolorbox}}

\newenvironment{boxprogramming}
{\begin{tcolorbox}
[enhanced jigsaw,breakable,pad at break*=1mm,
 colback=tsblue!10,boxrule=0pt,frame hidden]}
{\end{tcolorbox}}

\newenvironment{boxexample}
{\begin{tcolorbox}
[enhanced jigsaw,breakable,pad at break*=1mm,
 colback=tsgrey!20,boxrule=0pt,frame hidden]}
{\end{tcolorbox}}

\newenvironment{boxproof}
{\begin{tcolorbox}
[enhanced jigsaw,breakable,pad at break*=1mm,
 colback=tsgrey!20,boxrule=0pt,frame hidden,
 borderline west={1.5mm}{-2mm}{tsblue}]}
{\end{tcolorbox}}

% Styling of theorems
%--------------------------------------------------------------------------
\RequirePackage{amsthm}

\newtheoremstyle{styletheorem}
{0pt}{0pt}{\normalfont}{0pt}{\small\bf\sffamily\color{tssteelblue}}{\;}{0.25em}
{\small\sffamily\color{tssteelblue}\thmname{#1}
 \nobreakspace\thmnumber{\@ifnotempty{#1}{}\@upn{#2}}
 \thmnote{\nobreakspace\the\thm@notefont\sffamily\bfseries\color{black} (#3)}}

\newtheoremstyle{styledefinition}
{0pt}{0pt}{\normalfont}{0pt}{\small\bf\sffamily\color{black}}{\;}{0.25em}
{\small\sffamily\color{tsforestgreen}\thmname{#1}
 \nobreakspace\thmnumber{\@ifnotempty{#1}{}\@upn{#2}}
 \thmnote{\nobreakspace\the\thm@notefont\sffamily\bfseries\color{black} (#3)}}

\newtheoremstyle{styleexercise}
{0pt}{0pt}{\normalfont}{0pt}{\small\bf\sffamily\color{black}}{\;}{0.25em}
{\small\sffamily\color{black}\thmname{#1}
 \nobreakspace\thmnumber{\@ifnotempty{#1}{}\@upn{#2}}
 \thmnote{\nobreakspace\the\thm@notefont\sffamily\bfseries\color{black} (#3)}}
 
\newtheoremstyle{styleengapps}
{0pt}{0pt}{\normalfont}{0pt}{\small\bf\sffamily\color{black}}{\;}{0.25em}
{\small\sffamily\color{tsblue}\thmname{#1}
 \nobreakspace\thmnumber{\@ifnotempty{#1}{}\@upn{#2}}
 \thmnote{\nobreakspace\the\thm@notefont\sffamily\bfseries\color{black} (#3)}}

\newtheoremstyle{styleproof}
{0pt}{0pt}{\normalfont}{0pt}{\small\bf\sffamily\color{black}}{\;}{0.25em}
{\small\sffamily\color{tsblue}\thmname{#1}
 \nobreakspace\thmnumber{\@ifnotempty{#1}{}\@upn{#2}}
 \thmnote{\nobreakspace\the\thm@notefont\sffamily\bfseries\color{black} (#3)}}

\theoremstyle{styledefinition}
\newtheorem{envdefinition}{Definition}[chapter]
\theoremstyle{styleengapps}
\newtheorem*{envengapps}{Engineering Applications}
\newtheorem*{envproof}{Proof}
\theoremstyle{styletheorem}
\newtheorem{envtheorem}{Theorem}[chapter]
\newtheorem{envlemma}{Lemma}[chapter]
\theoremstyle{styleexercise}
\newtheorem{envexercise}{Exercise}[chapter]
\newtheorem{envproblem}{Problem}[chapter]
\newtheorem{envprogramming}{Computer exercise}[chapter]
\newtheorem{envexample}{Example}[chapter]

% New commands for problem numbering
%--------------------------------------------------------------------------
\newcounter{probcounter}[section]
\newcommand{\chptprob}{\textbf{P\thechapter.\arabic{probcounter}) }
    \stepcounter{probcounter}}

% Environments for theorems
%--------------------------------------------------------------------------
\newenvironment{definition}
               {\begin{boxdefinition}\begin{envdefinition}}
               {\end{envdefinition}\end{boxdefinition}}

\newenvironment{theorem}
               {\begin{boxtheorem}\begin{envtheorem}}
               {\end{envtheorem}\end{boxtheorem}}

\newenvironment{corollary}
               {\begin{boxtheorem}\begin{envtheorem}}
               {\end{envtheorem}\end{boxtheorem}}

\newenvironment{lemma}
               {\begin{boxtheorem}\begin{envlemma}}
               {\end{envlemma}\end{boxtheorem}}
               
\newenvironment{engapps}
               {\begin{boxengapps}\begin{envengapps}}
               {\end{envengapps}\end{boxengapps}}

\newenvironment{exercise}
               {\begin{boxexercise}\begin{envexercise}}
               {\end{envexercise}\end{boxexercise}}

\newenvironment{problem}
               {\begin{boxproblem}\begin{envproblem}}
               {\end{envproblem}\end{boxproblem}}

\newenvironment{programming}
               {\begin{boxprogramming}\begin{envprogramming}}
               {\end{envprogramming}\end{boxprogramming}}

\newenvironment{example}
               {\begin{boxexample}\begin{envexample}}
               {\end{envexample}\end{boxexample}}
               
\newenvironment{newproof}
               {\begin{boxproof}\begin{envproof}}
               {\end{envproof}\end{boxproof}}

% Other environments
%--------------------------------------------------------------------------
\newenvironment{summary}
{\hspace{10pt}\par\small\it
 \begin{list}{}{\leftmargin=35pt\rightmargin=25pt}
 \item\ignorespaces\advance\baselineskip -1pt}
{\end{list}\vspace{-0.5cm}}

\newenvironment{remark}
{\vspace{0.5cm}\noindent\small\it
 \marginpar{\vspace{-3mm}\includegraphics[width=1.0cm]{idea}}}
{\vspace{0.5cm}}

% Bibliography
%--------------------------------------------------------------------------
\RequirePackage[backend=biber,sorting=none]{biblatex}
\addbibresource{bibliography.bib}

% Index
%--------------------------------------------------------------------------
\RequirePackage{makeidx}
\makeindex

% Packages for mathematics and algorithms
%--------------------------------------------------------------------------
\RequirePackage{algorithm}
\RequirePackage{algpseudocode}
\RequirePackage{xfrac}
\RequirePackage{mathtools}
\RequirePackage{wasysym}
\RequirePackage{siunitx}
\newcommand\bmmax{2}
\RequirePackage{bm}

% Other useful packages
%--------------------------------------------------------------------------
\RequirePackage{blindtext}
\RequirePackage[most]{tcolorbox}
\RequirePackage{booktabs}
\RequirePackage{url}


%---------------------------------------------------------------------------
% Matlab environment - \begin{lstlisting} for long blocks and " " for inline
%--------------------------------------------------------------------------
\usepackage[numbered,framed]{matlab-prettifier}

\let\ph\mlplaceholder % shorter macro
\lstMakeShortInline"

\lstset{
  style              = Matlab-editor,
  basicstyle         = \mlttfamily,
  escapechar         = ",
  mlshowsectionrules = true,
  backgroundcolor    = \color{tsyellow!10!white},
}

%---------------------------------------------------------------------------
% New commands
%---------------------------------------------------------------------------
\newcommand{\vel}{\mathbf{v}}
\newcommand{\acc}{\mathbf{a}}
\newcommand{\vort}{\boldsymbol{\omega}}
\newcommand{\es}{\mathbf{\widehat{e}}_{s}}
\newcommand{\en}{\mathbf{\widehat{e}}_{n}}
\newcommand{\Vol}{\mathop{\ooalign{\hfil$V$\hfil\cr\kern0.08em--\hfil\cr}}\nolimits}
\newcommand{\brac}[1]{\left<\, #1 \,\right>}

%\newcommand{\grad}{\boldsymbol{\nabla}}
\newcommand{\CurlyL}{\mathscr{L}}


\newcommand{\chapterintro}{
  \vspace*{2mm}
  \noindent
  \makebox[\textwidth]{%
    \rule[0.5ex]{0.3\textwidth}{1pt}%
    \hspace{1em}%
    \textbf{Introduction}%
    \hspace{1em}%
    \rule[0.5ex]{0.3\textwidth}{1pt}%
  }
  \vspace{0mm}
}

