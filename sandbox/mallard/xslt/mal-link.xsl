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
                version="1.0">

<!--!!==========================================================================
Mallard Links
-->


<!--**==========================================================================
mal.link.content
Generates the content for a #{link} element
$node: FIXME
$xref: FIXME
-->
<xsl:template name="mal.link.content">
  <xsl:param name="node" select="."/>
  <xsl:param name="xref" select="$node/@xref"/>
  <xsl:variable name="linkid">
    <xsl:choose>
      <xsl:when test="contains($xref, '#')">
        <xsl:value-of select="$xref"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($xref, '#', $xref)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:for-each select="$cache">
    <!-- FIXME: if empty -->
    <xsl:apply-templates mode="mal2html.inline.mode"
                         select="key('cache_key', $linkid)
                                 /mal:info/mal:title[@type = 'link']/node()"/>
  </xsl:for-each>
</xsl:template>


<!--**==========================================================================
mal.link.target
Generates the target for a #{link} element
$node: FIXME
$xref: FIXME
-->
<xsl:template name="mal.link.target">
  <xsl:param name="node" select="."/>
  <xsl:param name="xref" select="$node/@xref"/>
  <!-- FIXME -->
  <xsl:choose>
    <xsl:when test="contains($xref, '#')">
      <xsl:variable name="page" select="substring-before($xref, '#')"/>
      <xsl:variable name="sect" select="substring-after($xref, '#')"/>
      <xsl:if test="$page != ''">
        <xsl:value-of select="concat($page, $mal.extension)"/>
      </xsl:if>
      <xsl:value-of select="concat('#', $sect)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat($xref, $mal.extension)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--**==========================================================================
mal.link.tooltip
Generates the tooltip for a #{link} element
$node: FIXME
$xref: FIXME
$href: FIXME
-->
<xsl:template name="mal.link.tooltip">
  <xsl:param name="node" select="."/>
  <xsl:param name="xref" select="$node/@xref"/>
  <xsl:param name="href" select="$node/@href"/>
  <xsl:choose>
    <xsl:when test="$xref">
      <!-- FIXME -->
    </xsl:when>
    <xsl:when test="starts-with($href, 'mailto:')">
      <xsl:variable name="addy" select="substring-after($href, 'mailto:')"/>
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'email.tooltip'"/>
        <xsl:with-param name="string" select="$addy"/>
        <xsl:with-param name="format" select="true()"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="normalize-space($href)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
