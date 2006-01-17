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


<!-- == db2html.footnote ===================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.footnote</name>
  <purpose>
    Generate a superscript with the footnote number and link
  </purpose>
</template>

<xsl:template name="db2html.footnote">
  <xsl:param name="node" select="."/>
  <xsl:param name="anchor">
    <xsl:text>ftn.</xsl:text>
    <xsl:choose>
      <xsl:when test="@id">
	<xsl:value-of select="@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="generate-id($node)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="href">
    <xsl:text>#</xsl:text>
    <xsl:choose>
      <xsl:when test="@id">
	<xsl:value-of select="@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="generate-id($node)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <a name="{$anchor}" />
  <sup>
    <a class="link" href="{$href}">
      <xsl:text>[</xsl:text>
      <xsl:call-template name="db2html.footnote.number"/>
      <xsl:text>]</xsl:text>
    </a>
  </sup>
</xsl:template>

<!-- == db2html.footnote,number ============================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.footnote.number</name>
  <purpose>
    Generates the appropriate number for a footnote.
  </purpose>
</template>

<xsl:template name="db2html.footnote.number">
  <xsl:variable name="number" select="count(preceding::footnote) + 1" />
  <xsl:number value="$number" /> 
</xsl:template>

<xsl:template name="process.footnotes">
  <xsl:variable name="footnotes" select=".//footnote" />
  <xsl:if test="$footnotes">
    <div class="footnotes">
      <hr width="100" align="left"/>
      <xsl:apply-templates select="$footnotes" mode="process.footnote.mode"/>
    </div>
  </xsl:if>
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
      font-size: 10px;
      font-style: italic;
    }
    div[class~="footnote"] {
      font-style: normal;
      background-color: #EEE;
      padding: 5px;
    }
  </xsl:text>
</xsl:template>

<!-- == Matched Templates ================================================== -->

<!-- = footnote = -->
<xsl:template match="footnote">
  <xsl:call-template name="db2html.footnote"/>
</xsl:template>

<xsl:template match="footnote" mode="process.footnote.mode">
  <div class="footnote">
    <xsl:apply-templates />
  </div>
</xsl:template>

<!-- this only works when the child of footnote is para or simpara,
 which it usually is -->
<xsl:template match="footnote/para[1] | footnote/simpara[1]" priority="2">
  <xsl:variable name="node" select="ancestor::footnote"/>
  <xsl:variable name="anchor">
    <xsl:choose>
      <xsl:when test="$node/@id">
	<xsl:value-of select="$node/@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="generate-id($node)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <a name="{$anchor}" />
  <p>
    <sup>
      <xsl:call-template name="db2html.footnote.number" />
    </sup>
    <xsl:apply-templates/>
  </p>
</xsl:template>

</xsl:stylesheet>
