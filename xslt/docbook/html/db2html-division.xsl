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
DocBook to HTML - Division Elements

REMARK: Describe this module
-->


<!--**==========================================================================
db2html.division.html
Renders a complete HTML page for a division element
$node: The element to create an HTML page for
$info: The info child element of ${node}
$depth_of_chunk: The depth of the containing chunk in the document

REMARK: Put in a word about the chunk flow; talk about what templates get called
-->
<xsl:template name="db2html.division.html">
  <xsl:param name="node" select="."/>
  <xsl:param name="info"/>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:variable name="prev_id">
    <xsl:choose>
      <xsl:when test="$depth_of_chunk = 0">
        <xsl:if test="$info">
          <xsl:value-of select="$db.chunk.info_basename"/>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="db.chunk.chunk-id.axis">
          <xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="axis" select="'previous'"/>
          <xsl:with-param name="depth_in_chunk" select="0"/>
          <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="next_id">
    <xsl:call-template name="db.chunk.chunk-id.axis">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="axis" select="'next'"/>
      <xsl:with-param name="depth_in_chunk" select="0"/>
      <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="prev_node" select="key('idkey', $prev_id)"/>
  <xsl:variable name="next_node" select="key('idkey', $next_id)"/>
  <!-- FIXME -->
  <html>
    <head>
      <title>
        <xsl:variable name="title">
          <xsl:call-template name="db.title">
            <xsl:with-param name="node" select="$node"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="normalize-space($title)"/>
      </title>
      <xsl:if test="string($prev_id) != ''">
        <link rel="previous">
          <xsl:attribute name="href">
            <xsl:call-template name="db.xref.target">
              <xsl:with-param name="linkend" select="$prev_id"/>
              <xsl:with-param name="target" select="$prev_node"/>
              <xsl:with-param name="is_chunk" select="true()"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:call-template name="db.title">
              <xsl:with-param name="node" select="$prev_node"/>
            </xsl:call-template>
          </xsl:attribute>
        </link>
      </xsl:if>
      <xsl:if test="string($next_id) != ''">
        <link rel="next">
          <xsl:attribute name="href">
            <xsl:call-template name="db.xref.target">
              <xsl:with-param name="linkend" select="$next_id"/>
              <xsl:with-param name="target" select="$next_node"/>
              <xsl:with-param name="is_chunk" select="true()"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:call-template name="db.title">
              <xsl:with-param name="node" select="$next_node"/>
            </xsl:call-template>
          </xsl:attribute>
        </link>
      </xsl:if>
      <xsl:if test="/*[1] != $node">
        <link rel="top">
          <xsl:attribute name="href">
            <xsl:call-template name="db.xref.target">
              <xsl:with-param name="linkend" select="/*[1]/@id"/>
              <xsl:with-param name="target" select="/*[1]"/>
              <xsl:with-param name="is_chunk" select="true()"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:call-template name="db.title">
              <xsl:with-param name="node" select="/*[1]"/>
            </xsl:call-template>
          </xsl:attribute>
        </link>
      </xsl:if>
      <xsl:call-template name="db2html.css">
        <xsl:with-param name="css_file" select="$depth_of_chunk = 0"/>
      </xsl:call-template>
      <xsl:call-template name="db2html.division.head.extra"/>
    </head>
    <body>
      <xsl:call-template name="db2html.division.top">
        <xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="info" select="$info"/>
        <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
        <xsl:with-param name="prev_id" select="$prev_id"/>
        <xsl:with-param name="next_id" select="$next_id"/>
        <xsl:with-param name="prev_node" select="$prev_node"/>
        <xsl:with-param name="next_node" select="$next_node"/>
      </xsl:call-template>
      <div class="body">
        <xsl:apply-templates select="$node">
          <xsl:with-param name="depth_in_chunk" select="0"/>
          <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
        </xsl:apply-templates>
      </div>
      <xsl:call-template name="db2html.division.bottom">
        <xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="info" select="$info"/>
        <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
        <xsl:with-param name="prev_id" select="$prev_id"/>
        <xsl:with-param name="next_id" select="$next_id"/>
        <xsl:with-param name="prev_node" select="$prev_node"/>
        <xsl:with-param name="next_node" select="$next_node"/>
      </xsl:call-template>
    </body>
  </html>
