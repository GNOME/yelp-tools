<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
		exclude-result-prefixes="doc"
                version="1.0">

<doc:title>DocBook to HTML conversion</doc:title>

<!-- Setting parameters for included stylesheets -->
<xsl:param name="db.chunk.extension" select="'.html'" doc:private="true"/>

<xsl:include href="../../gettext/gettext.xsl"/>

<xsl:include href="../common/db-chunk.xsl"/>
<xsl:include href="../common/db-common.xsl"/>

<xsl:include href="db2html-admon.xsl"/>
<xsl:include href="db2html-block.xsl"/>
<xsl:include href="db2html-cmdsynopsis.xsl"/>
<xsl:include href="db2html-division.xsl"/>
<xsl:include href="db2html-ebnf.xsl"/>
<xsl:include href="db2html-funcsynopsis.xsl"/>
<xsl:include href="db2html-info.xsl"/>
<xsl:include href="db2html-inline.xsl"/>
<xsl:include href="db2html-label.xsl"/>
<xsl:include href="db2html-suppressed.xsl"/>
<xsl:include href="db2html-title.xsl"/>
<xsl:include href="db2html-xref.xsl"/>

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

</xsl:stylesheet>
