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
                xmlns:str="http://exslt.org/strings"
                xmlns="http://www.w3.org/1999/xhtml"
                extension-element-prefixes="str"
                version="1.0">

<!--!!==========================================================================
DocBook to HTML - Function Synopses

REMARK: Describe this module
-->


<!--@@==========================================================================
db2html.funcsynopsis.style
How to render #{funcsynopsis} elements

This parameter controls the indentation style used to render #{funcsynopsis}
elements.  Supported values are #{'KR'} and #{'ANSI'}.
-->
<xsl:param name="db2html.funcsynopsis.style">
  <xsl:choose>
    <xsl:when test="processing-instruction('db2html.funcsynopsis.style')">
      <xsl:value-of
       select="processing-instruction('db2html.funcsynopsis.style')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'ANSI'"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>


<!-- == Matched Templates == -->

<!-- = funcdef = -->
<xsl:template match="funcdef">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = funcparams = -->
<xsl:template match="funcparams">
  <xsl:text>(</xsl:text>
  <xsl:call-template name="db2html.inline"/>
  <xsl:text>)</xsl:text>
</xsl:template>

<!-- = funcprototype = -->
<xsl:template match="funcprototype">
  <xsl:param name="style"/>
  <xsl:apply-templates select="funcdef/preceding-sibling::modifer"/>
  <xsl:apply-templates select="funcdef"/>
  <xsl:text> (</xsl:text>
  <xsl:choose>
    <xsl:when test="$style = 'KR'">
      <xsl:for-each select="void | varargs | paramdef/parameter">
        <xsl:if test="position() != 1">
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="."/>
      </xsl:for-each>
      <xsl:text>)</xsl:text>
      <xsl:apply-templates select="funcdef/following-sibling::modifier"/>
      <xsl:text>;</xsl:text>
      <xsl:for-each select="paramdef">
        <xsl:text>&#x000A;    </xsl:text>
        <xsl:apply-templates select="."/>
        <xsl:text>;</xsl:text>
      </xsl:for-each>
    </xsl:when>
    <!-- ANSI is the default -->
    <xsl:otherwise>
      <xsl:variable name="indent"
                    select="2 + string-length(funcdef |
                            funcdef/preceding-sibling::modifier)"/>
      <xsl:for-each select="void | varargs | paramdef">
        <xsl:if test="position() != 1">
          <xsl:text>,&#x000A;</xsl:text>
          <xsl:value-of select="str:padding($indent)"/>
        </xsl:if>
        <xsl:apply-templates select="."/>
      </xsl:for-each>
      <xsl:text>)</xsl:text>
      <xsl:apply-templates select="funcdef/following-sibling::modifier"/>
      <xsl:text>;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- = funcsynopsis = -->
<xsl:template match="funcsynopsis">
  <xsl:param name="style">
    <xsl:choose>
      <xsl:when test="processing-instruction('db2html.funcsynopsis.style')">
        <xsl:value-of
         select="processing-instruction('db2html.funcsynopsis.style')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$db2html.funcsynopsis.style"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <pre class="funcsynopsis">
    <xsl:call-template name="db2html.anchor"/>
    <!-- The select is needed to avoid extra whitespace -->
    <xsl:apply-templates select="*">
      <xsl:with-param name="style" select="$style"/>
    </xsl:apply-templates>
  </pre>
</xsl:template>

<!-- = funcsynopsisinfo = -->
<xsl:template match="funcsynopsisinfo">
  <xsl:call-template name="db2html.pre"/>
</xsl:template>

<!-- = initializer = -->
<xsl:template match="initializer">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = modifier = -->
<xsl:template match="modifier">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = paramdef = -->
<xsl:template match="paramdef">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = paramdef/parameter = -->
<xsl:template match="paramdef/parameter">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="mono" select="true()"/>
    <xsl:with-param name="italic" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = varargs = -->
<xsl:template match="varargs">
  <xsl:text>...</xsl:text>
</xsl:template>

<!-- = void = -->
<xsl:template match="void">
  <xsl:text>void</xsl:text>
</xsl:template>

</xsl:stylesheet>
