<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Question and Answer Sets</doc:title>


<!-- == db2html.qanda.css ================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.qanda.css</name>
  <purpose>
    Create CSS for the qanda elements
  </purpose>
</template>

<xsl:template name="db2html.qanda.css">
  <xsl:text>
    dl[class~="qandaset"] dt + dd { margin-top: -8px; }
    dt[class~="question"] { margin-left: 0px; }
    dt[class~="question"] div[class~="label"] {
      float: right;
      margin-right: 1em;
    }
    dd[class~="answer"] { margin-left: 12px; }
    dt[class~="answer"] div[class~="label"] {
      float: right;
      margin-right: 1em;
    }
  </xsl:text>
</xsl:template>


<!-- == Matched Templates ================================================== -->

<xsl:template match="answer">
  <dd class="answer">
    <div class="label">
      <xsl:call-template name="db.label"/>
    </div>
    <xsl:apply-templates/>
  </dd>
</xsl:template>

<xsl:template match="qandadiv">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.content">
    <xsl:with-param name="info" select="blockinfo"/>
    <xsl:with-param name="entries" select="qandaentry"/>
    <xsl:with-param name="divisions" select="qandadiv"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
    <xsl:with-param name="chunk_divisions" select="false()"/>
    <xsl:with-param name="chunk_info" select="false()"/>
    <xsl:with-param name="autotoc_divisions" select="false()"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="qandaentry">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="qandaset">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.content">
    <xsl:with-param name="info" select="blockinfo"/>
    <xsl:with-param name="entries" select="qandaentry"/>
    <xsl:with-param name="divisions" select="qandadiv"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
    <xsl:with-param name="chunk_divisions" select="false()"/>
    <xsl:with-param name="chunk_info" select="false()"/>
    <xsl:with-param name="autotoc_divisions" select="true()"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="question">
  <dt class="question">
    <!-- FIXME -->
    <div class="label">
      <xsl:call-template name="db.label"/>
    </div>
    <xsl:apply-templates/>
  </dt>
</xsl:template>

</xsl:stylesheet>
