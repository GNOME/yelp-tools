# Not using INTLTOOL_XML_RULE because of it causes db-format.xml to be
# rebuilt in the tarball, which causes docs to be rebuilt, which causes
# translated docs to be rebuilt, which requires xml2po, which breaks
# --disable-build-utils
db-format.xml: db-format.xml.in $(wildcard $(top_srcdir)/po/*.po)
	LC_ALL=C $(INTLTOOL_MERGE) -x -u -c $(top_builddir)/po/.intltool-merge-cache $(top_srcdir)/po $< $@

xsldir=$(datadir)/xml/gnome/xslt/docbook/common

xsl_DATA =			\
	db-chunk.xsl		\
	db-common.xsl		\
	db-format.xsl		\
	db-label.xsl		\
	db-title.xsl		\
	db-xref.xsl

EXTRA_DIST=$(xsl_DATA) db-format.xml.in db-format.xml

db-format.xsl: db-format.xml ../../gettext/format2xsl.xsl
	xsltproc ../../gettext/format2xsl.xsl $< | xmllint --format - > $@
