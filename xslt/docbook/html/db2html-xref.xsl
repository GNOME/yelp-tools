<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Links and Cross References</doc:title>


<!-- == db2html.anchor ===================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.anchor</name>
  <purpose>
    Generate an anchor point for an element
  </purpose>
</template>

<xsl:template name="db2html.anchor">
  <xsl:param name="node" select="."/>
  <xsl:param name="name" select="$node/@id"/>
  <xsl:if test="$name">
    <a name="{$name}"/>
  </xsl:if>
</xsl:template>


<!-- == Matched Templates ================================================== -->

<!-- = anchor = -->
<xsl:template match="anchor">
  <xsl:call-template name="db2html.anchor"/>
</xsl:template>

<!-- = link = -->
<xsl:template name="db2html.link" match="link">
  <xsl:param name="linkend" select="@linkend"/>
  <xsl:param name="target" select="key('idkey', $linkend)"/>
  <a class="link">
    <xsl:attribute name="href">
      <xsl:call-template name="db.xref.target">
        <xsl:with-param name="linkend" select="$linkend"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:if test="$target/title">
      <xsl:attribute name="title">
        <xsl:value-of select="$target/title"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="normalize-space(.) != ''">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="@endterm">
        <xsl:apply-templates select="id(@endterm)/node()"/>
      </xsl:when>
    </xsl:choose>
  </a>
</xsl:template>

<!-- 
<xsl:template match="olink">
<xsl:call-template name="FIXME"/>
</xsl:template>
-->

<!-- = ulink = -->
<xsl:template name="db2html.ulink" match="ulink">
  <xsl:param name="url" select="@url"/>
  <xsl:param name="content" select="false()"/>
  <!-- FIXME: add @title -->
  <a class="ulink" href="{$url}">
    <xsl:choose>
      <xsl:when test="$content">
        <xsl:copy-of select="$content"/>
      </xsl:when>
      <xsl:when test="string-length(normalize-space(node())) != 0">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$url"/>
      </xsl:otherwise>
    </xsl:choose>
  </a>
</xsl:template>

<!-- = xref = -->
<xsl:template name="db2html.xref" match="xref">
  <xsl:param name="linkend"   select="@linkend"/>
  <xsl:param name="target"    select="key('idkey', $linkend)"/>
  <xsl:param name="endterm"   select="@endterm"/>
  <xsl:param name="xrefstyle" select="@xrefstyle"/>
  <xsl:param name="content"   select="false()"/>
  <a class="xref">
    <xsl:attribute name="href">
      <xsl:call-template name="db.xref.target">
        <xsl:with-param name="linkend" select="$linkend"/>
        <xsl:with-param name="target" select="$target"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:if test="$target/title">
      <xsl:attribute name="title">
        <xsl:value-of select="$target/title"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$content">
        <xsl:copy-of select="$content"/>
      </xsl:when>
      <xsl:when test="$endterm">
        <xsl:apply-templates select="key('idkey', $endterm)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="db.xref.content">
          <xsl:with-param name="linkend" select="$linkend"/>
          <xsl:with-param name="target" select="$target"/>
          <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </a>
</xsl:template>

</xsl:stylesheet>
