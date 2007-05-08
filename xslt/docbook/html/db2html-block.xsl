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
                xmlns:msg="http://www.gnome.org/~shaunm/gnome-doc-utils/l10n"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="msg"
                version="1.0">

<!--!!==========================================================================
DocBook to HTML - Block Elements
:Requires: db-common db-label db-xref db2html-xref gettext

This module handles most simple block-level elements, turning them into the
appropriate HTML tags.  It does not handle tables, lists, and various other
complex block-level elements.
-->


<!--**==========================================================================
db2html.block
Renders a block-level element to an HTML #{div} tag
$node: The block-level element to render
$class: An extra string to insert in the #{class} attribute
$first: Whether this is the first child block in the parent
$indent: Whether this block should be indented
$verbatim: Whether to maintain whitespace as written
$formal: Whether this is a formal block element
$title: When ${formal} is true, an element to use for the title
$caption: When ${formal is true, an element to use for the caption 

This template creates an HTML #{div} element for the given DocBook element.
This template uses the parameters to construct the #{class} attribute, which
is then used by the CSS for styling.
-->
<xsl:template name="db2html.block">
  <xsl:param name="node" select="."/>
  <xsl:param name="class" select="''"/>
  <xsl:param name="first"
             select="not($node/preceding-sibling::*
                     [not(self::blockinfo) and not(self::title) and
                      not(self::titleabbrev) and not(self::attribution) ])"/>
  <xsl:param name="indent" select="false()"/>
  <xsl:param name="verbatim" select="false()"/>
  <xsl:param name="formal" select="false()"/>
  <xsl:param name="title" select="$node/title"/>
  <xsl:param name="caption" select="$node/caption"/>
  <div>
    <xsl:attribute name="class">
      <xsl:value-of select="concat($class, ' block ', local-name($node))"/>
      <xsl:if test="$first">
        <xsl:text> block-first</xsl:text>
      </xsl:if>
      <xsl:if test="$indent">
        <xsl:text> block-indent</xsl:text>
      </xsl:if>
      <xsl:if test="$verbatim">
        <xsl:text> block-verbatim</xsl:text>
      </xsl:if>
    </xsl:attribute>
    <xsl:call-template name="db2html.anchor">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="$formal">
        <xsl:if test="$title">
          <xsl:call-template name="db2html.block.title">
            <xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="title" select="$title"/>
          </xsl:call-template>
        </xsl:if>
        <div class="{local-name($node)}-inner">
          <xsl:apply-templates select="$node/node()[not(. = $title) and not(. = $caption)]"/>
        </div>
        <xsl:apply-templates select="$caption"/>
      </xsl:when>
      <xsl:when test="$node/self::title">
        <span class="title">
          <xsl:apply-templates select="$node/node()"/>
        </span>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$node/node()"/>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>


<!--**==========================================================================
db2html.block.title
Renders a formal title for a block-level element
$node: The block-level element being processed
$title: The element containing the title

FIXME
-->
<xsl:template name="db2html.block.title">
  <xsl:param name="node" select="."/>
  <xsl:param name="title" select="$node/title"/>
  <div class="block block-first title title-formal">
    <xsl:call-template name="db2html.anchor">
      <xsl:with-param name="node" select="$title"/>
    </xsl:call-template>
    <span class="label">
      <xsl:call-template name="db.label">
        <xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="role" select="'header'"/>
      </xsl:call-template>
    </span>
    <xsl:apply-templates select="$title/node()"/>
  </div>
</xsl:template>

<!--**==========================================================================
db2html.blockquote
Renders a #{blockquote} element to HTML
$node: The #{blockquote} element to render
$first: Whether this is the first child block in the parent

This template creates an HTML #{blockquote} element for the given DocBook
element.
-->
<xsl:template name="db2html.blockquote">
  <xsl:param name="node" select="."/>
  <xsl:param name="first"
             select="not($node/preceding-sibling::*
                     [not(self::blockinfo) and not(self::title) and
                      not(self::titleabbrev) and not(self::attribution) ])"/>
  <div>
    <xsl:attribute name="class">
      <xsl:value-of select="local-name($node)"/>
      <xsl:text> block block-indent</xsl:text>
      <xsl:if test="$first">
        <xsl:text> block-first</xsl:text>
      </xsl:if>
    </xsl:attribute>
    <xsl:call-template name="db2html.anchor">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <xsl:apply-templates select="$node/title"/>
    <blockquote class="{local-name($node)}">
      <xsl:apply-templates
       select="$node/node()[name(.) != 'title' and name(.) != 'attribution']"/>
    </blockquote>
    <xsl:apply-templates select="$node/attribution"/>
  </div>
</xsl:template>


<!--**==========================================================================
db2html.para
Renders a block-level element as an HTML #{p} element
$node: The block-level element to render
$first: Whether this is the first child block in the parent