</xsl:template>


<!--**==========================================================================
db2html.division.head.extra
FIXME
:Stub: true

REMARK: Describe this stub template.
-->
<xsl:template name="db2html.division.head.extra"/>


<!--**==========================================================================
db2html.division.top
FIXME

REMARK: Describe this template
-->
<xsl:template name="db2html.division.top">
  <xsl:param name="node"/>
  <xsl:param name="info"/>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="prev_id">
    <xsl:choose>
      <xsl:when test="$depth_of_chunk = 0 and $info">
        <xsl:if test="$info">
          <xsl:value-of select="$db.chunk.info_basename"/>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="db.chunk.chunk-id.axis">
          <xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="axis" select="'previous'"/>
          <xsl:with-param name="depth_in_chunk" select="0"/>
          <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="next_id">
    <xsl:call-template name="db.chunk.chunk-id.axis">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="axis" select="'next'"/>
      <xsl:with-param name="depth_in_chunk" select="0"/>
      <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="prev_node" select="key('idkey', $prev_id)"/>
  <xsl:param name="next_node" select="key('idkey', $next_id)"/>
</xsl:template>


<!--**==========================================================================
db2html.division.bottom
FIXME

REMARK: Describe this template
-->
<xsl:template name="db2html.division.bottom">
  <xsl:param name="node"/>
  <xsl:param name="info"/>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="prev_id">
    <xsl:choose>
      <xsl:when test="$depth_of_chunk = 0 and $info">
        <xsl:if test="$info">
          <xsl:value-of select="$db.chunk.info_basename"/>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="db.chunk.chunk-id.axis">
          <xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="axis" select="'previous'"/>
          <xsl:with-param name="depth_in_chunk" select="0"/>
          <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="next_id">
    <xsl:call-template name="db.chunk.chunk-id.axis">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="axis" select="'next'"/>
      <xsl:with-param name="depth_in_chunk" select="0"/>
      <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="prev_node" select="key('idkey', $prev_id)"/>
  <xsl:param name="next_node" select="key('idkey', $next_id)"/>
  <xsl:call-template name="db2html.division.navbar">
    <xsl:with-param name="node" select="$node"/>
    <xsl:with-param name="info" select="$info"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
    <xsl:with-param name="prev_id" select="$prev_id"/>
    <xsl:with-param name="next_id" select="$next_id"/>
    <xsl:with-param name="prev_node" select="$prev_node"/>
    <xsl:with-param name="next_node" select="$next_node"/>
  </xsl:call-template>
</xsl:template>


<!--**==========================================================================
db2html.division.div
Renders the content of a division element, chunking children if necessary
$node: The element to render the content of
$info: The info child element of ${node}
$title_content: The title for divisions lacking a #{title} tag
$entries: The entry-style child elements
$divisions: The division-level child elements
$depth_in_chunk: The depth of ${node} in the containing chunk
$depth_of_chunk: The depth of the containing chunk in the document
$chunk_divisions: Whether to create new documents for ${divisions}
$chunk_info: Whether to create a new document for a title page
$autotoc_depth: How deep to create contents listings of ${divisions}

