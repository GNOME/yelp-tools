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
Mallard to HTML - Block Elements

REMARK: Describe this module
-->


<!--**==========================================================================
mal2html.block.css
Outputs CSS that controls the appearance of block elements

REMARK: Describe this template
-->
<xsl:template name="mal2html.block.css">
<xsl:text>
<!-- FIXME: margins should be original ems, not adjusted -->
h1 { font-size: 1.72em; margin: 0; }
h2 { font-size: 1.44em; margin: 0; }
h3 { font-size: 1.2em; margin: 0; }
h4 { font-size: 1em; margin: 0 0; }
h5 { font-size: 1em; margin: 0 0; }
h6 { font-size: 1em; margin: 0 0; }
h7 { font-size: 1em; margin: 0 0; }
div.section { margin-top: 2em; }
div.section div.section { margin-top: 1.44em; }
div.section div.section div.section { margin-top: 1.2em; }
pre.code {
  background-color: #eeeeec;
  border: solid 2px #babdb6;
}
div.comment {
  margin-left: 1.72em;
  margin-right: 1em;
  padding: 0 1em 1em 1em;
  background-color: #fcaf3e;
  border: solid 1px #f57900;
  -moz-border-radius: 8px;
}
div.comment div.cite { font-style: italic; }
div.comment div.titlecite { margin-top: 0; }

div.synopsis {
  background-color: #eeeeec;
  border: solid 1px #babdb6;
  -moz-border-radius: 8px;
  padding: 0 1em 1em 1em;
}
div.synopsis pre.code {
  background: none;
  border: none;
}
div.title {
  font-size: 1.2em;
  margin-top: 0.83em;
  font-weight: bold;
}
</xsl:text>
</xsl:template>


<!-- == Matched Templates == -->

<!-- = code = -->
<xsl:template mode="mal2html.block.mode" match="mal:code">
  <!-- FIXME: strip leading/trailing newline -->
  <pre class="code">
    <!-- FIXME: if there's only one piece of text() -->
    <xsl:if test="node()[1]/self::text()">
      <xsl:choose>
        <!-- CR LF -->
        <xsl:when test="starts-with(text()[1], '&#x000D;&#x000A;')">
          <xsl:value-of select="substring-after(text()[1], '&#x000D;&#x000A;')"/>
        </xsl:when>
        <!-- CR -->
        <xsl:when test="starts-with(text()[1], '&#x000D;')">
          <xsl:value-of select="substring-after(text()[1], '&#x000D;')"/>
        </xsl:when>
        <!-- LF -->
        <xsl:when test="starts-with(text()[1], '&#x000A;')">
          <xsl:value-of select="substring-after(text()[1], '&#x000A;')"/>
        </xsl:when>
        <!-- NEL -->
        <xsl:when test="starts-with(text()[1], '&#x0085;')">
          <xsl:value-of select="substring-after(text()[1], '&#x0085;')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="text()[1]"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:apply-templates mode="mal2html.inline.mode"
                         select="node()[not((position() = 1 or position() = last())
                                            and self::text())]"/>
    <xsl:if test="node()[last()]/self::text()">
      <xsl:variable name="text" select="text()[last()]"/>
      <xsl:choose>
        <!-- CR LF -->
        <xsl:when test="substring($text, -2) = '&#x000D;&#x000A;'">
          <xsl:value-of select="substring($text, 1, string-length($text) - 2 )"/>
        </xsl:when>
        <!-- CR -->
        <xsl:when test="substring($text, -1) = '&#x000D;'">
          <xsl:value-of select="substring($text, 1, string-length($text) - 1 )"/>
        </xsl:when>
        <!-- LF -->
        <xsl:when test="substring($text, -1) = '&#x000A;'">
          <xsl:value-of select="substring($text, 1, string-length($text) - 1 )"/>
        </xsl:when>
        <!-- NEL -->
        <xsl:when test="substring($text, -1) = '&#x0085;'">
          <xsl:value-of select="substring($text, 1, string-length($text) - 1 )"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$text"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </pre>
</xsl:template>

<!-- = comment = -->
<xsl:template mode="mal2html.block.mode" match="mal:comment">
  <div class="comment">
    <xsl:apply-templates mode="mal2html.block.mode"/>
  </div>
</xsl:template>

<!-- = comment/title = -->
<xsl:template mode="mal2html.block.mode" match="mal:comment/mal:title">
  <div class="title">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<!-- = comment/cite = -->
<xsl:template mode="mal2html.block.mode" match="mal:comment/mal:cite">
  <div class="cite">
    <xsl:attribute name="class">
      <xsl:text>cite</xsl:text>
      <xsl:if test="preceding-sibling::*[1]/self::mal:title">
        <xsl:text> titlecite</xsl:text>
      </xsl:if>
    </xsl:attribute>
    <!-- FIXME: i18n -->
    <xsl:choose>
      <xsl:when test="mal:name and mal:date">
        <xsl:text>from </xsl:text>
        <xsl:apply-templates mode="mal2html.inline.mode" select="mal:name"/>
        <xsl:text> on </xsl:text>
        <xsl:apply-templates mode="mal2html.inline.mode" select="mal:date"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>from </xsl:text>
        <xsl:apply-templates select="mal:name"/>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<!-- = p = -->
<xsl:template mode="mal2html.block.mode" match="mal:p">
  <p class="p">
    <xsl:apply-templates mode="mal2html.inline.mode"/>
  </p>
</xsl:template>

<!-- = synopsis = -->
<xsl:template mode="mal2html.block.mode" match="mal:synopsis">
  <div class="synopsis">
    <xsl:apply-templates mode="mal2html.block.mode"/>
  </div>
</xsl:template>

<!-- = synopsis/title = -->
<xsl:template mode="mal2html.block.mode" match="mal:synopsis/mal:title">
  <div class="title">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<!-- FIXME -->
<xsl:template mode="mal2html.block.mode" match="*">
  <xsl:message>
    <xsl:text>Unmatched block element: </xsl:text>
    <xsl:value-of select="local-name(.)"/>
  </xsl:message>
  <xsl:apply-templates mode="mal2html.inline.mode"/>
</xsl:template>

</xsl:stylesheet>
