# Build configuration read by latexmk locally and by Overleaf.
# Usage (local):  latexmk main.tex        (build)
#                 latexmk -c              (clean aux files)
#                 latexmk -C              (clean everything incl. PDF)

# Compile with pdflatex to PDF (never DVI)
$pdf_mode = 1;

# Use biber for the bibliography (the class loads biblatex with backend=biber)
$bibtex_use = 2;

# Keep going past errors so a full log is produced; still reports failure
$pdflatex = 'pdflatex -interaction=nonstopmode -file-line-error %O %S';

# Extra generated extensions so `latexmk -c` cleans minitoc/index/biber files
$clean_ext = 'bbl bcf run.xml idx ilg ind ist maf mtc mtc0 mtc1 mtc2 mtc3 mtc4 mtc5 mtc6 mtc7 mtc8 mtc9 mtc10 mlf mlt synctex.gz';
