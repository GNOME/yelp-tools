<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Block-Level Elements</doc:title>


<!-- == db2html.block ====================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.block</name>
  <description>
    Format a block-level element
  </description>
  <parameter>
    <name>verbatim</name>
    <description>
      Whether to maintain whitespace verbatim
    </description>
  </parameter>
</template>

<xsl:template name="db2html.block">
  <xsl:param name="verbatim" select="false()"/>

  <div class="{local-name(.)}">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:choose>
      <xsl:when test="$verbatim">
        <xsl:variable name="style">
          <xsl:if test="$verbatim">
            <xsl:text>white-space: pre; </xsl:text>
          </xsl:if>
        </xsl:variable>
        <xsl:attribute name="style">
          <xsl:value-of select="$style"/>
        </xsl:attribute>
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>


<!-- == db2html.para ======================================================= -->


<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.para</name>
  <description>
    Format an element as a paragraph
  </description>
</template>

<xsl:template name="db2html.para">
  <p class="{local-name(.)}">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:apply-templates/>
  </p>
</xsl:template>


<!-- Matched Templates ===================================================== -->

<!-- = abstract = -->
<xsl:template match="abstract">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = abstract/title = -->
<xsl:template match="abstract/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

<!-- = ackno = -->
<xsl:template match="ackno">
  <xsl:call-template name="para"/>
</xsl:template>

<!-- = address = -->
<xsl:template match="address">
  <xsl:call-template name="db2html.block">
    <xsl:with-param name="verbatim" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = example = -->
<xsl:template match="example">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = example/title = -->
<xsl:template match="example/title">
  <xsl:call-template name="db2html.title.block"/>
</xsl:template>

</xsl:stylesheet>
