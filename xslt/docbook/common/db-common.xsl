<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Common DocBook Templates</doc:title>


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

</xsl:stylesheet>
