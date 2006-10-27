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
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

<!--!!==========================================================================
DocBook to HTML - Inline Elements

REMARK: Describe this module
-->


<!--**==========================================================================
db2html.inline
Renders an inline element
$node: The element to render
$bold: Whether to render the element in bold face
$italic: Whether to render the element in italics
$underline: Whether to underline the element
$mono: Whether to render the element in a monospace font
$sans: Whether to render the element in a sans-serif font

REMARK: Document this template
-->
<xsl:template name="db2html.inline">
  <xsl:param name="node" select="."/>
  <xsl:param name="bold" select="false()"/>
  <xsl:param name="italic" select="false()"/>
  <xsl:param name="underline" select="false()"/>
  <xsl:param name="mono" select="false()"/>
  <xsl:param name="sans" select="false()"/>

  <!-- FIXME: do CSS classes, rather than inline styles -->
  <span class="{local-name($node)}">
    <xsl:if test="$bold or $italic or $mono or $underline or $sans">
      <xsl:variable name="style">
        <xsl:if test="$bold">
          <xsl:text>font-weight: bold; </xsl:text>
        </xsl:if>
        <xsl:if test="$italic">
          <xsl:text>font-style: italic; </xsl:text>
        </xsl:if>
        <xsl:if test="$underline">
          <xsl:text>text-decoration: underline; </xsl:text>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="$mono">
            <xsl:text>font-family: monospace; </xsl:text>
          </xsl:when>
          <xsl:when test="$sans">
            <xsl:text>font-family: sans-serif; </xsl:text>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:attribute name="style">
        <xsl:value-of select="$style"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:call-template name="db2html.anchor">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <xsl:apply-templates select="$node/node()"/>
  </span>
</xsl:template>


<!-- == Matched Templates == -->

<!-- = abbrev = -->
<xsl:template match="abbrev">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = accel = -->
<xsl:template match="accel">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="underline" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = acronym = -->
<xsl:template match="acronym">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="sans" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = action = -->
<xsl:template match="action">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = artpagenums = -->
<xsl:template match="artpagenums">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = application = -->
<xsl:template match="application">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="italic" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = authorinitials = -->
<xsl:template match="authorinitials">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = citetitle = -->
<xsl:template match="citetitle">
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'citetitle.format'"/>
    <xsl:with-param name="role" select="@pubwork"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = city = -->
<xsl:template match="city">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = citation = -->
<xsl:template match="citation">
  <span class="citation-punc">
    <xsl:text>[</xsl:text>
    <xsl:call-template name="db2html.inline"/>
    <xsl:text>]</xsl:text>
  </span>
</xsl:template>

<!-- = classname = -->
<xsl:template match="classname">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="mono" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = code = -->
<xsl:template match="code">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="mono" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = command = -->
<xsl:template match="command">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="mono" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = computeroutput = -->
<xsl:template match="computeroutput">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="mono" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = constant = -->
<xsl:template match="constant">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="mono" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = corpauthor = -->
<xsl:template match="corpauthor">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = corpcredit = -->
<xsl:template match="corpcredit">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = country = -->
<xsl:template match="country">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = database = -->
<xsl:template match="database">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = date = -->
<xsl:template match="date">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = edition = -->
<xsl:template match="edition">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = email = -->
<xsl:template match="email">
  <span class="email-punc">
    <tt>
      <xsl:text>&lt;</xsl:text>
      <a>
        <xsl:attribute name="href">
          <xsl:text>mailto:</xsl:text>
          <xsl:value-of select="string(.)"/>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:call-template name="l10n.gettext">
            <xsl:with-param name="msgid" select="'email.tooltip'"/>
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="format" select="true()"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:call-template name="db2html.inline"/>
      </a>
      <xsl:text>&gt;</xsl:text>
    </tt>
  </span>
</xsl:template>

<!-- = emphasis = -->
<xsl:template match="emphasis">
  <xsl:variable name="bold" select="@role = 'bold' or @role = 'strong'"/>
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="bold" select="$bold"/>
    <xsl:with-param name="italic" select="not($bold)"/>
  </xsl:call-template>
</xsl:template>

<!-- = envar = -->
<xsl:template match="envar">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="mono" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = errorcode = -->
<xsl:template match="errorcode">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = errorname = -->
<xsl:template match="errorname">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = errortext = -->
<xsl:template match="errortext">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = errortype = -->
<xsl:template match="errortype">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = exceptionname = -->
<xsl:template match="exceptionname">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="mono" select="$true"/>
  </xsl:call-template>
