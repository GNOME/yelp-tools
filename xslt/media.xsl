<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mal="http://projectmallard.org/1.0/"
    xmlns:ui="http://projectmallard.org/ui/1.0/"
    xmlns:uix="http://projectmallard.org/experimental/ui/"
    xmlns:e="http://projectmallard.org/experimental/"
    xmlns:db="http://docbook.org/ns/docbook"
    version="1.0">

<xsl:output method="text"/>

<xsl:template match="/*[namespace-uri(.) = ''] | /db:*">
  <xsl:for-each select="
                        //audiodata | //imagedata | //videodata |
                        //db:audiodata | //db:imagedata | //db:videodata">
    <xsl:variable name="src">
      <xsl:choose>
        <xsl:when test="@fileref">
          <xsl:value-of select="@fileref"/>
        </xsl:when>
        <xsl:when test="@entityref">
          <xsl:value-of select="unparsed-entity-uri(@entityref)"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$src"/>
    <xsl:text>&#x000A;</xsl:text>
  </xsl:for-each>
</xsl:template>

<xsl:template match="/mal:page">
  <xsl:variable name="id" select="@id"/>  
  <xsl:for-each select="//mal:media[@src] | //uix:thumb | //ui:thumb | //e:mouseover">
    <xsl:value-of select="@src"/>
    <xsl:text>&#x000A;</xsl:text>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
