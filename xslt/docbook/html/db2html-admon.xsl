<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
		exclude-result-prefixes="doc"
		version="1.0">

<doc:title>Admonitions</doc:title>


<!-- == db2html.admon.border_color ========================================= -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.admon.border_color</name>
  <purpose>
    The color of the border around admonition elements
  </purpose>
</parameter>

<xsl:param name="db2html.admon.border_color" select="'#D1940C'"/>


<!-- == db2html.admon.graphics_path ======================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.admon.graphics_path</name>
  <purpose>
    The path to admonition graphics
  </purpose>
</parameter>

<xsl:param name="db2html.admon.graphics_path"/>


<!-- == db2html.admon.graphics_size ======================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.admon.graphics_size</name>
  <purpose>
    The size of admonition graphics, in pixels
  </purpose>
</parameter>

<xsl:param name="db2html.admon.graphics_size" select="48"/>


<!-- == db2html.admon.graphics_extension =================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.admon.graphics_extension</name>
  <purpose>
    The file extension for admonition graphics
  </purpose>
</parameter>

<xsl:param name="db2html.admon.graphics_extension" select="'.png'"/>


<!-- == db2html.admon ====================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.admon</name>
  <purpose>
    Render admonition elements
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The element for which to render an admonition
    </purpose>
  </parameter>
</template>

<xsl:template name="db2html.admon">
  <xsl:param name="node" select="."/>
  <div class="admonition {local-name(.)}">
    <xsl:apply-templates select="$node/node()"/>
  </div>
</xsl:template>


<!-- == db2html.admon.css ================================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.admon.css</name>
  <purpose>
    Create CSS for the admonition elements
  </purpose>
</template>

<xsl:template name="db2html.admon.css">
  <xsl:text>
    div[class~="caution"] {
      background-image: url("</xsl:text>
      <xsl:value-of select="$db2html.admon.graphics_path"/>
      <xsl:text>caution</xsl:text>
      <xsl:value-of select="$db2html.admon.graphics_extension"/><xsl:text>");
    }
    div[class~="important"] {
      background-image: url("</xsl:text>
      <xsl:value-of select="$db2html.admon.graphics_path"/>
      <xsl:text>important</xsl:text>
      <xsl:value-of select="$db2html.admon.graphics_extension"/><xsl:text>");
    }
    div[class~="note"] {
      background-image: url("</xsl:text>
      <xsl:value-of select="$db2html.admon.graphics_path"/>
      <xsl:text>note</xsl:text>
      <xsl:value-of select="$db2html.admon.graphics_extension"/><xsl:text>");
    }
    div[class~="tip"] {
      background-image: url("</xsl:text>
      <xsl:value-of select="$db2html.admon.graphics_path"/>
      <xsl:text>tip</xsl:text>
      <xsl:value-of select="$db2html.admon.graphics_extension"/><xsl:text>");
    }
    div[class~="warning"] {
      background-image: url("</xsl:text>
      <xsl:value-of select="$db2html.admon.graphics_path"/>
      <xsl:text>warning</xsl:text>
      <xsl:value-of select="$db2html.admon.graphics_extension"/><xsl:text>");
    }
    div[class~="admonition"] {
      margin-left: 2em;
      margin-right: 2em;
      padding-top: 4px;
      padding-left: </xsl:text>
      <xsl:value-of select="$db2html.admon.graphics_size + 8"/><xsl:text>px;
      padding-right: 8px;
      min-height: </xsl:text>
      <xsl:value-of select="$db2html.admon.graphics_size + 4"/><xsl:text>px;
      border: dotted </xsl:text>
      <xsl:value-of select="$db2html.admon.border_color"/><xsl:text> 1px;
      background-position: 4px 4px;
      background-repeat: no-repeat;
    }
  </xsl:text>
</xsl:template>


<!-- == Matched Templates == -->

<!-- = caution = -->
<xsl:template match="caution">
  <xsl:call-template name="db2html.admon"/>
</xsl:template>

<!-- = caution/title = -->
<xsl:template match="caution/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

<!-- = important = -->
<xsl:template match="important">
  <xsl:call-template name="db2html.admon"/>
</xsl:template>

<!-- = important/title = -->
<xsl:template match="important/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

<!-- = note = -->
<xsl:template match="note">
  <xsl:call-template name="db2html.admon"/>
</xsl:template>

<!-- = note/title = -->
<xsl:template match="note/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

<!-- = tip = -->
<xsl:template match="tip">
  <xsl:call-template name="db2html.admon"/>
</xsl:template>

<!-- = tip/title = -->
<xsl:template match="tip/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

<!-- = warning = -->
<xsl:template match="warning">
  <xsl:call-template name="db2html.admon"/>
</xsl:template>

<!-- = warning/title = -->
<xsl:template match="warning/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

</xsl:stylesheet>
