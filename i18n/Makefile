all: PLURALS.txt STYLESHEETS.xhtml

PLURALS.txt: plurals.sh ../xslt/gettext/gettext.xsl
	sh ./plurals.sh > PLURALS.txt

STYLESHEETS.xhtml: ../doc/xslt/C/translating.xml
	xsltproc -o STYLESHEETS.xhtml			\
	--param db.chunk.max_depth 0			\
	../xslt/docbook/html/db2html.xsl		\
	../doc/xslt/C/translating.xml
