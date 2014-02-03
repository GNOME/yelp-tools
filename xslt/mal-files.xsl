<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mal="http://projectmallard.org/1.0/"
    xmlns:if="http://projectmallard.org/if/1.0/"
    xmlns:ui="http://projectmallard.org/ui/1.0/"
    xmlns:uix="http://projectmallard.org/experimental/ui/"
    xmlns:e="http://projectmallard.org/experimental/"
    xmlns:exsl="http://exslt.org/common"
    xmlns:html="http://www.w3.org/1999/xhtml"
    version="1.0">

<xsl:param name="mal.files.copy.icon.dir"/>
<xsl:param name="mal.files.copy.js.dir"/>

<xsl:template name="mal.files.copy">
  <xsl:param name="node" select="."/>
  <xsl:param name="href"/>
  <xsl:value-of select="concat('+', $mal.files.copy.js.dir, '/jquery.js ./&#x000A;')"/>
  <xsl:value-of select="concat('+', $mal.files.copy.js.dir, '/jquery.syntax.js ./&#x000A;')"/>
  <xsl:value-of select="concat('+', $mal.files.copy.js.dir, '/jquery.syntax.core.js ./&#x000A;')"/>
  <xsl:value-of select="concat('+', $mal.files.copy.js.dir, '/jquery.syntax.layout.yelp.js ./&#x000A;')"/>
  <xsl:apply-templates mode="mal.files.copy.block.mode">
    <xsl:with-param name="dir">
      <xsl:call-template name="mal.files.copy.dirname">
        <xsl:with-param name="href" select="$href"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:apply-templates>
</xsl:template>

<xsl:template name="mal.files.copy.dirname">
  <xsl:param name="href"/>
  <xsl:if test="contains($href, '/')">
    <xsl:value-of select="substring-before($href, '/')"/>
    <xsl:text>/</xsl:text>
    <xsl:call-template name="mal.files.copy.dirname">
      <xsl:with-param name="href" select="substring-after($href, '/')"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template mode="mal.files.copy.media.mode" match="*"/>

<xsl:template mode="mal.files.copy.media.mode" match="mal:media | e:mouseover | ui:thumb | uix:thumb">
  <xsl:param name="dir"/>
  <xsl:if test="not(contains(@src, ':') or substring(@src, 1, 1) = '/')">
    <xsl:value-of select="concat('-', $dir, @src, ' ', @src, '&#x000A;')"/>
  </xsl:if>
</xsl:template>

<xsl:template mode="mal.files.copy.block.mode" match="text()"/>

