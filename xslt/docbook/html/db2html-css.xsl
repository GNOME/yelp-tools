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
    <xsl:call-template name="db2html.css.custom"/>
    <xsl:call-template name="db2html.admon.css"/>
    <xsl:call-template name="db2html.autotoc.css"/>
    <xsl:call-template name="db2html.block.css"/>
    <xsl:call-template name="db2html.callout.css"/>
    <xsl:call-template name="db2html.list.css"/>
    <xsl:call-template name="db2html.qanda.css"/>
    <xsl:call-template name="db2html.table.css"/>
    <xsl:call-template name="db2html.title.css"/>
    body {
      padding-left: 8px;
      padding-right: 12px;
    }
    div + div { margin-top: 1em; }
    p {
      text-align: justify;
    }
  </style>
</xsl:template>

<xsl:template name="db2html.css.custom"/>

</xsl:stylesheet>
