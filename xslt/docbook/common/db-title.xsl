<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Common Utilities for Titles</doc:title>


<!-- == db.title =========================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.title</name>
  <purpose>
    Process the title of an element
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The element for which to process the title
    </purpose>
  </parameter>
</template>

<xsl:template name="db.title">
  <xsl:param name="node" select="."/>
  <xsl:apply-templates mode="db.title.mode" select="."/>
</xsl:template>


<!-- == db.titleabbrev ===================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.titleabbrev</name>
  <purpose>
    Process the abbreviated title of an element
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The element for which to process the abbreviated title
    </purpose>
  </parameter>
</template>

<xsl:template name="db.titleabbrev">
  <xsl:param name="node" select="."/>
  <!-- FIXME -->
  <xsl:apply-templates mode="db.title.mode" select="."/>
</xsl:template>


<!-- == db.subtitle ======================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.subtitle</name>
  <purpose>
    Process the subtitle of an element
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The element for which to process the subtitle
    </purpose>
  </parameter>
</template>

<xsl:template name="db.subtitle">
  <xsl:param name="node" select="."/>
  <!-- FIXME -->
  <xsl:apply-templates mode="db.title.mode" select="."/>
</xsl:template>


<!-- == db.title.mode ====================================================== -->

<xsl:template mode="db.title.mode" match="*"/>

<xsl:template mode="db.title.mode" match="*[title]">
  <xsl:apply-templates select="title/node()"/>
</xsl:template>

<xsl:template mode="db.title.mode" match="*[blockinfo/title]">
  <xsl:apply-templates select="blockinfo/title/node()"/>
</xsl:template>

<xsl:template mode="db.title.mode" match="*[objectinfo/title]">
  <xsl:apply-templates select="objectinfo/title/node()"/>
</xsl:template>

<xsl:template mode="db.title.mode" match="appendix">
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title/node()"/>
    </xsl:when>
    <xsl:when test="appendixinfo/title">
      <xsl:apply-templates select="appendixinfo/title/node()"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template mode="db.title.mode" match="article">
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title/node()"/>
    </xsl:when>
    <xsl:when test="articleinfo/title">
      <xsl:apply-templates select="articleinfo/title/node()"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template mode="db.title.mode" match="bibliography">
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title/node()"/>
    </xsl:when>
    <xsl:when test="bibliographyinfo/title">
      <xsl:apply-templates select="bibliographyinfo/title/node()"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template mode="db.title.mode" match="book">
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title/node()"/>
    </xsl:when>
    <xsl:when test="bookinfo/title">
      <xsl:apply-templates select="bookinfo/title/node()"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template mode="db.title.mode" match="chapter">
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title/node()"/>
    </xsl:when>
    <xsl:when test="chapterinfo/title">
      <xsl:apply-templates select="chapterinfo/title/node()"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template mode="db.title.mode" match="glossary">
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title/node()"/>
    </xsl:when>
    <xsl:when test="glossaryinfo/title">
      <xsl:apply-templates select="glossaryinfo/title/node()"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template mode="db.title.mode" match="index">
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title/node()"/>
    </xsl:when>
    <xsl:when test="indexinfo/title">
      <xsl:apply-templates select="indexinfo/title/node()"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template mode="db.title.mode" match="part">
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title/node()"/>
    </xsl:when>
    <xsl:when test="partinfo/title">
      <xsl:apply-templates select="partinfo/title/node()"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template mode="db.title.mode" match="preface">
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title/node()"/>
    </xsl:when>
    <xsl:when test="prefaceinfo/title">
      <xsl:apply-templates select="prefaceinfo/title/node()"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template mode="db.title.mode" match="refentry">
  <xsl:choose>
    <xsl:when test="refmeta/refentrytitle">
      <xsl:apply-templates select="refmeta/refentrytitle/node()"/>
      <xsl:if test="refmeta/manvolnum">
        <xsl:call-template name="format.manvolnum">
          <xsl:with-param name="node" select="refmeta/manvolnum[1]"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:when>
    <xsl:when test="refentryinfo/title">
      <xsl:apply-templates select="refentryinfo/title/node()"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="refnamediv/refname[1]/node()"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template mode="db.title.mode" match="reference">
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title/node()"/>
    </xsl:when>
    <xsl:when test="referenceinfo/title">
      <xsl:apply-templates select="referenceinfo/title/node()"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template mode="db.title.mode" match="refsect1">
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title/node()"/>
    </xsl:when>
    <xsl:when test="refsect1info/title">
      <xsl:apply-templates select="refsect1info/title/node()"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template mode="db.title.mode" match="refsect2">
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title/node()"/>
    </xsl:when>
    <xsl:when test="refsect2info/title">
      <xsl:apply-templates select="refsect2info/title/node()"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template mode="db.title.mode" match="refsect3">
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title/node()"/>
    </xsl:when>
    <xsl:when test="refsect3info/title">
      <xsl:apply-templates select="refsect3info/title/node()"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template mode="db.title.mode" match="refsection">
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title/node()"/>
    </xsl:when>
    <xsl:when test="refsectioninfo/title">
      <xsl:apply-templates select="refsectioninfo/title/node()"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template mode="db.title.mode" match="refsynopsisdiv">
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title/node()"/>
    </xsl:when>
    <xsl:when test="refsynopsisdivinfo/title">
      <xsl:apply-templates select="refsynopsisdivinfo/title/node()"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template mode="db.title.mode" match="sect1">
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title/node()"/>
    </xsl:when>
    <xsl:when test="sect1info/title">
      <xsl:apply-templates select="sect1info/title/node()"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template mode="db.title.mode" match="sect2">
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title/node()"/>
    </xsl:when>
    <xsl:when test="sect2info/title">
      <xsl:apply-templates select="sect2info/title/node()"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template mode="db.title.mode" match="sect3">
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title/node()"/>
    </xsl:when>
    <xsl:when test="sect3info/title">
      <xsl:apply-templates select="sect3info/title/node()"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template mode="db.title.mode" match="sect4">
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title/node()"/>
    </xsl:when>
    <xsl:when test="sect4info/title">
      <xsl:apply-templates select="sect4info/title/node()"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template mode="db.title.mode" match="sect5">
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title/node()"/>
    </xsl:when>
    <xsl:when test="sect5info/title">
      <xsl:apply-templates select="sect5info/title/node()"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template mode="db.title.mode" match="section">
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title/node()"/>
    </xsl:when>
    <xsl:when test="sectioninfo/title">
      <xsl:apply-templates select="sectioninfo/title/node()"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template mode="db.title.mode" match="set">
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title/node()"/>
    </xsl:when>
    <xsl:when test="setinfo/title">
      <xsl:apply-templates select="setinfo/title/node()"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template mode="db.title.mode" match="setindex">
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title/node()"/>
    </xsl:when>
    <xsl:when test="setindexinfo/title">
      <xsl:apply-templates select="setindexinfo/title/node()"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template mode="db.title.mode" match="sidebar">
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title/node()"/>
    </xsl:when>
    <xsl:when test="sidebarinfo/title">
      <xsl:apply-templates select="sidebarinfo/title/node()"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
