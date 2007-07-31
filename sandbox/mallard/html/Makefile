xslts=$(wildcard ../xslt/*.xsl)
specs=$(filter-out ../spec/legal.xml, $(wildcard ../spec/*.xml))
pages=$(patsubst %.xml,%.xhtml, $(notdir $(specs)))

all: $(pages) figures mallard.cache

mallard.cache : $(specs) $(xslts)
	echo '<cache xmlns="http://www.gnome.org/~shaunm/mallard">' > $@.in
	for file in $(specs); do \
	  echo "<page href='$$file'/>" >> $@.in; \
	done
	echo '</cache>' >> $@.in
	xsltproc ../xslt/mal2cache.xsl $@.in | xmllint --format - > $@
	rm $@.in

$(pages) : mallard.cache ../xslt/theme.xml $(xslts)
$(pages) : %.xhtml : ../spec/%.xml
	xsltproc -o $@ \
	  --stringparam mal.cache_file `pwd`/mallard.cache \
	  ../xslt/mal2html.xsl $<

figures:
	if [ ! -d figures ]; then mkdir figures; fi
	cp ../spec/figures/*.png figures/

.PHONY: clean
clean:
	rm mallard.cache *.xhtml
