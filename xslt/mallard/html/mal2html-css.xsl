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
Mallard to HTML - CSS

REMARK: Describe this module
-->


<!--@@==========================================================================
mal2html.css.file
The file to output CSS to

This parameter allows you to output the CSS to separate file which is referenced
by each HTML file.  If this parameter is blank, then the CSS is embedded inside
a #{style} tag in the HTML instead.
-->
<xsl:param name="mal2html.css.file" select="''"/>


<!--**==========================================================================
mal2html.css
Outputs the CSS that controls the appearance of the entire document
$css_file: Whether to create a CSS file when @{mal2html.css.file} is set.

This template outputs a #{style} or #{link} tag and calls *{mal2html.css.content}
to output the actual CSS directives.  An external CSS file will only be created
when ${css_file} is true.
-->
<xsl:template name="mal2html.css">
  <xsl:param name="css_file" select="false()"/>
  <xsl:choose>
    <xsl:when test="$mal2html.css.file != ''">
      <xsl:if test="$css_file">
        <exsl:document href="{$mal2html.css.file}" method="text">
          <xsl:call-template name="mal2html.css.content"/>
        </exsl:document>
      </xsl:if>
      <link rel="stylesheet" type="text/css" href="{$mal2html.css.file}"/>
    </xsl:when>
    <xsl:otherwise>
      <style type="text/css">
        <xsl:call-template name="mal2html.css.content"/>
      </style>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--**==========================================================================
mal2html.css.content
Outputs the actual CSS directives

This template is called by *{mal2html.css} to output CSS content.  It also calls
templates from other modules to output CSS specific to the content addressed in
those modules.

This template calls *{mal2html.css.custom} at the end.  That template may be used
by extension stylesheets to extend or override the CSS.
-->
<xsl:template name="mal2html.css.content">
  <xsl:call-template name="mal2html.block.css"/>
  <xsl:call-template name="mal2html.inline.css"/>
  <xsl:call-template name="mal2html.list.css"/>
  <xsl:call-template name="mal2html.table.css"/>
<xsl:text>
html { height: 100%; }
body {
  direction: </xsl:text><xsl:call-template name="l10n.direction"/><xsl:text>;
  margin: 0px;
  background-color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'gray-background'"/>
  </xsl:call-template>
  <xsl:text>;
  padding: 12px;
  min-height: 100%;
}
<!-- FIXME: only in editor mode & better colors -->
body.status-stub { background-color:  </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'red-background'"/>
  </xsl:call-template>
  <xsl:text>; }
body.status-draft { background-color:  </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'red-background'"/>
  </xsl:call-template>
  <xsl:text>; }
body.status-incomplete { background-color:  </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'red-background'"/>
  </xsl:call-template>
  <xsl:text>; }
body.status-review { background-color:  </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'yellow-background'"/>
  </xsl:call-template>
  <xsl:text>; }
div.version {
  margin: 0 0 1em 0;
  padding: 0.5em 1em 0.5em 1em;
  max-width: 60em;
  border: solid 1px </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'gray-border'"/>
  </xsl:call-template>
  <xsl:text>;
  background-color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'yellow-background'"/>
  </xsl:call-template>
  <xsl:text>;
}
div.version p.version {
  margin-top: 0.2em;
}
div.body {
  margin: 0;
  padding: 1em;
  max-width: 60em;
  min-height: 20em;
  border: solid 1px </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'gray-border'"/>
  </xsl:call-template>
  <xsl:text>;
  background-color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'background'"/>
  </xsl:call-template>
  <xsl:text>;
}
div.copyrights {
  max-width: 60em;
  text-align: center;
  color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'text-light'"/>
  </xsl:call-template>
  <xsl:text>;
}
div.section { margin-top: 2em; clear: both; }
div.section div.section { margin-top: 1.72em; margin-left: 1.72em; }
div.section div.section div.section { margin-top: 1.44em; }
div.header {
  margin: 0;
  color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'text-light'"/>
  </xsl:call-template>
  <xsl:text>;
  border-bottom: solid 1px </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'gray-border'"/>
  </xsl:call-template>
  <xsl:text>;
}
div.section div.section div.header { border: none; }
h1, h2, h3, h4, h5, h6, h7 { margin: 0; }
h1.title { font-size: 1.44em; }
h2.title { font-size: 1.2em; }
h3.title { font-size: 1em; }
h4.title { font-size: 1em; }
h5.title { font-size: 1em; }
h6.title { font-size: 1em; }
h7.title { font-size: 1em; }

div.pagelink div.title {
  font-size: 1em;
  color: inherit;
}
div.pagelink div.desc {
  margin-top: 0.2em;
  color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'text-light'"/>
  </xsl:call-template>
  <xsl:text>;
}
div.pagelink {
  margin: 0;
  padding: 0.5em;
  border: solid 1px </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'background'"/>
  </xsl:call-template>
  <xsl:text>;
}
div.pagelink:hover {
  border-color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'blue-border'"/>
  </xsl:call-template>
  <xsl:text>;
  background-color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'blue-background'"/>
  </xsl:call-template>
  <xsl:text>;
}
ul.guidelinks {
  display: block;
  margin: 0;
  text-align: right;
}
li.guidelink { display: inline; }
li.guidelink::before {
  content: ' • ';
  color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'gray-dark'"/>
  </xsl:call-template>
  <xsl:text>;
}
li.guidelink-first::before, li.guidelink-only::before {
  content: '';
}

ul.seealsolinks {
  margin: 0; padding: 0;
}
li.seealsolink {
  margin-left: 1.44em;
}
li.seealsolinksep {
  margin: 0.5em 0 0.5em 1.44em;
  list-style-type: none;
  max-width: 12em;
  border-bottom: solid 1px </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'gray-border'"/>
  </xsl:call-template>
  <xsl:text>;
}

div, pre, p { margin: 1em 0 0 0; padding: 0; }
.first-child { margin-top: 0; }
a {
  text-decoration: none;
  color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'link'"/>
  </xsl:call-template>
  <xsl:text>;
}
a:visited {
  color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'link-visited'"/>
  </xsl:call-template>
  <xsl:text>;
}
a:hover { text-decoration: underline; }
</xsl:text>
<xsl:call-template name="mal2html.css.custom"/>
</xsl:template>
<!--
2.4
2
1.72
1.44
1.2
1
0.83
0.69
0.5
-->


<!--**==========================================================================
mal2html.css.custom
Allows extension stylesheets to extend or override CSS
:Stub: true

This stub template has no content.  Extension stylesheets can override this
template to output extra CSS.
-->
<xsl:template name="mal2html.css.custom"/>

</xsl:stylesheet>
