<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Links and Cross References</doc:title>


<!-- == db2html.anchor ===================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.anchor</name>
  <description>
    Generate an anchor point for an element
  </description>
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
<xsl:template match="link">
  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="db.xref.target">
        <xsl:with-param name="linkend" select="@linkend"/>
      </xsl:call-template>
    </xsl:attribute>
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

<xsl:template name="ulink" match="ulink">
<xsl:param name="url" select="@url"/>
<xsl:param name="content" select="false()"/>
<a href="{$url}">
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


<xsl:template name="xref" match="xref">
<xsl:param name="linkend" select="@linkend"/>
<xsl:param name="target" select="id($linkend)"/>
<xsl:param name="content" select="false()"/>
<a>
<xsl:attribute name="href">
<xsl:call-template name="xref.target">
<xsl:with-param name="linkend" select="$linkend"/>
<xsl:with-param name="target" select="$target"/>
</xsl:call-template>
</xsl:attribute>
<xsl:choose>
<xsl:when test="$content">
<xsl:copy-of select="$content"/>
</xsl:when>
<xsl:when test="@endterm">
<xsl:apply-templates select="id(@endterm)"/>
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="xref.content">
<xsl:with-param name="linkend" select="$linkend"/>
<xsl:with-param name="target" select="$target"/>
</xsl:call-template>
</xsl:otherwise>
</xsl:choose>
</a>
</xsl:template>


<xsl:template name="xref.content">
<xsl:param name="linkend" select="@linkend"/>
<xsl:param name="target" select="id($linkend)"/>
<xsl:choose>
<xsl:when test="$target/@xreflabel">
<xsl:value-of select="$target/@xreflabel"/>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates mode="xref.content.mode" select="$target"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template mode="xref.content.mode" match="article | reference">
<xsl:choose>
<xsl:when test="
(preceding-sibling::*[name(.) = name(current())])							or
(following-sibling::*[name(.) = name(current())])							or
(parent::part/preceding-sibling::part/*[name(.) = name(current())])	or
(parent::part/following-sibling::part/*[name(.) = name(current())])	">
<xsl:call-template name="header"/>
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="gettext">
<xsl:with-param name="msgid" select="'Table of Contents'"/>
</xsl:call-template>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template mode="xref.content.mode" match="book">
<xsl:call-template name="gettext">
<xsl:with-param name="msgid" select="'Table of Contents'"/>
</xsl:call-template>
</xsl:template>

<xsl:template mode="xref.content.mode" match="glossentry">
<xsl:apply-templates mode="xref.content.mode" select="glossterm[1]"/>
</xsl:template>

<xsl:template mode="xref.content.mode" match="glossterm">
<xsl:apply-templates/>
</xsl:template>

<xsl:template mode="xref.content.mode" match="*">
<xsl:call-template name="header"/>
</xsl:template>

-->

</xsl:stylesheet>
