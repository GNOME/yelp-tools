<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:ref="http://www.gnome.org/~shaunm/mallard/reference"
		exclude-result-prefixes="ref"
                version="1.0">

<ref:title>Function Synopses</ref:title>


<!-- == db2html.funcsynopsis.style == -->

<ref:refname>db2html.funcsynopsis.style</ref:refname>
<ref:refpurpose>
  How to render <ref:xmltag>funcsynopsis</ref:xmltag> elements,
  either <ref:constant>'K&amp;R'</ref:constant> or
  <ref:constant>'ANSI'</ref:constant>
</ref:refpurpose>

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


<!-- == db2html.funcsynopsis == -->

<ref:refname>db2html.funcsynopsis</ref:refname>
<ref:refpurpose>
  Process <ref:xmltag>funcsynopsis</ref:xmltag> elements
</ref:refpurpose>

<xsl:template name="db2html.funcsynopsis">
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
  <div class="funcsynopsis">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:apply-templates mode="db2html.funcsynopsis.mode">
      <xsl:with-param name="style" select="$style"/>
    </xsl:apply-templates>
  </div>
</xsl:template>


<!-- == Matched Templates == -->

<!-- = funcsynopsis = -->
<xsl:template match="funcsynopsis">
  <xsl:call-template name="db2html.funcsynopsis"/>
</xsl:template>

<!-- = db2html.funcsynopsis.mode == funcsynopsisinfo = -->
<xsl:template mode="db2html.funcsynopsis.mode" match="funcsynopsisinfo">
  <pre class="funcsynopsisinfo">
    <xsl:apply-templates/>
  </pre>
</xsl:template>

</xsl:stylesheet>