REMARK: Talk about some of the parameters
-->
<xsl:template name="db2html.division.div">
  <xsl:param name="node" select="."/>
  <xsl:param name="title_content"/>
  <xsl:param name="info"/>
  <xsl:param name="entries" select="/false"/>
  <xsl:param name="divisions" select="/false"/>
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>
  <!-- FIXME: these two parameters don't make much sense now -->
  <xsl:param name="chunk_divisions"
             select="($depth_in_chunk = 0) and
                     ($depth_of_chunk &lt; $db.chunk.max_depth)"/>
  <xsl:param name="chunk_info"
             select="($depth_of_chunk = 0) and
                     ($depth_in_chunk = 0 and $info)"/>
  <xsl:param name="autotoc_depth" select="number(boolean($chunk_divisions))"/>

  <div class="{local-name($node)}">
    <xsl:call-template name="db2html.anchor">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <xsl:variable name="titles" select="$node/title | $node/subtitle"/>
    <xsl:choose>
      <xsl:when test="$titles">
        <xsl:apply-templates select="$titles">
          <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk + 1"/>
          <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$info and $info/title">
        <xsl:apply-templates select="$info/title">
          <xsl:with-param name="referent" select="$node"/>
          <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk + 1"/>
          <xsl:with-param name="referent_depth_in_chunk" select="$depth_in_chunk"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$info/subtitle">
          <xsl:with-param name="referent" select="$node"/>
          <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk + 1"/>
          <xsl:with-param name="referent_depth_in_chunk" select="$depth_in_chunk"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$title_content">
        <xsl:call-template name="db2html.title.header">
          <xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="referent" select="$node"/>
          <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk + 1"/>
          <xsl:with-param name="referent_depth_in_chunk" select="$depth_in_chunk"/>
          <xsl:with-param name="title_content" select="$title_content"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
    <xsl:if test="$autotoc_depth != 0">
      <xsl:call-template name="db2html.autotoc">
        <xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="info" select="$info"/>
        <xsl:with-param name="divisions" select="$divisions"/>
        <xsl:with-param name="toc_depth" select="number($autotoc_depth)"/>
        <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:variable name="nots" select="$divisions | $entries | $titles"/>
    <xsl:apply-templates select="*[not(. = $nots)]">
      <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk + 1"/>
      <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
    </xsl:apply-templates>
    <xsl:if test="$entries">
      <dl class="{local-name($node)}">
        <xsl:apply-templates select="$entries">
          <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk + 1"/>
          <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
        </xsl:apply-templates>
      </dl>
    </xsl:if>
    <xsl:if test="not($chunk_divisions)">
      <xsl:apply-templates select="$divisions">
        <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk + 1"/>
        <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
      </xsl:apply-templates>
    </xsl:if>
    <xsl:if test="$depth_in_chunk = 0">
      <xsl:call-template name="db2html.footnote.footer">
        <xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
      </xsl:call-template>
    </xsl:if>
  </div>
</xsl:template>


<!--**==========================================================================
db2html.division.navbar
FIXME

REMARK: Document this template
-->
<xsl:template name="db2html.division.navbar">
  <xsl:param name="node"/>
  <xsl:param name="info"/>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="prev_id">
    <xsl:choose>
      <xsl:when test="$depth_of_chunk = 0 and $info">
        <xsl:if test="$info">
          <xsl:value-of select="$db.chunk.info_basename"/>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="db.chunk.chunk-id.axis">
          <xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="axis" select="'previous'"/>
          <xsl:with-param name="depth_in_chunk" select="0"/>
          <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="next_id">
    <xsl:call-template name="db.chunk.chunk-id.axis">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="axis" select="'next'"/>
      <xsl:with-param name="depth_in_chunk" select="0"/>
      <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="prev_node" select="key('idkey', $prev_id)"/>
  <xsl:param name="next_node" select="key('idkey', $next_id)"/>
  <div class="navbar">
    <xsl:if test="($info and $depth_of_chunk = 0) or $prev_node">
      <xsl:variable name="class">
        <xsl:text>navbar-prev</xsl:text>
        <xsl:if test="not($next_node)">
          <xsl:text> navbar-prev-sans-next</xsl:text>
        </xsl:if>
      </xsl:variable>
      <div class="{$class}">
        <span class="{$class}">
          <a class="navbar {$class}">
            <xsl:attribute name="href">
              <xsl:call-template name="db.xref.target">
                <xsl:with-param name="linkend" select="$prev_id"/>
                <xsl:with-param name="is_chunk" select="true()"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:choose>
              <xsl:when test="$depth_of_chunk = 0">
                <!-- FIXME: don't use db.label for this -->
                <xsl:variable name="label">
                  <xsl:call-template name="db.label">
                    <xsl:with-param name="node" select="$info"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:attribute name="title">
                  <xsl:value-of select="normalize-space($label)"/>
                </xsl:attribute>
                <xsl:value-of select="$label"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="title">
                  <xsl:call-template name="db.xref.tooltip">
                    <xsl:with-param name="linkend" select="$prev_id"/>
                    <xsl:with-param name="target"  select="$prev_node"/>
                  </xsl:call-template>
                </xsl:attribute>
                <xsl:call-template name="db.titleabbrev">
                  <xsl:with-param name="node" select="$prev_node"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </a>
        </span>
      </div>
    </xsl:if>
    <xsl:if test="$next_node">
      <xsl:variable name="class">
        <xsl:text>navbar-next</xsl:text>
        <xsl:if test="not($prev_node)">
          <xsl:text> navbar-next-sans-prev</xsl:text>
        </xsl:if>
      </xsl:variable>
      <div class="{$class}">
        <span class="{$class}">
          <a class="navbar {$class}">
            <xsl:attribute name="href">
              <xsl:call-template name="db.xref.target">
                <xsl:with-param name="linkend" select="$next_id"/>
                <xsl:with-param name="is_chunk" select="true()"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="title">
              <xsl:call-template name="db.xref.tooltip">
                <xsl:with-param name="linkend" select="$next_id"/>
                <xsl:with-param name="target"  select="$next_node"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:call-template name="db.titleabbrev">
              <xsl:with-param name="node" select="$next_node"/>
            </xsl:call-template>
          </a>
        </span>
      </div>
    </xsl:if>
  </div>
