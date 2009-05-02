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
  font-size: 1.2em;
  margin-top: 0;
  font-weight: bold;
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
    <xsl:with-param name="id" select="'gray-border'"/>
  </xsl:call-template>
  <xsl:text>;
  padding: 0.5em 1em 0.5em 1em;
}
div.example {
  border-left: solid 4px </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'gray-border'"/>
  </xsl:call-template>
  <xsl:text>;
  padding-left: 1em;
}
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
div.figure div.desc { margin: 4px 0 0 0; }
div.listing div.title { font-size: 1em; margin: 0 0 4px 0; }
div.listing div.desc { margin: 0 0 4px 0; font-style: italic; }
pre.screen {
  background-color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'gray-background'"/>
  </xsl:call-template>
  <xsl:text>;
  border: solid 2px </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'gray-border'"/>
  </xsl:call-template>
  <xsl:text>;
  padding: 0.5em 1em 0.5em 1em;
}
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
</xsl:text>
</xsl:template>


<!--**==========================================================================
mal2html.pre

FIXME
-->
<xsl:template name="mal2html.pre">
  <xsl:param name="node" select="."/>
  <xsl:param name="first_child" select="not(preceding-sibling::*)"/>
  <xsl:variable name="first" select="$node/node()[1]/self::text()"/>
  <xsl:variable name="last" select="$node/node()[last()]/self::text()"/>
  <pre>
    <xsl:attribute name="class">
      <xsl:value-of select="local-name($node)"/>
      <xsl:if test="$first_child">
        <xsl:text> first-child</xsl:text>
      </xsl:if>
    </xsl:attribute>
    <xsl:if test="$first">
      <xsl:call-template name="util.strip_newlines">
        <xsl:with-param name="string" select="$first"/>
        <xsl:with-param name="leading" select="true()"/>
        <xsl:with-param name="trailing" select="count(node()) = 1"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:apply-templates mode="mal2html.inline.mode"
                         select="node()[not(self::text() and (position() = 1 or position() = last()))]"/>
    <xsl:if test="$last and (count(node()) != 1)">
      <xsl:call-template name="util.strip_newlines">
        <xsl:with-param name="string" select="$last"/>
        <xsl:with-param name="leading" select="false()"/>
        <xsl:with-param name="trailing" select="true()"/>
      </xsl:call-template>
    </xsl:if>
  </pre>
</xsl:template>


<!-- == Matched Templates == -->

<!-- = desc = -->
<xsl:template mode="mal2html.block.mode" match="mal:desc">
  <div class="desc">
    <xsl:apply-templates mode="mal2html.inline.mode"/>
  </div>
</xsl:template>

<!-- = code = -->
<xsl:template mode="mal2html.block.mode" match="mal:code">
  <xsl:param name="first_child" select="not(preceding-sibling::*)"/>
  <xsl:call-template name="mal2html.pre">
    <xsl:with-param name="first_child" select="$first_child"/>
  </xsl:call-template>
</xsl:template>

<!-- = comment = -->
<xsl:template mode="mal2html.block.mode" match="mal:comment">
  <xsl:param name="first_child" select="not(preceding-sibling::*)"/>
  <div>
    <xsl:attribute name="class">
      <xsl:text>comment</xsl:text>
      <xsl:if test="$first_child">
        <xsl:text> first-child</xsl:text>
      </xsl:if>
    </xsl:attribute>
    <xsl:apply-templates mode="mal2html.block.mode" select="mal:title"/>
    <xsl:apply-templates mode="mal2html.block.mode" select="mal:cite"/>
    <xsl:for-each select="mal:*[not(self::mal:title or self::mal:cite)]">
      <xsl:apply-templates mode="mal2html.block.mode" select=".">
        <xsl:with-param name="first_child" select="position() = 1"/>
      </xsl:apply-templates>
    </xsl:for-each>
  </div>
</xsl:template>

<!-- = comment/cite = -->
<xsl:template mode="mal2html.block.mode" match="mal:comment/mal:cite">
  <div class="cite">
    <!-- FIXME: i18n -->
    <xsl:choose>
      <xsl:when test="mal:name and @date">
        <xsl:text>from </xsl:text>
        <xsl:apply-templates mode="mal2html.inline.mode" select="mal:name"/>
        <xsl:text> on </xsl:text>
        <xsl:apply-templates mode="mal2html.inline.mode" select="@date"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>from </xsl:text>
        <xsl:apply-templates mode="mal2html.inline.mode" select="mal:name"/>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<!-- = example = -->
