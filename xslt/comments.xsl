<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mal="http://projectmallard.org/1.0/"
    xmlns:db="http://docbook.org/ns/docbook"
    exclude-result-prefixes="mal db"
    version="1.0">

<xsl:output method="text"/>

<xsl:param name="basename"/>

<xsl:template match="/*[namespace-uri(.) = ''] | /db:*">
  <xsl:for-each select="//remark | //db:remark">
    <xsl:text>Page:  </xsl:text>
    <xsl:value-of select="$basename"/>
    <xsl:if test="ancestor::*/@id | ancestor::*/@xml:id">
      <xsl:text>#</xsl:text>
      <xsl:value-of select="(ancestor::*/@id | ancestor::*/@xml:id)[last()]"/>
    </xsl:if>
    <xsl:text>&#x000A;</xsl:text>
    <xsl:if test="@revisionflag">
      <xsl:text>Flag:  </xsl:text>
      <xsl:value-of select="@revisionflag"/>
      <xsl:text>&#x000A;</xsl:text>
    </xsl:if>
    <xsl:text>&#x000A;</xsl:text>
    <xsl:call-template name="fill">
      <xsl:with-param name="text" select="normalize-space(.)"/>
      <xsl:with-param name="pad" select="'  '"/>
    </xsl:call-template>
    <xsl:text>&#x000A;</xsl:text>
  </xsl:for-each>
</xsl:template>

<xsl:template match="/mal:page">
  <xsl:for-each select="//mal:comment">
    <xsl:variable name="id">
      <xsl:value-of select="/mal:page/@id"/>
      <xsl:if test="ancestor::mal:section[1]/@id">
        <xsl:text>#</xsl:text>
        <xsl:value-of select="ancestor::mal:section[1]/@id"/>
      </xsl:if>
    </xsl:variable>
    <xsl:text>Page:  </xsl:text>
    <xsl:value-of select="$id"/>
    <xsl:text>&#x000A;</xsl:text>
    <xsl:if test="mal:cite">
      <xsl:text>From:  </xsl:text>
      <xsl:value-of select="mal:cite[1]"/>
      <xsl:if test="starts-with(mal:cite[1]/@href, 'mailto:')">
        <xsl:text> &lt;</xsl:text>
        <xsl:value-of select="substring-after(mal:cite[1]/@href, 'mailto:')"/>
        <xsl:text>&gt;</xsl:text>
      </xsl:if>
      <xsl:text>&#x000A;</xsl:text>
      <xsl:if test="mal:cite[1]/@date">
        <xsl:text>Date:  </xsl:text>
        <xsl:value-of select="mal:cite[1]/@date"/>
        <xsl:text>&#x000A;</xsl:text>
      </xsl:if>
    </xsl:if>
    <xsl:text>&#x000A;</xsl:text>
    <xsl:for-each select="*[not(self::mal:cite)]">
      <xsl:choose>
        <xsl:when test="self::mal:p">
          <xsl:call-template name="fill">
            <xsl:with-param name="text" select="normalize-space(.)"/>
            <xsl:with-param name="pad" select="'  '"/>
          </xsl:call-template>
          <xsl:text>&#x000A;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>  FIXME: &lt;</xsl:text>
          <xsl:value-of select="local-name(.)"/>
          <xsl:text>&gt;...&lt;/</xsl:text>
          <xsl:value-of select="local-name(.)"/>
          <xsl:text>&gt;</xsl:text>
          <xsl:text>&#x000A;&#x000A;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:if test="not(*[not(self::mal:cite)])">
      <xsl:text>&#x000A;&#x000A;</xsl:text>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

<xsl:template name="fill">
  <xsl:param name="text" select="''"/>
  <xsl:param name="pad" select="''"/>
  <xsl:param name="end" select="80 - string-length($pad)"/>
  <xsl:param name="col" select="$end"/>
  <xsl:choose>
    <xsl:when test="$col &gt; string-length($text)">
      <xsl:value-of select="$pad"/>
      <xsl:value-of select="$text"/>
      <xsl:text>&#x000A;</xsl:text>
    </xsl:when>
    <xsl:when test="substring($text, $col, 1) = ' '">
      <xsl:value-of select="$pad"/>
      <xsl:value-of select="substring($text, 0, $col)"/>
      <xsl:text>&#x000A;</xsl:text>
      <xsl:call-template name="fill">
        <xsl:with-param name="text" select="substring($text, $col + 1)"/>
        <xsl:with-param name="end" select="$end"/>
        <xsl:with-param name="pad" select="$pad"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="fill">
        <xsl:with-param name="text" select="$text"/>
        <xsl:with-param name="end" select="$end"/>
        <xsl:with-param name="pad" select="$pad"/>
        <xsl:with-param name="col" select="$col - 1"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
