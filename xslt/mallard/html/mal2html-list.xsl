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
Mallard to HTML - List Elements

REMARK: Describe this module
-->


<!--**==========================================================================
mal2html.list.css
Outputs CSS that controls the appearance of lists

REMARK: Describe this template
-->
<xsl:template name="mal2html.list.css">
<xsl:text>
ul.ulist {
  margin: 0; padding: 0;
}
ul.ulist li {
  margin-left: 1.44em;
}
ul.tree {
  margin: 0; padding: 0;
  list-style-type: none;
}
ul.tree li {
  margin: 0; padding: 0;
}
.item-tree { margin: 0; padding: 0; }
ul.tree ul.tree {
  margin-left: 1.44em;
}
div.tree-lines ul.tree ul.tree {
  margin-left: 0.2em;
}
div.tree-lines ul.tree ul.tree ul.tree {
  margin-left: 1.44em;
}
</xsl:text>
</xsl:template>


<!-- == Bullet Lists == -->

<xsl:template mode="mal2html.block.mode" match="mal:ulist">
  <div>
    <xsl:attribute name="class">
      <xsl:text>ulist</xsl:text>
      <xsl:if test="not(preceding-sibling::*)">
        <xsl:text> first-child</xsl:text>
      </xsl:if>
    </xsl:attribute>
    <ul class="ulist">
      <xsl:apply-templates mode="mal2html.list.bullet.mode"/>
    </ul>
  </div>
</xsl:template>

<xsl:template mode="mal2html.list.bullet.mode" match="mal:item">
  <li>
    <xsl:if test="not(preceding-sibling::mal:item)">
      <xsl:attribute name="class">
        <xsl:text>first-child</xsl:text>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates mode="mal2html.block.mode"/>
  </li>
</xsl:template>


<!-- == Numbered Lists == -->

<!-- == Definition Lists == -->

<!-- == Tree Lists == -->

<xsl:template mode="mal2html.block.mode" match="mal:tree">
  <xsl:variable name="lines" select="contains(concat(' ', @style, ' '), ' lines ')"/>
  <div>
    <xsl:attribute name="class">
      <xsl:text>tree</xsl:text>
      <xsl:if test="$lines">
        <xsl:text> tree-lines</xsl:text>
      </xsl:if>
      <xsl:if test="not(preceding-sibling::*)">
        <xsl:text> first-child</xsl:text>
      </xsl:if>
    </xsl:attribute>
    <ul class="tree">
      <xsl:apply-templates mode="mal2html.list.tree.mode">
        <xsl:with-param name="lines" select="$lines"/>
      </xsl:apply-templates>
    </ul>
  </div>
</xsl:template>

<xsl:template mode="mal2html.list.tree.mode" match="mal:item">
  <xsl:param name="lines" select="false()"/>
  <li class="item item-tree">
    <div class="item item-tree">
      <xsl:if test="$lines and not(parent::mal:list)">
        <xsl:choose>
          <xsl:when test="following-sibling::mal:item">
            <xsl:text>&#x251C; </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>&#x2514; </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:apply-templates mode="mal2html.inline.mode"
                           select="*[not(self::mal:item)]"/>
    </div>
    <xsl:if test="mal:item">
      <ul class="tree">
        <xsl:apply-templates mode="mal2html.list.tree.mode" select="mal:item">
          <xsl:with-param name="lines" select="$lines"/>
        </xsl:apply-templates>
      </ul>
    </xsl:if>
  </li>
</xsl:template>

</xsl:stylesheet>
