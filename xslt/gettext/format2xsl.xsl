<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                xmlns:xslt="http://www.example.com/XSLT"
		exclude-result-prefixes="doc"
                version="1.0">

<xsl:namespace-alias stylesheet-prefix="xslt" result-prefix="xsl"/>

<!-- == format2xsl == -->
<xsl:template name="format2xsl">
  <xsl:param name="str"/>
  <xsl:param name="cur"/>
  <xsl:param name="template"/>
  <xsl:choose>
    <xsl:when test="contains($cur, '%')">
      <xsl:choose>
        <xsl:when test="starts-with(substring-after($cur, '%'), '%')">
          <xslt:text>
            <xsl:value-of select="substring-before($cur, '%')"/>
            <xsl:text>%</xsl:text>
          </xslt:text>
        </xsl:when>
        <xsl:otherwise>
          <xslt:text>
            <xsl:value-of select="substring-before($cur, '%')"/>
          </xslt:text>
          <xsl:variable name="type" select="substring-before(
                                              substring-after($cur, '%'),
                                              '{')"/>
          <xsl:variable name="name" select="substring-before(
                                              substring-after($cur, '{'),
                                              '}')"/>
          <xsl:variable name="aft" select="substring-after($cur, '}')"/>
          <xsl:variable name="param" select="$template/params/param[@name = $name]"/>
          <xsl:choose>
            <xsl:when test="$type = 't'">
              <xsl:if test="not($param/apply-templates or $param/call-template)">
                <xsl:message terminate="yes">
                  <xsl:value-of select="concat(
                                'format2xsl: Error in template ', $template/@name,
                                ', format string for param ', $name,
                                ' is type ', $type,
                                ' but template calls ', local-name($param/*[1])
                                )"/>
                </xsl:message>
              </xsl:if>
              <xsl:apply-templates select="$param/*"/>
            </xsl:when>
            <xsl:when test="$type = 's'">
              <xsl:if test="not($param/value-of)">
                <xsl:message terminate="yes">
                  <xsl:value-of select="concat(
                                'format2xsl: Error in template ', $template/@name,
                                ', format string for param ', $name,
                                ' is type ', $type,
                                ' but template calls ', local-name($param/*[1])
                                )"/>
                </xsl:message>
              </xsl:if>
              <xsl:apply-templates select="$param/*"/>
            </xsl:when>
            <!-- FIXME: numbers -->
          </xsl:choose>
          <xsl:call-template name="format2xsl">
            <xsl:with-param name="str" select="$str"/>
            <xsl:with-param name="cur" select="$aft"/>
            <xsl:with-param name="template" select="$template"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xslt:text>
        <xsl:value-of select="$cur"/>
      </xslt:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- == apply-templates == -->
<xsl:template match="apply-templates">
  <xslt:apply-templates>
    <xsl:if test="@select">
      <xsl:attribute name="select">
        <xsl:value-of select="@select"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@mode">
      <xsl:attribute name="mode">
        <xsl:value-of select="@mode"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </xslt:apply-templates>
</xsl:template>

<!-- == call-template == -->
<xsl:template match="call-template">
  <xslt:call-template name="{@name}">
    <xsl:apply-templates/>
  </xslt:call-template>
</xsl:template>

<!-- == template == -->
<xsl:template match="template">
  <xslt:template name="{@name}">
    <xslt:param name="lang" select="/*/@lang"/>
    <xsl:for-each select="params/param">
      <xslt:param name="{@name}"/>
    </xsl:for-each>
    <xslt:choose>
      <xsl:for-each select="msg/msgstr">
        <!--
          Language codes: en_US@Latn.UTF8
          We can ignore the encoing thing, so we have language, dialect, and charset.
          Sort by the following order, and fallback as needed:
          en_US@Latn en@Latn en_US en
        -->
        <xslt:when>
          <xsl:attribute name="test">
            <xsl:text>$lang = '</xsl:text>
            <xsl:value-of select="@xml:lang"/>
            <xsl:text>'</xsl:text>
          </xsl:attribute>
          <xsl:call-template name="format2xsl">
            <xsl:with-param name="str" select="string(.)"/>
            <xsl:with-param name="cur" select="string(.)"/>
            <xsl:with-param name="template" select="../.."/>
          </xsl:call-template>
        </xslt:when>
      </xsl:for-each>
    </xslt:choose>
  </xslt:template>
</xsl:template>

<!-- == stylesheet == -->
<xsl:template match="stylesheet">
  <xslt:stylesheet version="1.0">
    <xsl:apply-templates select="template"/>
  </xslt:stylesheet>
</xsl:template>

<!-- == value-of == -->
<xsl:template match="value-of">
  <xslt:value-of select="{@select}"/>
</xsl:template>

<!-- == with-param == -->
<xsl:template match="with-param">
  <xslt:with-param name="{@name}">
    <xsl:if test="@select">
      <xsl:attribute name="select">
        <xsl:value-of select="@select"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </xslt:with-param>
</xsl:template>

</xsl:stylesheet>
