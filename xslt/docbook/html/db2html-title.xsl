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
  <xsl:apply-templates mode="db2html.title.label.mode" select="$node"/>
</xsl:template>


<!-- == db2html.title.label.mode =========================================== -->

<xsl:template mode="db2html.title.label.mode" match="article"/>
<xsl:template mode="db2html.title.label.mode" match="book"/>
<xsl:template mode="db2html.title.label.mode" match="qandaset"/>

<xsl:template mode="db2html.title.label.mode" match="*">
  <span class="label">
    <xsl:call-template name="db2html.label"/>
  </span>
</xsl:template>

<xsl:template mode="db2html.title.label.mode" match="
              sect1  | sect2  | sect3   |
              sect4  | sect5  | section ">
  <span class="label">
    <xsl:call-template name="db2html.label.number"/>
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
  <div class="{name(.)}">
    <xsl:call-template name="db2html.anchor">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <i>
      <xsl:call-template name="db2html.title.label">
	<xsl:with-param name="node" select="$title_for"/>
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

  <!-- Avoid xsl:element because of #141532 -->
  <xsl:choose>
    <xsl:when test="$depth_in_chunk = 1">
      <h1 class="{local-name($title_for)}">
        <xsl:call-template name="db2html.anchor">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:call-template name="db2html.title.label">
          <xsl:with-param name="node" select="$title_for"/>
        </xsl:call-template>
        <xsl:apply-templates select="$node/node()"/>
      </h1>
    </xsl:when>
    <xsl:when test="$depth_in_chunk = 2">
      <h2 class="{local-name($title_for)}">
        <xsl:call-template name="db2html.anchor">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:call-template name="db2html.title.label">
          <xsl:with-param name="node" select="$title_for"/>
        </xsl:call-template>
        <xsl:apply-templates select="$node/node()"/>
      </h2>
    </xsl:when>
    <xsl:when test="$depth_in_chunk = 3">
      <h3 class="{local-name($title_for)}">
        <xsl:call-template name="db2html.anchor">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:call-template name="db2html.title.label">
          <xsl:with-param name="node" select="$title_for"/>
        </xsl:call-template>
        <xsl:apply-templates select="$node/node()"/>
      </h3>
    </xsl:when>
    <xsl:when test="$depth_in_chunk = 4">
      <h4 class="{local-name($title_for)}">
        <xsl:call-template name="db2html.anchor">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:call-template name="db2html.title.label">
          <xsl:with-param name="node" select="$title_for"/>
        </xsl:call-template>
        <xsl:apply-templates select="$node/node()"/>
      </h4>
    </xsl:when>
    <xsl:when test="$depth_in_chunk = 5">
      <h5 class="{local-name($title_for)}">
        <xsl:call-template name="db2html.anchor">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:call-template name="db2html.title.label">
          <xsl:with-param name="node" select="$title_for"/>
        </xsl:call-template>
        <xsl:apply-templates select="$node/node()"/>
      </h5>
    </xsl:when>
    <xsl:when test="$depth_in_chunk = 6">
      <h6 class="{local-name($title_for)}">
        <xsl:call-template name="db2html.anchor">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:call-template name="db2html.title.label">
          <xsl:with-param name="node" select="$title_for"/>
        </xsl:call-template>
        <xsl:apply-templates select="$node/node()"/>
      </h6>
    </xsl:when>
    <xsl:otherwise>
      <h7 class="{local-name($title_for)}">
        <xsl:call-template name="db2html.anchor">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:call-template name="db2html.title.label">
          <xsl:with-param name="node" select="$title_for"/>
        </xsl:call-template>
        <xsl:apply-templates select="$node/node()"/>
      </h7>
    </xsl:otherwise>
  </xsl:choose>
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

  <!-- Avoid xsl:element because of #141532 -->
  <xsl:choose>
    <xsl:when test="$depth_in_chunk = 1">
      <h2 class="{local-name($title_for)}">
        <xsl:call-template name="db2html.anchor">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:apply-templates select="$node/node()"/>
      </h2>
    </xsl:when>
    <xsl:when test="$depth_in_chunk = 2">
      <h3 class="{local-name($title_for)}">
        <xsl:call-template name="db2html.anchor">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:apply-templates select="$node/node()"/>
      </h3>
    </xsl:when>
    <xsl:when test="$depth_in_chunk = 3">
      <h4 class="{local-name($title_for)}">
        <xsl:call-template name="db2html.anchor">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:apply-templates select="$node/node()"/>
      </h4>
    </xsl:when>
    <xsl:when test="$depth_in_chunk = 4">
      <h5 class="{local-name($title_for)}">
        <xsl:call-template name="db2html.anchor">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:apply-templates select="$node/node()"/>
      </h5>
    </xsl:when>
    <xsl:when test="$depth_in_chunk = 5">
      <h6 class="{local-name($title_for)}">
        <xsl:call-template name="db2html.anchor">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:apply-templates select="$node/node()"/>
      </h6>
    </xsl:when>
    <xsl:otherwise>
      <h7 class="{local-name($title_for)}">
        <xsl:call-template name="db2html.anchor">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:apply-templates select="$node/node()"/>
      </h7>
    </xsl:otherwise>
  </xsl:choose>
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
