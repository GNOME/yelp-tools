<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:import href="../../xslt/docbook/html/db2html.xsl"/>

<!--
<xsl:template match="/*/*[1]/title | /*/title">
  <xsl:param name="title_for" select=".."/>
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.title.header">
    <xsl:with-param name="title_for" select="$title_for"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
  </xsl:call-template>
  <pre style="margin: 0.8em; padding: 0.8em; background-color: #9EB6D1;">
    <xsl:apply-templates mode="source.mode" select="/"/>
  </pre>
</xsl:template>
-->

<xsl:template match="/*/*[preceding-sibling::*][name(.) != 'title']">
  <pre style="margin: 0.8em; padding: 0.8em; background-color: #9EB6D1;">
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
