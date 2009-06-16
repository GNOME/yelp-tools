xslts=$(wildcard ../../../xslt/mallard/common/*.xsl) $(wildcard ../../../xslt/mallard/html/*.xsl)
specs=$(wildcard ../../../doc/mallard/C/*.page)
pages=$(patsubst %.page,%.html, $(notdir $(specs)))
xhtmls=$(patsubst %.page,%.xhtml, $(notdir $(specs)))
icons=admon-bug.png admon-caution.png admon-important.png admon-note.png admon-tip.png admon-warning.png
marks=watermark-blockquote-201C.png watermark-code.png

all: $(pages) $(icons) $(marks) figures mallard.cache

mallard.cache : $(specs) $(xslts)
	echo '<cache xmlns="http://projectmallard.org/1.0/">' > $@.in
	for file in $(specs); do \
	  echo "<page href='$$file'/>" >> $@.in; \
	done
	echo '</cache>' >> $@.in
	xsltproc ../../../xslt/mallard/utils/mal2cache.xsl $@.in | xmllint --format - > $@
	rm $@.in


$(icons):
	ln -sf ../../../data/icons/hicolor/24x24/$@ $@
$(marks):
	ln -sf ../../../data/watermarks/$@ $@

$(pages) : mallard.cache $(xslts)
$(pages) : %.html : ../../../doc/mallard/C/%.page
	xsltproc \
	  --stringparam mal.cache.file `pwd`/mallard.cache \
	  --stringparam theme.icon.admon.path '' \
	  --param mal.chunk.chunk_top 1 \
	  --param theme.icon.admon.size 24 \
	  --param mal2html.editor_mode 1 \
	  ../../../xslt/mallard/html/mal2html.xsl $<

$(xhtmls) : mallard.cache $(xslts)
$(xhtmls) : %.xhtml : ../../../doc/mallard/C/%.page
	xsltproc \
	  --stringparam mal.cache.file `pwd`/mallard.cache \
	  --stringparam theme.icon.admon.path '' \
	  --param mal.chunk.chunk_top 1 \
	  --param theme.icon.admon.size 24 \
	  --param mal2html.editor_mode 1 \
	  ../../../xslt/mallard/html/mal2xhtml.xsl $<

figures:
	if [ ! -d figures ]; then mkdir figures; fi
	cp ../../../doc/mallard/C/figures/*.png figures/

.PHONY: clean
clean:
	rm mallard.cache *.html
