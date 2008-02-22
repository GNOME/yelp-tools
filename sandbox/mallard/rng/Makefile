all: mallard.rnc mallard.rng

specs1=../spec/spec_pages.xml \
       ../spec/mal_page.xml   \
       ../spec/mal_block.xml  $(wildcard ../spec/mal_block_*.xml) \
       ../spec/mal_inline.xml $(wildcard ../spec/mal_inline_*.xml)
specs=$(specs1) $(filter-out $(specs1), $(wildcard ../spec/*.xml))

mallard.rnc: $(wildcard ../spec/*.xml)
	for file in $(specs); do \
	  xsltproc ../xslt/mal2rnc.xsl $$file; \
	done > mallard.rnc

mallard.rng: mallard.rnc rnc2rng.awk
	awk -f rnc2rng.awk mallard.rnc > $@.tmp || ( rm -f $@.tmp && exit 1 )
	xmllint --format $@.tmp | \
	  sed -e 's/^  //' \
	      -e 's/ xmlns/\n    xmlns/g' \
	      -e 's/" ns=/"\n    ns=/' \
	      -e 's/^<s/\n<s/' \
	      -e 's/^<d/\n<d/' \
	  > $@ || ( rm -f $@.tmp && exit 1 )

