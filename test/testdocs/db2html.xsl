<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:import href="../../xslt/docbook/html/db2html.xsl"/>

<xsl:template match="/*/*[preceding-sibling::*][name(.) != 'title']">
  <pre style="margin: 16px; padding: 0.8em; background-color: #9EB6D1; -moz-border-radius: 8px;">
    <xsl:apply-templates mode="source.mode" select="."/>
  </pre>
  <xsl:apply-imports/>
</xsl:template>

<xsl:template mode="source.mode" match="*">
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="local-name(.)"/>
  <xsl:for-each select="attribute::*">
    <xsl:text> </xsl:text>
    <xsl:value-of select="name(.)"/>
    <xsl:text>="</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>"</xsl:text>
  </xsl:for-each>
  <xsl:text>&gt;</xsl:text>
  <xsl:apply-templates mode="source.mode" select="node()"/>
  <xsl:text>&lt;/</xsl:text>
  <xsl:value-of select="local-name(.)"/>
  <xsl:text>&gt;</xsl:text>
</xsl:template>

</xsl:stylesheet>
