xsldir=$(datadir)/sgml/gnome/docbook/html

xsl_DATA =				\
	db2html-admon.xsl		\
	db2html-cmdsynopsis.xsl		\
	db2html-ebnf.xsl		\
	db2html-funcsynopsis.xsl	\
	db2html-info.xsl		\
	db2html-inline.xsl		\
	db2html-label.xsl		\
	db2html-suppressed.xsl		\
	db2html-title.xsl		\
	db2html.xsl

EXTRA_DIST=$(xsl_DATA)

report.xml: $(wildcard db*.xsl) elements report.sh
	./report.sh > report.xml
report.html: report.xml report.xslt
	xsltproc -o report.html report.xslt report.xml

