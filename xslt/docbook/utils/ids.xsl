<?xml version='1.0' encoding='utf-8'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:output method="text" encoding="utf-8"/>

<xsl:include href="../common/db-common.xsl"/>

<xsl:template match="/">
  <xsl:for-each select="//@id">
    <xsl:value-of select="."/>
    <xsl:text>&#x000A;</xsl:text>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
