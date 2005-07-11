<?xml version='1.0' encoding='UTF-8'?><!-- -*- indent-tabs-mode: nil -*- -->
<!--
This program is free software; you can redistribute it and/or modify it under
the terms of the GNU Lesser General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
details.

You should have received a copy of the GNU Lesser General Public License
along with this program; see the file COPYING.LGPL.  If not, write to the
Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
02111-1307, USA.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>CSS</doc:title>


<!-- == db2html.css ======================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.css</name>
</template>

<xsl:template name="db2html.css">
  <style>
    <xsl:call-template name="db2html.admon.css"/>
    <xsl:call-template name="db2html.autotoc.css"/>
    <xsl:call-template name="db2html.block.css"/>
    <xsl:call-template name="db2html.callout.css"/>
    <xsl:call-template name="db2html.cmdsynopsis.css"/>
    <xsl:call-template name="db2html.list.css"/>
    <xsl:call-template name="db2html.qanda.css"/>
    <xsl:call-template name="db2html.refentry.css"/>
    <xsl:call-template name="db2html.table.css"/>
    <xsl:call-template name="db2html.title.css"/>
    body {
      margin: 0px;
    }
    div[class ~= "body"] {
      padding: 12px;
    }
    div[class ~= "navbar"] {
      margin-left: 12px;
      margin-right: 12px;
      margin-bottom: 12px;
      padding: 6px;
      border: solid 1px;
    }
    div[class ~= "navbar-prev"] {
      margin: 0px;
      padding: 0px;
      float: left;
    }
    div[class ~= "navbar-prev-sans-next"] {
      float: none;
    }
    div[class ~= "navbar-next"] {
      margin: 0px;
      padding: 0px;
      text-align: right;
    }
    div {
      margin-top: 0em;  margin-bottom: 0em;
      padding-top: 0em; padding-bottom: 0em;
    }
    p {
      margin-top: 0em;  margin-bottom: 0em;
      padding-top: 0em; padding-bottom: 0em;
    }
    div + * { margin-top: 1em; }
    p   + * { margin-top: 1em; }
    p &gt; div { margin-top: 1em; }
    p { text-align: justify; }
    <xsl:call-template name="db2html.css.custom"/>
  </style>
</xsl:template>

<xsl:template name="db2html.css.custom"/>

</xsl:stylesheet>
