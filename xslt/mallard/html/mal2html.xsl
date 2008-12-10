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

<xsl:include href="../common/mal-link.xsl"/>

<xsl:include href="mal2html-block.xsl"/>
<xsl:include href="mal2html-css.xsl"/>
<xsl:include href="mal2html-inline.xsl"/>
<xsl:include href="mal2html-list.xsl"/>
<xsl:include href="mal2html-media.xsl"/>
<xsl:include href="mal2html-page.xsl"/>
<xsl:include href="mal2html-table.xsl"/>

<xsl:include href="theme.xsl"/>
<xsl:include href="util.xsl"/>

<xsl:param name="mal.extension" select="'.xhtml'"/>

<!-- FIXME -->
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