<xsl:template mode="mal2html.block.mode" match="mal:example">
  <xsl:param name="first_child" select="not(preceding-sibling::*)"/>
  <div>
    <xsl:attribute name="class">
      <xsl:text>example</xsl:text>
      <xsl:if test="$first_child">
        <xsl:text> first-child</xsl:text>
      </xsl:if>
    </xsl:attribute>
    <xsl:for-each select="mal:*">
      <xsl:apply-templates mode="mal2html.block.mode" select=".">
        <xsl:with-param name="first_child" select="position() = 1"/>
      </xsl:apply-templates>
    </xsl:for-each>
  </div>
</xsl:template>

<!-- = figure = -->
<xsl:template mode="mal2html.block.mode" match="mal:figure">
  <xsl:param name="first_child" select="not(preceding-sibling::*)"/>
  <div>
    <xsl:attribute name="class">
      <xsl:text>figure</xsl:text>
      <xsl:if test="$first_child">
        <xsl:text> first-child</xsl:text>
      </xsl:if>
    </xsl:attribute>
    <xsl:apply-templates mode="mal2html.block.mode" select="mal:title"/>
    <div class="figure-contents">
      <xsl:for-each select="mal:*[not(self::mal:title or self::mal:desc)]">
        <xsl:apply-templates mode="mal2html.block.mode" select=".">
          <xsl:with-param name="first_child" select="position() = 1"/>
        </xsl:apply-templates>
      </xsl:for-each>
    </div>
    <xsl:apply-templates mode="mal2html.block.mode" select="mal:desc"/>
  </div>
</xsl:template>

<!-- = listing = -->
<xsl:template mode="mal2html.block.mode" match="mal:listing">
  <xsl:param name="first_child" select="not(preceding-sibling::*)"/>
  <div>
    <xsl:attribute name="class">
      <xsl:text>listing</xsl:text>
      <xsl:if test="$first_child">
        <xsl:text> first-child</xsl:text>
      </xsl:if>
    </xsl:attribute>
    <xsl:apply-templates mode="mal2html.block.mode" select="mal:title"/>
    <xsl:apply-templates mode="mal2html.block.mode" select="mal:desc"/>
    <div class="listing-contents">
      <xsl:for-each select="mal:*[not(self::mal:title or self::mal:desc)]">
        <xsl:apply-templates mode="mal2html.block.mode" select=".">
          <xsl:with-param name="first_child" select="position() = 1"/>
        </xsl:apply-templates>
      </xsl:for-each>
    </div>
  </div>
</xsl:template>

<!-- = info = -->
<xsl:template mode="mal2html.block.mode" match="mal:info"/>

<!-- = p = -->
<xsl:template mode="mal2html.block.mode" match="mal:p">
  <xsl:param name="first_child" select="not(preceding-sibling::*)"/>
  <p>
    <xsl:attribute name="class">
      <xsl:text>p</xsl:text>
      <xsl:if test="$first_child">
        <xsl:text> first-child</xsl:text>
      </xsl:if>
    </xsl:attribute>
    <xsl:apply-templates mode="mal2html.inline.mode"/>
  </p>
</xsl:template>

<!-- = screen = -->
<xsl:template mode="mal2html.block.mode" match="mal:screen">
  <xsl:param name="first_child" select="not(preceding-sibling::*)"/>
  <xsl:call-template name="mal2html.pre">
    <xsl:with-param name="first_child" select="$first_child"/>
  </xsl:call-template>
</xsl:template>

<!-- = synopsis = -->
<xsl:template mode="mal2html.block.mode" match="mal:synopsis">
  <xsl:param name="first_child" select="not(preceding-sibling::*)"/>
  <div class="synopsis">
    <xsl:attribute name="class">
      <xsl:text>synopsis</xsl:text>
      <xsl:if test="$first_child">
        <xsl:text> first-child</xsl:text>
      </xsl:if>
    </xsl:attribute>
    <xsl:apply-templates mode="mal2html.block.mode" select="mal:title"/>
    <xsl:apply-templates mode="mal2html.block.mode" select="mal:desc"/>
    <div class="synopsis-contents">
      <xsl:for-each select="mal:*[not(self::mal:title or self::mal:desc)]">
        <xsl:apply-templates mode="mal2html.block.mode" select=".">
          <xsl:with-param name="first_child" select="position() = 1"/>
        </xsl:apply-templates>
      </xsl:for-each>
    </div>
  </div>
</xsl:template>

<xsl:template mode="mal2html.block.mode" match="mal:title">
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
