db2html = $(top_srcdir)/xslt/docbook/html/db2html.xsl

tests = $(wildcard *.xml)
htmls = $(patsubst %.xml,%.html,$(tests))

$(htmls) : %.html : %.xml
	xsltproc -o $@ $(db2html) $<

check-local: $(htmls)
