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
  <xsl:call-template name="mal2html.page.css"/>
  <xsl:call-template name="mal2html.table.css"/>
<xsl:text>
div, pre, p { margin: 1em 0 0 0; padding: 0; }
.first-child { margin-top: 0; }
a { text-decoration: none; }
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
