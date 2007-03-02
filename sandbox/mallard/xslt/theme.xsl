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
                xmlns:theme="http://www.gnome.org/~shaunm/gnome-doc-utils/theme"
                version="1.0">

<!--!!==========================================================================
Themes

REMARK: Describe this module
-->


<xsl:variable name="theme" select="document('theme.xml')"/>

<xsl:key name="theme_key" match="*[@id]" use="@id"/>


<!--**==========================================================================
theme.get_color
-->
<xsl:template name="theme.get_color">
  <xsl:param name="id"/>
  <xsl:for-each select="$theme">
    <xsl:value-of select="key('theme_key', $id)/@value"/>
  </xsl:for-each>
</xsl:template>


<!--**==========================================================================
theme.get_icon_src
-->
<xsl:template name="theme.get_icon_src">
  <xsl:param name="id"/>
  <xsl:for-each select="$theme">
    <xsl:value-of select="key('theme_key', $id)/@src"/>
  </xsl:for-each>
</xsl:template>


<!--**==========================================================================
theme.get_icon_width
-->
<xsl:template name="theme.get_icon_width">
  <xsl:param name="id"/>
  <xsl:for-each select="$theme">
    <xsl:value-of select="key('theme_key', $id)/@width"/>
  </xsl:for-each>
</xsl:template>


<!--**==========================================================================
theme.get_icon_height
-->
<xsl:template name="theme.get_height">
  <xsl:param name="id"/>
  <xsl:for-each select="$theme">
    <xsl:value-of select="key('theme_key', $id)/@height"/>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
