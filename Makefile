RM=/bin/rm -vf

all: diss.pdf abstractpage.pdf

%.pdf: %.ps
	ps2pdf -dMaxSubsetPct=100 -dCompatibilityLevel=1.2 -dSubsetFonts=true -dEmbedAllFonts=true $<

%.ps: %.dvi
	dvips -t letter $< -o

diss.dvi: diss.tex intro.tex solarsystem.tex biblio.tex abstract.tex \
	definitions.tex masers.tex hercules.tex veldist.tex groups.tex \
	acknowledge.tex
	latex $<
	latex $<
	- bash -c " ( grep undefined $*.log && latex $< ) || echo noRerun "
	- bash -c " ( grep undefined $*.log && latex $< ) || echo noRerun "
	- bash -c " ( grep undefined $*.log && latex $< ) || echo noRerun "

abstractpage.dvi: abstractpage.tex abstract.tex
	latex $<
	latex $<
	- bash -c " ( grep undefined $*.log && latex $< ) || echo noRerun "
	- bash -c " ( grep undefined $*.log && latex $< ) || echo noRerun "
	- bash -c " ( grep undefined $*.log && latex $< ) || echo noRerun "

%.dvi: %.tex
	latex $<
	- bash -c " ( grep undefined $*.log && latex $< ) || echo noRerun "
	- bash -c " ( grep undefined $*.log && latex $< ) || echo noRerun "
	- bash -c " ( grep undefined $*.log && latex $< ) || echo noRerun "

%.eps: %.ps
	cp $< $(@)_tmp
	echo "1,\$$s/%%BoundingBox: 27 195 585 596/%%BoundingBox: 30 358 337 562/g" > $(@)_edcmd
	echo "w" >> $(@)_edcmd
	ed $< < $(@)_edcmd
	cp $< $@
	cp $(@)_tmp $< 
	rm $(@)_edcmd $(@)_tmp

#%.dvi: %.tex

.PHONY: clean spotless

clean:
	$(RM) *.dvi *.aux *.log *.lof *.toc *.lot

spotless:
	$(RM) diss.pdf abstractpage.pdf