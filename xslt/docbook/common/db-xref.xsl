<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Common Cross Reference Utilities</doc:title>


<!-- == db2html.xref.content =============================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.xref.content</name>
  <description>
    Generate the content for a cross reference
  </description>
</template>

<xsl:template name="db.xref.content">
  <xsl:param name="linkend" select="@linkend"/>
  <xsl:param name="target" select="key('idkey', $linkend)"/>
  <xsl:param name="xrefstyle" select="@xrefstyle"/>
  <xsl:choose>
    <xsl:when test="$target/@xreflabel">
      <xsl:value-of select="$target/@xreflabel"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="db.xref.content.mode" select="$target"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
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
