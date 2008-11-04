xslts=$(wildcard ../../../xslt/mallard/common/*.xsl) $(wildcard ../../../xslt/mallard/html/*.xsl)
specs=$(filter-out ../../../doc/mallard/C/legal.xml, $(wildcard ../../../doc/mallard/C/*.xml))
pages=$(patsubst %.xml,%.xhtml, $(notdir $(specs)))

all: $(pages) figures mallard.cache

mallard.cache : $(specs) $(xslts)
	echo '<cache xmlns="http://www.gnome.org/~shaunm/mallard">' > $@.in
	for file in $(specs); do \
	  echo "<page href='$$file'/>" >> $@.in; \
	done
	echo '</cache>' >> $@.in
	xsltproc ../../../xslt/mallard/utils/mal2cache.xsl $@.in | xmllint --format - > $@
	rm $@.in

$(pages) : mallard.cache $(xslts)
$(pages) : %.xhtml : ../../../doc/mallard/C/%.xml
	xsltproc -o $@ \
	  --stringparam mal.cache_file `pwd`/mallard.cache \
	  ../../../xslt/mallard/html/mal2html.xsl $<

figures:
	if [ ! -d figures ]; then mkdir figures; fi
	cp ../../../doc/mallard/C/figures/*.png figures/

.PHONY: clean
clean:
	rm mallard.cache *.xhtml
