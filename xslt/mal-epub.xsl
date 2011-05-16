<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mal="http://projectmallard.org/1.0/"
    exclude-result-prefixes="mal"
    version="1.0">

<xsl:param name="mal.if.env" select="'epub html xhtml'"/>

<xsl:template mode="html.header.mode" match="mal:page"/>
<xsl:template mode="html.footer.mode" match="mal:page"/>

<xsl:template mode="html.css.mode" match="mal:page">
<xsl:text>
body { background-color: </xsl:text><xsl:value-of select="$color.background"/><xsl:text>; }
div.body { border: none; }
</xsl:text>
<xsl:apply-imports/>
</xsl:template>

</xsl:stylesheet>
