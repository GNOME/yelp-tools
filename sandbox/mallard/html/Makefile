pages=$(patsubst %.xml,%.xhtml, $(notdir $(wildcard ../spec/*.xml)))

all: $(pages) figures mallard.cache

mallard.cache : $(wildcard ../xslt/*.xsl)
	echo '<cache xmlns="http://www.gnome.org/~shaunm/mallard">' >> $@.tmp
	for file in $(wildcard ../spec/*.xml); do \
	  xsltproc ../xslt/mal2cache.xsl $$file >> $@.tmp; \
	done
	echo '</cache>' >> $@.tmp
	mv $@.tmp $@

$(pages) : mallard.cache
$(pages) : $(wildcard ../xslt/*.xsl)
$(pages) : %.xhtml : ../spec/%.xml
	xsltproc -o $@ ../xslt/mal2html.xsl $<

figures:
	if [ ! -d figures ]; then mkdir figures; fi
	cp ../spec/figures/*.png figures/
