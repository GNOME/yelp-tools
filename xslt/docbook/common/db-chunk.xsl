<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:ref="http://www.gnome.org/~shaunm/mallard/reference"
		exclude-result-prefixes="ref"
                version="1.0">

<ref:title>Chunking</ref:title>

<!-- == db.chunk.max_depth == -->

<ref:refname>db2html.chunk.max_depth</ref:refname>
<ref:refpurpose>
  The maximum depth for chunking sections
</ref:refpurpose>

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


<!-- == db.chunk.depth-in-chunk == -->

<ref:refname>db.chunk.depth-in-chunk</ref:refname>
<ref:refpurpose>
  Determine the depth of an element in the containing chunk
</ref:refpurpose>

<xsl:template name="db.chunk.depth-in-chunk">
  <xsl:param name="node" select="."/>
  <!-- FIXME -->
</xsl:template>


<!-- == db.chunk.depth-of-chunk == -->

<ref:refname>db.chunk.depth-of-chunk</ref:refname>
<ref:refpurpose>
  Determine the depth of the containing chunk in the document
</ref:refpurpose>

<xsl:template name="db.chunk.depth-of-chunk">
  <xsl:param name="node" select="."/>
  <!-- FIXME -->
</xsl:template>

</xsl:stylesheet>
