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

<doc:title>Callout Elements</doc:title>


<!-- == Color Parameters =================================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.co.color</name>
  <purpose>
    The text color for callout dingbats
  </purpose>
</parameter>
<xsl:param name="db2html.co.color" select="'#FFFFFF'"/>

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.co.background_color</name>
  <purpose>
    The background color for callout dingbats
  </purpose>
</parameter>
<xsl:param name="db2html.co.background_color" select="'#000000'"/>

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.co.border_color</name>
  <purpose>
    The border color for callout dingbats
  </purpose>
</parameter>
<xsl:param name="db2html.co.border_color" select="'#000000'"/>

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.co.color.hover</name>
  <purpose>
    The hover text color for callout dingbats
  </purpose>
</parameter>
<xsl:param name="db2html.co.color.hover" select="'#FFFFFF'"/>

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.co.background_color.hover</name>
  <purpose>
    The hover background color for callout dingbat
  </purpose>
</parameter>
<xsl:param name="db2html.co.background_color.hover" select="'#333333'"/>

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.co.border_color.hover</name>
  <purpose>
    The hover border color for callout dingbats
  </purpose>
</parameter>
<xsl:param name="db2html.co.border_color.hover" select="'#333333'"/>


<!-- == db2html.callout.css ================================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.callout.css</name>
  <purpose>
    Create CSS for the callout elements
  </purpose>
</template>

<xsl:template name="db2html.callout.css">
  <xsl:text>
    span[class~="co"] {
      font-size: 8px;
      padding-left:  0.4em;
      padding-right: 0.4em;
      margin-left:   0.2em;
      margin-right:  0.2em;
      border: solid 1px;
      -moz-border-radius: 8px;
      color: </xsl:text>
      <xsl:value-of select="$db2html.co.color"/><xsl:text>;
      background-color: </xsl:text>
      <xsl:value-of select="$db2html.co.background_color"/><xsl:text>;
      border-color: </xsl:text>
      <xsl:value-of select="$db2html.co.border_color"/><xsl:text>;
    }
    span[class~="co"]:hover {
      color: </xsl:text>
      <xsl:value-of select="$db2html.co.color.hover"/><xsl:text>;
      background-color: </xsl:text>
      <xsl:value-of select="$db2html.co.background_color.hover"/><xsl:text>;
      border-color: </xsl:text>
      <xsl:value-of select="$db2html.co.border_color.hover"/><xsl:text>;
    }
    span[class~="co"] a { text-decoration: none; }
    span[class~="co"] a:hover { text-decoration: none; }
  </xsl:text>
</xsl:template>


<!-- == db2html.co.dingbat ================================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.co.dingbat</name>
  <purpose>
    Render the dingbat for a callout
  </purpose>
  <parameter>
    <name>co</name>
    <purpose>
      The <xmltag>co</xmltag> element for which to render a dingbat
    </purpose>
  </parameter>
</template>

<xsl:template name="db2html.co.dingbat">
  <xsl:param name="co" select="."/>
  <span class="co">
    <xsl:value-of select="count(preceding::co) + 1"/>
  </span>
</xsl:template>


<!-- == db2html.co.dingbats ================================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.co.dingbats</name>
  <purpose>
    Render a dingbat for each <xmltag>co</xmltag> referenced in the
    <parameter>arearefs</parameter> parameter
  </purpose>
  <parameter>
    <name>arearefs</name>
    <purpose>
      A space-seperated list of <xmltag>co</xmltag> elements
    </purpose>
  </parameter>
</template>

<xsl:template name="db2html.co.dingbats">
  <xsl:param name="arearefs" select="@arearefs"/>
  <!-- FIXME -->
</xsl:template>


<!-- == Matched Templates ================================================== -->

<!-- = co = -->
<xsl:template match="co">
  <xsl:call-template name="db2html.co.dingbat"/>
</xsl:template>

</xsl:stylesheet>
