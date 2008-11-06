all: mallard.rnc mallard.rng

specs1=$(top_srcdir)/doc/mallard/C/mal_page.xml   \
       $(top_srcdir)/doc/mallard/C/mal_block.xml  $(wildcard $(top_srcdir)/doc/mallard/C/mal_block_*.xml) \
       $(top_srcdir)/doc/mallard/C/mal_inline.xml $(wildcard $(top_srcdir)/doc/mallard/C/mal_inline_*.xml)
specs=$(specs1) $(filter-out $(specs1), $(wildcard $(top_srcdir)/doc/mallard/C/*.xml))

mallard.rnc: $(wildcard $(top_srcdir)/doc/mallard/C/*.xml)
	for file in $(specs); do \
	  xsltproc $(srcdir)/mal2rnc.xsl $$file; \
	done > mallard.rnc

mallard.rng: mallard.rnc rnc2rng.awk
	awk -f $(srcdir)/rnc2rng.awk mallard.rnc > $@.tmp || ( rm -f $@.tmp && exit 1 )
	xmllint --format $@.tmp | \
	  sed -e 's/^  //' \
	      -e 's/ xmlns/\n    xmlns/g' \
	      -e 's/" ns=/"\n    ns=/' \
	      -e 's/^<s/\n<s/' \
	      -e 's/^<d/\n<d/' \
	  > $@ || ( rm -f $@.tmp && exit 1 )

