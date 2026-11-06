# Numerical Solutions to Partial Differential Equations

LaTeX source for the textbook by Brennan Sprinkle and Rachel Bertaud.

## Build

```bash
latexmk main.tex
```

Output is `main.pdf`. Run `latexmk -c` to clean up auxiliary files.

The same setup compiles on Overleaf with no extra configuration.

Output will be a very large file when originally compiled. Stripping it is possible in Adobe Acrobat through following pipeline:
```
Tools>Redact a PDF>Sanitize PDF
```
## Layout

- `main.tex` — main file (title info and chapter includes)
- `tstextbook.cls` — document class (styling)
- `bibliography.bib` — references
- Each chapter lives in its own folder (e.g. `Plots/text.tex`) with its images alongside
