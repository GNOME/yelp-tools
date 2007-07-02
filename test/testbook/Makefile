.ALL: html xhtml norm
.PHONY: html xhtml norm

html:
	if [ ! -d html ]; then mkdir html; fi
	rm -f html/*.*
	xsltproc --timing --nonet --xinclude -o html/ \
	--param db.chunk.chunk_top 1 \
	--stringparam theme.icon.admon.path "../../../data/icons/hicolor/48x48/" \
	../../xslt/docbook/html/db2html.xsl \
	testbook.xml
xhtml:
	if [ ! -d xhtml ]; then mkdir xhtml; fi
	rm -f xhtml/*.*
	xsltproc --timing --nonet --xinclude -o xhtml/ \
	--param db.chunk.chunk_top 1 \
	--stringparam theme.icon.admon.path "../../../data/icons/hicolor/48x48/" \
	../../xslt/docbook/html/db2xhtml.xsl \
	testbook.xml

norm:
	if [ ! -d html ]; then mkdir norm; fi
	rm -f norm/*.*
	xsltproc --timing --nonet --xinclude -o norm/index.html \
	/usr/share/sgml/docbook/xsl-stylesheets/html/chunk.xsl \
	testbook.xml
