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
Mallard to HTML - Inline Elements

REMARK: Describe this module
-->


<!--**==========================================================================
mal2html.span
Renders an inline element as a #{span}
$node: The element to render
$content: An optional parameter specifying the content of the #{span}

REMARK: Document this template
-->
<xsl:template name="mal2html.span">
  <xsl:param name="node" select="."/>
  <xsl:param name="content" select="false()"/>
  <span class="{local-name($node)}">
    <xsl:choose>
      <xsl:when test="$node/@xref">
        <a class="xref">
          <xsl:attribute name="href">
            <xsl:call-template name="mal.link.target">
              <xsl:with-param name="node" select="$node"/>
              <xsl:with-param name="xref" select="$node/@xref"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:call-template name="mal.link.tooltip">
              <xsl:with-param name="node" select="$node"/>
              <xsl:with-param name="xref" select="$node/@xref"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:choose>
            <xsl:when test="$content">
              <xsl:copy-of select="$content"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="mal2html.inline.mode" select="$node/node()"/>
            </xsl:otherwise>
          </xsl:choose>
        </a>
      </xsl:when>
      <xsl:when test="$node/@href">
        <a class="href" href="{$node/@href}">
          <xsl:attribute name="title">
            <xsl:call-template name="mal.link.tooltip">
              <xsl:with-param name="node" select="$node"/>
              <xsl:with-param name="href" select="$node/@href"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:choose>
            <xsl:when test="$content">
              <xsl:copy-of select="$content"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="mal2html.inline.mode" select="$node/node()"/>
            </xsl:otherwise>
          </xsl:choose>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$content">
            <xsl:copy-of select="$content"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="mal2html.inline.mode" select="$node/node()"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </span>
</xsl:template>


<!--**==========================================================================
mal2html.inline.css
Outputs CSS that controls the appearance of inline elements

REMARK: Describe this template
-->
<xsl:template name="mal2html.inline.css">
<xsl:text>
span.app { font-style: italic; }
span.cmd {
  font-family: monospace;
  background-color: #f0f0f0;
  padding-left: 0.2em;
  padding-right: 0.4em;
}
span.code { font-family: monospace; }
span.em { font-style: italic; }
span.email { color: red; }
span.file { font-family: monospace; }
span.gui { color: red; }
span.input { color: red; }
span.key { color: red; }
span.output { color: red; }
span.sys { font-family: monospace; }
span.var { font-style: italic; }
</xsl:text>
</xsl:template>


<!-- == Matched Templates == -->

<!-- = app = -->
<xsl:template mode="mal2html.inline.mode" match="mal:app">
  <xsl:call-template name="mal2html.span"/>
</xsl:template>

<!-- = cmd = -->
<xsl:template mode="mal2html.inline.mode" match="mal:cmd">
  <xsl:call-template name="mal2html.span"/>
</xsl:template>

<!-- = code = -->
<xsl:template mode="mal2html.inline.mode" match="mal:code">
  <xsl:call-template name="mal2html.span"/>
</xsl:template>

<!-- = date = -->
<xsl:template mode="mal2html.inline.mode" match="mal:date">
  <xsl:call-template name="mal2html.span"/>
</xsl:template>

<!-- = em = -->
<xsl:template mode="mal2html.inline.mode" match="mal:em">
  <xsl:call-template name="mal2html.span"/>
</xsl:template>

<!-- = email = -->
<xsl:template mode="mal2html.inline.mode" match="mal:email">
  <xsl:call-template name="mal2html.span"/>
</xsl:template>

<!-- = file = -->
<xsl:template mode="mal2html.inline.mode" match="mal:file">
  <xsl:call-template name="mal2html.span"/>
</xsl:template>

<!-- = gui = -->
<xsl:template mode="mal2html.inline.mode" match="mal:gui">
  <!-- FIXME: menu -->
  <xsl:call-template name="mal2html.span"/>
</xsl:template>

<!-- = input = -->
<xsl:template mode="mal2html.inline.mode" match="mal:input">
  <xsl:call-template name="mal2html.span"/>
</xsl:template>

<!-- = key = -->
<xsl:template mode="mal2html.inline.mode" match="mal:key">
  <!-- FIXME: keycombo -->
  <xsl:call-template name="mal2html.span"/>
</xsl:template>

<!-- = link = -->
<xsl:template mode="mal2html.inline.mode" match="mal:link">
  <xsl:call-template name="mal2html.span">
    <xsl:with-param name="content">
      <xsl:choose>
        <xsl:when test="normalize-space(.) != ''">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:when test="@xref">
          <xsl:call-template name="mal.link.content">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="xref" select="@xref"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="@href">
          <xsl:value-of select="@href"/>
        </xsl:when>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- = media = -->
<xsl:template mode="mal2html.inline.mode" match="mal:media">
  <!-- FIXME -->
</xsl:template>

<!-- = name = -->
<xsl:template mode="mal2html.inline.mode" match="mal:name">
  <xsl:call-template name="mal2html.span"/>
</xsl:template>

<!-- = output = -->
<xsl:template mode="mal2html.inline.mode" match="mal:output">
  <xsl:call-template name="mal2html.span"/>
</xsl:template>

<!-- = quote = -->
<xsl:template mode="mal2html.inline.mode" match="mal:quote">
  <!-- FIXME: do smart quoting -->
  <xsl:text>"</xsl:text>
  <xsl:call-template name="mal2html.span"/>
  <xsl:text>"</xsl:text>
</xsl:template>

<!-- = sys = -->
<xsl:template mode="mal2html.inline.mode" match="mal:sys">
  <xsl:call-template name="mal2html.span"/>
</xsl:template>

<!-- = var = -->
<xsl:template mode="mal2html.inline.mode" match="mal:var">
  <xsl:call-template name="mal2html.span"/>
</xsl:template>

<!-- = text() = -->
<xsl:template mode="mal2html.inline.mode" match="text()">
  <xsl:value-of select="."/>
</xsl:template>

<!-- = FIXME = -->
<xsl:template mode="mal2html.inline.mode" match="*">
  <xsl:message>
    <xsl:text>Unmatched inline element: </xsl:text>
    <xsl:value-of select="local-name(.)"/>
  </xsl:message>
  <xsl:apply-templates mode="mal2html.inline.mode"/>
</xsl:template>

</xsl:stylesheet>