</xsl:template>


<!--%%==========================================================================
db.chunk.content.mode
FIXME
$depth_of_chunk: The depth of the containing chunk in the document

REMARK: Document this mode
-->
<xsl:template mode="db.chunk.content.mode" match="*">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.html">
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = appendix % db.chunk.content.mode = -->
<xsl:template mode="db.chunk.content.mode" match="appendix">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.html">
    <xsl:with-param name="info" select="appendixinfo"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = article % db.chunk.content.mode = -->
<xsl:template mode="db.chunk.content.mode" match="article">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.html">
    <xsl:with-param name="info" select="articleinfo"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = bibliography % db.chunk.content.mode = -->
<xsl:template mode="db.chunk.content.mode" match="bibliography">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.html">
    <xsl:with-param name="info" select="bibliographyinfo"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = book % db.chunk.content.mode = -->
<xsl:template mode="db.chunk.content.mode" match="book">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.html">
    <xsl:with-param name="info" select="bookinfo"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = chapter % db.chunk.content.mode = -->
<xsl:template mode="db.chunk.content.mode" match="chapter">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.html">
    <xsl:with-param name="info" select="chapterinfo"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = glossary % db.chunk.content.mode = -->
<xsl:template mode="db.chunk.content.mode" match="glossary">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.html">
    <xsl:with-param name="info" select="glossaryinfo"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = part % db.chunk.content.mode = -->
<xsl:template mode="db.chunk.content.mode" match="part">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.html">
    <xsl:with-param name="info" select="partinfo"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = preface % db.chunk.content.mode = -->
<xsl:template mode="db.chunk.content.mode" match="preface">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.html">
    <xsl:with-param name="info" select="prefaceinfo"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = sect1 % db.chunk.content.mode = -->
<xsl:template mode="db.chunk.content.mode" match="sect1">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.html">
    <xsl:with-param name="info" select="sect1info"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = sect2 % db.chunk.content.mode = -->
<xsl:template mode="db.chunk.content.mode" match="sect2">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.html">
    <xsl:with-param name="info" select="sect2info"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = sect3 % db.chunk.content.mode = -->
<xsl:template mode="db.chunk.content.mode" match="sect3">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.html">
    <xsl:with-param name="info" select="sect3info"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = sect4 % db.chunk.content.mode = -->
<xsl:template mode="db.chunk.content.mode" match="sect4">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.html">
    <xsl:with-param name="info" select="sect4info"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = sect5 % db.chunk.content.mode = -->
<xsl:template mode="db.chunk.content.mode" match="sect5">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.html">
    <xsl:with-param name="info" select="sect5info"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = section % db.chunk.content.mode = -->
<xsl:template mode="db.chunk.content.mode" match="section">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.html">
    <xsl:with-param name="info" select="sectioninfo"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>


<!-- == Matched Templates == -->

<!-- = appendix = -->
<xsl:template match="appendix">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.div">
    <xsl:with-param name="divisions" select="
                    bibliography | glossary | index      | lot | refentry |
                    sect1        | section  | simplesect | toc "/>
    <xsl:with-param name="info" select="appendixinfo"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = article = -->
