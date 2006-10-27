<?xml version='1.0' encoding='UTF-8'?><!-- -*- indent-tabs-mode: nil -*- -->
<!--
This program is free software; you can redistribute it and/or modify it under
the terms of the GNU Lesser General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
details.

You should have received a copy of the GNU Lesser General Public License
along with this program; see the file COPYING.LGPL.  If not, write to the
Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
02111-1307, USA.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

<!--!!==========================================================================
DocBook to HTML - Titles and Subtitles

REMARK: Describe this module
-->


<!--**==========================================================================
db2html.title.css
Outputs CSS that controls the appearance of titles

REMARK: Describe this template
-->
<xsl:template name="db2html.title.css">
<xsl:text>
h1 { font-size: 1.72em; margin-top: 0em; }
h2 { font-size: 1.44em; }
h2.title { margin-top: 1.72em; border-bottom: solid 1px; }
h3 { font-size: 1.2em; }
h3.title { margin-top: 1.72em; }
h3 span.title { border-bottom: solid 1px; }
h4 { font-size: 1.0em; }
h4.title { margin-top: 1.44em; }
h4 span.title { border-bottom: solid 1px; }
h5 { font-size: 1em; margin-top: 1em; }
h6 { font-size: 1em; margin-top: 1em; }
h7 { font-size: 1em; margin-top: 1em; }
</xsl:text>
</xsl:template>


<!--**==========================================================================
db2html.title.label
Generates the label for a title
$node: The element to generate a label for
$depth_in_chunk: The depth of ${node} in the containing chunk

REMARK: Talk about what a label is
-->
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


<!--**==========================================================================
db2html.title.block
Generates a labeled block title
$node: The element to generate a title for
$referent: The element that ${node} is a title for

REMARK: Talk about the different kinds of title blocks
-->
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


<!--**==========================================================================
db2html.title.simple
Generates a simple, unlabeled title
$node: The element to generate a title for
$referent: The element that ${node} is a title for

REMARK: Talk about the different kinds of title blocks
-->
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


<!--**==========================================================================
db2html.title.header
Generates a header-level title
$node: The element to generate a title for
$referent: The element that ${node} is a title for
$depth_in_chunk: The depth of ${node} in the containing chunk
$referent_depth_in_chunk: The depth of ${referent} in the containing chunk
$depth_of_chunk: The depth of the containing chunk in the document
$generate_label: Whether to generate a label in the title
$title_content: An optional string containing the title

REMARK: Talk about the different kinds of title blocks
-->
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

  <xsl:element name="{concat('h', $depth_in_chunk)}"
               namespace="http://www.w3.org/1999/xhtml">
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


<!--**==========================================================================
db2html.subtitle.header
Generates a header-level subtitle
$node: The element to generate a subtitle for
$referent: The element that ${node} is a subtitle for
$depth_in_chunk: The depth of ${node} in the containing chunk
$referent_depth_in_chunk: The depth of ${referent} in the containing chunk
$subtitle_content: An optional string containing the subtitle

REMARK: Talk about the different kinds of title blocks
-->
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

  <xsl:element name="{concat('h', $depth_in_chunk + 1)}"
               namespace="http://www.w3.org/1999/xhtml">
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


<!-- == Matched Templates == -->

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
    <xsl:with-param name="generate_label"
                    select="$referent_depth_in_chunk != 0 and (
                            $referent/self::appendix   or $referent/self::chatper or
                            $referent/self::section    or $referent/self::sect1   or
                            $referent/self::sect2      or $referent/self::sect3   or
                            $referent/self::sect4      or $referent/self::sect5   or
                            $referent/self::simplesect )"/>
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
