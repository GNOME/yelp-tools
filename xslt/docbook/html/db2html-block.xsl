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


<!-- == db2html.blockquote ================================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.blockquote</name>
  <description>
    Render a blockquote for an element
  </description>
</template>

<xsl:template name="db2html.blockquote">
  <div class="{local-name(.)}">
    <xsl:apply-templates select="title"/>
    <blockquote>
      <xsl:apply-templates
       select="*[name(.) != 'title' and name(.) != 'attribution']"/>
    </blockquote>
    <xsl:apply-templates select="attribution"/>
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


<!-- == db2html.pre ======================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.pre</name>
  <description>
    Format an element in a <xmltag>pre</xmltag> tag
  </description>
</template>

<xsl:template name="db2html.pre">
  <pre class="{local-name(.)}">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:apply-templates/>
  </pre>
</xsl:template>


<!-- Matched Templates ===================================================== -->

<!-- = abstract = -->
<xsl:template match="abstract">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = ackno = -->
<xsl:template match="ackno">
  <xsl:call-template name="db2html.para"/>
</xsl:template>

<!-- = address = -->
<xsl:template match="address">
  <xsl:call-template name="db2html.block">
    <xsl:with-param name="verbatim" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = attribution = -->
<xsl:template match="attribution">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = blockquote = -->
<xsl:template match="blockquote">
  <xsl:call-template name="db2html.blockquote"/>
</xsl:template>

<!-- = caption = -->
<xsl:template match="caption">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = epigraph = -->
<xsl:template match="epigraph">
  <xsl:call-template name="db2html.blockquote"/>
</xsl:template>

<!-- = example = -->
<xsl:template match="example">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = para = -->
<xsl:template match="para">
  <xsl:call-template name="db2html.para"/>
</xsl:template>

</xsl:stylesheet>
