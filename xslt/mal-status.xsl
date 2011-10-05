<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mal="http://projectmallard.org/1.0/"
    xmlns:cache="http://projectmallard.org/cache/1.0/"
    xmlns:exsl="http://exslt.org/common"
    xmlns:str="http://exslt.org/strings"
    xmlns:dyn="http://exslt.org/dynamic"
    exclude-result-prefixes="mal cache exsl dyn"
    version="1.0">

<xsl:output method="text"/>

<xsl:param name="version" select="''"/>
<xsl:param name="docversion" select="''"/>
<xsl:param name="pkgversion" select="''"/>

<xsl:param name="older" select="''"/>
<xsl:param name="newer" select="''"/>

<xsl:param name="only" select="''"/>
<xsl:variable name="only_" select="concat(' ', translate($only, ',', ' '), ' ')"/>
<xsl:param name="except" select="''"/>
<xsl:variable name="except_" select="concat(' ', translate($except, ',', ' '), ' ')"/>

<xsl:param name="totals" select="''"/>

<xsl:template match="/">
  <xsl:choose>
    <xsl:when test="$totals = '1'">
      <xsl:variable name="statuses">
        <xsl:apply-templates/>
      </xsl:variable>
      <xsl:variable name="stlist" select="str:split($statuses)"/>
      <xsl:for-each select="$stlist">
        <xsl:sort select="string(.)"/>
        <xsl:variable name="stval" select="string(.)"/>
        <xsl:if test="not(preceding-sibling::*[string(.) = $stval])">
          <xsl:value-of select="$stval"/>
          <xsl:text>: </xsl:text>
          <xsl:value-of select="count($stlist[string(.) = $stval])"/>
          <xsl:text>&#x000A;</xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="/cache:cache">
  <xsl:for-each select="mal:page">
    <xsl:sort select="@id"/>
    <xsl:variable name="select">
      <xsl:text>mal:info/mal:revision</xsl:text>
      <xsl:if test="$version != ''">
        <xsl:text>[</xsl:text>
        <xsl:for-each select="str:tokenize($version, ', ')">
          <xsl:if test="position() != 1">
            <xsl:text> or </xsl:text>
          </xsl:if>
          <xsl:text>@version = '</xsl:text>
          <xsl:value-of select="."/>
          <xsl:text>'</xsl:text>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
      </xsl:if>
      <xsl:if test="$docversion != ''">
        <xsl:text>[</xsl:text>
        <xsl:for-each select="str:tokenize($docversion, ', ')">
          <xsl:if test="position() != 1">
            <xsl:text> or </xsl:text>
          </xsl:if>
          <xsl:text>@docversion = '</xsl:text>
          <xsl:value-of select="."/>
          <xsl:text>'</xsl:text>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
      </xsl:if>
      <xsl:if test="$pkgversion != ''">
        <xsl:text>[</xsl:text>
        <xsl:for-each select="str:tokenize($pkgversion, ', ')">
          <xsl:if test="position() != 1">
            <xsl:text> or </xsl:text>
          </xsl:if>
          <xsl:text>@pkgversion = '</xsl:text>
          <xsl:value-of select="."/>
          <xsl:text>'</xsl:text>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="revision_">
      <xsl:for-each select="dyn:evaluate($select)">
        <xsl:sort select="@date" order="descending"/>
        <xsl:if test="position() = 1">
          <xsl:copy-of select="."/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="revision" select="exsl:node-set($revision_)/*"/>
    <xsl:variable name="status">
      <xsl:choose>
        <xsl:when test="$revision and $revision/@status">
          <xsl:value-of select="$revision/@status"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>none</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$only = '' or contains($only_, concat(' ', $status, ' '))">
      <xsl:if test="$except = '' or not(contains($except_, concat(' ', $status, ' ')))">
        <xsl:if test="$older = '' or ($revision/@date and
                      (translate($revision/@date, '-', '') &lt; translate($older, '-', '')))">
          <xsl:if test="$newer = '' or ($revision/@date and
                        (translate($revision/@date, '-', '') &gt; translate($newer, '-', '')))">
            <xsl:if test="$totals != '1'">
              <xsl:value-of select="@id"/>
              <xsl:text>: </xsl:text>
            </xsl:if>
            <xsl:value-of select="$status"/>
            <xsl:choose>
              <xsl:when test="$totals != '1'">
                <xsl:text>&#x000A;</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text> </xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </xsl:if>
      </xsl:if>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
