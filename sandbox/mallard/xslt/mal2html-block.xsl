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
div.title {
  color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'text-light'"/>
  </xsl:call-template>
  <xsl:text>;
  font-weight: bold;
}
pre.code {
  <!-- FIXME: theme -->
  background: url(mallard-icon-code.png) no-repeat top right;
  border: solid 2px </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'gray-light'"/>
  </xsl:call-template>
  <xsl:text>;
  padding: 0.5em 1em 0.5em 1em;
}
div.comment {
  padding: 0.5em;
  border: solid 2px </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'red-border'"/>
  </xsl:call-template>
  <xsl:text>;
  background-color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'red-background'"/>
  </xsl:call-template>
  <xsl:text>;
}
div.comment div.comment {
  margin: 1em 0 0 1em;
}
div.comment div.cite { margin: 0; font-style: italic; }

div.figure {
  color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'text-light'"/>
  </xsl:call-template>
  <xsl:text>;
  border: solid 1px </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'gray-border'"/>
  </xsl:call-template>
  <xsl:text>;
  background-color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'gray-background'"/>
  </xsl:call-template>
  <xsl:text>;
  margin-left: 1.72em;
  padding: 4px;
}
div.figure-contents {
  color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'text'"/>
  </xsl:call-template>
  <xsl:text>;
  border: solid 1px </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'gray-border'"/>
  </xsl:call-template>
  <xsl:text>;
  background-color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'background'"/>
  </xsl:call-template>
  <xsl:text>;
  padding: 0.5em 1em 0.5em 1em;
  margin: 0;
  text-align: center;
}
div.figure div.title { margin: 0 0 4px 0; }
div.figure div.caption { margin: 4px 0 0 0; }

div.synopsis {
  border-top: solid 2px;
  border-bottom: solid 2px;
  border-color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'blue-border'"/>
  </xsl:call-template>
  <xsl:text>;
  background-color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'gray-background'"/>
  </xsl:call-template>
  <xsl:text>;
  padding: 0.5em 1em 0.5em 1em;
}
div.synopsis pre.code {
  background: none;
  border: none;
  padding: 0;
}
div.title {
  font-size: 1.2em;
  margin-top: 0;
  font-weight: bold;
}
</xsl:text>
</xsl:template>


<!-- == Matched Templates == -->

<!-- = caption = -->
<xsl:template mode="mal2html.block.mode" match="mal:caption">
  <div class="caption">
    <xsl:apply-templates mode="mal2html.block.mode"/>
  </div>
</xsl:template>

<!-- = code = -->
<xsl:template mode="mal2html.block.mode" match="mal:code">
  <xsl:variable name="first" select="node()[1]/self::text()"/>
  <xsl:variable name="last" select="node()[last()]/self::text()"/>
  <pre class="code">
    <xsl:if test="not(preceding-sibling::*)">
      <xsl:attribute name="class">
        <xsl:text>first-child</xsl:text>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="$first">
      <xsl:call-template name="util.strip_newlines">
        <xsl:with-param name="string" select="$first"/>
        <xsl:with-param name="leading" select="true()"/>
        <xsl:with-param name="trailing" select="$first = $last"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:apply-templates mode="mal2html.inline.mode"
                         select="node()[not(. = $first or . = $last)]"/>
    <xsl:if test="$last and ($first != $last)">
      <xsl:call-template name="util.strip_newlines">
        <xsl:with-param name="string" select="$last"/>
        <xsl:with-param name="leading" select="false()"/>
        <xsl:with-param name="trailing" select="true()"/>
      </xsl:call-template>
    </xsl:if>
  </pre>
</xsl:template>

<!-- = comment = -->
<xsl:template mode="mal2html.block.mode" match="mal:comment">
  <div class="comment">
    <xsl:if test="not(preceding-sibling::*)">
      <xsl:attribute name="class">
        <xsl:text>first-child</xsl:text>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates mode="mal2html.block.mode"/>
  </div>
</xsl:template>

<!-- = comment/title = -->
<xsl:template mode="mal2html.block.mode" match="mal:comment/mal:title">
  <div class="title">
    <xsl:apply-templates mode="mal2html.inline.mode"/>
  </div>
</xsl:template>

<!-- = comment/cite = -->
<xsl:template mode="mal2html.block.mode" match="mal:comment/mal:cite">
  <div class="cite">
    <!-- FIXME: i18n -->
    <xsl:choose>
      <xsl:when test="@name and @date">
        <xsl:text>from </xsl:text>
        <xsl:apply-templates mode="mal2html.inline.mode" select="@name"/>
        <xsl:text> on </xsl:text>
        <xsl:apply-templates mode="mal2html.inline.mode" select="@date"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>from </xsl:text>
        <xsl:apply-templates mode="mal2html.inline.mode" select="@name"/>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<!-- = figure = -->
<xsl:template mode="mal2html.block.mode" match="mal:figure">
  <div class="figure">
    <xsl:if test="not(preceding-sibling::*)">
      <xsl:attribute name="class">
        <xsl:text>first-child</xsl:text>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates mode="mal2html.block.mode" select="mal:title"/>
    <div class="figure-contents">
      <xsl:apply-templates mode="mal2html.block.mode"
                           select="*[not(self::mal:title or self::mal:caption)]"/>
    </div>
    <xsl:apply-templates mode="mal2html.block.mode" select="mal:caption"/>
  </div>
</xsl:template>

<!-- = figure/title = -->
<xsl:template mode="mal2html.block.mode" match="mal:figure/mal:title">
  <div class="title">
    <xsl:apply-templates mode="mal2html.inline.mode"/>
  </div>
</xsl:template>

<!-- = info = -->
<xsl:template mode="mal2html.block.mode" match="mal:info"/>

<!-- = p = -->
<xsl:template mode="mal2html.block.mode" match="mal:p">
  <p class="p">
    <xsl:if test="not(preceding-sibling::*)">
      <xsl:attribute name="class">
        <xsl:text>first-child</xsl:text>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates mode="mal2html.inline.mode"/>
  </p>
</xsl:template>

<!-- = synopsis = -->
<xsl:template mode="mal2html.block.mode" match="mal:synopsis">
  <div class="synopsis">
    <xsl:if test="not(preceding-sibling::*)">
      <xsl:attribute name="class">
        <xsl:text>first-child</xsl:text>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates mode="mal2html.block.mode"/>
  </div>
</xsl:template>

<!-- = synopsis/title = -->
<xsl:template mode="mal2html.block.mode" match="mal:synopsis/mal:title">
  <div class="title">
    <xsl:apply-templates mode="mal2html.inline.mode"/>
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
