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
                xmlns:exsl="http://exslt.org/common"
                xmlns="http://www.w3.org/1999/xhtml"
                extension-element-prefixes="exsl"
                version="1.0">

<!--!!==========================================================================
DocBook to HTML - CSS
:Requires: l10n theme

REMARK: Describe this module
-->


<!--@@==========================================================================
db2html.css.file
The file to output CSS to

This parameter allows you to output the CSS to separate file which is referenced
by each HTML file.  If this parameter is blank, then the CSS is embedded inside
a #{style} tag in the HTML instead.
-->
<xsl:param name="db2html.css.file" select="''"/>


<!--**==========================================================================
db2html.css
Outputs the CSS that controls the appearance of the entire document
$css_file: Whether to create a CSS file when @{db2html.css.file} is set.

This template outputs a #{style} or #{link} tag and calls *{db2html.css.content}
to output the actual CSS directives.  An external CSS file will only be created
when ${css_file} is true.  This is only set to true by the top-level chunk to
avoid creating the same file multiple times.
-->
<xsl:template name="db2html.css">
  <xsl:param name="css_file" select="false()"/>
  <xsl:choose>
    <xsl:when test="$db2html.css.file != ''">
      <xsl:if test="$css_file">
        <exsl:document href="{$db2html.css.file}" method="text">
          <xsl:call-template name="db2html.css.content"/>
        </exsl:document>
      </xsl:if>
      <link rel="stylesheet" type="text/css" href="{$db2html.css.file}"/>
    </xsl:when>
    <xsl:otherwise>
      <style type="text/css">
        <xsl:call-template name="db2html.css.content"/>
      </style>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--**==========================================================================
db2html.css.content
Outputs the actual CSS directives

This template is called by *{db2html.css} to output CSS content.  It also calls
templates from other modules to output CSS specific to the content addressed in
those modules.

This template calls *{db2html.css.custom} at the end.  That template may be used
by extension stylesheets to extend or override the CSS.
-->
<xsl:template name="db2html.css.content"><xsl:text>
html { height: 100%; }
body {
  margin: 0px;
  padding: 12px;
  background-color: </xsl:text>
    <xsl:value-of select="$theme.color.gray_background"/><xsl:text>;
  min-height: 100%;
  direction: </xsl:text>
    <xsl:call-template name="l10n.direction"/><xsl:text>;
}
div, p, pre, blockquote { margin: 0; }

.block { margin-top: 1em; }
.block .block-first { margin-top: 0; }
<!-- FIXME: rtl -->
.block-indent {
  margin-left: 1.72em;
  margin-right: 1em;
}
.block-indent .block-indent {
  margin-left: 0em;
  margin-right: 0em;
}
.block-verbatim { white-space: pre; }

div.body {
  padding: 1em;
  max-width: 60em;
  background-color: </xsl:text>
    <xsl:value-of select="$theme.color.background"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$theme.color.gray_border"/><xsl:text>;
}
div.body-sidebar {
  <!-- FIXME: rtl -->
  margin-right: 13em;
}

div.division div.division { margin-top: 1.72em; }
div.division div.division div.division { margin-top: 1.44em; }

div.header {
  margin: 0;
  color: </xsl:text>
    <xsl:value-of select="$theme.color.text_light"/><xsl:text>;
  border-bottom: solid 1px </xsl:text>
    <xsl:value-of select="$theme.color.gray_border"/><xsl:text>;
}
h1, h2, h3, h4, h5, h6, h7 { margin: 0; padding: 0; }
h1.title { font-size: 1.72em; }
h2.title { font-size: 1.44em; }
h3.title { font-size: 1.2em; }
h4.title { font-size: 1em; }
h5.title { font-size: 1em; }
h6.title { font-size: 1em; }
h7.title { font-size: 1em; }
div.title {
  margin-bottom: 0.2em;
  font-weight: bold;
  color: </xsl:text>
    <xsl:value-of select="$theme.color.text_light"/><xsl:text>;
}
div.title-formal .label {
  font-weight: normal;
}

a {
  color: </xsl:text>
    <xsl:value-of select="$theme.color.link"/><xsl:text>;
  text-decoration: none;
}
a:hover { text-decoration: underline; }
a:visited {
  color: </xsl:text>
    <xsl:value-of select="$theme.color.link_visited"/><xsl:text>;
}


ul.linktrail {
  display: block;
  margin: 0.2em 0 0 0;
  text-align: right;
}
li.linktrail { display: inline; }
li.linktrail::before {
  content: '&#x00A0; /&#x00A0;&#x00A0;';
  color: </xsl:text>
    <xsl:value-of select="$theme.color.text_light"/><xsl:text>;
}
li.linktrail-first::before, li.linktrail-only::before { content: ''; }

div.navbar {
  padding: 0.5em 1em 0.5em 1em;
  max-width: 60em;
  background-color: </xsl:text>
    <xsl:value-of select="$theme.color.background"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$theme.color.gray_border"/><xsl:text>;
}
div.navbar-top { margin-bottom: 1em; }
div.navbar-bottom { margin-top: 1em; clear: both; }
div.navbar img {
  border: 0;
  vertical-align: -0.4em;
}
table.navbar {
  width: 100%;
  margin: 0;
  border: none;
}
table.navbar td {
  padding: 0;
  border: none;
}
td.navbar-next {
  <!-- FIXME: rtl -->
  text-align: right;
}

div.autotoc {
  <!-- FIXME: rtl -->
  margin-left: 1.72em;
  padding: 0;
}
div.autotoc ul { margin: 0; padding: 0; }
div.autotoc li { list-style-type: none; }