</xsl:template>

<!-- = fax = -->
<xsl:template match="fax">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = filename = -->
<xsl:template match="filename">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="mono" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = firstname = -->
<xsl:template match="firstname">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = firstterm = -->
<xsl:template match="firstterm">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="italic" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = foreignphrase = -->
<xsl:template match="foreignphrase">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="italic" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = function = -->
<xsl:template match="function">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="mono" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = glossterm = -->
<xsl:template match="glossterm">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = guibutton = -->
<xsl:template match="guibutton">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="bold" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = guiicon = -->
<xsl:template match="guiicon">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = guilabel = -->
<xsl:template match="guilabel">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="bold" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = guimenu = -->
<xsl:template match="guimenu">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="bold" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = guimenuitem = -->
<xsl:template match="guimenuitem">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="bold" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = guisubmenu = -->
<xsl:template match="guisubmenu">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="bold" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = hardware = -->
<xsl:template match="hardware">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = honorific = -->
<xsl:template match="honorific">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = inlineequation = -->
<xsl:template match="inlineequation">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = interface = -->
<xsl:template match="interface">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="bold" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = interfacename = -->
<xsl:template match="interfacename">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="mono" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = isbn = -->
<xsl:template match="isbn">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = jobtitle = -->
<xsl:template match="jobtitle">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = keycap = -->
<xsl:template match="keycap">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="bold" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = keycode = -->
<xsl:template match="keycode">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = keycombo = -->
<xsl:template match="keycombo">
  <xsl:variable name="joinchar">
    <xsl:choose>
      <xsl:when test="@action = 'seq'"><xsl:text> </xsl:text></xsl:when>
      <xsl:when test="@action = 'simul'">+</xsl:when>
      <xsl:when test="@action = 'press'">-</xsl:when>
      <xsl:when test="@action = 'click'">-</xsl:when>
      <xsl:when test="@action = 'double-click'">-</xsl:when>
      <xsl:when test="@action = 'other'"></xsl:when>
      <xsl:otherwise>+</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <span class="keycombo">
    <xsl:for-each select="*">
      <xsl:if test="position() != 1">
        <xsl:value-of select="$joinchar"/>
      </xsl:if>
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </span>
</xsl:template>

<!-- = keysym = -->
<xsl:template match="keysym">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = lineage = -->
<xsl:template match="lineage">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = lineannotation = -->
<xsl:template match="lineannotation">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="italic" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = literal = -->
<xsl:template match="literal">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="mono" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = markup = -->
<xsl:template match="markup">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="mono" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = medialabel = -->
<xsl:template match="medialabel">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="italic" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = menuchoice = -->
<xsl:template match="menuchoice">
  <span class="menuchoice">
    <xsl:for-each select="*[local-name(.) != 'shortcut']">
      <xsl:if test="position() != 1">
        <xsl:text>&#x00A0;→ </xsl:text>
      </xsl:if>
      <xsl:apply-templates select="."/>
    </xsl:for-each>
    <xsl:if test="shortcut">
      <span class="shortcut-punc">
        <xsl:text> (</xsl:text>
        <xsl:apply-templates select="shortcut"/>
        <xsl:text>)</xsl:text>
      </span>
    </xsl:if>
  </span>
</xsl:template>

<!-- = methodname = -->
<xsl:template match="methodname">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="mono" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = mousebutton = -->
<xsl:template match="mousebutton">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = option = -->
<xsl:template match="option">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="mono" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = optional = -->
<xsl:template match="optional">
  <span class="optional-punc">
    <xsl:text>[</xsl:text>
    <xsl:call-template name="db2html.inline"/>
    <xsl:text>]</xsl:text>
  </span>
</xsl:template>

<!-- = orgdiv = -->
<xsl:template match="orgdiv">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = orgname = -->
<xsl:template match="orgname">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = othername = -->
<xsl:template match="othername">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = parameter = -->
<xsl:template match="parameter">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="mono" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = personname = -->
<xsl:template match="personname">
  <div class="personname">
    <xsl:call-template name="db.personname"/>
  </div>
</xsl:template>

