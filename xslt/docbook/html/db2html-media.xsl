<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Images and Other Media</doc:title>


<!-- == db2html.imagedata ================================================== -->

<xsl:template name="db2html.imagedata">
  <img>
    <xsl:attribute name="src">
      <xsl:choose>
        <xsl:when test="@fileref">
          <!-- FIXME: do this less stupidly, or not at all -->
          <xsl:choose>
            <xsl:when test="
                      @format = 'PNG' and
                        (substring(@fileref, string-length(@fileref) - 3)
                          != '.png')">
              <xsl:value-of select="concat(@fileref, '.png')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@fileref"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="@entityref">
          <xsl:value-of select="unparsed-entity-uri(@entityref)"/>
        </xsl:when>
      </xsl:choose>
    </xsl:attribute>
    <xsl:choose>
      <xsl:when test="@scale">
        <xsl:attribute name="width">
          <xsl:value-of select="concat(@scale, '%')"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@width">
        <xsl:attribute name="width">
          <xsl:value-of select="@width"/>
        </xsl:attribute>
        <xsl:if test="@height">
          <xsl:attribute name="height">
            <xsl:value-of select="@height"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
    <xsl:if test="@align">
      <xsl:attribute name="align">
        <xsl:value-of select="@align"/>
      </xsl:attribute>
    </xsl:if>
<!-- FIXME
    <xsl:if test="$textobject/phrase">
      <xsl:attribute name="alt">
        <xsl:value-of select="phrase[1]"/>
      </xsl:attribute>
    </xsl:if>
-->
    <!-- FIXME: longdesc -->
  </img>
</xsl:template>


<!-- == db2html.mediaobject ================================================ -->

<xsl:template name="db2html.mediaobject">
  <xsl:choose>
<!-- FIXME
    <xsl:when test="$text_only">
      <xsl:apply-templates select="textobject[1]"/>
    </xsl:when>
-->
    <xsl:when test="imageobject[imagedata/@format = 'PNG']">
      <xsl:apply-templates
       select="imageobject[imagedata/@format = 'PNG'][1]">
        <xsl:with-param name="textobject" select="textobject[1]"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="imageobjectco[imageobject/imagedata/@format = 'PNG']">
      <xsl:apply-templates
       select="imageobjectco[imageobject/imagedata/@format = 'PNG'][1]">
        <xsl:with-param name="textobject" select="textobject[1]"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="(imageobject | imageobjectco)[1]">
        <xsl:with-param name="textobject" select="textobject[1]"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- == Matched Templates ================================================== -->

<!-- = graphic = -->
<xsl:template match="graphic">
  <div class="graphic">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:call-template name="db2html.imagedata"/>
  </div>
</xsl:template>

<!--
<xsl:template match="graphicco">
	<xsl:param name="textobject" select="false()"/>
	<xsl:call-template name="db2html.anchor"/>
	<xsl:apply-templates select="graphic">
		<xsl:with-param name="textobject" select="$textobject"/>
	</xsl:apply-templates>
	<xsl:apply-templates select="calloutlist"/>
</xsl:template>

<xsl:template match="audiodata">
</xsl:template>

<xsl:template match="audioobject">
</xsl:template>
-->

<!-- = imagedata = -->
<xsl:template match="imagedata">
  <xsl:call-template name="db2html.imagedata"/>
</xsl:template>

<!-- = imageobject = -->
<xsl:template match="imageobject">
  <xsl:apply-templates select="imagedata"/>
</xsl:template>

<!--
<xsl:template match="imageobjectco">
	<xsl:param name="textobject" select="false()"/>
	<xsl:call-template name="db2html.anchor"/>
	<xsl:apply-templates select="imageobject">
		<xsl:with-param name="textobject" select="$textobject"/>
	</xsl:apply-templates>
	<xsl:apply-templates select="calloutlist"/>
</xsl:template>
-->

<!-- = inlinegraphic = -->
<xsl:template match="inlinegraphic">
  <span class="inlinegraphic">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:call-template name="db2html.imagedata"/>
  </span>
</xsl:template>

<!-- = inlinemediaobject = -->
<xsl:template match="inlinemediaobject">
  <span class="inlinemediaobject">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:call-template name="db2html.mediaobject"/>
  </span>
</xsl:template>

<!-- = mediaojbect = -->
<xsl:template match="mediaobject">
  <div class="mediaobject">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:call-template name="db2html.mediaobject"/>
    <xsl:apply-templates select="caption"/>
  </div>
</xsl:template>

<!--
<xsl:template match="mediaobjectco">
	<div class="{name(.)}">
		<xsl:call-template name="db2html.anchor"/>
		<xsl:call-template name="mediaobject"/>
	</div>
</xsl:template>
-->

<!-- = screenshot = -->
<xsl:template match="screenshot">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!--
<xsl:template match="textdata">
</xsl:template>

<xsl:template match="textobject">
</xsl:template>

<xsl:template match="videodata">
</xsl:template>

<xsl:template match="videoobject">
</xsl:template>
-->

</xsl:stylesheet>
