SHELL := /bin/bash
GHOSTSCRIPT = gs
GREP = grep
PDFLATEX = pdflatex

TARGETS = mitschrieb_stochastik uebung
TARGETS_PDF = $(TARGETS:%=%.pdf)
TARGETS_PUBLISH = $(TARGETS:%=%_publish.pdf)

STDOUT_FILTER = ".*:[0-9]*:.*\|warning"

all: $(TARGETS_PDF)

publish: $(TARGETS_PUBLISH)

%_publish.pdf: %.pdf docinfo_%.txt
	$(GHOSTSCRIPT) -sDEVICE=pdfwrite -dDOPDFMARKS=true -dMaxSubsetPct=100 -dPDFSETTINGS=/printer -dUseCIEColor=true -sOutputFile="$@" -dNOPAUSE -dBATCH $^

%.pdf: %.tex
	$(PDFLATEX) $(TEX_ARGS) -draftmode $< | $(GREP) -i $(STDOUT_FILTER)
	$(PDFLATEX) $(TEX_ARGS) $< | $(GREP) -i $(STDOUT_FILTER)

clean:
	rm --force *.{aux,log,lof,out,toc} $(TARGETS_PDF) $(TARGETS_PUBLISH)

.PHONY: all publish clean