<!-- = phone = -->
<xsl:template match="phone">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = pharse = -->
<xsl:template match="phrase">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = pob = -->
<xsl:template match="pob">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = postcode = -->
<xsl:template match="postcode">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = productname = -->
<xsl:template match="productname">
  <span class="productname-punc">
    <xsl:call-template name="db2html.inline"/>
    <xsl:if test="@class">
      <xsl:call-template name="db.dingbat">
        <xsl:with-param name="dingbat" select="@class"/>
      </xsl:call-template>
    </xsl:if>
  </span>
</xsl:template>

<!-- = productnumber = -->
<xsl:template match="productnumber">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = prompt = -->
<xsl:template match="prompt">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="mono" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = property = -->
<xsl:template match="property">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = pubdate = -->
<xsl:template match="pubdate">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = publishername = -->
<xsl:template match="publishername">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = quote = -->
<xsl:template match="quote">
  <span class="quote">
    <xsl:call-template name="l10n.gettext">
      <xsl:with-param name="msgid" select="'quote.format'"/>
      <xsl:with-param name="role">
        <xsl:choose>
          <xsl:when test="(count(ancestor::quote) mod 2) = 0">
            <xsl:text>outer</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>inner</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="node" select="."/>
      <xsl:with-param name="format" select="true()"/>
    </xsl:call-template>
  </span>
</xsl:template>

<!-- = replaceable = -->
<xsl:template match="replaceable">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="italic" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = returnvalue = -->
<xsl:template match="returnvalue">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="mono" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = sgmltag = -->
<xsl:template match="sgmltag">
  <xsl:variable name="class">
    <xsl:choose>
      <xsl:when test="@class">
        <xsl:value-of select="@class"/>
      </xsl:when>
      <xsl:otherwise>element</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <tt class="sgmltag-{$class}">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:choose>
      <xsl:when test="$class = 'attribute'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="$class = 'attvalue'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="$class = 'element'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="$class = 'emptytag'">
        <xsl:text>&lt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>/&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class = 'endtag'">
        <xsl:text>&lt;/</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class = 'genentity'">
        <xsl:text>&amp;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>;</xsl:text>
      </xsl:when>
      <xsl:when test="$class = 'namespace'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="$class = 'numcharref'">
        <xsl:text>&amp;#</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>;</xsl:text>
      </xsl:when>
      <xsl:when test="$class = 'paramentity'">
        <xsl:text>%</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>;</xsl:text>
      </xsl:when>
      <xsl:when test="$class = 'pi'">
        <xsl:text>&lt;?</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class = 'sgmlcomment'">
        <xsl:text>&lt;!--</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>--&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class = 'starttag'">
        <xsl:text>&lt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class = 'xmlpi'">
        <xsl:text>&lt;?</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>?&gt;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </tt>
</xsl:template>

<!-- = shortcut = -->
<xsl:template match="shortcut">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="bold" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = state = -->
<xsl:template match="state">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = street = -->
<xsl:template match="street">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = structfield = -->
<xsl:template match="structfield">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="italic" select="true()"/>
    <xsl:with-param name="mono" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = structname = -->
<xsl:template match="structname">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="mono" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = subscript = -->
<xsl:template match="subscript">
  <sub>
    <xsl:call-template name="db2html.anchor"/>
    <xsl:apply-templates/>
  </sub>
</xsl:template>

<!-- = superscript = -->
<xsl:template match="superscript">
  <sup>
    <xsl:call-template name="db2html.anchor"/>
    <xsl:apply-templates/>
  </sup>
</xsl:template>

<!-- = surname = -->
<xsl:template match="surname">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = symbol = -->
<xsl:template match="symbol">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = systemitem = -->
<xsl:template match="systemitem">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="mono" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = token = -->
<xsl:template match="token">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = trademark = -->
<xsl:template match="trademark">
  <xsl:variable name="class">
    <xsl:choose>
      <xsl:when test="@class">
        <xsl:value-of select="@class"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'trade'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <span class="trademark">
    <xsl:apply-templates/>
    <xsl:call-template name="db.dingbat">
      <xsl:with-param name="dingbat" select="$class"/>
    </xsl:call-template>
  </span>
</xsl:template>

<!-- = type = -->
<xsl:template match="type">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = uri = -->
<xsl:template match="uri">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="mono" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = userinput = -->
<xsl:template match="userinput">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="bold" select="true()"/>
    <xsl:with-param name="mono" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = varname = -->
<xsl:template match="varname">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="mono" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = wordasword = -->
<xsl:template match="wordasword">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="italic" select="true()"/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
