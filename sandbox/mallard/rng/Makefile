all: mallard.rnc mallard.rng

mallard.rnc: $(wildcard ../spec/*.xml)
	for file in ../spec/*.xml; do \
	  xsltproc ../xslt/mal2rnc.xsl $$file; \
	done > mallard.rnc

mallard.rng: mallard.rnc rnc2rng.awk
	awk -f rnc2rng.awk mallard.rnc > $@.tmp || ( rm -f $@.tmp && exit 1 )
	xmllint --format $@.tmp > $@ || ( rm -f $@.tmp && exit 1 )
