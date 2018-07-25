SVG_FILES := $(shell find . -name "*.svg")
SVG_FILES_CONVERTED := $(SVG_FILES:.svg=.eps)
PDF_FILES := $(SVG_FILES:.svg=.pdf)

TEX_FILES := $(shell find . -maxdepth 1 -name "*.tex" )
TEX_FILES_PDF := $(TEX_FILES:.tex=.pdf)

NAME_LOG_FILE := pdflatex.log

clean:
	@echo Try to remove \*.eps \*.pdf \*.nlg \*.nls \*.nlo \*.aux \*.log \*.out \*.synctex.gz
	@rm -rf $(shell find . -name "*.eps")
	@rm -rf $(shell find . -name "*.pdf")
	@rm -rf $(shell find . -name "*.aux")
	@rm -rf $(shell find . -name "*.log")
	@rm -rf $(shell find . -name "*.out")
	@rm -rf $(shell find . -name "*.nlg")
	@rm -rf $(shell find . -name "*.nls")
	@rm -rf $(shell find . -name "*.nlo")
	@rm -rf $(shell find . -name "*.synctex.gz")
	@echo Successful clean repository!


$(SVG_FILES_CONVERTED): $(SVG_FILES)
	@echo
	@echo Making file $@
	inkscape $(@:.eps=.svg) -E $@ --export-ignore-filters --export-ps-level=3
	@echo Done!

$(PDF_FILES): $(SVG_FILES)
	@echo
	@touch -c $(TEX_FILES)
	@echo Making file $@
	inkscape -D -z --file=$(@:.pdf=.svg) --export-pdf=$@
	@echo Done!

pre_build: clean
	@echo
	@echo Starting build process.

# Конвертирует все .svg в .eps
svg_conversion: $(SVG_FILES_CONVERTED)

# Конвертирует все .svg в .pfg
svg_convert_to_pdf: $(PDF_FILES)

$(TEX_FILES_PDF): $(TEX_FILES)
	@echo
	@echo Starting bulding file $@
	@echo
	@echo Starting first time build
	@echo Redirection stdout into file: $(NAME_LOG_FILE)
	@echo First time build logs > $(NAME_LOG_FILE)
	@pdflatex --shell-escape -synctex=1 -interaction=nonstopmode $(@:.pdf=.tex) >> $(NAME_LOG_FILE)
	@echo Done first step build!
	@echo
	@-makeindex -s nomencl.ist -t  $(@:.pdf=.nlg) -o  $(@:.pdf=.nls)  $(@:.pdf=.nlo)
# build for the second time to adjust all in-document references
	@echo
	@echo Starting second time build
	@echo Redirection stdout into file: $(NAME_LOG_FILE)
	@echo Second time build logs >> $(NAME_LOG_FILE)
	@pdflatex --shell-escape -synctex=1 -interaction=nonstopmode  $(@:.pdf=.tex) >> $(NAME_LOG_FILE)
	@echo Done second time build!
	@echo
	@echo You can see all output of error/warnings from pdflatex in the file with path $(shell pwd)/$(NAME_LOG_FILE)
	@echo
	@echo File $@ successful builded!

build: $(TEX_FILES_PDF)
	@echo Finished building.

all: svg_convert_to_pdf build

deps:
	apt-get install -y inkscape
	apt-get install -y texlive texlive-lang-cyrillic texlive-lang-english texlive-latex-extra cm-super
	apt-get install -y texstudio
