<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Common DocBook Templates</doc:title>


<!-- == db.dingbat ========================================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.dingbat</name>
  <description>
    Render a character from a logical name, possibly localized
  </description>
  <parameter>
    <name>dingbat</name>
    <description>
      The logical name of the character
    </description>
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
  <description>
    Number each line in a verbatim environment
  </description>
  <parameter>
    <name>node</name>
    <description>
      The verbatim element for which create line numbering
    </description>
  </parameter>
  <parameter>
    <name>number</name>
    <description>
    </description>
  </parameter>
</template>

<xsl:template name="db.linenumbering">
  <xsl:param name="node" select="."/>
  <xsl:param name="number" select="1"/>
  <xsl:variable name="substr" select="string($node)"/>
  <xsl:number value="$number"/>
  <xsl:call-template name="db.linenumbering.substr">
    <xsl:with-param name="substr" select="$substr"/>
    <xsl:with-param name="number" select="$number + 1"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="db.linenumbering.substr" doc:private="true">
  <xsl:param name="substr"/>
  <xsl:param name="number"/>
  <xsl:if test="contains($substr, '&#x000A;')">
    <xsl:text>&#x000A;</xsl:text>
    <xsl:number value="$number"/>
    <xsl:call-template name="db.linenumbering.substr">
      <xsl:with-param name="substr"
                      select="substring-after($substr, '&#x000A;')"/>
      <xsl:with-param name="number" select="$number + 1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- == db.personname ====================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.personname</name>
  <description>
    Render the name of a person
  </description>
  <parameter>
    <name>node</name>
    <description>
      The element containing <xmltag>firstname</xmltag>,
      <xmltag>surname</xmltag>, etc.
    </description>
  </parameter>
  <parameter>
    <name>lang</name>
    <description>
      The language to use for the rules of constructing a name
    </description>
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


<!-- == db.xref.target ===================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.xref.target</name>
  <description>
    Create a URL for a target element
  </description>
  <parameter>
    <name>linkend</name>
    <description>
      The id of the target element
    </description>
  </parameter>
  <parameter>
    <name>target</name>
    <description>
      The target element
    </description>
  </parameter>
</template>

<xsl:template name="db.xref.target">
  <xsl:param name="linkend" select="@linkend"/>
  <xsl:param name="target" select="id($linkend)"/>
  <xsl:variable name="chunk_id">
    <xsl:call-template name="db.chunk.chunk-id">
      <xsl:with-param name="node" select="$target"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="concat($chunk_id, $db.chunk.extension)"/>
  <xsl:if test="$linkend and (string($chunk_id) != $linkend)">
    <xsl:text>#</xsl:text>
    <xsl:value-of select="$linkend"/>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
