<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:ref="http://www.gnome.org/~shaunm/mallard/reference"
		exclude-result-prefixes="ref"
                version="1.0">

<ref:title>Admonitions</ref:title>


<!-- == db2html.admon.graphics_path == -->

<ref:refname>db2html.admon.graphics_path</ref:refname>
<ref:refpurpose>The path to admonition graphics</ref:refpurpose>

<xsl:param name="db2html.admon.graphics_path"/>


<!-- == db2html.admon.graphics_extension == -->

<ref:refname>db2html.admon.graphics_extension</ref:refname>
<ref:refpurpose>The file extension for admonition graphics</ref:refpurpose>

<xsl:param name="db2html.admon.graphics_extension" select="'png'"/>


<!-- == db2html.admon.text_only == -->

<ref:refname>db2html.admon.text_only</ref:refname>
<ref:refpurpose>Whether to render admonitions text-only</ref:refpurpose>

<xsl:param name="db2html.admon.text_only" select="false()"/>


<!-- == db2html.admon -->

<ref:refname>db2html.admon</ref:refname>
<ref:refpurpose>Render admonition elements</ref:refpurpose>
<ref:para>
  This template renders the DocBook admonition elements.  The template
  simply calls <ref:function>db2html.admon.text</ref:function> or
  <ref:function>db2html.admon.boxed</ref:function>, depending on
  the value of <ref:parameter>$db2html.admon.text_only</ref:parameter>.
</ref:para>

<xsl:template name="db2html.admon">
  <xsl:param name="node" select="."/>
  <xsl:choose>
    <xsl:when test="$db2html.admon.text_only">
      <xsl:call-template name="db2html.admon.text">
	<xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="db2html.admon.boxed">
	<xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- == db2html.admon.boxed -->

<ref:refname>db2html.admon.boxed</ref:refname>
<ref:refpurpose>
  Render admonition elements as stylized boxes with admonition graphics
</ref:refpurpose>

<xsl:template name="db2html.admon">
  <xsl:param name="node" select="."/>
  <div class="admonition">
    <div class="{name(.)}">
      <table style="border: none;">
	<tr>
	  <td rowspan="2" align="center" valign="top" class="image">
	    <xsl:call-template name="db2html.admon.image">
	      <xsl:with-param name="node" select="$node"/>
	    </xsl:call-template>
	  </td>
	  <th align="left" valign="top">
	    <xsl:apply-templates select="$node/title"/>
	  </th>
	</tr>
	<tr>
	  <td align="left" valign="top">
	    <xsl:apply-templates select="$node/*[local-name(.) != 'title']"/>
	  </td>
	</tr>
      </table>
    </div>
  </div>
</xsl:template>


<!-- == db2html.admon.text -->

<ref:refname>db2html.admon.text</ref:refname>
<ref:refpurpose>
  Render admonition elements as simple text blocks
</ref:refpurpose>

<xsl:template name="db2html.admon">
  <xsl:param name="node" select="."/>
  <div class="admonition">
    <div class="{name(.)}">
      <xsl:call-template name="db2html-xref.anchor">
	<xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
      <xsl:apply-templates select="$node/node()"/>
    </div>
  </div>
</xsl:template>


<!-- == db2html.admon.image -->

<ref:refname>db2html.admon.image</ref:refname>
<ref:refpurpose>
  Create the <ref:xmltag>img</ref:xmltag> for an admonition graphic
</ref:refpurpose>

<xsl:template name="db2html.admon.image">
  <xsl:param name="node" select="."/>
  <img>
    <xsl:attribute name="src">
      <xsl:value-of select="$db2html.admon.graphics_path"/>
      <xsl:value-of select="name($node)"/>
      <xsl:value-of select="$db2html.admon.graphics_extension"/>
    </xsl:attribute>
  </img>
</xsl:template>


<!-- == Matched Templates == -->

<!-- = caution = -->
<xsl:template match="caution">
  <xsl:call-template name="db2html.admon"/>
</xsl:template>

<!-- = caution/title = -->
<xsl:template match="caution/title">
  <xsl:call-template name="db2html-title.title.simple"/>
</xsl:template>

<!-- = important = -->
<xsl:template match="important">
  <xsl:call-template name="db2html.admon"/>
</xsl:template>

<!-- = important/title = -->
<xsl:template match="important/title">
  <xsl:call-template name="db2html-title.title.simple"/>
</xsl:template>

<!-- = note = -->
<xsl:template match="note">
  <xsl:call-template name="db2html.admon"/>
</xsl:template>

<!-- = note/title = -->
<xsl:template match="note/title">
  <xsl:call-template name="db2html-title.title.simple"/>
</xsl:template>

<!-- = tip = -->
<xsl:template match="tip">
  <xsl:call-template name="db2html.admon"/>
</xsl:template>

<!-- = tip/title = -->
<xsl:template match="tip/title">
  <xsl:call-template name="db2html-title.title.simple"/>
</xsl:template>

<!-- = warning = -->
<xsl:template match="warning">
  <xsl:call-template name="db2html.admon"/>
</xsl:template>

<!-- = warning/title = -->
<xsl:template match="warning/title">
  <xsl:call-template name="db2html-title.title.simple"/>
</xsl:template>

</xsl:stylesheet>
