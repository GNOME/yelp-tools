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
                version="1.0">

<!--!!==========================================================================
DocBook Common

REMARK: Describe this
-->

<xsl:key name="idkey" match="*" use="@id"/>


<!--**==========================================================================
db.dingbat
Outputs a character from a character name, possibly localized
$dingbat: The name of the character

REMARK: Document the dingbats.  "Logical name" sounds dumb
-->
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


<!--**==========================================================================
db.linenumbering
Numbers each line in a verbatim environment
$node: The verbatim element to create the line numbering for
$number: The starting line number

REMARK: Document this template
-->
<xsl:template name="db.linenumbering">
  <xsl:param name="node" select="."/>
  <xsl:param name="number" select="1"/>
  <xsl:variable name="substr">
    <xsl:choose>
      <xsl:when test="node()[1]/self::text()">
        <xsl:choose>
          <!-- CR LF -->
          <xsl:when test="starts-with(string($node), '&#x000D;&#x000A;')">
            <xsl:value-of select="substring-after(string($node), '&#x000D;&#x000A;')"/>
          </xsl:when>
          <!-- CR -->
          <xsl:when test="starts-with(string($node), '&#x000D;')">
            <xsl:value-of select="substring-after(string($node), '&#x000D;')"/>
          </xsl:when>
          <!-- LF -->
          <xsl:when test="starts-with(string($node), '&#x000A;')">
            <xsl:value-of select="substring-after(string($node), '&#x000A;')"/>
          </xsl:when>
          <!-- NEL -->
          <xsl:when test="starts-with(string($node), '&#x0085;')">
            <xsl:value-of select="substring-after(string($node), '&#x0085;')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="string($node)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="string($node)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:call-template name="db.linenumbering.substr">
    <xsl:with-param name="substr" select="$substr"/>
    <xsl:with-param name="number" select="$number"/>
  </xsl:call-template>
</xsl:template>

<!--#* db.linenumbering.substr -->
<xsl:template name="db.linenumbering.substr">
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


<!--**==========================================================================
db.personname
Outputs the name of a person
$node: The element containing tags such as #{firstname} and #{surname}
$lang: The language rules to use to construct the name

REMARK: Document this template
-->
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
