<?xml version='1.0' encoding='utf-8'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:output method="text" encoding="utf-8"/>

<xsl:include href="../common/db-common.xsl"/>

<xsl:template match="/">
  <xsl:for-each select="/*/*//author">
    <xsl:choose>
      <xsl:when test="personnname">
	<xsl:call-template name="db.personname">
	  <xsl:with-param name="node" select="personname"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:call-template name="db.personname">
	  <xsl:with-param name="node" select="."/>
	</xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>" \</xsl:text>
    <xsl:if test="email">
      <xsl:text> &lt;</xsl:text>
      <xsl:value-of select="email"/>
      <xsl:text>&gt;</xsl:text>
    </xsl:if>
    <xsl:text>&#x000A;</xsl:text>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
