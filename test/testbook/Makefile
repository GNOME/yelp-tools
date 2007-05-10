.ALL: html xhtml
.PHONY: html xhtml

html:
	if [ ! -d html ]; then mkdir html; fi
	rm -f html/*.*
	xsltproc --timing --nonet --xinclude -o html/ \
	--param db.chunk.chunk_top 1 \
	../../xslt/docbook/html/db2html.xsl \
	testbook.xml
xhtml:
	if [ ! -d xhtml ]; then mkdir xhtml; fi
	rm -f xhtml/*.*
	xsltproc --timing --nonet --xinclude -o xhtml/ \
	--param db.chunk.chunk_top 1 \
	--stringparam theme.icon.admon.path "../../../data/icons/hicolor/48x48/" \
	--stringparam theme.icon.nav.previous "../../../data/icons/hicolor/22x22/nav-previous.png" \
	--stringparam theme.icon.nav.next "../../../data/icons/hicolor/22x22/nav-next.png" \
	../../xslt/docbook/html/db2xhtml.xsl \
	testbook.xml
