<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:str="http://exslt.org/strings"
		xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
		extension-element-prefixes="str"
		exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Function Synopses</doc:title>


<!-- == db2html.funcsynopsis.style ========================================= -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.funcsynopsis.style</name>
  <description>
    How to render <xmltag>funcsynopsis</xmltag> elements, either
    <constant>'KR'</constant> or <constant>'ANSI'</constant>
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


<!-- == Matched Templates ================================================== -->

<!-- = funcdef = -->
<xsl:template match="funcdef">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = funcparams = -->
<xsl:template match="funcparams">
  <xsl:text>(</xsl:text>
  <xsl:call-template name="db2html.inline"/>
  <xsl:text>)</xsl:text>
</xsl:template>

<!-- = funcprototype = -->
<xsl:template match="funcprototype">
  <xsl:param name="style"/>
  <xsl:apply-templates select="funcdef/preceding-sibling::modifer"/>
  <xsl:apply-templates select="funcdef"/>
  <xsl:text> (</xsl:text>
  <xsl:choose>
    <xsl:when test="$style = 'KR'">
      <xsl:for-each select="void | varargs | paramdef/parameter">
	<xsl:if test="position() != 1">
	  <xsl:text>, </xsl:text>
	</xsl:if>
	<xsl:apply-templates select="."/>
      </xsl:for-each>
      <xsl:text>)</xsl:text>
      <xsl:apply-templates select="funcdef/following-sibling::modifier"/>
      <xsl:text>;</xsl:text>
      <xsl:for-each select="paramdef">
	<xsl:text>&#x000A;    </xsl:text>
	<xsl:apply-templates select="."/>
	<xsl:text>;</xsl:text>
      </xsl:for-each>
    </xsl:when>
    <!-- ANSI is the default -->
    <xsl:otherwise>
      <xsl:variable name="indent"
		    select="2 + string-length(
		                  funcdef |
		                  funcdef/preceding-sibling::modifier)"/>
      <xsl:for-each select="void | varargs | paramdef">
	<xsl:if test="position() != 1">
	  <xsl:text>,&#x000A;</xsl:text>
	  <xsl:value-of select="str:padding($indent)"/>
	</xsl:if>
	<xsl:apply-templates select="."/>
      </xsl:for-each>
      <xsl:text>)</xsl:text>
      <xsl:apply-templates select="funcdef/following-sibling::modifier"/>
      <xsl:text>;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- = funcsynopsis = -->
<xsl:template match="funcsynopsis">
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
  <pre class="funcsynopsis">
    <xsl:call-template name="db2html.anchor"/>
    <!-- The select is needed to avoid extra whitespace -->
    <xsl:apply-templates select="*">
      <xsl:with-param name="style" select="$style"/>
    </xsl:apply-templates>
  </pre>
</xsl:template>

<!-- = funcsynopsisinfo = -->
<xsl:template match="funcsynopsisinfo">
  <xsl:call-template name="db2html.pre"/>
</xsl:template>

<!-- = initializer = -->
<xsl:template match="initializer">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = modifier = -->
<xsl:template match="modifier">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = paramdef = -->
<xsl:template match="paramdef">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = paramdef/parameter = -->
<xsl:template match="paramdef/parameter">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="mono" select="true()"/>
    <xsl:with-param name="italic" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = varargs = -->
<xsl:template match="varargs">
  <xsl:text>...</xsl:text>
</xsl:template>

<!-- = void = -->
<xsl:template match="void">
  <xsl:text>void</xsl:text>
</xsl:template>

</xsl:stylesheet>
