<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
		exclude-result-prefixes="doc"
		version="1.0">

<doc:title>Titles and Subtitles</doc:title>


<!-- == db2html.title.css ================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.title.css</name>
  <purpose>
    Create CSS for the title elements
  </purpose>
</template>

<xsl:template name="db2html.title.css">
  <xsl:text>
    h1 { font-size: 1.6em; margin-top: 0em; }
    h2 { font-size: 1.4em; }
    h2[class~="title"] {
      margin-top: 1.8em;
      border-bottom: solid 1px;
    }
    h3 { font-size: 1.2em; margin-top: 1.8em; }
    h3 span[class~="title"] { border-bottom: solid 1px; }
    h4 { font-size: 1.0em; margin-top: 1.8em; }
    h4 span[class~="title"] { border-bottom: solid 1px; }
    h5 { font-size: 1.0em; margin-top: 1.2em; }
    h1 span[class~="label"] { padding-right: 0.8em; }
    h2 span[class~="label"] { padding-right: 0.8em; }
    h3 span[class~="label"] { padding-right: 0.8em; }
    h4 span[class~="label"] { padding-right: 0.8em; }
    h5 span[class~="label"] { padding-right: 0.8em; }
  </xsl:text>
</xsl:template>


<!-- == db2html.title.label ================================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.title.label</name>
  <purpose>
    Generate the label for a title
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The element for which to generate a label
    </purpose>
  </parameter>
  <parameter>
    <name>depth_in_chunk</name>
    <purpose>
      The depth of <parameter>node</parameter> in the containing chunk
    </purpose>
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
  <purpose>
    Generate a labelled block title
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The title element for which to generate a title
    </purpose>
  </parameter>
  <parameter>
    <name>referent</name>
    <purpose>
      The element for which this is the title
    </purpose>
  </parameter>
</template>

<xsl:template name="db2html.title.block">
  <xsl:param name="node" select="."/>
  <xsl:param name="referent" select="$node/.."/>
  <div class="{local-name($node)}">
    <span class="{local-name($node)}">
      <xsl:call-template name="db2html.anchor">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
      <xsl:call-template name="db2html.title.label">
        <xsl:with-param name="node" select="$referent"/>
      </xsl:call-template>
      <xsl:apply-templates select="$node/node()"/>
    </span>
  </div>
</xsl:template>


<!-- == db2html.title.simple =============================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.title.simple</name>
  <purpose>
    Generate a simple unlabelled title
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The title element for which to generate a title
    </purpose>
  </parameter>
  <parameter>
    <name>referent</name>
    <purpose>
      The element for which this is the title
    </purpose>
  </parameter>
</template>

<xsl:template name="db2html.title.simple">
  <xsl:param name="node" select="."/>
  <xsl:param name="referent" select="$node/.."/>
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
  <purpose>
    Generate a header-level title
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The title element for which to generate a title
    </purpose>
  </parameter>
  <parameter>
    <name>referent</name>
    <purpose>
      The element for which this is the title
    </purpose>
  </parameter>
  <parameter>
    <name>depth_in_chunk</name>
    <purpose>
      The depth of <parameter>node</parameter> in the containing chunk
    </purpose>
  </parameter>
  <parameter>
    <name>referent_depth_in_chunk</name>
    <purpose>
      The depth of <parameter>referent</parameter> in the containing chunk
    </purpose>
  </parameter>
  <parameter>
    <name>depth_of_chunk</name>
    <purpose>
      The depth of the containing chunk in the document
    </purpose>
  </parameter>
  <parameter>
    <name>generate_label</name>
    <purpose>
      Whether to generate a label in the title
    </purpose>
  </parameter>
  <parameter>
    <name>title_content</name>
    <purpose>
      The title, for divisions lacking a <sgmltag>title</sgmltag> element
    </purpose>
  </parameter>
</template>

<xsl:template name="db2html.title.header">
  <xsl:param name="node" select="."/>
  <xsl:param name="referent" select="$node/.."/>
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="referent_depth_in_chunk">
    <xsl:choose>
      <xsl:when test="$referent = $node">
        <xsl:value-of select="$depth_in_chunk"/>
      </xsl:when>
      <xsl:when test="$node/ancestor::* = $referent">
        <xsl:value-of select="$depth_in_chunk -
                      (count($node/ancestor::*) - count($referent/ancestor::*)) "/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="db.chunk.depth-in-chunk">
          <xsl:with-param name="node" select="$referent"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="generate_label" select="true()"/>
  <xsl:param name="title_content"/>

  <xsl:element name="{concat('h', $depth_in_chunk)}">
    <xsl:attribute name="class">
      <xsl:value-of select="local-name($referent)"/>
      <xsl:text> title</xsl:text>
    </xsl:attribute>
    <span class="title">
      <xsl:call-template name="db2html.anchor">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
      <xsl:if test="$generate_label">
        <xsl:call-template name="db2html.title.label">
          <xsl:with-param name="node" select="$referent"/>
          <xsl:with-param name="depth_in_chunk" select="$referent_depth_in_chunk"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="$title_content">
          <xsl:value-of select="$title_content"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$node/node()"/>
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:element>
</xsl:template>


<!-- == db2html.subtitle.header ============================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.subtitle.header</name>
  <purpose>
    Generate a header-level subtitle
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The subtitle element for which to generate a subtitle
    </purpose>
  </parameter>
  <parameter>
    <name>referent</name>
    <purpose>
      The element for which this is the subtitle
    </purpose>
  </parameter>
  <parameter>
    <name>depth_in_chunk</name>
    <purpose>
      The depth of <parameter>node</parameter> in the containing chunk
    </purpose>
  </parameter>
  <parameter>
    <name>referent_depth_in_chunk</name>
    <purpose>
      The depth of <parameter>referent</parameter> in the containing chunk
    </purpose>
  </parameter>
  <parameter>
    <name>subtitle_content</name>
    <purpose>
      The subtitle, for divisions lacking a <sgmltag>subtitle</sgmltag> element
    </purpose>
  </parameter>
</template>

<xsl:template name="db2html.subtitle.header">
  <xsl:param name="node" select="."/>
  <xsl:param name="referent" select="$node/.."/>
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="referent_depth_in_chunk">
    <xsl:choose>
      <xsl:when test="$referent = $node">
        <xsl:value-of select="$depth_in_chunk"/>
      </xsl:when>
      <xsl:when test="$node/ancestor::* = $referent">
        <xsl:value-of select="$depth_in_chunk -
                      (count($node/ancestor::*) - count($referent/ancestor::*)) "/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="db.chunk.depth-in-chunk">
          <xsl:with-param name="node" select="$referent"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="subtitle_content"/>

  <xsl:element name="{concat('h', $depth_in_chunk + 1)}">
    <xsl:attribute name="class">
      <xsl:value-of select="local-name($referent)"/>
    </xsl:attribute>
    <span class="subtitle">
      <xsl:call-template name="db2html.anchor">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
      <xsl:choose>
        <xsl:when test="$subtitle_content">
          <xsl:value-of select="$subtitle_content"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$node/node()"/>
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:element>
</xsl:template>


<!-- == Matched Templates ================================================== -->

<!-- = title = -->
<xsl:template match="title">
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
    <xsl:with-param name="generate_label" select="$referent != /*"/>
  </xsl:call-template>
</xsl:template>

<!-- = subtitle = -->
<xsl:template match="subtitle">
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
  <xsl:call-template name="db2html.subtitle.header">
    <xsl:with-param name="referent" select="$referent"/>
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
