<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                xmlns="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="doc"
                version="1.0">

<doc:title>DocBook to HTML conversion</doc:title>

<!-- Setting parameters for included stylesheets -->
<xsl:param name="db.chunk.extension" select="'.xhtml'" doc:private="true"/>

<xsl:include href="../../gettext/gettext.xsl"/>

<xsl:include href="../common/db-chunk.xsl"   doc:summary="true"/>
<xsl:include href="../common/db-common.xsl"  doc:summary="true"/>
<xsl:include href="../common/db-format.xsl"  doc:summary="true"/>
<xsl:include href="../common/db-label.xsl"   doc:summary="true"/>
<xsl:include href="../common/db-xref.xsl"    doc:summary="true"/>

<xsl:include href="db2html-admon.xsl"
             doc:summary="true"
             doc:include="true"/>
<xsl:include href="db2html-autotoc.xsl"
             doc:summary="true"
             doc:include="true"/>
<xsl:include href="db2html-block.xsl"
             doc:summary="true"
             doc:include="true"/>
<xsl:include href="db2html-callout.xsl"
             doc:summary="true"
             doc:include="true"/>
<xsl:include href="db2html-classsynopsis.xsl"
             doc:summary="true"
             doc:include="true"/>
<xsl:include href="db2html-cmdsynopsis.xsl"
             doc:summary="true"
             doc:include="true"/>
<xsl:include href="db2html-css.xsl"
             doc:summary="true"
             doc:include="true"/>
<xsl:include href="db2html-division.xsl"
             doc:summary="true"
             doc:include="true"/>
<xsl:include href="db2html-ebnf.xsl"
             doc:summary="true"
             doc:include="true"/>
<xsl:include href="db2html-funcsynopsis.xsl"
             doc:summary="true"
             doc:include="true"/>
<xsl:include href="db2html-info.xsl"
             doc:summary="true"
             doc:include="true"/>
<xsl:include href="db2html-inline.xsl"
             doc:summary="true"
             doc:include="true"/>
<xsl:include href="db2html-media.xsl"
             doc:summary="true"
             doc:include="true"/>
<xsl:include href="db2html-list.xsl"
             doc:summary="true"
             doc:include="true"/>
<xsl:include href="db2html-qanda.xsl"
             doc:summary="true"
             doc:include="true"/>
<xsl:include href="db2html-refentry.xsl"
             doc:summary="true"
             doc:include="true"/>
<xsl:include href="db2html-suppressed.xsl"
             doc:summary="true"
             doc:include="true"/>
<xsl:include href="db2html-table.xsl"
             doc:summary="true"
             doc:include="true"/>
<xsl:include href="db2html-title.xsl"
             doc:summary="true"
             doc:include="true"/>
<xsl:include href="db2html-xref.xsl"
             doc:summary="true"
             doc:include="true"/>

<xsl:template match="*">
  <xsl:message>
    <xsl:text>Unmatched element: </xsl:text>
    <xsl:value-of select="local-name(.)"/>
  </xsl:message>
  <xsl:apply-templates select="node()"/>
</xsl:template>

<!-- Implement the stub templates from db-chunk -->
<xsl:template name="info">
  <xsl:param name="node"/>
  <xsl:param name="info"/>
  <xsl:param name="depth_in_chunk"/>
  <xsl:param name="depth_of_chunk"/>
  <xsl:call-template name="db2html.info">
    <xsl:with-param name="node" select="$node"/>
    <xsl:with-param name="info" select="$info"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- Implement the format2xsl stub templates -->
<xsl:template name="format2xsl.element.name">
  <xsl:param name="name"/>
  <xsl:param name="namespace"/>
  <xsl:value-of select="$name"/>
</xsl:template>
<xsl:template name="format2xsl.element.namespace">
  <xsl:param name="name"/>
  <xsl:param name="namespace"/>
  <xsl:value-of select="'http://www.w3.org/1999/xhtml'"/>
</xsl:template>

</xsl:stylesheet>
