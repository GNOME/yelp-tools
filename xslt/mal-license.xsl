<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mal="http://projectmallard.org/1.0/"
    xmlns:str="http://exslt.org/strings"
    xmlns:exsl="http://exslt.org/common"
    version="1.0">

<xsl:output method="text"/>

<xsl:param name="only" select="''"/>
<xsl:variable name="only_" select="concat(' ', translate($only, ',', ' '), ' ')"/>
<xsl:param name="except" select="''"/>
<xsl:variable name="except_" select="concat(' ', translate($except, ',', ' '), ' ')"/>
<xsl:param name="totals" select="''"/>

<xsl:param name="site.dir"/>

<xsl:template match="/">
  <xsl:variable name="idents">
    <xsl:if test="not(/mal:page/mal:info/mal:license)">
      <ident>none</ident>
    </xsl:if>
    <xsl:for-each select="/mal:page/mal:info/mal:license">
      <ident>
	<xsl:call-template name="license.identifier"/>
      </ident>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="display">
    <xsl:for-each select="exsl:node-set($idents)/*">
      <xsl:choose>
	<xsl:when test="$only != ''">
	  <xsl:if test="contains($only_, concat(' ', ., ' '))">
	    <xsl:text>1</xsl:text>
	  </xsl:if>
	</xsl:when>
	<xsl:when test="$except != ''">
	  <xsl:if test="not(contains($except_, concat(' ', ., ' ')))">
	    <xsl:text>1</xsl:text>
	  </xsl:if>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:text>1</xsl:text>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:variable>
  <xsl:if test="$display != ''">
    <xsl:choose>
      <xsl:when test="$totals = ''">
	<xsl:value-of select="$site.dir"/>
	<xsl:value-of select="concat(/mal:page/@id, ': ')"/>
	<xsl:for-each select="exsl:node-set($idents)/*">
	  <xsl:if test="position() != 1">
	    <xsl:text>, </xsl:text>
	  </xsl:if>
	  <xsl:value-of select="."/>
	</xsl:for-each>
	<xsl:text>&#x0A;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:for-each select="exsl:node-set($idents)/*">
	  <xsl:value-of select="."/>
	  <xsl:text>&#x0A;</xsl:text>
	</xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template name="license.identifier">
  <xsl:param name="href" select="@href"/>
  <xsl:choose>
    <xsl:when test="$href = ''">
      <xsl:text>unknown</xsl:text>
    </xsl:when>
    <xsl:when test="starts-with($href, 'http://creativecommons.org/licenses/')">
      <xsl:text>cc-</xsl:text>
      <xsl:for-each select="str:split(substring-after($href, 'http://creativecommons.org/licenses/'), '/')">
	<xsl:if test="position() != 1">
	  <xsl:text>-</xsl:text>
	</xsl:if>
	<xsl:value-of select="."/>
      </xsl:for-each>
    </xsl:when>
    <xsl:when test="starts-with($href, 'http://www.gnu.org/licenses/')">
      <xsl:variable name="basename">
	<xsl:value-of select="substring-after($href, 'http://www.gnu.org/licenses/')"/>
      </xsl:variable>
      <xsl:choose>
	<xsl:when test="substring($basename, string-length($basename) - 4) = '.html'">
	  <xsl:value-of select="substring($basename, 1, string-length($basename) - 5)"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="$basename"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>unknown</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