This template creates an HTML #{p} element for the given DocBook element.
-->
<xsl:template name="db2html.para">
  <xsl:param name="node" select="."/>
  <xsl:param name="first"
             select="not($node/preceding-sibling::*
                     [not(self::blockinfo) and not(self::title) and
                      not(self::titleabbrev) and not(self::attribution) ])"/>
  <p>
    <xsl:attribute name="class">
      <xsl:value-of select="local-name($node)"/>
      <xsl:text> block</xsl:text>
      <xsl:if test="$first">
        <xsl:text> block-first</xsl:text>
      </xsl:if>
    </xsl:attribute>
    <xsl:call-template name="db2html.anchor">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <xsl:apply-templates select="$node/node()"/>
  </p>
</xsl:template>


<!--**==========================================================================
db2html.pre
Renders a block-level element as an HTML #{pre} element
$node: The block-level element to render
$first: Whether this is the first child block in the parent
$indent: Whether this block should be indented
$children: The child elements to process

This template creates an HTML #{pre} element for the given DocBook element.
This template uses the parameters to construct the #{class} attribute, which
is then used by the CSS for styling.
-->
<xsl:template name="db2html.pre">
  <xsl:param name="node" select="."/>
  <xsl:param name="first"
             select="not($node/preceding-sibling::*
                     [not(self::blockinfo) and not(self::title) and
                      not(self::titleabbrev) and not(self::attribution) ])"/>
  <xsl:param name="indent" select="false()"/>
  <xsl:param name="children" select="$node/node()"/>
  <!-- FIXME:
  @width
  @language
  @format
  -->
  <div>
    <xsl:attribute name="class">
      <xsl:value-of select="local-name($node)"/>
      <xsl:text> block</xsl:text>
      <xsl:if test="$indent">
        <xsl:text> block-indent</xsl:text>
      </xsl:if>
      <xsl:if test="$first">
        <xsl:text> block-first</xsl:text>
      </xsl:if>
    </xsl:attribute>
    <xsl:call-template name="db2html.anchor">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <xsl:if test="$node/@linenumbering = 'numbered'">
      <xsl:variable name="number">
        <xsl:choose>
          <!-- FIXME: continuation -->
          <xsl:when test="@startinglinenumber">
            <xsl:value-of select="@startinglinenumber"/>
          </xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <pre class="linenumbering"><xsl:call-template name="db.linenumbering">
        <xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="number" select="$number"/>
      </xsl:call-template></pre>
    </xsl:if>
    <pre class="{local-name($node)}">
      <!-- Strip off a leading newline -->
      <xsl:if test="$children[1]/self::text()">
        <xsl:choose>
          <xsl:when test="starts-with($node/text()[1], '&#x000A;')">
            <xsl:value-of select="substring-after($node/text()[1], '&#x000A;')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$node/text()[1]"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:apply-templates select="$children[not(position() = 1 and self::text())]"/>
    </pre>
  </div>
</xsl:template>


<!--**==========================================================================
db2html.block.css
Outputs CSS that controls the appearance of block-level elements

REMARK: Describe this template
-->
<xsl:template name="db2html.block.css">
<xsl:text>
dt.glossterm { margin-left: 0em; }
dd + dt.glossterm { margin-top: 2em; }
dd.glossdef, dd.glosssee, dd.glossseealso
  { margin-top: 1em; margin-left: 2em; margin-right: 1em; }
</xsl:text>
</xsl:template>


<!-- == Matched Templates == -->

<!-- = abstract = -->
<xsl:template match="abstract">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = ackno = -->
<xsl:template match="ackno">
  <xsl:call-template name="db2html.para"/>
</xsl:template>

<!-- = address = -->
<xsl:template match="address">
  <xsl:call-template name="db2html.block">
    <xsl:with-param name="verbatim" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = attribution = -->
<xsl:template match="attribution">
  <xsl:call-template name="db2html.block">
    <xsl:with-param name="first" select="false()"/>
  </xsl:call-template>
</xsl:template>

<!-- = blockquote = -->
<xsl:template match="blockquote">
  <xsl:call-template name="db2html.blockquote"/>
</xsl:template>

<!-- = caption = -->
<xsl:template match="caption">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = caution = -->
<xsl:template match="caution">
  <xsl:call-template name="db2html.block">
    <xsl:with-param name="class" select="'admonition'"/>
    <xsl:with-param name="indent" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = epigraph = -->
<xsl:template match="epigraph">
  <xsl:call-template name="db2html.blockquote"/>
</xsl:template>

<!-- = equation = -->
<xsl:template match="equation">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = example = -->
<xsl:template match="example">
  <xsl:call-template name="db2html.block">
    <xsl:with-param name="indent" select="true()"/>
    <xsl:with-param name="formal" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = figure = -->
