<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Reference Pages</doc:title>


<!-- == db2html.refentry.css =============================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.refentry.css</name>
  <purpose>
    Create CSS for the refentry elements
  </purpose>
</template>

<xsl:template name="db2html.refentry.css">
  <xsl:text>
    div[class~="refentry"] h2[class~="refentry"] {
      border: none;
      margin-top: 1em;
    }
    div[class~="refentry"] + div[class~="refentry"] {
      border-top: dashed black 1px;
    }
  </xsl:text>
</xsl:template>


<!-- = manvolnum = -->
<xsl:template match="manvolnum">
  <xsl:call-template name="format.manvolnum">
    <xsl:with-param name="node" select="."/>
  </xsl:call-template>
</xsl:template>


<!-- = refentry = -->
<xsl:template match="refentry">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>

  <div class="refentry">
    <xsl:choose>
      <xsl:when test="refmeta/refentrytitle">
        <xsl:call-template name="db2html.title.header">
          <!-- FIXME: this won't work -->
          <xsl:with-param name="node"
                          select="refmeta/refentrytitle | refmeta/manvolnum"/>
          <xsl:with-param name="referent" select="."/>
          <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk + 1"/>
          <xsl:with-param name="referent_depth_in_chunk" select="$depth_in_chunk"/>
          <xsl:with-param name="generate_label" select="false()"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="refentryinfo/title">
        <xsl:call-template name="db2html.title.header">
          <xsl:with-param name="node" select="refentryinfo/title"/>
          <xsl:with-param name="referent" select="."/>
          <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk + 1"/>
          <xsl:with-param name="referent_depth_in_chunk" select="$depth_in_chunk"/>
          <xsl:with-param name="generate_label" select="false()"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message><xsl:text>foo</xsl:text></xsl:message>
        <xsl:call-template name="db2html.title.header">
          <xsl:with-param name="node" select="refnamediv/refname[1]"/>
          <xsl:with-param name="referent" select="."/>
          <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk + 1"/>
          <xsl:with-param name="referent_depth_in_chunk" select="$depth_in_chunk"/>
          <xsl:with-param name="generate_label" select="false()"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>

    <div class="refnamedivs">
      <xsl:call-template name="db2html.title.header">
        <xsl:with-param name="node" select="refnamediv"/>
        <xsl:with-param name="referent" select="refnamediv"/>
        <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk + 2"/>
        <xsl:with-param name="referent_depth_in_chunk" select="$depth_in_chunk + 1"/>
        <xsl:with-param name="generate_label" select="false()"/>
        <xsl:with-param name="title_content">
          <xsl:call-template name="gettext">
            <xsl:with-param name="msgid" select="'Name'"/>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:apply-templates select="refnamediv"/>
    </div>
    <xsl:apply-templates select="refsynopsisdiv | refsect1 | refsection">
      <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk + 1"/>
      <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
    </xsl:apply-templates>
  </div>
</xsl:template>

<!-- = refname = -->
<xsl:template match="refname">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = refnamediv = -->
<xsl:template match="refnamediv">
  <div class="refnamediv">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:for-each select="refname">
      <xsl:if test="position() != 1">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:apply-templates select="."/>
    </xsl:for-each>
    <xsl:text> — </xsl:text>
    <xsl:apply-templates select="refpurpose"/>
  </div>
</xsl:template>

<!-- = refpurpose = -->
<xsl:template match="refpurpose">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = refsect1 = -->
<xsl:template match="refsect1">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.div">
    <xsl:with-param name="divisions" select="refsect2"/>
    <xsl:with-param name="info" select="refsect1info"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
    <xsl:with-param name="chunk_divisions" select="false()"/>
  </xsl:call-template>
</xsl:template>

<!-- = refsect2 = -->
<xsl:template match="refsect2">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.div">
    <xsl:with-param name="divisions" select="refsect3"/>
    <xsl:with-param name="info" select="refsect2info"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
    <xsl:with-param name="chunk_divisions" select="false()"/>
  </xsl:call-template>
</xsl:template>

<!-- = refsect3 = -->
<xsl:template match="refsect3">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.div">
    <xsl:with-param name="divisions" select="/false"/>
    <xsl:with-param name="info" select="refsect3info"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
    <xsl:with-param name="chunk_divisions" select="false()"/>
  </xsl:call-template>
</xsl:template>

<!-- = refsection = -->
<xsl:template match="refsection">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.div">
    <xsl:with-param name="divisions" select="refsection"/>
    <xsl:with-param name="info" select="refsectioninfo"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
    <xsl:with-param name="chunk_divisions" select="false()"/>
  </xsl:call-template>
</xsl:template>

<!-- = refsynopsisdiv = -->
<xsl:template match="refsynopsisdiv">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <div class="refsynopsisdiv">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:if test="not(title)">
      <xsl:call-template name="db2html.title.header">
        <xsl:with-param name="node" select="."/>
        <xsl:with-param name="referent" select="."/>
        <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk + 1"/>
        <xsl:with-param name="referent_depth_in_chunk" select="$depth_in_chunk"/>
        <xsl:with-param name="generate_label" select="false()"/>
        <xsl:with-param name="title_content">
          <xsl:call-template name="gettext">
            <xsl:with-param name="msgid" select="'Synopsis'"/>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:apply-templates>
      <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk + 1"/>
    </xsl:apply-templates>
  </div>
</xsl:template>

<!-- = title = -->
<xsl:template match="refsect1/title | refsect2/title   |
                     refsect3/title | refsection/title ">
  <xsl:param name="referent" select=".."/>
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="referent_depth_in_chunk">
    <xsl:choose>
      <xsl:when test="$referent = .">
        <xsl:value-of select="$depth_in_chunk"/>
      </xsl:when>
      <xsl:when test="ancestor::* = $referent">
        <xsl:value-of select="$depth_in_chunk -
                      (count(ancestor::*) - count($referent/ancestor::*)) "/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="db.chunk.depth-in-chunk">
          <xsl:with-param name="node" select="$referent"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.title.header">
    <xsl:with-param name="referent" select="$referent"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
    <xsl:with-param name="generate_label" select="false()"/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
