<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
		exclude-result-prefixes="ref"
                version="1.0">

<doc:title>Function Synopses</doc:title>


<!-- == db2html.funcsynopsis.style ========================================= -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.funcsynopsis.style</name>
  <description>
    How to render <xmltag>funcsynopsis</xmltag> elements, either
    <constant>'K&amp;R'</constant> or <constant>'ANSI'</constant>
  </description>
</parameter>

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


<!-- == db2html.funcsynopsis =============================================== -->

<function xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.funcsynopsis</name>
  <description>
    Process a <xmltag>funcsynopsis</xmltag> element
  </description>
  <parameter>
    <name>style</name>
    <description>
      How to render the <xmltag>funcsynopsis</xmltag> element, either
      <constant>'K&amp;R'</constant> or <constant>'ANSI'</constant>
    </description>
  </parameter>
</function>

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
