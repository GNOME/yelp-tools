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
    <xsl:call-template name="db2html.callout.css"/>
    <xsl:call-template name="db2html.list.css"/>
    <xsl:call-template name="db2html.title.css"/>
    p {
      text-align: justify;
    }
    tr[class="odd"] { background-color: #F0F0F0; }
    div[class="table"] {
      margin-left: 16px;
    }
    table {
      border-collapse: collapse;
      border: solid 1px black;
      -moz-border-radius: 5px;
    }
    td { padding-left: 0.8em; padding-right: 8px; }
    th { padding-left: 0.8em; padding-right: 8px; }
    thead tr th {
      border-bottom: solid 1px black;
    }
    td + td {
      border-left: solid 1px black;
    }
    tbody {
      border: solid 1px black;
      -moz-border-radius: 5px;
    }
  </style>
</xsl:template>

</xsl:stylesheet>
