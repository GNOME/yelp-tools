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
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Common DocBook Templates</doc:title>

<xsl:key name="idkey" match="*" use="@id"/>


<!-- == db.dingbat ========================================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.dingbat</name>
  <purpose>
    Render a character from a logical name, possibly localized
  </purpose>
  <parameter>
    <name>dingbat</name>
    <purpose>
      The logical name of the character
    </purpose>
  </parameter>
</template>

<xsl:template name="db.dingbat">
  <xsl:param name="dingbat"/>
  <xsl:choose>
    <xsl:when test="$dingbat = 'copyright'">
      <!-- U+00A9 -->
      <xsl:value-of select="'©'"/>
    </xsl:when>
    <xsl:when test="$dingbat = 'registered'">
      <!-- U+00AE -->
      <xsl:value-of select="'®'"/>
    </xsl:when>
    <xsl:when test="$dingbat = 'trade'">
      <!-- U+2122 -->
      <xsl:value-of select="'™'"/>
    </xsl:when>
    <xsl:when test="$dingbat = 'service'">
      <!-- U+2120 -->
      <xsl:value-of select="'℠'"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>


<!-- == db.linenumbering =================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.linenumbering</name>
  <purpose>
    Number each line in a verbatim environment
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The verbatim element for which create line numbering
    </purpose>
  </parameter>
  <parameter>
    <name>number</name>
    <purpose>
    </purpose>
  </parameter>
</template>

<xsl:template name="db.linenumbering">
  <xsl:param name="node" select="."/>
  <xsl:param name="number" select="1"/>
  <xsl:variable name="substr" select="string($node)"/>
  <xsl:call-template name="db.linenumbering.substr">
    <xsl:with-param name="substr" select="$substr"/>
    <xsl:with-param name="number" select="$number"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="db.linenumbering.substr" doc:private="true">
  <xsl:param name="substr"/>
  <xsl:param name="number"/>
  <xsl:choose>
    <xsl:when test="contains($substr, '&#x000A;')">
      <xsl:number value="$number"/>
      <xsl:text>&#x000A;</xsl:text>
      <xsl:call-template name="db.linenumbering.substr">
        <xsl:with-param name="substr"
                        select="substring-after($substr, '&#x000A;')"/>
        <xsl:with-param name="number" select="$number + 1"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="string-length($substr) != 0">
      <xsl:number value="$number"/>
      <xsl:text>&#x000A;</xsl:text>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<!-- == db.personname ====================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.personname</name>
  <purpose>
    Render the name of a person
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The element containing <xmltag>firstname</xmltag>,
      <xmltag>surname</xmltag>, etc.
    </purpose>
  </parameter>
  <parameter>
    <name>lang</name>
    <purpose>
      The language to use for the rules of constructing a name
    </purpose>
  </parameter>
</template>

<xsl:template name="db.personname">
  <xsl:param name="node" select="."/>
  <xsl:param name="lang" select="ancestor-or-self::*[@lang][1]/@lang"/>

  <!-- FIXME: Use xsl:choose for different language rules -->
  <xsl:if test="$node/honorific">
    <xsl:apply-templates select="$node/honorific[1]"/>
    <xsl:text>.</xsl:text>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="$node/@role = 'family-given'">
      <xsl:if test="$node/surname">
        <xsl:if test="$node/honorific">
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="$node/surname[1]"/>
      </xsl:if>
      <xsl:if test="$node/othername">
        <xsl:if test="$node/honorific or $node/surname">
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="$node/othername[1]"/>
      </xsl:if>
      <xsl:if test="$node/firstname">
        <xsl:if test="$node/honorific or $node/surname or $node/othername">
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="$node/firstname[1]"/>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="$node/firstname">
        <xsl:if test="$node/honorific">
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="$node/firstname[1]"/>
      </xsl:if>
      <xsl:if test="$node/othername">
        <xsl:if test="$node/honorific or $node/firstname">
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="$node/othername[1]"/>
      </xsl:if>
      <xsl:if test="$node/surname">
        <xsl:if test="$node/honorific or $node/firstname or $node/othername">
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="$node/surname[1]"/>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="$node/lineage">
    <xsl:text>, </xsl:text>
    <xsl:apply-templates select="$node/lineage[1]"/>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
