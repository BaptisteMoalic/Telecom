#
# Use this Makefile with GNU make.
#
TOP ?= maprene-xxi-presentation.pdf
TOP_NAME = $(patsubst %.pdf,%,$(TOP))
EXT = pdf log aux out bbl blg toc snm nav fdb_latexmk fls

STYS       = $(wildcard texinputs/*.sty)

FIGS       = $(wildcard figs/*.fig)
FIGS_PDF   = $(patsubst %.fig,%.pdftex,$(FIGS))
FIGS_PDF_T = $(patsubst %.fig,%.pdftex_t,$(FIGS))

SVGS       = $(wildcard svgs/*.svg)
SVGS_PDF   = $(patsubst %.svg,%.pdf,$(SVGS))

ODGS       = $(wildcard odgs/*.odg)
ODGS_PDF   = $(patsubst %.odg,%.pdf,$(ODGS))
FODGS       = $(wildcard odgs/*.fodg)
FODGS_PDF   = $(patsubst %.fodg,%.pdf,$(FODGS))

PPMS       = $(wildcard bitmap/*.ppm)
PPMS_PNG   = $(patsubst %.ppm,%.png,$(PPMS))


NEEDED_PDF = $(FIGS_PDF) $(FIGS_PDF_T) $(SVGS_PDF) $(ODGS_PDF) $(FODGS_PDF)

export TEXINPUTS := ./texinputs/:$(TEXINPUTS)

#.SECONDARY: $(FIGS_PDF)

.PHONY: all clean dep preview

all: $(TOP)

$(TOP) : dep

dep: $(NEEDED_PDF) $(PPMS_PNG)

%.pdf:%.tex $(STYS)
	@echo "LaTeX search path $(TEXINPUTS)"
	@latexmk -pdf $<

preview: dep
	pdflatex  '$(PREVIEW_OPTS) \input{$(TOP_NAME).tex}'

clean:
	@echo Cleaning $(TOP) and $(NEEDED_PDF)
	@$(foreach file,$(TOP_NAME) texput,$(foreach ext,$(EXT),[ -e $(file).$(ext) ] && rm -f $(file).$(ext) || true;))
	@rm -f $(NEEDED_PDF)


%.pdftex:%.fig
	fig2dev -L pdftex $< $@
%.pdftex_t:%.pdftex
	fig2dev -L pdftex_t -p $< $(patsubst %.pdftex_t,%.fig,$@) $@

%.swf:%.pdf
	pdf2swf $< && chmod -x $@

%.pdf:%.svg
	inkscape -f $< --export-pdf=$@

%.pdf:%.odg
	libreoffice --headless --convert-to pdf $< --outdir odgs
	pdfcrop --margins 1 $@ $@

%.pdf:%.fodg
	libreoffice --headless --convert-to pdf $< --outdir odgs
	pdfcrop --margins 1 $@ $@

%.png:%.ppm
	convert $< $@