# Compiles the given tex files

# Tools
SHELL := /bin/bash
GHOSTSCRIPT = gs
GREP = grep
INKSCAPE = inkscape
PDFLATEX = pdflatex

# Target defs
TARGETS = mitschrieb_stochastik uebung
TARGETS_PDF = $(TARGETS:%=%.pdf)
TARGETS_PUBLISH = $(TARGETS:%=%_publish.pdf)

# SVG files to compile
SVGFILES = $(wildcard *.svg)
SVGFILES_TEX = $(SVGFILES:%.svg=%.pdf_tex)

# Command line args for tools
STDOUT_FILTER = ".*:[0-9]*:.*\|warning"
TEX_ARGS = -interaction=nonstopmode -file-line-error

# The 'normal' target
all: $(TARGETS_PDF)

# Targets for publishing (and compressing) PDF files
publish: $(TARGETS_PUBLISH)

%_publish.pdf: %.pdf docinfo_%.txt
	$(GHOSTSCRIPT) -sDEVICE=pdfwrite -dDOPDFMARKS=true -dMaxSubsetPct=100 -dPDFSETTINGS=/printer -dUseCIEColor=true -sOutputFile="$@" -dNOPAUSE -dBATCH $^

# Target, that compiles SVG files
%.pdf_tex %.pdf: %.svg
	$(INKSCAPE) -z -D --file=$< --export-pdf=$*.pdf --export-latex

# Standard TeX target
%.pdf: %.tex $(SVGFILES_TEX)
	$(PDFLATEX) $(TEX_ARGS) -draftmode $< | $(GREP) -i $(STDOUT_FILTER)
	$(PDFLATEX) $(TEX_ARGS) $< | $(GREP) -i $(STDOUT_FILTER)

# Cleanup :)
clean:
	rm --force *.{aux,log,lof,out,pdf,pdf_tex,toc}

# You should add this lineyss
.PHONY: all publish clean

# Stopping make deleting intermediate files
.SECONDARY:
