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
DocBook to HTML - Admonitions

This module handles DocBook's admonition elements.  Admonitions are used to set
off small blocks of text which provide auxiliary information to the reader.
DocBook's admonitions come in five flavors: #{caution}, #{important}, #{note},
#{tip}, and #{warning}.

Admontions are wrapped in colored blocks with leading icons.  Each admonition
has its own icon, the base name of which is exactly the name of the admonition
element.  You can control where these icons are located and what their file
extensions are.
-->


<!--@@==========================================================================
db2html.admon.border_color
The color of the border around admonition elements

REMARK: Describe this parameter
-->
<xsl:param name="db2html.admon.border_color" select="'#D1940C'"/>


<!--@@==========================================================================
db2html.admon.graphics_path
The path to admonition graphics

This path is inserted into the HTML output, so it may be a fully-qualified URL.
-->
<xsl:param name="db2html.admon.graphics_path"/>


<!--@@==========================================================================
db2html.admon.graphics_size
The size of admonition graphics in pixels

As well as allowing the width and height to be specified in the HTML, various
offsets are also computed from the size of the admonition icons.  Admonition
icons are assumed to be square, so the size refers to the lenght in one
dimension.
-->
<xsl:param name="db2html.admon.graphics_size" select="48"/>


<!--@@==========================================================================
db2html.admon.graphics_extension
The file extension for admonition icons

This is appended to the name of the admonition (one of #{caution}, #{important},
#{note}, #{tip}, or #{warning}) to produce the file name of the icon.
-->
<xsl:param name="db2html.admon.graphics_extension" select="'.png'"/>


<!--**==========================================================================
db2html.admon
Renders an admonition element into HTML
$node: The element to render

REMARK: Describe this template.
-->
<xsl:template name="db2html.admon">
  <xsl:param name="node" select="."/>
  <div class="admonition block-indent {local-name(.)}">
    <xsl:apply-templates select="$node/node()"/>
  </div>
</xsl:template>


<!--**==========================================================================
db2html.admon.css
Outputs CSS that controls the appearance of admonition elements

REMARK: Describe this template.
-->
<xsl:template name="db2html.admon.css">
<xsl:text>
div.admonition {
  padding: 4px 8px 4px </xsl:text>
  <xsl:value-of select="$db2html.admon.graphics_size + 8"/><xsl:text>px;
  min-height: </xsl:text>
  <xsl:value-of select="$db2html.admon.graphics_size + 4"/><xsl:text>px;
  border: solid 1px </xsl:text>
  <xsl:value-of select="$db2html.admon.border_color"/><xsl:text>;
  background-position: 4px 4px;
  background-repeat: no-repeat;
}
div.caution {
  background-image: url("</xsl:text>
  <xsl:value-of select="$db2html.admon.graphics_path"/>
  <xsl:text>caution</xsl:text>
  <xsl:value-of select="$db2html.admon.graphics_extension"/><xsl:text>");
}
div.important {
  background-image: url("</xsl:text>
  <xsl:value-of select="$db2html.admon.graphics_path"/>
  <xsl:text>important</xsl:text>
  <xsl:value-of select="$db2html.admon.graphics_extension"/><xsl:text>");
}
div.note {
  background-image: url("</xsl:text>
  <xsl:value-of select="$db2html.admon.graphics_path"/>
  <xsl:text>note</xsl:text>
  <xsl:value-of select="$db2html.admon.graphics_extension"/><xsl:text>");
}
div.tip {
  background-image: url("</xsl:text>
  <xsl:value-of select="$db2html.admon.graphics_path"/>
  <xsl:text>tip</xsl:text>
  <xsl:value-of select="$db2html.admon.graphics_extension"/><xsl:text>");
}
div.warning {
  background-image: url("</xsl:text>
  <xsl:value-of select="$db2html.admon.graphics_path"/>
  <xsl:text>warning</xsl:text>
  <xsl:value-of select="$db2html.admon.graphics_extension"/><xsl:text>");
}
</xsl:text>
</xsl:template>


<!-- == Matched Templates == -->

<!-- = caution = -->
<xsl:template match="caution">
  <xsl:call-template name="db2html.admon"/>
</xsl:template>

<!-- = caution/title = -->
<xsl:template match="caution/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

<!-- = important = -->
<xsl:template match="important">
  <xsl:call-template name="db2html.admon"/>
</xsl:template>

<!-- = important/title = -->
<xsl:template match="important/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

<!-- = note = -->
<xsl:template match="note">
  <xsl:call-template name="db2html.admon"/>
</xsl:template>

<!-- = note/title = -->
<xsl:template match="note/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

<!-- = tip = -->
<xsl:template match="tip">
  <xsl:call-template name="db2html.admon"/>
</xsl:template>

<!-- = tip/title = -->
<xsl:template match="tip/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

<!-- = warning = -->
<xsl:template match="warning">
  <xsl:call-template name="db2html.admon"/>
</xsl:template>

<!-- = warning/title = -->
<xsl:template match="warning/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

</xsl:stylesheet>
