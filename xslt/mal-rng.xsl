<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:str="http://exslt.org/strings"
    xmlns:exsl="http://exslt.org/common"
    xmlns:mal="http://projectmallard.org/1.0/"
    xmlns:cache="http://projectmallard.org/cache/1.0/"
    xmlns:rng="http://relaxng.org/ns/structure/1.0"
    xmlns="http://relaxng.org/ns/structure/1.0"
    exclude-result-prefixes="mal cache str exsl rng"
    version="1.0">

<xsl:param name="rng.strict" select="false()"/>
<xsl:param name="rng.strict.allow" select="''"/>

<xsl:template match="/*">
  <xsl:variable name="version">
    <xsl:choose>
      <xsl:when test="string(@version) != ''">
        <xsl:value-of select="@version"/>
      </xsl:when>
      <xsl:when test="/cache:cache">
        <xsl:value-of select="'cache/1.0 1.0'"/>
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
        <xsl:if test="@ns != ''">
          <nsName ns="{@ns}"/>
        </xsl:if>
        <xsl:for-each select="namespace::*">
          <xsl:if test=". != '' and
                        not(local-name(.) = '' and . = 'http://relaxng.org/ns/structure/1.0') and
                        not(local-name(.) = 'xml' and . = 'http://www.w3.org/XML/1998/namespace')
                        ">
            <nsName ns="{.}"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
    <nsName ns=""/>
  </xsl:variable>
  <xsl:variable name="nss" select="exsl:node-set($nss_)/*[not(@ns = preceding-sibling::*/@ns)]"/>
  <grammar>
    <xsl:for-each select="str:split($uris)">
      <xsl:variable name="first" select="position() = 1"/>
      <xsl:for-each select="document(.)/rng:grammar">
        <xsl:apply-templates mode="rng.mode" select="*">
          <xsl:with-param name="first" select="$first"/>
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
  <xsl:param name="first"/>
  <xsl:param name="ns"/>
  <xsl:param name="nss"/>
  <xsl:choose>
    <xsl:when test="$rng.strict and rng:anyName">
      <xsl:choose>
        <xsl:when test="$rng.strict.allow != ''">
          <xsl:copy>
            <choice>
              <xsl:if test="self::rng:attribute/ancestor::rng:element[1]/rng:anyName">
                <nsName ns=""/>
              </xsl:if>
              <xsl:for-each select="str:split($rng.strict.allow)">
                <nsName ns="{.}"/>
              </xsl:for-each>
              <xsl:if test="ancestor::rng:define/@name = 'mal_attr_external'">
                <nsName ns="http://www.w3.org/XML/1998/namespace"/>
              </xsl:if>
            </choice>
            <xsl:apply-templates mode="rng.mode" select="rng:anyName/following-sibling::*">
              <xsl:with-param name="first" select="$first"/>
              <xsl:with-param name="ns" select="$ns"/>
              <xsl:with-param name="nss" select="$nss"/>
            </xsl:apply-templates>
          </xsl:copy>
        </xsl:when>
        <xsl:when test="ancestor::rng:define/@name = 'mal_attr_external'">
          <xsl:copy>
            <nsName ns="http://www.w3.org/XML/1998/namespace"/>
          </xsl:copy>
        </xsl:when>
        <xsl:otherwise>
          <empty/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="nsmunge" select="self::rng:element or self::rng:attribute"/>
      <xsl:copy>
        <xsl:for-each select="@*">
          <xsl:choose>
            <xsl:when test="$nsmunge and local-name(.) = 'name' and contains(., ':')">
              <xsl:attribute name="name">
                <xsl:value-of select="substring-after(., ':')"/>
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:copy-of select="."/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
        <xsl:if test="$nsmunge and not(@ns)">
          <xsl:choose>
            <xsl:when test="contains(@name, ':')">
              <xsl:variable name="prefix" select="substring-before(@name, ':')"/>
              <xsl:attribute name="ns">
                <xsl:value-of select="namespace::*[local-name(.) = $prefix]"/>
              </xsl:attribute>
            </xsl:when>
            <xsl:when test="self::rng:element">
              <xsl:attribute name="ns">
                <xsl:value-of select="$ns"/>
              </xsl:attribute>
            </xsl:when>
          </xsl:choose>
        </xsl:if>
        <xsl:apply-templates mode="rng.mode">
          <xsl:with-param name="first" select="$first"/>
          <xsl:with-param name="ns" select="$ns"/>
          <xsl:with-param name="nss" select="$nss"/>
        </xsl:apply-templates>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template mode="rng.mode" match="rng:start">
  <xsl:param name="first"/>
  <xsl:param name="ns"/>
  <xsl:param name="nss"/>
  <xsl:if test="$first or @combine = 'choice' or @combine = 'interleave'">
    <xsl:copy>
      <xsl:for-each select="@*">
        <xsl:copy-of select="."/>
      </xsl:for-each>
      <xsl:apply-templates mode="rng.mode">
        <xsl:with-param name="first" select="$first"/>
        <xsl:with-param name="ns" select="$ns"/>
        <xsl:with-param name="nss" select="$nss"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:if>
</xsl:template>

<xsl:template mode="rng.mode" match="rng:anyName/rng:except">
  <xsl:param name="first"/>
  <xsl:param name="ns"/>
  <xsl:param name="nss"/>
  <except>
    <xsl:copy-of select="$nss"/>
  </except>
</xsl:template>

</xsl:stylesheet>
