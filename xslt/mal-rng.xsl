<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:str="http://exslt.org/strings"
    xmlns:exsl="http://exslt.org/common"
    xmlns:mal="http://projectmallard.org/1.0/"
    xmlns:rng="http://relaxng.org/ns/structure/1.0"
    xmlns="http://relaxng.org/ns/structure/1.0"
    exclude-result-prefixes="str exsl"
    version="1.0">

<xsl:template match="/*">
  <xsl:variable name="version">
    <xsl:choose>
      <xsl:when test="string(@version) != ''">
        <xsl:value-of select="@version"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'1.0'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="uris">
    <xsl:for-each select="str:split($version)">
      <xsl:choose>
        <xsl:when test="contains(., ':')">
          <xsl:value-of select="."/>
        </xsl:when>
        <xsl:when test="contains(., '/')">
          <xsl:variable name="ext" select="substring-before(., '/')"/>
          <xsl:variable name="ver" select="substring-after(., '/')"/>
          <xsl:text>http://projectmallard.org/</xsl:text>
          <xsl:value-of select="concat($ext, '/', $ver, '/', $ext, '-', $ver, '.rng')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>http://projectmallard.org/</xsl:text>
          <xsl:value-of select="concat(., '/mallard-', ., '.rng')"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="nss_">
    <xsl:for-each select="str:split($uris)">
      <xsl:for-each select="document(.)/*">
        <nsName ns="{@ns}"/>
      </xsl:for-each>
    </xsl:for-each>
    <nsName ns=""/>
  </xsl:variable>
  <xsl:variable name="nss" select="exsl:node-set($nss_)/*"/>
  <grammar>
    <xsl:for-each select="str:split($uris)">
      <xsl:for-each select="document(.)/rng:grammar">
        <xsl:apply-templates mode="rng.mode" select="*">
          <xsl:with-param name="ns" select="string(@ns)"/>
          <xsl:with-param name="nss" select="$nss"/>
        </xsl:apply-templates>
      </xsl:for-each>
    </xsl:for-each>
  </grammar>
</xsl:template>

<xsl:template mode="rng.mode" match="text()">
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template mode="rng.mode" match="*">
  <xsl:param name="ns"/>
  <xsl:param name="nss"/>
  <xsl:copy>
    <xsl:for-each select="@*">
      <xsl:copy-of select="."/>
    </xsl:for-each>
    <xsl:if test="self::rng:element and not(@ns)">
      <xsl:attribute name="ns">
        <xsl:value-of select="$ns"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates mode="rng.mode">
      <xsl:with-param name="ns" select="$ns"/>
      <xsl:with-param name="nss" select="$nss"/>
    </xsl:apply-templates>
  </xsl:copy>
</xsl:template>

<xsl:template mode="rng.mode" match="rng:anyName/rng:except">
  <xsl:param name="ns"/>
  <xsl:param name="nss"/>
  <except>
    <xsl:copy-of select="$nss"/>
  </except>
</xsl:template>

</xsl:stylesheet>
