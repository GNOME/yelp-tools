<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
		exclude-result-prefixes="doc"
		version="1.0">

<doc:title>Titles and Subtitles</doc:title>


<!-- == db2html.title.css ================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.title.css</name>
  <description>
    Create CSS for the title elements
  </description>
</template>

<xsl:template name="db2html.title.css">
  <xsl:text>
    h1 {
      font-size: 1.6em;
      margin-top: 0em;
      margin-left: -8px;
    }
    h2 {
      font-size: 1.4em;
      margin-top: 1.8em;
      border-bottom: solid 1px;
      margin-left: -8px;
    }
    h2 span[class~="label"] {
      float: right;
      font-size: 0.8em;
      padding-left: 6px;
      padding-top: 6px;
      padding-bottom: 8px;
      border-left: solid 1px;
    }
    h3 { font-size: 1.2em; margin-top: 1.8em; margin-left: -8px; }
    h4 { font-size: 1.2em; margin-top: 1.2em; margin-left: -8px; }
    h5 { font-size: 1.0em; margin-top: 1.2em; margin-left: -8px; }
  </xsl:text>
</xsl:template>


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
  <parameter>
    <name>depth_in_chunk</name>
    <description>
      The depth of <parameter>node</parameter> in the containing chunk
    </description>
  </parameter>
</template>

<xsl:template name="db2html.title.label">
  <xsl:param name="node" select="."/>
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>
  <span class="label">
    <xsl:call-template name="db.label">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="role" select="'header'"/>
      <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
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
      The title element for which to generate a title
    </description>
  </parameter>
  <parameter>
    <name>title_for</name>
    <description>
      The element for which this is the title
    </description>
  </parameter>
</template>

<xsl:template name="db2html.title.block">
  <xsl:param name="node" select="."/>
  <xsl:param name="title_for" select="$node/.."/>
  <div class="{local-name($node)}">
    <span class="{local-name($node)}">
      <xsl:call-template name="db2html.anchor">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
      <span class="label">
        <xsl:call-template name="db2html.title.label">
          <xsl:with-param name="node" select="$title_for"/>
        </xsl:call-template>
      </span>
      <xsl:apply-templates select="$node/node()"/>
    </span>
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
      The title element for which to generate a title
    </description>
  </parameter>
  <parameter>
    <name>title_for</name>
    <description>
      The element for which this is the title
    </description>
  </parameter>
</template>

<xsl:template name="db2html.title.simple">
  <xsl:param name="node" select="."/>
  <xsl:param name="title_for" select="$node/.."/>
  <div class="{local-name($node)}">
    <span class="{local-name($node)}">
      <xsl:call-template name="db2html.anchor">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
      <b>
        <xsl:apply-templates select="$node/node()"/>
      </b>
    </span>
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
      The title element for which to generate a title
    </description>
  </parameter>
  <parameter>
    <name>title_for</name>
    <description>
      The element for which this is the title
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
  <xsl:param name="title_for" select="$node/.."/>
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:variable name="title_for_depth">
    <xsl:choose>
      <xsl:when test="$title_for = $node">
        <xsl:value-of select="$depth_in_chunk"/>
      </xsl:when>
      <xsl:when test="$node/ancestor::* = $title_for">
        <xsl:value-of select="
                      $depth_in_chunk - 1 -
                      count($node/ancestor::*[ancestor::* = $title_for])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="db.chunk.depth-in-chunk">
          <xsl:with-param name="node" select="$title_for"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:element name="{concat('h', $depth_in_chunk)}">
    <xsl:attribute name="class">
      <xsl:value-of select="local-name($title_for)"/>
    </xsl:attribute>
    <span class="{local-name($node)}">
      <xsl:call-template name="db2html.anchor">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
      <!-- FIXME: I don't quite like doing this -->
      <xsl:if test="$depth_in_chunk = 2">
        <xsl:call-template name="db2html.title.label">
          <xsl:with-param name="node" select="$title_for"/>
          <xsl:with-param name="depth_in_chunk" select="$title_for_depth"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:apply-templates select="$node/node()"/>
    </span>
  </xsl:element>
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
      The subtitle element for which to generate a subtitle
    </description>
  </parameter>
  <parameter>
    <name>title_for</name>
    <description>
      The element for which this is the subtitle
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
  <xsl:param name="title_for" select="$node/.."/>
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:variable name="title_for_depth">
    <xsl:choose>
      <xsl:when test="$title_for = $node">
        <xsl:value-of select="$depth_in_chunk"/>
      </xsl:when>
      <xsl:when test="$node/ancestor::* = $title_for">
        <xsl:value-of select="
                      $depth_in_chunk - 1 -
                      count($node/ancestor::*[ancestor::* = $title_for])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="db.chunk.depth-in-chunk">
          <xsl:with-param name="node" select="$title_for"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:element name="{concat('h', $depth_in_chunk + 1)}">
    <xsl:attribute name="class">
      <xsl:value-of select="local-name($title_for)"/>
    </xsl:attribute>
    <span class="{local-name($node)}">
      <xsl:call-template name="db2html.anchor">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
      <xsl:apply-templates select="$node/node()"/>
    </span>
  </xsl:element>
