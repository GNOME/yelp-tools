<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
		exclude-result-prefixes="doc"
		version="1.0">

<doc:title>Admonitions</doc:title>


<!-- == db2html.admon.graphics_path ======================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.admon.graphics_path</name>
  <description>
    The path to admonition graphics
  </description>
</parameter>

<xsl:param name="db2html.admon.graphics_path"/>


<!-- == db2html.admon.graphics_extension =================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.admon.graphics_extension</name>
  <description>
    The file extension for admonition graphics
  </description>
</parameter>

<xsl:param name="db2html.admon.graphics_extension" select="'png'"/>


<!-- == db2html.admon.text_only ============================================ -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.admon.text_only</name>
  <description>
    Whether to render admonitions text-only
  </description>
</parameter>

<xsl:param name="db2html.admon.text_only" select="false()"/>


<!-- == db2html.admon ====================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.admon</name>
  <description>
    Render admonition elements
  </description>
  <parameter>
    <name>node</name>
    <description>
      The element for which to render an admonition
    </description>
  </parameter>
  <para>
    This template renders the DocBook admonition elements.  The
    template simply calls <template>db2html.admon.text</template>
    or <template>db2html.admon.boxed</template>, depending on the
    value of <parameter>$db2html.admon.text_only</parameter>.
  </para>
</template>

<xsl:template name="db2html.admon">
  <xsl:param name="node" select="."/>
  <xsl:choose>
    <xsl:when test="$db2html.admon.text_only">
      <xsl:call-template name="db2html.admon.text">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="db2html.admon.boxed">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- == db2html.admon.boxed ================================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.admon.boxed</name>
  <description>
    Render an admonition element as a stylized box with admonition graphics
  </description>
  <parameter>
    <name>node</name>
    <description>
      The element for which to render an admonition
    </description>
  </parameter>
</template>

<xsl:template name="db2html.admon.boxed">
  <xsl:param name="node" select="."/>
  <!-- FIXME: maybe sideline the admon boxes -->
  <div class="admonition">
    <div class="{local-name(.)}">
      <xsl:call-template name="db2html.admon.image">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
      <xsl:apply-templates select="$node/title"/>
      <xsl:apply-templates select="$node/*[local-name(.) != 'title']"/>
    </div>
  </div>
</xsl:template>


<!-- == db2html.admon.text ================================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.admon.text</name>
  <description>
    Render an admonition element as a simple text block
  </description>
  <parameter>
    <name>node</name>
    <description>
      The element for which to render an admonition
    </description>
  </parameter>
</template>

<xsl:template name="db2html.admon.text">
  <xsl:param name="node" select="."/>
  <div class="admonition">
    <div class="{name(.)}">
      <xsl:call-template name="db2html-xref.anchor">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
      <xsl:apply-templates select="$node/node()"/>
    </div>
  </div>
</xsl:template>


<!-- == db2html.admon.image ================================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.admon.image</name>
  <description>
    Create the <xmltag>img</xmltag> for an admonition graphic
  </description>
  <parameter>
    <name>node</name>
    <description>
      The element for which to render an admonition image
    </description>
  </parameter>
</template>

<xsl:template name="db2html.admon.image">
  <xsl:param name="node" select="."/>
  <img style="float: left;">
    <xsl:attribute name="src">
      <xsl:value-of select="$db2html.admon.graphics_path"/>
      <xsl:value-of select="name($node)"/>
      <xsl:value-of select="$db2html.admon.graphics_extension"/>
    </xsl:attribute>
  </img>
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
