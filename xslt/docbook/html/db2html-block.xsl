<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Block-Level Elements</doc:title>


<!-- == db2html.block ====================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.block</name>
  <purpose>
    Format a block-level element
  </purpose>
  <parameter>
    <name>verbatim</name>
    <purpose>
      Whether to maintain whitespace verbatim
    </purpose>
  </parameter>
</template>

<xsl:template name="db2html.block">
  <xsl:param name="verbatim" select="false()"/>

  <div class="{local-name(.)}">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:choose>
      <xsl:when test="$verbatim">
        <xsl:variable name="style">
          <xsl:if test="$verbatim">
            <xsl:text>white-space: pre; </xsl:text>
          </xsl:if>
        </xsl:variable>
        <xsl:attribute name="style">
          <xsl:value-of select="$style"/>
        </xsl:attribute>
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>


<!-- == db2html.blockquote ================================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.blockquote</name>
  <purpose>
    Render a blockquote for an element
  </purpose>
</template>

<xsl:template name="db2html.blockquote">
  <div class="{local-name(.)}">
    <xsl:apply-templates select="title"/>
    <blockquote class="{local-name(.)}">
      <xsl:apply-templates
       select="*[name(.) != 'title' and name(.) != 'attribution']"/>
    </blockquote>
    <xsl:apply-templates select="attribution"/>
  </div>
</xsl:template>


<!-- == db2html.para ======================================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.para</name>
  <purpose>
    Format an element as a paragraph
  </purpose>
</template>

<xsl:template name="db2html.para">
  <p class="{local-name(.)}">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:apply-templates/>
  </p>
</xsl:template>


<!-- == db2html.pre ======================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.pre</name>
  <purpose>
    Format an element in a <xmltag>pre</xmltag> tag
  </purpose>
</template>

<xsl:template name="db2html.pre">
  <!-- FIXME:
  @width
  @language
  @continuation
  @format
  @startinglinenumber
  -->
  <div class="{local-name(.)}">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:if test="@linenumbering = 'numbered'">
      <pre class="linenumbering" style="float: left; text-align: right;"><xsl:call-template name="db.linenumbering"/></pre>
    </xsl:if>
    <pre class="{local-name(.)}">
      <xsl:apply-templates/>
    </pre>
  </div>
</xsl:template>


<!-- == db2html.block.css ================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.block.css</name>
  <purpose>
    Create CSS for the block elements
  </purpose>
</template>

<xsl:template name="db2html.block.css">
  <xsl:text>
    div[class~="figure"] { margin-left: 24px; margin-right: 12px; }
    pre[class~="programlisting"] {
      margin-left: 24px;
      margin-right: 12px;
      overflow: auto;
    }
    pre[class~="screen"] {
      margin-left: 24px;
      margin-right: 12px;
      overflow: auto;
    }
    pre[class~="synopsis"] {
      margin-left: 24px;
      margin-right: 12px;
      overflow: auto;
    }
    pre[class~="linenumbering"] {
      <!-- This margin is important to get the line numbering
      to line up vertically with the content. -->
      margin-top: 0px;
      margin-left: 18px;
      background-color: black;
      color: white;
      -moz-opacity: .3;
      padding-right: 0.4em;
      padding-left: 0.4em;
    }
    blockquote[class~="blockquote"] { margin-left: 24px; margin-right: 12px; }
    dt[class~="glossterm"] { margin-left: 8px; }
    dt[class~="glossterm"] + dd { margin-top: 0.4em; margin-bottom: 0.4em; }
    dt[class~="glossterm"] + dd &gt; p:first-child { margin-top: 0px; }
    dd[class~="glossdef"]     { margin-left: 24px; margin-right: 12px; }
    dd[class~="glosssee"]     { margin-left: 24px; margin-right: 12px; }
    dd[class~="glossseealso"] { margin-left: 24px; margin-right: 12px; }
  </xsl:text>
</xsl:template>


<!-- Matched Templates ===================================================== -->

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
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = blockquote = -->
<xsl:template match="blockquote">
  <xsl:call-template name="db2html.blockquote"/>
</xsl:template>

<!-- = caption = -->
<xsl:template match="caption">
  <xsl:call-template name="db2html.block"/>
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
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = figure = -->
<xsl:template match="figure">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = glossdef = -->
<xsl:template match="glossdef">
  <dd class="glossdef">
    <xsl:apply-templates select="*[local-name(.) != 'glossseealso']"/>
  </dd>
  <xsl:apply-templates select="glossseealso"/>
</xsl:template>

<!-- = glossentry = -->
<xsl:template match="glossentry">
  <dt class="glossterm">
    <xsl:apply-templates select="glossterm"/>
  </dt>
  <xsl:apply-templates select="glossdef | glosssee"/>
</xsl:template>

<!-- = glosssee = -->
<xsl:template match="glosssee">
  <!-- FIXME: this i18n sucks badly -->
  <dd class="glosssee">
    <p>
      <xsl:call-template name="gettext">
        <xsl:with-param name="msgid" select="'See'"/>
      </xsl:call-template>
      <xsl:text> </xsl:text>
      <xsl:choose>
        <xsl:when test="@otherterm">
          <xsl:call-template name="db2html.xref">
            <xsl:with-param name="linkend" select="@otherterm"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>.</xsl:text>
    </p>
  </dd>
</xsl:template>

<!-- = highlights = -->
<xsl:template match="highlights">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = informalequation = -->
<xsl:template match="informalequation">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = literallayout = -->
<xsl:template match="literallayout">
  <xsl:call-template name="db2html.block">
    <xsl:with-param name="verbatim" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = para = -->
<xsl:template match="para">
  <xsl:call-template name="db2html.para"/>
</xsl:template>

<!-- = programlisting = -->
<xsl:template match="programlisting">
  <xsl:call-template name="db2html.pre"/>
</xsl:template>

<!-- = screen = -->
<xsl:template match="screen">
  <xsl:call-template name="db2html.pre"/>
</xsl:template>

<!-- = synopsis = -->
<xsl:template match="synopsis">
  <xsl:call-template name="db2html.pre"/>
</xsl:template>

</xsl:stylesheet>