<xsl:template match="figure">
  <xsl:call-template name="db2html.block">
    <xsl:with-param name="indent" select="true()"/>
    <xsl:with-param name="formal" select="true()"/>
    <!-- When a figure contains only a single mediaobject, it eats the caption -->
    <xsl:with-param name="caption"
                    select="*[not(self::blockinfo) and not(self::title) and not(self::titleabbrev)]
                             [last() = 1]/self::mediaobject/caption"/>
  </xsl:call-template>
</xsl:template>

<!-- = formalpara = -->
<xsl:template match="formalpara">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = glossdef = -->
<xsl:template match="glossdef">
  <dd class="glossdef">
    <xsl:apply-templates select="*[local-name(.) != 'glossseealso']"/>
  </dd>
  <xsl:apply-templates select="glossseealso[1]"/>
</xsl:template>

<!-- = glossentry = -->
<xsl:template match="glossentry">
  <dt class="glossterm">
    <xsl:apply-templates select="glossterm"/>
  </dt>
  <xsl:apply-templates select="glossdef | glosssee[1]"/>
</xsl:template>

<!-- = glosssee = -->
<xsl:template match="glosssee | glossseealso">
  <dd class="{local-name(.)}">
    <p>
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="concat(local-name(.), '.format')"/>
        <xsl:with-param name="node" select="."/>
        <xsl:with-param name="format" select="true()"/>
      </xsl:call-template>
    </p>
  </dd>
</xsl:template>

<!--#% l10n.format.mode -->
<xsl:template mode="l10n.format.mode" match="msg:glosssee">
  <xsl:param name="node"/>
  <xsl:for-each select="$node |
                        $node/following-sibling::*[name(.) = name($node)]">
    <xsl:if test="position() != 1">
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="', '"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@otherterm">
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="db.xref.target">
              <xsl:with-param name="linkend" select="@otherterm"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:call-template name="db.xref.tooltip">
              <xsl:with-param name="linkend" select="@otherterm"/>
            </xsl:call-template>
          </xsl:attribute>
        </a>
        <xsl:choose>
          <xsl:when test="normalize-space(.) != ''">
            <xsl:apply-templates/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="db.xref.content">
              <xsl:with-param name="linkend" select="@otherterm"/>
              <xsl:with-param name="role" select="'glosssee'"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

<!-- = highlights = -->
<xsl:template match="highlights">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = important = -->
<xsl:template match="important">
  <xsl:call-template name="db2html.block">
    <xsl:with-param name="class" select="'admonition'"/>
    <xsl:with-param name="indent" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = informalequation = -->
<xsl:template match="informalequation">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = informalexample = -->
<xsl:template match="informalexample">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = informalfigure = -->
<xsl:template match="informalfigure">
  <xsl:call-template name="db2html.block">
    <xsl:with-param name="indent" select="true()"/>
    <xsl:with-param name="formal" select="true()"/>
    <!-- When a figure contains only a single mediaobject, it eats the caption -->
    <xsl:with-param name="caption"
                    select="*[not(self::blockinfo) and not(self::title) and not(self::titleabbrev)]
                             [last() = 1]/self::mediaobject/caption"/>
  </xsl:call-template>
</xsl:template>

<!-- = literallayout = -->
<xsl:template match="literallayout">
  <xsl:call-template name="db2html.block">
    <xsl:with-param name="verbatim" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = note = -->
<xsl:template match="note">
  <xsl:call-template name="db2html.block">
    <xsl:with-param name="class">
      <xsl:text>admonition</xsl:text>
      <xsl:if test="@role = 'bug'">
        <xsl:text> note-bug</xsl:text>
      </xsl:if>
    </xsl:with-param>
    <xsl:with-param name="indent" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = para = -->
<xsl:template match="para">
  <xsl:call-template name="db2html.para"/>
</xsl:template>

<!-- = programlisting = -->
<xsl:template match="programlisting">
  <xsl:call-template name="db2html.pre">
    <xsl:with-param name="indent" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = screen = -->
<xsl:template match="screen">
  <xsl:call-template name="db2html.pre">
    <xsl:with-param name="indent" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = simpara = -->
<xsl:template match="simpara">
  <xsl:call-template name="db2html.para"/>
</xsl:template>

<!-- = synopsis = -->
<xsl:template match="synopsis">
  <xsl:call-template name="db2html.pre"/>
</xsl:template>

<!-- = tip = -->
<xsl:template match="tip">
  <xsl:call-template name="db2html.block">
    <xsl:with-param name="class" select="'admonition'"/>
    <xsl:with-param name="indent" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = title = -->
<xsl:template match="title">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = warning = -->
<xsl:template match="warning">
  <xsl:call-template name="db2html.block">
    <xsl:with-param name="class" select="'admonition'"/>
    <xsl:with-param name="indent" select="true()"/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
