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
<xsl:template name="db2html.css.content">
  <xsl:call-template name="db2html.footnote.css"/>
  <xsl:call-template name="db2html.admon.css"/>
  <xsl:call-template name="db2html.autotoc.css"/>
  <xsl:call-template name="db2html.bibliography.css"/>
  <xsl:call-template name="db2html.block.css"/>
  <xsl:call-template name="db2html.callout.css"/>
  <xsl:call-template name="db2html.cmdsynopsis.css"/>
  <xsl:call-template name="db2html.list.css"/>
  <xsl:call-template name="db2html.qanda.css"/>
  <xsl:call-template name="db2html.refentry.css"/>
  <xsl:call-template name="db2html.table.css"/>
  <xsl:call-template name="db2html.title.css"/>
<xsl:text>
body {
  margin: 0px;
  direction: </xsl:text><xsl:call-template name="l10n.direction"/><xsl:text>;
}
div.body { padding: 12px; }
div.navbar {
  margin-left: 12px; margin-right: 12px; margin-bottom: 12px;
  padding: 6px;
  border: solid 1px;
}
div.navbar-prev { margin: 0px; padding: 0px; float: left; }
div.navbar-prev-sans-next { float: none; }
div.navbar-next { margin: 0px; padding: 0px; text-align: right; }
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
p &gt; div { margin-top: 1em; margin-bottom: 1em; }
p &gt; div + div { margin-top: 0em; }
p { text-align: justify; }
</xsl:text>
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