</xsl:template>


<!-- == Matched Templates ================================================== -->

<!-- = title = -->
<xsl:template match="title">
  <xsl:param name="title_for" select=".."/>
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.title.header">
    <xsl:with-param name="title_for" select="$title_for"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = subtitle = -->
<xsl:template match="subtitle">
  <xsl:param name="title_for" select=".."/>
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.subtitle.header">
    <xsl:with-param name="title_for" select="$title_for"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = abstract/title = -->
<xsl:template match="abstract/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

<!-- = blockquote/title = -->
<xsl:template match="abstract/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

<!-- = calloutlist/title = -->
<xsl:template match="calloutlist/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

<!-- = dedication/title = -->
<xsl:template match="dedication/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

<!-- = dedication/subtitle = -->
<xsl:template match="dedication/subtitle">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

<!-- = example/title = -->
<xsl:template match="example/title">
  <xsl:call-template name="db2html.title.block"/>
</xsl:template>

<!-- = equation/title = -->
<xsl:template match="equation/title">
  <xsl:call-template name="db2html.title.block"/>
</xsl:template>

<!-- = figure/title = -->
<xsl:template match="figure/title">
  <xsl:call-template name="db2html.title.block"/>
</xsl:template>

<!-- = formalpara/title = -->
<xsl:template match="formalpara/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

<!-- = itemizedlist/title = -->
<xsl:template match="itemizedlist/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

<!-- = msg/title = -->
<xsl:template match="msg/title">
  <xsl:call-template name="db2html.title.block"/>
</xsl:template>

<!-- = msgrel/title = -->
<xsl:template match="msgrel/title">
  <xsl:call-template name="db2html.title.block"/>
</xsl:template>

<!-- = msgset/title = -->
<xsl:template match="msgset/title">
  <xsl:call-template name="db2html.title.block"/>
</xsl:template>

<!-- = msgsub/title  = -->
<xsl:template match="msgsub/title">
  <xsl:call-template name="db2html.title.block"/>
</xsl:template>

<!-- = orderedlist/title = -->
<xsl:template match="orderedlist/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

<!-- = procedure/title = -->
<xsl:template match="procedure/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

<!-- = refsynopsisdiv/title = -->
<xsl:template match="refsynopsisdiv/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

<!-- = segmentedlist/title = -->
<xsl:template match="segmentedlist/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

<!-- = sidebar/title = -->
<xsl:template match="sidebar/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

<!-- = step/title = -->
<xsl:template match="step/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

<!-- = table/title = -->
<xsl:template match="table/title">
  <xsl:call-template name="db2html.title.block"/>
</xsl:template>

<!-- = variablelist/title = -->
<xsl:template match="variablelist/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

</xsl:stylesheet>
