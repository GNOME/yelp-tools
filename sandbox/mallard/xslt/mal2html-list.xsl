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
ul.list-tree {
  margin: 0; padding: 0;
  list-style-type: none;
}
ul.list-tree li {
  margin: 0; padding: 0;
}
ul.list-tree li p {
  margin: 0; padding: 0;
}
ul.list-tree ul.list-tree {
  margin-left: 1.44em;
}
ul.list-tree ul.list-tree li {
  margin-top: 0.69em;
}
</xsl:text>
</xsl:template>


<!-- == Bullet Lists == -->

<!-- == Numbered Lists == -->

<!-- == Definition Lists == -->

<!-- == Tree Lists == -->

<xsl:template mode="mal2html.block.mode" match="mal:list[@type='tree']">
  <div class="list list-tree">
    <ul class="list list-tree">
      <xsl:apply-templates mode="mal2html.list.tree.mode"/>
    </ul>
  </div>
</xsl:template>

<xsl:template mode="mal2html.list.tree.mode" match="mal:item">
  <li>
    <p>
      <xsl:apply-templates mode="mal2html.inline.mode"
                           select="*[not(self::mal:item)]"/>
    </p>
  </li>
  <xsl:if test="mal:item">
    <ul class="list list-tree">
      <xsl:apply-templates mode="mal2html.list.tree.mode"
                           select="mal:item"/>
    </ul>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
