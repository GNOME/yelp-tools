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
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Footnotes</doc:title>


<!-- == db2html.footnote.ref =============================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.footnote.ref</name>
  <purpose>
    Generate a superscript with the footnote number and link
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The footnote to process
    </purpose>
  </parameter>
</template>

<xsl:template name="db2html.footnote.ref">
  <xsl:param name="node" select="."/>
  <xsl:variable name="anchor">
    <xsl:text>-noteref-</xsl:text>
    <xsl:choose>
      <xsl:when test="$node/@id">
	<xsl:value-of select="$node/@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="generate-id($node)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="href">
    <xsl:text>#</xsl:text>
    <xsl:choose>
      <xsl:when test="$node/@id">
	<xsl:value-of select="$node/@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>-note-</xsl:text>
        <xsl:value-of select="generate-id($node)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <a name="{$anchor}"/>
  <sup>
    <a class="footnote" href="{$href}">
      <xsl:call-template name="db.number">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
    </a>
  </sup>
</xsl:template>


<!-- == db2html.footnote.note ============================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.footnote.note</name>
  <purpose>
    Generate a footnote
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The footnote to process
    </purpose>
  </parameter>
</template>

<xsl:template name="db2html.footnote.note">
  <xsl:param name="node" select="."/>
  <xsl:variable name="anchor">
    <xsl:choose>
      <xsl:when test="$node/@id">
	<xsl:value-of select="$node/@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>-note-</xsl:text>
        <xsl:value-of select="generate-id($node)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="href">
    <xsl:text>#</xsl:text>
    <xsl:text>-noteref-</xsl:text>
    <xsl:choose>
      <xsl:when test="$node/@id">
	<xsl:value-of select="$node/@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="generate-id($node)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <div class="footnote">
    <a name="{$anchor}"/>
    <span class="footnote-number">
      <a class="footnote-ref" href="{$href}">
        <xsl:call-template name="db.number">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
      </a>
    </span>
    <xsl:apply-templates select="$node/node()"/>
  </div>
</xsl:template>


<!-- == db2html.footnote.footer ============================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.footnote.footer</name>
  <purpose>
    Generate a footer containing all the footnotes in the chunk
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The node to process
    </purpose>
  </parameter>
  <parameter>
    <name>depth_of_chunk</name>
    <purpose>
      The depth of the containing chunk in the document
    </purpose>
  </parameter>
</template>

<xsl:template name="db2html.footnote.footer">
  <xsl:param name="node" select="."/>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:variable name="notes" select="$node//footnote" />
  <xsl:if test="count($notes) != 0">
    <xsl:call-template name="db2html.footnote.footer.sibling">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
      <xsl:with-param name="notes" select="$notes"/>
      <xsl:with-param name="pos" select="1"/>
      <xsl:with-param name="div" select="false()"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="db2html.footnote.footer.sibling" doc:private="true">
  <xsl:param name="node"/>
  <xsl:param name="depth_of_chunk"/>
  <xsl:param name="notes"/>
  <xsl:param name="pos"/>
  <xsl:param name="div"/>
  <xsl:variable name="this" select="$notes[$pos]"/>
  <xsl:variable name="depth">
    <xsl:call-template name="db.chunk.depth-of-chunk">
      <xsl:with-param name="node" select="$this"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="($depth = $depth_of_chunk) and not($div)">
      <div class="footnotes">
        <xsl:call-template name="db2html.footnote.note">
          <xsl:with-param name="node" select="$this"/>
        </xsl:call-template>
        <xsl:if test="$pos &lt; count($notes)">
          <xsl:call-template name="db2html.footnote.footer.sibling">
            <xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
            <xsl:with-param name="notes" select="$notes"/>
            <xsl:with-param name="pos" select="$pos + 1"/>
            <xsl:with-param name="div" select="true()"/>
          </xsl:call-template>
        </xsl:if>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="$depth = $depth_of_chunk">
        <xsl:call-template name="db2html.footnote.note">
          <xsl:with-param name="node" select="$this"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="$pos &lt; count($notes)">
        <xsl:call-template name="db2html.footnote.footer.sibling">
          <xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
          <xsl:with-param name="notes" select="$notes"/>
          <xsl:with-param name="pos" select="$pos + 1"/>
          <xsl:with-param name="div" select="$div"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- == db2html.footnote.css ================================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.footnote.css</name>
  <purpose>
    Create CSS for the footnote elements
  </purpose>
</template>

<xsl:template name="db2html.footnote.css">
  <xsl:text>
    div[class~="footnotes"] {
      font-style: italic;
      font-size: 0.8em;
    }
    div[class~="footnote"] {
      margin-top: 1.44em;
    }
    span[class~="footnote-number"] {
      display: inline;
      padding-right: 0.83em;
    }
    span[class~="footnote-number"] + p {
      display: inline;
    }
    a[class~="footnote"] {
      text-decoration: none;
      font-size: 0.8em;
    }
    a[class~="footnote-ref"] {
      text-decoration: none;
    }
  </xsl:text>
</xsl:template>


<!-- == Matched Templates ================================================== -->

<!-- = footnote = -->
<xsl:template match="footnote">
  <xsl:call-template name="db2html.footnote.ref"/>
</xsl:template>

</xsl:stylesheet>
