@INTLTOOL_XML_RULE@

xsldir=$(datadir)/sgml/gnome/docbook/common

xsl_DATA =			\
	db-chunk.xsl		\
	db-common.xsl		\
	db-format.xsl		\
	db-label.xsl		\
	db-xref.xsl

EXTRA_DIST=$(xsl_DATA) db-format.xml.in db-format.xml

db-format.xsl: db-format.xml
	xsltproc ../../gettext/format2xsl.xsl $< | xmllint --format - > $@
