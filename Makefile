RM=/bin/rm -vf

all: diss.pdf abstractpage.pdf

%.pdf: %.ps
	ps2pdf -dMaxSubsetPct=100 -dCompatibilityLevel=1.2 -dSubsetFonts=true -dEmbedAllFonts=true $<

%.ps: %.dvi
	dvips -t letter $< -o

%.dvi: %.tex
	latex $<
	- bash -c " ( grep Rerun $*.log && latex $< ) || echo noRerun "
	- bash -c " ( grep Rerun $*.log && latex $< ) || echo noRerun "
	- bash -c " ( grep Rerun $*.log && latex $< ) || echo noRerun "

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
	$(RM) *.dvi *.aux *.log

spotless:
	$(RM) diss.pdf abstractpage.pdf