<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Question and Answer Sets</doc:title>


<!-- == Matched Templates ================================================== -->

<xsl:template match="answer">
  <dd class="answer">
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
    <xsl:call-template name="db.label"/>
    <xsl:apply-templates/>
  </dt>
</xsl:template>

</xsl:stylesheet>
