xslts=$(wildcard ../../../xslt/mallard/common/*.xsl) $(wildcard ../../../xslt/mallard/html/*.xsl)
specs=$(filter-out ../../../doc/mallard/C/legal.xml, $(wildcard ../../../doc/mallard/C/*.xml))
pages=$(patsubst %.xml,%.html, $(notdir $(specs)))
icons=admon-bug.png admon-caution.png admon-important.png admon-note.png admon-tip.png admon-warning.png

all: $(pages) $(icons) figures mallard.cache

mallard.cache : $(specs) $(xslts)
	echo '<cache xmlns="http://www.gnome.org/~shaunm/mallard">' > $@.in
	for file in $(specs); do \
	  echo "<page href='$$file'/>" >> $@.in; \
	done
	echo '</cache>' >> $@.in
	xsltproc ../../../xslt/mallard/utils/mal2cache.xsl $@.in | xmllint --format - > $@
	rm $@.in


$(icons):
	ln -sf ../../../data/icons/hicolor/24x24/$@ $@

$(pages) : mallard.cache $(xslts)
$(pages) : %.html : ../../../doc/mallard/C/%.xml
	xsltproc -o $@ \
	  --stringparam mal.cache.file `pwd`/mallard.cache \
	  --stringparam theme.icon.admon.path '' \
	  --param theme.icon.admon.size 24 \
	  --param mal2html.editor_mode 1 \
	  ../../../xslt/mallard/html/mal2html.xsl $<

figures:
	if [ ! -d figures ]; then mkdir figures; fi
	cp ../../../doc/mallard/C/figures/*.png figures/

.PHONY: clean
clean:
	rm mallard.cache *.html
