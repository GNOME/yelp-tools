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

<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:mal='http://projectmallard.org/1.0/'
                xmlns='http://projectmallard.org/1.0/'
                version='1.0'>

<xsl:output omit-xml-declaration="yes"/>

<xsl:template match='/mal:cache'>
  <cache>
    <xsl:for-each select="mal:page">
      <xsl:apply-templates select="document(@href)/*">
        <xsl:with-param name="href" select="@href"/>
      </xsl:apply-templates>
    </xsl:for-each>
  </cache>
</xsl:template>

<xsl:template match="mal:page">
  <xsl:param name="href"/>
  <page>
    <xsl:attribute name="id">
      <xsl:value-of select="@id"/>
    </xsl:attribute>
    <xsl:attribute name="href">
      <xsl:value-of select="$href"/>
    </xsl:attribute>
    <xsl:if test="@type">
      <xsl:attribute name="type">
        <xsl:value-of select="@type"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="not(mal:info)">
      <xsl:call-template name="info">
        <xsl:with-param name="info" select="mal:info"/>
        <xsl:with-param name="node" select="."/>
      </xsl:call-template>
    </xsl:if>
    <xsl:apply-templates/>
  </page>
</xsl:template>

<xsl:template match="mal:section">
  <section>
    <xsl:if test="@id">
      <xsl:attribute name="id">
        <xsl:value-of select="ancestor::mal:page[1]/@id"/>
        <xsl:text>#</xsl:text>
        <xsl:value-of select="@id"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="not(mal:info)">
      <xsl:call-template name="info">
        <xsl:with-param name="info" select="mal:info"/>
        <xsl:with-param name="node" select="."/>
      </xsl:call-template>
    </xsl:if>
    <xsl:apply-templates/>
  </section>
</xsl:template>

<xsl:template match="mal:title">
  <xsl:copy-of select="."/>
</xsl:template>

<xsl:template name="info" match="mal:info">
  <xsl:param name="info" select="."/>
  <xsl:param name="node" select="$info/.."/>
  <info>
    <xsl:if test="not($info/mal:title[@type = 'link'])">
      <title type="link">
        <xsl:copy-of select="$node/mal:title/node()"/>
      </title>
    </xsl:if>
    <xsl:if test="not($info/mal:title[@type = 'sort'])">
      <title type="sort">
        <xsl:choose>
          <xsl:when test="$info/mal:title[@type = 'link']">
            <xsl:copy-of select="$info/mal:title[@type = 'link'][1]/node()"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$node/mal:title/node()"/>
          </xsl:otherwise>
        </xsl:choose>
      </title>
    </xsl:if>
    <xsl:for-each select="$info/*">
      <xsl:choose>
        <xsl:when test="self::mal:link[@type = 'guide' and not(@weight)]">
          <link type="guide" xref="{@xref}" weight="0"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </info>
</xsl:template>

<xsl:template match="node() | text()"/>

</xsl:stylesheet>
