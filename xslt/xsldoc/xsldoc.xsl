<?xml version='1.0' encoding='utf-8'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:ref="http://www.gnome.org/~shaunm/mallard/reference"
		exclude-result-prefixes="ref"
		version="1.0">

<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<ref:title>Documenting XSLT Stylesheets</ref:title>


<!-- == xsldoc.toplevel_element == -->

<ref:refname>xsldoc.toplevel_element</ref:refname>
<ref:refpurpose>The top-level element in the generated DocBook</ref:refpurpose>
<ref:para>
  The <ref:parameter>xsldoc.toplevel_element</ref:parameter> parameter
  defines the top-level element used in the generated DocBook.  Allowed
  values are
  <ref:literal>'article'</ref:literal>,
  <ref:literal>'appendix'</ref:literal>,
  <ref:literal>'chapter'</ref:literal>,
  <ref:literal>'reference'</ref:literal>, and
  <ref:literal>'section'</ref:literal>.
  The default is <ref:literal>'section'</ref:literal>.  This may also be
  set by the <ref:xmltag role="xmlpi">xsldoc.toplevel_element</ref:xmltag>
  processing instruction in the source RELAX-NG file.
</ref:para>

<xsl:param name="xsldoc.toplevel_element">
  <xsl:choose>
    <xsl:when test="processing-instruction('xsldoc.toplevel_element')">
      <xsl:value-of select="processing-instruction('xsldoc.toplevel_element')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'section'"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>


<!-- == Matched Templates == -->

<!-- = /xsl:stylesheet = -->
<xsl:template match="/xsl:stylesheet">
  <xsl:variable name="toplevel_element">
    <xsl:choose>
      <xsl:when test="
		$xsldoc.toplevel_element = 'article'   or
		$xsldoc.toplevel_element = 'appendix'  or
		$xsldoc.toplevel_element = 'chapter'   or
		$xsldoc.toplevel_element = 'reference' or
		$xsldoc.toplevel_element = 'section'   ">
	<xsl:value-of select="$xsldoc.toplevel_element"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:message terminate="yes">
	  <xsl:text>Unsupported value of $xsldoc.toplevel_element: </xsl:text>
	  <xsl:value-of select="$xsldoc.toplevel_element"/>
	</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:element name="{toplevel_element}">
    <section>
      <title>Stylesheet Parameters</title>
      <xsl:for-each
       select="ref:refname[following-sibling::xsl:*[1]/self::xsl:param]">
	<refentry>
	  <refnamediv>
	    <refname>
	      <xsl:apply-templates/>
	    </refname>
	    <xsl:if test="following-sibling::ref:*[1]/self::ref:refpurpose">
	      <refpurpose>
		<xsl:apply-templates select="following-sibling::ref:*[1]"/>
	      </refpurpose>
	    </xsl:if>
	  </refnamediv>
	</refentry>
      </xsl:for-each>
    </section>
    <section>
      <title>Named Templates</title>
    </section>
    <section>
      <title>Matched Templates</title>
    </section>
  </xsl:element>
</xsl:template>

</xsl:stylesheet>
