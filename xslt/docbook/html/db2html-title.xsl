<?xml version='1.0' encoding='utf-8'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:ref="http://www.gnome.org/~shaunm/mallard/reference"
		exclude-result-prefixes="ref"
                version="1.0">

<ref:title>Titles and Subtitles</ref:title>


<!-- == db2html.title.label == -->

<ref:refname>db2html.title.label</ref:refname>
<ref:refpurpose></ref:refpurpose>
<ref:para></ref:para>

<xsl:template name="db2html.title.label">
  <xsl:param name="node" select="."/>
  <span class="label">
    <xsl:call-template name="db2html-label.label">
      <xsl:with-param name="node" select="$node/.."/>
    </xsl:call-template>
  </span>
</xsl:template>


<!-- == db2html.title.block == -->

<ref:refname>db2html.title.block</ref:refname>
<ref:refpurpose></ref:refpurpose>
<ref:para></ref:para>

<xsl:template name="db2html.title.block">
  <xsl:param name="node" select="."/>
  <div class="{name(.)}">
    <xsl:call-template name="db2html-xref.anchor">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <i>
      <xsl:call-template name="db2html.title.label">
	<xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
    </i>
    <xsl:apply-templates select="$node/node()"/>
  </div>
</xsl:template>


<!-- == db2html.title.simple == -->

<ref:refname>db2html.title.simple</ref:refname>
<ref:refpurpose></ref:refpurpose>
<ref:para></ref:para>

<xsl:template name="db2html.title.simple">
  <xsl:param name="node" select="."/>
  <div class="{local-name(.)}">
    <xsl:call-template name="db2html-xref.anchor">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <b>
      <xsl:apply-templates select="$node/node()"/>
    </b>
  </div>
</xsl:template>


<!-- == db2html.title.header == -->

<ref:refname>db2html.title.header</ref:refname>
<ref:refpurpose></ref:refpurpose>
<ref:para></ref:para>

<xsl:template name="db2html.title.header">
  <xsl:param name="node" select="."/>
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db2html-depth.depth-in-chunk">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>

  <xsl:variable name="element">
    <xsl:choose>
      <xsl:when test="$depth_in_chunk &lt;= 7">
	<xsl:value-of select="concat('h', $depth_in_chunk)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="'h7'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:element name="{$element}">
    <xsl:attribute name="class">
      <xsl:value-of select="local-name($node/..)"/>
    </xsl:attribute>
    <xsl:call-template name="db2html-xref.anchor">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <xsl:call-template name="db2html.title.label">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <xsl:apply-templates select="$node/node()"/>
  </xsl:element>
</xsl:template>

<xsl:template match="title">
  <xsl:call-template name="db2html.title.header"/>
</xsl:template>


<!-- == db2html.subtitle.header == -->

<ref:refname>db2html.subtitle.header</ref:refname>
<ref:refpurpose></ref:refpurpose>
<ref:para></ref:para>

<xsl:template name="db2html.subtitle.header">
  <xsl:param name="node" select="."/>
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db2html-depth.depth-in-chunk">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>

  <xsl:variable name="element">
    <xsl:choose>
      <xsl:when test="$depth_in_chunk &lt;= 6">
	<xsl:value-of select="concat('h', $depth_in_chunk + 1)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="'h7'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:element name="{$element}">
    <xsl:attribute name="class">
      <xsl:value-of select="local-name($node/..)"/>
    </xsl:attribute>
    <xsl:call-template name="db2html-xref.anchor">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <xsl:call-template name="db2html.title.label">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <xsl:apply-templates select="$node/node()"/>
  </xsl:element>
</xsl:template>

<xsl:template match="subtitle">
  <xsl:call-template name="db2html.subtitle.header"/>
</xsl:template>

</xsl:stylesheet>
