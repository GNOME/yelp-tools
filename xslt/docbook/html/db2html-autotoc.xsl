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
DocBook to HTML - Tables of Contents
:Requires: db-label db-xref db2html-xref

REMARK: Write some intro material here
-->


<!--**==========================================================================
db2html.autotoc
Creates a table of contents for a given element
$node: The element to create a table of contents for
$selected: A currently-selected page
$divisions: The division-level child elements of ${node}
$labels: Whether to generate labels
$titleabbrev: Whether to use #{titleabbrev} instead of #{title}

REMARK: Extra explanation of the parameters would be good
-->
<xsl:template name="db2html.autotoc">
  <xsl:param name="node" select="."/>
  <xsl:param name="selected" select="false()"/>
  <xsl:param name="divisions"/>
  <xsl:param name="toc_depth" select="1"/>
  <xsl:param name="labels" select="true()"/>
  <xsl:param name="titleabbrev" select="false()"/>
  <div class="autotoc">
    <ul>
      <xsl:for-each select="$divisions">
        <xsl:if test="($selected = false()) or ($node = $selected/ancestor-or-self::*)">
          <xsl:apply-templates mode="db2html.autotoc.mode" select=".">
            <xsl:with-param name="selected" select="$selected"/>
            <xsl:with-param name="toc_depth" select="$toc_depth - 1"/>
            <xsl:with-param name="labels" select="$labels"/>
            <xsl:with-param name="titleabbrev" select="$titleabbrev"/>
          </xsl:apply-templates>
        </xsl:if>
      </xsl:for-each>
    </ul>
  </div>
</xsl:template>


<!--%%==========================================================================
db2html.autotoc.mode
Renders a TOC entry for an element and its children
$selected: A currently-selected page
$toc_depth: How deep to create entries in the table of contents
$labels: Whether to generate labels
$titleabbrev: Whether to use #{titleabbrev} instead of #{title}

REMARK: Describe this mode
-->
<xsl:template mode="db2html.autotoc.mode" match="*">
  <xsl:param name="selected" select="false()"/>
  <xsl:param name="toc_depth" select="0"/>
  <xsl:param name="labels" select="true()"/>
  <xsl:param name="titleabbrev" select="false()"/>
  <xsl:variable name="xrefstyle">
    <xsl:text>role:title</xsl:text>
    <xsl:if test="$titleabbrev">
      <xsl:text>abbrev</xsl:text>
    </xsl:if>
  </xsl:variable>
  <li>
    <xsl:if test="$labels">
      <span class="label">
        <xsl:call-template name="db.label">
          <xsl:with-param name="node" select="."/>
          <xsl:with-param name="role" select="'li'"/>
        </xsl:call-template>
      </span>
    </xsl:if>
    <xsl:choose>
      <xsl:when test=". = $selected">
        <xsl:call-template name="db.xref.content">
          <xsl:with-param name="linkend" select="@id"/>
          <xsl:with-param name="target" select="."/>
          <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="db2html.xref">
          <xsl:with-param name="linkend" select="@id"/>
          <xsl:with-param name="target" select="."/>
          <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$toc_depth &gt; 0">
      <xsl:call-template name="db2html.autotoc">
        <xsl:with-param name="selected" select="$selected"/>
        <xsl:with-param name="toc_depth" select="$toc_depth"/>
        <xsl:with-param name="divisions"
                        select="*[contains($db.chunk.chunks_,
                                    concat(' ', local-name(.), ' '))]"/>
        <xsl:with-param name="labels" select="$labels"/>
        <xsl:with-param name="titleabbrev" select="$titleabbrev"/>
      </xsl:call-template>
    </xsl:if>
  </li>
</xsl:template>

<!-- = refentry % db2html.autotoc.mode = -->
<xsl:template mode="db2html.autotoc.mode" match="refentry">
  <xsl:param name="selected" select="false()"/>
  <xsl:param name="toc_depth" select="0"/>
  <xsl:param name="labels" select="true()"/>
  <xsl:param name="titleabbrev" select="false()"/>
  <xsl:variable name="xrefstyle">
    <xsl:text>role:title</xsl:text>
    <xsl:if test="$titleabbrev">
      <xsl:text>abbrev</xsl:text>
    </xsl:if>
  </xsl:variable>
  <li>
    <xsl:call-template name="db2html.xref">
      <xsl:with-param name="linkend" select="@id"/>
      <xsl:with-param name="target" select="."/>
      <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    </xsl:call-template>
    <xsl:if test="refnamediv/refpurpose">
      <!-- FIXME: I18N -->
      <xsl:text> — </xsl:text>
      <xsl:apply-templates select="refnamediv/refpurpose[1]"/>
    </xsl:if>
  </li>
</xsl:template>

</xsl:stylesheet>
