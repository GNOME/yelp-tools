<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
		exclude-result-prefixes="doc"
		version="1.0">

<doc:title>Titles and Subtitles</doc:title>


<!-- == db2html.title.label ================================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.title.label</name>
  <description>
    Generate the label for a title
  </description>
  <parameter>
    <name>node</name>
    <description>
      The element for which to generate a label
    </description>
  </parameter>
</template>

<xsl:template name="db2html.title.label">
  <xsl:param name="node" select="."/>
  <span class="label">
    <xsl:call-template name="db2html.label">
      <xsl:with-param name="node" select="$node/.."/>
    </xsl:call-template>
  </span>
</xsl:template>


<!-- == db2html.title.block ================================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.title.block</name>
  <description>
    Generate a labelled block title
  </description>
  <parameter>
    <name>node</name>
    <description>
      The element for which to generate a title
    </description>
  </parameter>
</template>

<xsl:template name="db2html.title.block">
  <xsl:param name="node" select="."/>
  <div class="{name(.)}">
    <xsl:call-template name="db2html.anchor">
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


<!-- == db2html.title.simple =============================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.title.simple</name>
  <description>
    Generate a simple unlabelled title
  </description>
  <parameter>
    <name>node</name>
    <description>
      The element for which to generate a title
    </description>
  </parameter>
</template>

<xsl:template name="db2html.title.simple">
  <xsl:param name="node" select="."/>
  <div class="{local-name(.)}">
    <xsl:call-template name="db2html.anchor">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <b>
      <xsl:apply-templates select="$node/node()"/>
    </b>
  </div>
</xsl:template>


<!-- == db2html.title.header =============================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.title.header</name>
  <description>
    Generate a header-level title
  </description>
  <parameter>
    <name>node</name>
    <description>
      The element for which to generate a title
    </description>
  </parameter>
  <parameter>
    <name>depth_in_chunk</name>
    <description>
      The depth of <parameter>node</parameter> in the containing chunk
    </description>
  </parameter>
</template>

<xsl:template name="db2html.title.header">
  <xsl:param name="node" select="."/>
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>

  <!-- Avoid xsl:element because of #141532 -->
  <xsl:choose>
    <xsl:when test="$depth_in_chunk = 1">
      <h1 class="{local-name($node/..)}">
        <xsl:call-template name="db2html.anchor">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:call-template name="db2html.title.label">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:apply-templates select="$node/node()"/>
      </h1>
    </xsl:when>
    <xsl:when test="$depth_in_chunk = 2">
      <h2 class="{local-name($node/..)}">
        <xsl:call-template name="db2html.anchor">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:call-template name="db2html.title.label">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:apply-templates select="$node/node()"/>
      </h2>
    </xsl:when>
    <xsl:when test="$depth_in_chunk = 3">
      <h3 class="{local-name($node/..)}">
        <xsl:call-template name="db2html.anchor">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:call-template name="db2html.title.label">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:apply-templates select="$node/node()"/>
      </h3>
    </xsl:when>
    <xsl:when test="$depth_in_chunk = 4">
      <h4 class="{local-name($node/..)}">
        <xsl:call-template name="db2html.anchor">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:call-template name="db2html.title.label">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:apply-templates select="$node/node()"/>
      </h4>
    </xsl:when>
    <xsl:when test="$depth_in_chunk = 5">
      <h5 class="{local-name($node/..)}">
        <xsl:call-template name="db2html.anchor">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:call-template name="db2html.title.label">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:apply-templates select="$node/node()"/>
      </h5>
    </xsl:when>
    <xsl:when test="$depth_in_chunk = 6">
      <h6 class="{local-name($node/..)}">
        <xsl:call-template name="db2html.anchor">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:call-template name="db2html.title.label">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:apply-templates select="$node/node()"/>
      </h6>
    </xsl:when>
    <xsl:otherwise>
      <h7 class="{local-name($node/..)}">
        <xsl:call-template name="db2html.anchor">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:call-template name="db2html.title.label">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:apply-templates select="$node/node()"/>
      </h7>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="title">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.title.header">
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
  </xsl:call-template>
</xsl:template>


<!-- == db2html.subtitle.header ============================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.subtitle.header</name>
  <description>
    Generate a header-level subtitle
  </description>
  <parameter>
    <name>node</name>
    <description>
      The element for which to generate a title
    </description>
  </parameter>
  <parameter>
    <name>depth_in_chunk</name>
    <description>
      The depth of <parameter>node</parameter> in the containing chunk
    </description>
  </parameter>
</template>

<xsl:template name="db2html.subtitle.header">
  <xsl:param name="node" select="."/>
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk">
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
    <xsl:call-template name="db2html.anchor">
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
