<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                exclude-result-prefixes="doc"
                version="1.0">

<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<doc:title>Documenting XSLT Stylesheets</doc:title>


<!-- == xsldoc.id ========================================================== -->

<doc:parameter>
  <doc:name>xsldoc.id</doc:name>
  <doc:description>
    The id of the top-level element in the output
  </doc:description>
</doc:parameter>

<xsl:param name="xsldoc.id"/>


<!-- == xsldoc.toplevel_element ============================================ -->

<doc:parameter>
  <doc:name>xsldoc.toplevel_element</doc:name>
  <doc:description>
    The top-level element in the generated DocBook
  </doc:description>
  <doc:para>
    The <doc:parameter>xsldoc.toplevel_element</doc:parameter> parameter defines
    the top-level element used in the generated DocBook.  Allowed values are
    <doc:literal>'article'</doc:literal>, <doc:literal>'appendix'</doc:literal>,
    <doc:literal>'chapter'</doc:literal>, and
    <doc:literal>'section'</doc:literal>.  The default is
    <doc:literal>'section'</doc:literal>.  This may also be set by the
    <doc:xmltag role="xmlpi">xsldoc.toplevel_element</doc:xmltag>
    processing instruction in the source RELAX-NG file.
  </doc:para>
</doc:parameter>

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

<doc:template>
  <doc:name>xsldoc.checks</doc:name>
  <doc:description>
    Perform some checks on the source file
  </doc:description>
</doc:template>

<xsl:template name="xsldoc.checks">
  <xsl:variable name="stylesheet" select="."/>

  <!-- Check for orphaned doc:parameter -->
  <xsl:for-each select="doc:parameter">
    <xsl:if test="not(following-sibling::*[1]/
                        self::xsl:param[@name = current()/doc:name])">
      <xsl:message>
        <xsl:value-of select="$xsldoc.id"/>
        <xsl:text>: Orphaned doc:parameter </xsl:text>
        <xsl:value-of select="doc:name"/>
      </xsl:message>
    </xsl:if>
  </xsl:for-each>

  <!-- Check for undocumented xsl:param -->
  <xsl:for-each select="xsl:param[not(@doc:private = 'true')]">
    <xsl:if test="not(preceding-sibling::*[1]/
                        self::doc:parameter[doc:name = current()/@name])">
      <xsl:message>
        <xsl:value-of select="$xsldoc.id"/>
        <xsl:text>: Undocumented xsl:param </xsl:text>
        <xsl:value-of select="@name"/>
      </xsl:message>
    </xsl:if>
  </xsl:for-each>

  <!-- Check for orphaned doc:template -->
  <xsl:for-each select="doc:template">
    <xsl:if test="not(following-sibling::*[1]/
                        self::xsl:template[@name = current()/doc:name])">
      <xsl:message>
        <xsl:value-of select="$xsldoc.id"/>
        <xsl:text>: Orphaned doc:template </xsl:text>
        <xsl:value-of select="doc:name"/>
      </xsl:message>
    </xsl:if>
  </xsl:for-each>

  <!-- Check for undocumented xsl:template[@name] -->
  <xsl:for-each select="xsl:template[@name][not(@doc:private = 'true')]">
    <xsl:if test="not(preceding-sibling::*[1]/
                        self::doc:template[doc:name = current()/@name])">
      <xsl:message>
        <xsl:value-of select="$xsldoc.id"/>
        <xsl:text>: Undocumented xsl:template </xsl:text>
        <xsl:value-of select="@name"/>
      </xsl:message>
    </xsl:if>
  </xsl:for-each>

  <!-- Check for orphaned doc:mode -->
  <xsl:for-each select="doc:mode">
    <xsl:if test="not($stylesheet/xsl:template[@mode = current()/doc:name])">
      <xsl:if test="not($stylesheet/xsl:template//
                          xsl:call-template[@mode = current()/doc:name])">
        <xsl:message>
          <xsl:value-of select="$xsldoc.id"/>
          <xsl:text>: Orphaned doc:mode </xsl:text>
          <xsl:value-of select="doc:name"/>
        </xsl:message>
      </xsl:if>
    </xsl:if>
  </xsl:for-each>

  <!-- Check for undocumented xsl:template/@mode -->
  <xsl:for-each select="xsl:template[@mode]">
    <xsl:if test="not(preceding-sibling::xsl:template[@mode = current()/@mode])">
      <xsl:if test="not(preceding-sibling::doc:mode[doc:name = current()/@mode])">
        <xsl:message>
          <xsl:value-of select="$xsldoc.id"/>
          <xsl:text>: Undocumented xsl:template/@mode </xsl:text>
          <xsl:value-of select="@mode"/>
        </xsl:message>
      </xsl:if>
    </xsl:if>
  </xsl:for-each>

  <!-- Check for undocumented xsl:call-template/@mode -->
  <xsl:for-each select="xsl:template//xsl:call-template[@mode]">
    <xsl:if test="not($stylesheet/doc:mode[doc:name = current()/@mode])">
      <xsl:message>
        <xsl:value-of select="$xsldoc.id"/>
        <xsl:text>: Undocumented xsl:call-template/@mode </xsl:text>
        <xsl:value-of select="@mode"/>
      </xsl:message>
    </xsl:if>
  </xsl:for-each>
</xsl:template>


<!-- == xsldoc.synopsis ==================================================== -->

<doc:template>
  <doc:name>xsldoc.synopsis</doc:name>
  <doc:description>
    Generate the Synopsis section
  </doc:description>
</doc:template>

<xsl:template name="xsldoc.synopsis">
  <xsl:variable name="params" select="doc:parameter"/>
  <xsl:variable name="templates" select="doc:template"/>
  <xsl:variable name="modes" select="doc:mode"/>
  <section id="{concat($xsldoc.id, '-synopsis')}">
    <title>Synopsis</title>
  </section>
</xsl:template>


<!-- == xsldoc.params ====================================================== -->

<doc:template>
  <doc:name>xsldoc.params</doc:name>
  <doc:description>
    Generate the Parameters section
  </doc:description>
</doc:template>

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

<doc:template>
  <doc:name>xsldoc.named</doc:name>
  <doc:description>
    Generate the Named Templates section
  </doc:description>
</doc:template>

<xsl:template name="xsldoc.named">
  <xsl:variable name="named"
                select="ref:refname
                          [following-sibling::xsl:*[1]
                            /self::xsl:template[@name]]"/>
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

<!--
  <xsl:element name="{$toplevel_element}">
-->
<xsl:element name="section">
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
