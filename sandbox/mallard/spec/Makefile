pages=$(filter-out legal.xml, $(wildcard *.xml))

.PHONY: check-validate check-links status-report

check-validate:
	@(cd ../rng/ && $(MAKE) mallard.rnc)
	xmllint --noout --relaxng ../rng/mallard.rng $(pages)

check-links:
	@files=$$(for page in $(pages); do \
	  xml sel -t -m "//*[@xref and contains(@xref, '#')]" \
          -v "substring-before(@xref, '#')" -n "$$page"; \
	  xml sel -t -m "//*[@xref and not(contains(@xref, '#'))]" \
          -v "@xref" -n "$$page"; \
	done | sort -u); \
	for file in $$files; do \
	  if [ ! -f "$$file.xml" -a ! -f "$$file.TODO" ]; then \
	    echo "$$file not found"; \
	    exit 1; \
	  fi; \
	done;

status_xslt='<xsl:stylesheet version="1.0" \
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" \
    xmlns:mal="http://www.gnome.org/~shaunm/mallard"> \
<xsl:output method="text"/> \
<xsl:param name="base"/> \
<xsl:template match="/"> \
  <xsl:variable name="version" select="*/mal:info/mal:version"/> \
  <xsl:if test="not($$version)"> \
    <xsl:value-of select="$$base"/> \
    <xsl:text>: none&\#x000A;</xsl:text> \
  </xsl:if> \
  <xsl:for-each select="$$version"> \
    <xsl:sort select="@date" date-type="text" order="descending"/> \
    <xsl:if test="position() = 1"> \
      <xsl:value-of select="$$base"/> \
      <xsl:text>: </xsl:text> \
      <xsl:choose> \
        <xsl:when test="@status"> \
          <xsl:value-of select="@status"/> \
          <xsl:text>&\#x000A;</xsl:text> \
        </xsl:when> \
        <xsl:otherwise> \
          <xsl:text>none&\#x000A;</xsl:text> \
        </xsl:otherwise> \
      </xsl:choose> \
    </xsl:if> \
  </xsl:for-each> \
</xsl:template> \
</xsl:stylesheet>'

status-report:
	@for page in $(pages); do \
	  base=`echo "$$page" | sed -e 's/.xml$$//'`; \
	  echo $(status_xslt) | xsltproc --stringparam base "$$base" - "$$page"; \
	done