<xsl:template mode="mal.files.copy.block.mode" match="*">
  <xsl:param name="dir"/>
  <xsl:param name="restricted" select="false()"/>
  <xsl:if test="not($restricted)">
    <xsl:variable name="if">
      <xsl:call-template name="mal.if.test"/>
    </xsl:variable>
    <xsl:if test="$if != ''">
      <xsl:apply-templates mode="mal.files.copy.block.mode">
        <xsl:with-param name="dir" select="$dir"/>
        <xsl:with-param name="restricted" select="true()"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template mode="mal.files.copy.block.mode" match="mal:info">
  <xsl:param name="dir"/>
  <xsl:apply-templates mode="mal.files.copy.block.mode"
                       select="mal:title | mal:desc | mal:license/* | mal:link/*
                               | mal:revision/* | mal:credit | ui:thumb | uix:thumb">
    <xsl:with-param name="dir" select="$dir"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template mode="mal.files.copy.block.mode" match="mal:p | mal:screen">
  <xsl:param name="dir"/>
  <xsl:variable name="if">
    <xsl:call-template name="mal.if.test"/>
  </xsl:variable>
  <xsl:if test="$if != ''">
    <xsl:apply-templates mode="mal.files.copy.media.mode" select=".//mal:media">
      <xsl:with-param name="dir" select="$dir"/>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

<xsl:template mode="mal.files.copy.block.mode" match="mal:title | mal:subtitle | mal:desc | mal:cite | mal:credit">
  <xsl:param name="dir"/>
  <xsl:apply-templates mode="mal.files.copy.media.mode" select=".//mal:media">
    <xsl:with-param name="dir" select="$dir"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template mode="mal.files.copy.block.mode" match="mal:code">
  <xsl:param name="dir"/>
  <xsl:variable name="if">
    <xsl:call-template name="mal.if.test"/>
  </xsl:variable>
  <xsl:if test="$if != ''">
    <xsl:apply-templates mode="mal.files.copy.media.mode" select=".//mal:media">
      <xsl:with-param name="dir" select="$dir"/>
    </xsl:apply-templates>
    <xsl:if test="$html.syntax.highlight and @mime">
      <xsl:variable name="brush">
        <xsl:call-template name="html.syntax.class"/>
      </xsl:variable>
      <xsl:if test="starts-with($brush, 'syntax brush-')">
        <xsl:value-of select="concat('+', $mal.files.copy.js.dir, '/jquery.syntax.brush.',
                              substring-after($brush,  'syntax brush-'), '.js ./&#x000A;')"/>
      </xsl:if>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template mode="mal.files.copy.block.mode"
              match="mal:example | mal:quote | mal:listing | mal:figure |
                     mal:synopsis | mal:links | mal:list | mal:steps |
                     mal:terms | mal:tree | mal:item | mal:table |
                     mal:section | if:if">
  <xsl:param name="dir"/>
  <xsl:variable name="if">
    <xsl:call-template name="mal.if.test"/>
  </xsl:variable>
  <xsl:if test="$if != ''">
    <xsl:apply-templates mode="mal.files.copy.block.mode">
      <xsl:with-param name="dir" select="$dir"/>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

<xsl:template mode="mal.files.copy.block.mode" match="mal:media | e:mouseover | ui:thumb | uix:thumb">
  <xsl:param name="dir"/>
  <xsl:variable name="if">
    <xsl:call-template name="mal.if.test"/>
  </xsl:variable>
  <xsl:if test="$if != ''">
    <xsl:apply-templates mode="mal.files.copy.media.mode" select=".">
      <xsl:with-param name="dir" select="$dir"/>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

<xsl:template mode="mal.files.copy.block.mode" match="mal:comment">
  <xsl:param name="dir"/>
  <xsl:variable name="if">
    <xsl:call-template name="mal.if.test"/>
  </xsl:variable>
  <xsl:if test="$if != ''">
    <xsl:if test="$mal2html.editor_mode
                  or processing-instruction('mal2html.show_comment')">
      <xsl:apply-templates mode="mal.files.copy.block.mode">
        <xsl:with-param name="dir" select="$dir"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template mode="mal.files.copy.block.mode" match="mal:note">
  <xsl:param name="dir"/>
  <xsl:variable name="if">
    <xsl:call-template name="mal.if.test"/>
  </xsl:variable>
  <xsl:if test="$if != ''">
    <xsl:variable name="style" select="concat(' ', @style, ' ')"/>
    <xsl:choose>
      <!--
        <xsl:when test="contains($style, ' advanced ')">
        <xsl:value-of select="concat('+', $mal.files.copy.icon.dir, '/yelp-note-advanced.png ./&#x000A;')"/>
        </xsl:when>
      -->
      <xsl:when test="contains($style, ' bug ')">
        <xsl:value-of select="concat('+', $mal.files.copy.icon.dir, '/yelp-note-bug.png ./&#x000A;')"/>
      </xsl:when>
      <xsl:when test="contains($style, ' important ')">
        <xsl:value-of select="concat('+', $mal.files.copy.icon.dir, '/yelp-note-important.png ./&#x000A;')"/>
      </xsl:when>
      <xsl:when test="contains($style, ' sidebar ')"/>
      <xsl:when test="contains($style, ' tip ')">
        <xsl:value-of select="concat('+', $mal.files.copy.icon.dir, '/yelp-note-tip.png ./&#x000A;')"/>
      </xsl:when>
      <xsl:when test="contains($style, ' warning ')">
        <xsl:value-of select="concat('+', $mal.files.copy.icon.dir, '/yelp-note-warning.png ./&#x000A;')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('+', $mal.files.copy.icon.dir, '/yelp-note.png ./&#x000A;')"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="mal.files.copy.block.mode">
      <xsl:with-param name="dir" select="$dir"/>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

<xsl:template mode="mal.files.copy.block.mode" match="mal:tr | mal:td"> 
  <xsl:param name="dir"/>
  <xsl:apply-templates mode="mal.files.copy.block.mode">
    <xsl:with-param name="dir" select="$dir"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template mode="mal.files.copy.block.mode" match="if:choose">
  <xsl:param name="dir"/>
  <xsl:apply-templates mode="mal.files.copy.block.mode" select="if:when[1]">
    <xsl:with-param name="dir" select="$dir"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template mode="mal.files.copy.block.mode" match="if:when">
  <xsl:param name="dir"/>
  <xsl:variable name="if">
    <xsl:call-template name="mal.if.test"/>
  </xsl:variable>
  <xsl:if test="$if != ''">
    <xsl:apply-templates mode="mal.files.copy.block.mode">
      <xsl:with-param name="dir" select="$dir"/>
    </xsl:apply-templates>
  </xsl:if>
  <xsl:if test="$if != 'true'">
    <xsl:apply-templates mode="mal.files.copy.block.mode" select="following-sibling::*[1]">
      <xsl:with-param name="dir" select="$dir"/>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

<xsl:template mode="mal.files.copy.block.mode" match="if:else">
  <xsl:param name="dir"/>
  <xsl:apply-templates mode="mal.files.copy.block.mode">
    <xsl:with-param name="dir" select="$dir"/>
  </xsl:apply-templates>
</xsl:template>

</xsl:stylesheet>
