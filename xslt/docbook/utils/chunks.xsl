<?xml version='1.0' encoding='utf-8'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:output method="text" encoding="utf-8"/>

<xsl:include href="../common/db-chunk.xsl"/>
<xsl:include href="../common/db-xref.xsl"/>

<xsl:template match="/">
  <xsl:apply-templates>
    <xsl:with-param name="depth_of_chunk" select="0"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="
	      appendix  | article  | bibliography | book     |
	      chatper   | colophon | dedication   | glossary |
	      glossdiv  | index    | lot          | part     |
	      preface   | refentry | reference    | sect1    |
	      sect2     | sect3    | sect4        | sect5    |
	      section   | setindex | simplesect   | toc      ">
  <xsl:param name="depth_of_chunk" select="0"/>
  <xsl:call-template name="db.xref.target">
    <xsl:with-param name="linkend" select="@id"/>
    <xsl:with-param name="target" select="."/>
  </xsl:call-template>
  <xsl:text>&#x000A;</xsl:text>

  <xsl:if test="$depth_of_chunk &lt; $db.chunk.max_depth">
    <xsl:apply-templates>
      <xsl:with-param name="depth_of_chunk"
		      select="$depth_of_chunk + 1"/>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

<xsl:template match="node()"/>

</xsl:stylesheet>
