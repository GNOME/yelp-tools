<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>CSS</doc:title>


<!-- == db2html.css ======================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.css</name>
</template>

<xsl:template name="db2html.css">
  <style>
    .odd { background-color: #F0F0F0; }
    <xsl:call-template name="db2html.css.block"/>
    <xsl:call-template name="db2html.css.division"/>
    <xsl:call-template name="db2html.css.inline"/>
  </style>
</xsl:template>


<!-- == db2html.css.block ================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.css.block</name>
</template>

<xsl:template name="db2html.css.block"/>


<!-- == db2html.css.division =============================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.css.division</name>
</template>

<xsl:template name="db2html.css.division"/>


<!-- == db2html.css.inline ================================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.css.inline</name>
</template>

<xsl:template name="db2html.css.inline"/>

</xsl:stylesheet>
