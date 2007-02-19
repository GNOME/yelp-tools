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
                xmlns:mal="http://www.gnome.org/~shaunm/mallard"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

<!--!!==========================================================================
Mallard to HTML

REMARK: Describe this module
-->

<xsl:include href="mal-link.xsl"/>

<xsl:include href="mal2html-block.xsl"/>
<xsl:include href="mal2html-css.xsl"/>
<xsl:include href="mal2html-inline.xsl"/>
<xsl:include href="mal2html-list.xsl"/>
<xsl:include href="mal2html-media.xsl"/>
<xsl:include href="mal2html-table.xsl"/>

<xsl:include href="util.xsl"/>

<xsl:param name="mal.extension" select="'.xhtml'"/>
<xsl:param name="mal.cache_file"/>
<xsl:variable name="cache" select="document($mal.cache_file)"/>
<xsl:key name="cache_page" match="$cache//mal:guide | $cache//mal:topic" use="@id"/>
<xsl:key name="cache_sect" match="$cache//mal:section"
         use="concat((ancestor::mal:guide | ancesotr::mal:topic)[1]/@id, '#', @id)"/>

<xsl:template match="/">
  <html>
    <head>
      <title>
        <xsl:value-of select="/*/mal:title"/>
      </title>
      <xsl:call-template name="mal2html.css"/>
    </head>
    <body>
      <div class="body">
        <xsl:apply-templates/>
      </div>
    </body>
  </html>
</xsl:template>

<!-- = guide = -->
<xsl:template match="mal:guide">
  <xsl:apply-templates mode="mal2html.block.mode"
                       select="*[not(self::mal:section)]"/>
  <xsl:for-each select="mal:info/mal:link[@type = 'page']">
    <xsl:choose>
      <xsl:when test="not(@xref)"/>
      <xsl:when test="contains(@xref, '#')">
        <div>
          <xsl:value-of select="key('cache_sect', @xref)/mal:title"/>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div>
          <xsl:value-of select="key('cache_page', @xref)/mal:title"/>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
  <xsl:apply-templates select="mal:section"/>
</xsl:template>

<!-- = topic = -->
<xsl:template match="mal:topic">
  <xsl:apply-templates mode="mal2html.block.mode"
                       select="*[not(self::mal:section)]"/>
  <xsl:apply-templates select="mal:section"/>
</xsl:template>

<!-- = section = -->
<xsl:template match="mal:section">
  <div class="section" id="{@id}">
    <xsl:apply-templates mode="mal2html.block.mode"/>
  </div>
</xsl:template>

<!-- = title = -->
<xsl:template mode="mal2html.block.mode" match="mal:title">
  <xsl:variable name="depth"
                select="count(ancestor::mal:section) + 1"/>
  <xsl:element name="{concat('h', $depth)}">
    <xsl:apply-templates mode="mal2html.inline.mode"/>
  </xsl:element>
</xsl:template>


<xsl:template match="*">
  <xsl:message>
    <xsl:text>Unmatched element: </xsl:text>
    <xsl:value-of select="local-name(.)"/>
  </xsl:message>
  <xsl:apply-templates/>
</xsl:template>

<!-- FIXME -->
<xsl:template name="l10n.gettext">
  <xsl:param name="msgid" select="'email.tooltip'"/>
  <xsl:value-of select="$msgid"/>
</xsl:template>
<xsl:template name="l10n.direction">
  <xsl:text>ltr</xsl:text>
</xsl:template>

</xsl:stylesheet>
