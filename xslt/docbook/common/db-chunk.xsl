<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
		exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Chunking</doc:title>

<!-- == db.chunk.max_depth ================================================= -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.chunk.max_depth</name>
  <description>
    The maximum depth for chunking sections
  </description>
</parameter>

<xsl:param name="db.chunk.max_depth">
  <xsl:choose>
    <xsl:when
     test="number(processing-instruction('db.chunk.max_depth'))">
      <xsl:value-of
       select="number(processing-instruction('db.chunk.max_depth'))"/>
    </xsl:when>
    <xsl:when test="/book">
      <xsl:value-of select="2"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="1"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>


<!-- == db.chunk.depth-in-chunk ============================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.chunk.depth-in-chunk</name>
  <description>
    Determine the depth of an element in the containing chunk
  </description>
  <parameter>
    <name>node</name>
    <description>
      The element for which to determine the depth
    </description>
  </parameter>
</template>

<xsl:template name="db.chunk.depth-in-chunk">
  <xsl:param name="node" select="."/>
  <!-- FIXME -->
</xsl:template>


<!-- == db.chunk.depth-of-chunk ============================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.chunk.depth-of-chunk</name>
  <description>
    Determine the depth of the containing chunk in the document
  </description>
  <parameter>
    <name>node</name>
    <description>
      The element for which to determine the depth
    </description>
  </parameter>
</template>

<xsl:template name="db.chunk.depth-of-chunk">
  <xsl:param name="node" select="."/>
  <!-- FIXME -->
</xsl:template>

</xsl:stylesheet>
