.ALL: html xhtml
.PHONY: html xhtml

html:
	if [ ! -d html ]; then mkdir html; fi
	rm -f html/*.*
	xsltproc --timing --nonet --xinclude -o html/ \
	--param db.chunk.chunk_top 1 \
	--stringparam theme.icon.admon.path "../../../data/icons/" \
	--stringparam theme.icon.nav.previous "../../../data/icons/nav-previous.png" \
	--stringparam theme.icon.nav.next "../../../data/icons/nav-next.png" \
	../../xslt/docbook/html/db2html.xsl \
	testbook.xml
xhtml:
	if [ ! -d xhtml ]; then mkdir xhtml; fi
	rm -f xhtml/*.*
	xsltproc --timing --nonet --xinclude -o xhtml/ \
	--param db.chunk.chunk_top 1 \
	--stringparam theme.icon.admon.path "../../../data/icons/" \
	--stringparam theme.icon.nav.previous "../../../data/icons/nav-previous.png" \
	--stringparam theme.icon.nav.next "../../../data/icons/nav-next.png" \
	../../xslt/docbook/html/db2xhtml.xsl \
	testbook.xml
