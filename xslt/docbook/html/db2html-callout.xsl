<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Callout Elements</doc:title>


<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.co.color</name>
</parameter>
<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.co.background_color</name>
</parameter>
<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.co.border_color</name>
</parameter>
<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.co.color.hover</name>
</parameter>
<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.co.background_color.hover</name>
</parameter>
<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.co.border_color.hover</name>
</parameter>
<xsl:param name="db2html.co.color" select="'#FFFFFF'"/>
<xsl:param name="db2html.co.background_color" select="'#000000'"/>
<xsl:param name="db2html.co.border_color" select="'#000000'"/>
<xsl:param name="db2html.co.color.hover" select="'#FFFFFF'"/>
<xsl:param name="db2html.co.background_color.hover" select="'#333333'"/>
<xsl:param name="db2html.co.border_color.hover" select="'#333333'"/>


<!-- == db2html.callout.css ================================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.callout.css</name>
  <description>
    Create CSS for the callout elements
  </description>
</template>

<xsl:template name="db2html.callout.css">
  <xsl:text>
    span[class="co"] {
      padding-left:  0.4em;
      padding-right: 0.4em;
      margin-left:   0.2em;
      margin-right:  0.2em;
      border: solid 1px;
      color: </xsl:text>
      <xsl:value-of select="$db2html.co.color"/><xsl:text>;
      background-color: </xsl:text>
      <xsl:value-of select="$db2html.co.background_color"/><xsl:text>;
      border-color: </xsl:text>
      <xsl:value-of select="$db2html.co.border_color"/><xsl:text>;
      -moz-border-radius: 0.6em;
    }
    span[class="co"]:hover {
      color: </xsl:text>
      <xsl:value-of select="$db2html.co.color.hover"/><xsl:text>;
      background-color: </xsl:text>
      <xsl:value-of select="$db2html.co.background_color.hover"/><xsl:text>;
      border-color: </xsl:text>
      <xsl:value-of select="$db2html.co.border_color.hover"/><xsl:text>;
    }
    span[class="co"] a { text-decoration: none; }
    span[class="co"] a:hover { text-decoration: none; }
  </xsl:text>
</xsl:template>


<!-- == db2html.co.dingbat ================================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.co.dingbat</name>
  <description>
    Render the dingbat for a callout
  </description>
  <parameter>
    <name>co</name>
    <description>
      The <xmltag>co</xmltag> element for which to render a dingbat
    </description>
  </parameter>
</template>

<xsl:template name="db2html.co.dingbat">
  <xsl:param name="co" select="."/>
  <span class="co">
    <xsl:value-of select="count(preceding::co) + 1"/>
  </span>
</xsl:template>


<!-- == db2html.co.dingbats ================================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.co.dingbats</name>
  <description>
    Render a dingbat for each <xmltag>co</xmltag> referenced in the
    <parameter>arearefs</parameter> parameter
  </description>
  <parameter>
    <name>arearefs</name>
    <description>
      A space-seperated list of <xmltag>co</xmltag> elements
    </description>
  </parameter>
</template>

<xsl:template name="db2html.co.dingbats">
  <xsl:param name="arearefs" select="@arearefs"/>
  <!-- FIXME -->
</xsl:template>


<!-- == Matched Templates ================================================== -->

<!-- = co = -->
<xsl:template match="co">
  <xsl:call-template name="db2html.co.dingbat"/>
</xsl:template>

</xsl:stylesheet>
