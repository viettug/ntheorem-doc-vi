DOC = ntheorem-doc-vn
SRC = ntheorem-doc-vn-src

VERSION = `gawk -F '=' '{print $$2}' $(DOC).ktvnum`

default:
	@echo x

latex:
	@latex -src-specials $(DOC)

clean:
	@clean
	@0texclean
	@rm -fv *.thm

index:
	@sed -e 's/|hyperpage//g' $(DOC).idx > $(DOC).jdx
	@makeindex -s gind.ist -o $(DOC).ind $(DOC).jdx

doc: $(DOC)

$(DOC):
	@rm -fv printctl.tex
	@latex $@
	@latex $@
	@sed -e 's/|hyperpage//g' $@.idx > $@.jdx
	@makeindex -s gind.ist -o $@.ind $@.jdx
	@latex $@
	@dvips $@.dvi -o$@.ps
	@ps2pdf $@.ps

ps:
	@dvips $(DOC).dvi

pdf:
	@ps2pdf $(DOC).ps

pdflatex:
	@pdflatex $(DOC)

dist:
	@mkdir -p {src,distro}
	@rm -fv src/*
	@rm -f distro/*$(VERSION).*
	@cp *.tex TODO README.src Makefile src/
	@zip -9r distro/$(DOC)-$(VERSION).zip \
		README FILELIST COPYING \
		$(DOC).pdf \
		test.tex \
		test.pdf \
		src/* \
		-x src/test.tex
	@unzip -t distro/$(DOC)-$(VERSION).zip

example:
	@latex test
	@latex test
	@dvips test.dvi
	@ps2pdf test.ps