<xsl:template match="article">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.div">
    <xsl:with-param name="divisions" select="
                    appendix | bibliography | glossary | index      | lot |
                    refentry | sect1        | section  | simplesect | toc "/>
    <xsl:with-param name="info" select="articleinfo"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = book = -->
<xsl:template match="book">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.div">
    <xsl:with-param name="divisions" select="
                    appendix | article    | bibliography | chapter   |
                    colophon | dedication | glossary     | index     |
                    lot      | part       | preface      | reference |
                    setindex | toc        "/>
    <xsl:with-param name="info" select="bookinfo"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
    <xsl:with-param name="autotoc_depth" select="boolean(part | reference) + 1"/>
  </xsl:call-template>
</xsl:template>

<!-- = chapter = -->
<xsl:template match="chapter">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.div">
    <xsl:with-param name="divisions" select="
                    bibliography | glossary | index      | lot | refentry |
                    sect1        | section  | simplesect | toc "/>
    <xsl:with-param name="info" select="chapterinfo"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = dedication = -->
<xsl:template match="dedication">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.div">
    <xsl:with-param name="title_content">
      <xsl:if test="not(title)">
        <xsl:call-template name="l10n.gettext">
          <xsl:with-param name="msgid" select="'Dedication'"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:with-param>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = glossary = -->
<xsl:template match="glossary">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.div">
    <xsl:with-param name="entries" select="glossentry"/>
    <xsl:with-param name="divisions" select="glossdiv | bibliography"/>
    <xsl:with-param name="title_content">
      <xsl:if test="not(title) and not(glossaryinfo/title)">
        <xsl:call-template name="l10n.gettext">
          <xsl:with-param name="msgid" select="'Glossary'"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:with-param>
    <xsl:with-param name="info" select="glossaryinfo"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
    <xsl:with-param name="chunk_divisions" select="false()"/>
  </xsl:call-template>
</xsl:template>

<!-- = glossdiv = -->
<xsl:template match="glossdiv">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.div">
    <xsl:with-param name="entries" select="glossentry"/>
    <xsl:with-param name="divisions" select="bibliography"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = part = -->
<xsl:template match="part">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.div">
    <xsl:with-param name="divisions" select="
                    appendix | article   | bibliography | chapter |
                    glossary | index     | lot          | preface |
                    refentry | reference | toc          "/>
    <xsl:with-param name="info" select="partinfo"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = preface = -->
<xsl:template match="preface">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.div">
    <xsl:with-param name="divisions" select="
                    refentry | simplesect | sect1    | section      | toc  |
                    lot      | index      | glossary | bibliography "/>
    <xsl:with-param name="info" select="prefaceinfo"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = sect1 = -->
<xsl:template match="sect1">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.div">
    <xsl:with-param name="divisions" select="
                    bibliography | glossary | index      | lot |
                    refentry     | sect2    | simplesect | toc "/>
    <xsl:with-param name="info" select="sect1info"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = sect2 = -->
<xsl:template match="sect2">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.div">
    <xsl:with-param name="divisions" select="
                    bibliography | glossary | index      | lot |
                    refentry     | sect3    | simplesect | toc "/>
    <xsl:with-param name="info" select="sect2info"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = sect3 = -->
<xsl:template match="sect3">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.div">
    <xsl:with-param name="divisions" select="
                    bibliography | glossary | index      | lot |
                    refentry     | sect4    | simplesect | toc "/>
    <xsl:with-param name="info" select="sect3info"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = sect4 = -->
<xsl:template match="sect4">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.div">
    <xsl:with-param name="divisions" select="
                    bibliography | glossary | index      | lot |
                    refentry     | sect5    | simplesect | toc "/>
    <xsl:with-param name="info" select="sect4info"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = sect5 = -->
<xsl:template match="sect5">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.div">
    <xsl:with-param name="divisions" select="
                    bibliography | glossary   | index | lot |
                    refentry     | simplesect | toc   "/>
    <xsl:with-param name="info" select="sect5info"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = section = -->
<xsl:template match="section">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.div">
    <xsl:with-param name="divisions" select="
                    bibliography | glossary | index      | lot |
                    refentry     | section  | simplesect | toc "/>
    <xsl:with-param name="info" select="sectioninfo"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = simplesect = -->
<xsl:template match="simplesect">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.div">
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