div.sidebar {
  <!-- FIXME: rtl -->
  float: right;
  padding: 0;
  margin: 0;
  width: 12em;
}
div.sidenav {
  padding: 0.5em 1em 0.5em 1em;
  background-color: </xsl:text>
    <xsl:value-of select="$theme.color.background"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$theme.color.gray_border"/><xsl:text>;
}
div.sidenav div.autotoc { margin: 0; }
div.sidenav div.autotoc div.autotoc { margin-top: 0.5em; }
div.sidenav div.autotoc div.autotoc li { margin-bottom: 0.5em; }
div.sidenav div.autotoc div.autotoc div.autotoc {
  <!-- FIXME: rtl -->
  margin-left: 1em;
  margin-top: 0;
}
div.sidenav div.autotoc div.autotoc div.autotoc li { margin-bottom: 0; }

div.blockquote {
  background-image: url('../../../data/icons/yelp-watermark-blockquote-201C.png');
  background-repeat: no-repeat;
  <!-- FIXME: rtl -->
  background-position: top left;
  padding: 0.5em;
  <!-- FIXME: rtl -->
  padding-left: 4em;
}
div.attribution {
  margin-top: 0.5em;
  color: </xsl:text>
    <xsl:value-of select="$theme.color.text_light"/><xsl:text>;
}
div.attribution::before {
  content: '&#x2015; ';
}
div.epigraph {
  <!-- FIXME: rtl -->
  text-align: right;
  <!-- FIXME: rtl -->
  margin-left: 20%;
  <!-- FIXME: rtl -->
  margin-right: 0;
  color: </xsl:text>
    <xsl:value-of select="$theme.color.text_light"/><xsl:text>;
}
div.figure {
  padding: 0.5em;
  background-color: </xsl:text>
    <xsl:value-of select="$theme.color.blue_background"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$theme.color.blue_border"/><xsl:text>;
}
div.figure-inner {
  background-color: </xsl:text>
    <xsl:value-of select="$theme.color.background"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$theme.color.gray_border"/><xsl:text>;
}
div.caption {
  margin-top: 0.5em;
}
pre.programlisting {
  padding: 0.5em;
  overflow: auto;
  <!-- FIXME: watermark -->
  background-color: </xsl:text>
    <xsl:value-of select="$theme.color.gray_background"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$theme.color.gray_border"/><xsl:text>;
}
pre.screen {
  padding: 0.5em;
  overflow: auto;
  <!-- FIXME: watermark -->
  background-color: </xsl:text>
    <xsl:value-of select="$theme.color.gray_background"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$theme.color.gray_border"/><xsl:text>;
}
pre.synopsis { overflow: auto; }
pre.linenumbering {
  <!-- The margin is important to get the line numbering
  to line up vertically with the content. -->
  margin-top: 0;
  <!-- FIXME: rtl -->
  margin-left: 0.83em;
  padding: 1em 0.4em 1em 0.4em;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$theme.color.gray_border"/><xsl:text>;
  background-color: </xsl:text>
    <xsl:value-of select="$theme.color.gray_background"/><xsl:text>;
  color: </xsl:text>
    <xsl:value-of select="$theme.color.text_light"/><xsl:text>;
  <!-- FIXME: rtl -->
  float: left;
  <!-- FIXME: rtl -->
  text-align: right;
}

div.admonition {
  padding: 0.5em 1em 0.5em 1em;
  <!-- FIXME: rtl -->
  padding-left: </xsl:text>
    <xsl:value-of select="$theme.icon.admon.size + 12"/><xsl:text>px;
  min-height: </xsl:text>
    <xsl:value-of select="$theme.icon.admon.size"/><xsl:text>px;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$theme.color.gray_border"/><xsl:text>;
  background-color: </xsl:text>
    <xsl:value-of select="$theme.color.yellow_background"/><xsl:text>;
  <!-- FIXME: rtl -->
  background-position: 6px 0.5em;
  background-repeat: no-repeat;
}
div.caution {
  background-image: url("</xsl:text>
    <xsl:value-of select="$theme.icon.admon.caution"/><xsl:text>");
}
div.important {
  background-image: url("</xsl:text>
    <xsl:value-of select="$theme.icon.admon.important"/><xsl:text>");
}
div.note {
  background-image: url("</xsl:text>
    <xsl:value-of select="$theme.icon.admon.note"/><xsl:text>");
}
div.note-bug {
  background-image: url("</xsl:text>
    <xsl:value-of select="$theme.icon.admon.bug"/><xsl:text>");
}
div.tip {
  background-image: url("</xsl:text>
    <xsl:value-of select="$theme.icon.admon.tip"/><xsl:text>");
}
div.warning {
  background-image: url("</xsl:text>
    <xsl:value-of select="$theme.icon.admon.warning"/><xsl:text>");
}


<!-- FIXME below -->

</xsl:text>
  <xsl:call-template name="db2html.footnote.css"/>
  <xsl:call-template name="db2html.bibliography.css"/>
  <xsl:call-template name="db2html.block.css"/>
  <xsl:call-template name="db2html.callout.css"/>
  <xsl:call-template name="db2html.cmdsynopsis.css"/>
  <xsl:call-template name="db2html.list.css"/>
  <xsl:call-template name="db2html.qanda.css"/>
  <xsl:call-template name="db2html.refentry.css"/>
  <xsl:call-template name="db2html.table.css"/>
<xsl:call-template name="db2html.css.custom"/>
</xsl:template>


<!--**==========================================================================
db2html.css.custom
Allows extension stylesheets to extend or override CSS
:Stub: true

This stub template has no content.  Extension stylesheets can override this
template to output extra CSS.
-->
<xsl:template name="db2html.css.custom"/>

</xsl:stylesheet>
