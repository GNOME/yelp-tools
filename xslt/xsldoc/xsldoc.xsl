<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                exclude-result-prefixes="doc"
                version="1.0">

<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<doc:title>Documenting XSLT Stylesheets</doc:title>


<!-- == xsldoc.id ========================================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>xsldoc.id</name>
  <description>
    The id of the top-level element in the output
  </description>
</parameter>

<xsl:param name="id"/>


<!-- == xsldoc.toplevel_element ============================================ -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>xsldoc.toplevel_element</name>
  <description>
    The top-level element in the generated DocBook
  </description>
  <para>
    The <parameter>xsldoc.toplevel_element</parameter> parameter defines the
    top-level element used in the generated DocBook.  Allowed values are
    <literal>'article'</literal>, <literal>'appendix'</literal>,
    <literal>'chapter'</literal>, and <literal>'section'</literal>.
    The default is <literal>'section'</literal>.  This may also be set by
    the <xmltag role="xmlpi">xsldoc.toplevel_element</xmltag> processing
    instruction in the source RELAX-NG file.
  </para>
</parameter>

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


<!-- == xsldoc.checks ====================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>xsldoc.checks</name>
  <description>
    Perform some checks on the source file
  </description>
</template>

<xsl:template name="xsldoc.checks">
  <!-- Check for orphaned doc:parameter -->
  <xsl:for-each select="doc:parameter">
    <xsl:if test="not(following-sibling::*[1]/self::xsl:param)">
      <xsl:message>
        <xsl:text>Orphaned doc:parameter "</xsl:text>
        <xsl:value-of select="doc:name"/>
        <xsl:text>"</xsl:text>
      </xsl:message>
    </xsl:if>
  </xsl:for-each>

  <!-- Check for orphaned xsl:param -->
  <xsl:for-each select="xsl:param[
                          not(preceding-sibling::*[1]/self::doc:parameter)]">
    <xsl:message>
      <xsl:text>Orphaned xsl:param "</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>"</xsl:text>
    </xsl:message>
  </xsl:for-each>
</xsl:template>


<!-- == xsldoc.synopsis ==================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>xsldoc.synopsis</name>
  <description>
    Generate the Synopsis section
  </description>
</template>

<xsl:template name="xsldoc.synopsis">
  <xsl:variable name="params"
                select="doc:parameter[
                          following-sibling::xsl:*[1]/self::xsl:param]"/>
</xsl:template>



<!-- == xsldoc.params ====================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>xsldoc.params</name>
  <description>
    Generate the Parameters section
  </description>
</template>

<xsl:template name="xsldoc.params">
  <xsl:variable name="params"
                select="ref:refname[following-sibling::xsl:*[1]/self::xsl:param]"/>
  <xsl:if test="$params">
    <section>
      <xsl:attribute name="id">
        <xsl:value-of select="concat($xsldoc.id, '-params')"/>
      </xsl:attribute>
      <title>Stylesheet Parameters</title>
      <xsl:for-each select="$params">
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
  </xsl:if>
</xsl:template>


<!-- == xsldoc.named ======================================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>xsldoc.named</name>
  <description>
    Generate the Named Templates section
  </description>
</template>

<xsl:template name="xsldoc.named">
  <xsl:variable name="named"
                select="ref:refname[following-sibling::xsl:*[1]/self::xsl:template[@name]]"/>
  <xsl:if test="$named">
    <section>
      <xsl:attribute name="id">
        <xsl:value-of select="concat($xsldoc.id, '-named')"/>
      </xsl:attribute>
      <title>Named Templates</title>
      <xsl:for-each select="$named">
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
  </xsl:if>
</xsl:template>


<!-- == Matched Templates ================================================== -->

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

  <xsl:element name="{$toplevel_element}">
    <xsl:attribute name="id">
      <xsl:value-of select="$xsldoc.id"/>
    </xsl:attribute>
    <title>
      <xsl:apply-templates select="doc:title[1]/node()"/>
    </title>
    <xsl:call-template name="xsldoc.checks"/>
    <xsl:call-template name="xsldoc.synopsis"/>
    <!--
      <xsl:call-template name="xsldoc.params"/>
      <xsl:call-template name="xsldoc.named"/>
      <section>
      <xsl:attribute name="id">
      <xsl:value-of select="concat($xsldoc.id, '-matched')"/>
      </xsl:attribute>
      <title>Matched Templates</title>
      </section>
    -->
  </xsl:element>
</xsl:template>

</xsl:stylesheet>
