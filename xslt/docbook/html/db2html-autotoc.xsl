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
                xmlns:html="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="html"
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
$show_info: Whether to include a link to the info page
$is_info: Whether this contents list is for the info page
$show_title: Whether to give the contents list a title
$selected: A currently-selected page
$divisions: The division-level child elements of ${node}
$labels: Whether to generate labels
$titleabbrev: Whether to use #{titleabbrev} instead of #{title}

REMARK: Extra explanation of the parameters would be good
-->
<xsl:template name="db2html.autotoc">
  <xsl:param name="node" select="."/>
  <xsl:param name="show_info" select="false()"/>
  <xsl:param name="is_info" select="false()"/>
  <xsl:param name="show_title" select="false()"/>
  <xsl:param name="selected" select="false()"/>
  <xsl:param name="divisions"/>
  <xsl:param name="toc_depth" select="1"/>
  <xsl:param name="labels" select="true()"/>
  <xsl:param name="titleabbrev" select="false()"/>
  <xsl:if test="($selected = false()) or ($node = $selected/ancestor-or-self::*)">
    <html:div class="autotoc">
      <xsl:if test="$show_title">
        <html:div class="title autotoc-title">
          <xsl:call-template name="l10n.gettext">
            <xsl:with-param name="msgid" select="'Contents'"/>
          </xsl:call-template>
        </html:div>
      </xsl:if>
      <html:ul>
        <xsl:if test="$show_info">
          <html:li>
            <xsl:choose>
              <xsl:when test="$is_info">
                <xsl:call-template name="l10n.gettext">
                  <xsl:with-param name="msgid" select="'About This Document'"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <html:a>
                  <xsl:attribute name="href">
                    <xsl:call-template name="db.xref.target">
                      <xsl:with-param name="linkend" select="$db.chunk.info_basename"/>
                      <xsl:with-param name="is_chunk" select="true()"/>
                    </xsl:call-template>
                  </xsl:attribute>
                  <xsl:variable name="text">
                    <xsl:call-template name="l10n.gettext">
                      <xsl:with-param name="msgid" select="'About This Document'"/>
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:attribute name="title">
                    <xsl:value-of select="$text"/>
                  </xsl:attribute>
                  <xsl:value-of select="$text"/>
                </html:a>
              </xsl:otherwise>
            </xsl:choose>
          </html:li>
        </xsl:if>
        <xsl:for-each select="$divisions">
          <xsl:apply-templates mode="db2html.autotoc.mode" select=".">
            <xsl:with-param name="is_info" select="$is_info"/>
            <xsl:with-param name="selected" select="$selected"/>
            <xsl:with-param name="toc_depth" select="$toc_depth - 1"/>
            <xsl:with-param name="labels" select="$labels"/>
            <xsl:with-param name="titleabbrev" select="$titleabbrev"/>
          </xsl:apply-templates>
        </xsl:for-each>
      </html:ul>
    </html:div>
  </xsl:if>
</xsl:template>


<!--%%==========================================================================
db2html.autotoc.mode
Renders a TOC entry for an element and its children
$is_info: Whether this contents list is for the info page
$selected: A currently-selected page
$toc_depth: How deep to create entries in the table of contents
$labels: Whether to generate labels
$titleabbrev: Whether to use #{titleabbrev} instead of #{title}

REMARK: Describe this mode
-->
<xsl:template mode="db2html.autotoc.mode" match="*">
  <xsl:param name="is_info" select="false()"/>
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
  <html:li>
    <xsl:if test="$labels">
      <html:span class="label">
        <xsl:call-template name="db.label">
          <xsl:with-param name="node" select="."/>
          <xsl:with-param name="role" select="'li'"/>
        </xsl:call-template>
      </html:span>
    </xsl:if>
    <xsl:choose>
      <xsl:when test=". = $selected and not($is_info)">
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
  </html:li>
</xsl:template>

<!-- = refentry % db2html.autotoc.mode = -->
<xsl:template mode="db2html.autotoc.mode" match="refentry">
  <xsl:param name="is_info" select="false()"/>
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
  <html:li>
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
  </html:li>
</xsl:template>

</xsl:stylesheet>
