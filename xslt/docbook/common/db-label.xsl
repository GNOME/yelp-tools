<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Automatic Labels</doc:title>


<!-- == db.label =========================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.label</name>
  <purpose>
    Generate the label for an element
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The element for which to generate a label
    </purpose>
  </parameter>
  <parameter>
    <name>role</name>
    <purpose>
      The role of the label, as passed to the format templates
    </purpose>
  </parameter>
  <para>
    This template generates the label used for some sectioning and
    block-level elements.  For instance, this would generate strings
    such as Section 14.3 or Table 5-2.  The template simply applies
    the mode <mode>db.label.mode</mode> to the element.  To change
    the behavior of a particular type of element, you should always
    override the mode template for that type of element.
  </para>
  <para>
    Overriding the <template>db.label</template> template should only
    be done if you wish to change the labelling mechanism completely, or
    you wish to wrap the labelling mechanism (for instance, with a caching
    extension).  Do not override this template to suppress label prefixes
    in titles.
  </para>
</template>

<xsl:template name="db.label">
  <xsl:param name="node" select="."/>
  <xsl:param name="role"/>
  <xsl:choose>
    <xsl:when test="$node/@label">
      <xsl:value-of select="$node/@label"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="db.label.mode" select="$node">
        <xsl:with-param name="role" select="$role"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- == db.label.mode ====================================================== -->

<mode xmlns="http://www.gnome.org/~shaunm/xsldoc">>
<name>db.label.mode</name>
<FIXME/>
</mode>

<xsl:template mode="db.label.mode" match="appendix">
  <xsl:param name="role"/>
  <xsl:call-template name="format.appendix.label">
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="lang" select="ancestor-or-self::*[@lang][1]/@lang"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db.label.mode" match="chapter">
  <xsl:param name="role"/>
  <xsl:call-template name="format.chapter.label">
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="lang" select="ancestor-or-self::*[@lang][1]/@lang"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db.label.mode" match="example">
  <xsl:param name="role"/>
  <xsl:call-template name="format.example.label">
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="lang" select="ancestor-or-self::*[@lang][1]/@lang"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db.label.mode" match="figure">
  <xsl:param name="role"/>
  <xsl:call-template name="format.figure.label">
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="lang" select="ancestor-or-self::*[@lang][1]/@lang"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db.label.mode" match="glossentry">
  <xsl:apply-templates select="glossterm/node()"/>
</xsl:template>

<xsl:template mode="db.label.mode" match="part">
  <xsl:param name="role"/>
  <xsl:call-template name="format.part.label">
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="lang" select="ancestor-or-self::*[@lang][1]/@lang"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db.label.mode" match="
              section | sect1 | sect2 | sect3 | sect4 | sect5 | simplesect">
  <xsl:param name="role"/>
  <xsl:call-template name="format.section.label">
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="lang" select="ancestor-or-self::*[@lang][1]/@lang"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db.label.mode" match="table">
  <xsl:param name="role"/>
  <xsl:call-template name="format.table.label">
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="lang" select="ancestor-or-self::*[@lang][1]/@lang"/>
  </xsl:call-template>
</xsl:template>

<!-- FIXME: refsection refsect1 refsect2 refsect3 -->

<xsl:template mode="db.label.mode" match="
              article  | book     | bibliography |
              colophon | glossary     | index     |
              qandadiv | qandaset | preface      | reference |
              refentry | set      | setindex ">
  <xsl:param name="role"/>
<!-- FIXME 
  <xsl:call-template name="db.label.name"/>
  <xsl:text> </xsl:text>
  <xsl:call-template name="db.label.number"/>
-->
</xsl:template>

<xsl:template mode="db.label.mode" match="answer | question">
  <xsl:param name="role" select="@role"/>
  <xsl:variable name="qandaset" select="ancestor::qandaset[1]"/>
  <!-- FIXME -->
  <xsl:choose>
    <xsl:when test="label">
      <xsl:apply-templates select="label/node()"/>
    </xsl:when>
    <xsl:when test="$qandaset/@defaultlabel = 'none'"/>
    <xsl:when test="$qandaset/@defaultlabel = 'qanda'">
      <xsl:call-template name="gettext">
        <xsl:with-param name="msgid" select="'Q:'"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gettext">
        <xsl:with-param name="msgid" select="'Q:'"/>
      </xsl:call-template>
      <xsl:call-template name="db.label.number"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template mode="db.label.mode" match="synopfragment">
  <xsl:param name="role"/>
  <xsl:text>(</xsl:text>
  <xsl:call-template name="db.label.number"/>
  <xsl:text>)</xsl:text>
</xsl:template>

<xsl:template mode="db.label.mode" match="title | subtitle">
  <xsl:param name="role"/>
  <xsl:call-template name="db.label">
    <xsl:with-param name="node" select=".."/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db.label.mode" match="
              appendixinfo | articleinfo  | bibliographyinfo | bookinfo     |
              chapterinfo  | glossaryinfo | indexinfo        | partinfo     |
              prefaceinfo  | refentryinfo | referenceinfo    | refsect1info |
              refsect2info | refsect3info | refsectioninfo   | sect1info    |
              sect2info    | sect3info    | sect4info        | sect5info    |
              sectioninfo  | setindexinfo | setinfo          ">
  <xsl:param name="role"/>
<!-- FIXME 
  <xsl:call-template name="db.label.name"/>
-->
</xsl:template>

<xsl:template mode="db.label.mode" match="*"/>


<!-- == db.label.number ==================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.label.number</name>
  <purpose>
    Generate the number portion of a label
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The element for which to generate a number
    </purpose>
  </parameter>
  <para>
    This template generates the number portion of the label used for some
    sectioning and block-level elements.  The template simply applies the
    mode <mode>db.label.number.mode</mode> to the element.  To change
    the behavior of a particular type of element, then, you should always
    override the mode template for that type of element.
  </para>
  <para>
    Overriding the <template>db.label.number</template> template should
    only be done if you wish to change the numbering mechanism completely,
    or you wish to wrap the numbering mechanism (for instance, with a caching
    extension).
  </para>
</template>

<xsl:template name="db.label.number">
  <xsl:param name="node" select="."/>
  <xsl:apply-templates mode="db.label.number.mode" select="$node"/>
</xsl:template>


<!-- == db.label.number.mode =============================================== -->

<mode xmlns="http://www.gnome.org/~shaunm/xsldoc">>
<name>db.label.number.mode</name>
<FIXME/>
</mode>

<!-- need to use formatters -->

<xsl:template mode="db.label.number.mode" match="answer">
  <!-- FIXME -->
</xsl:template>

<xsl:template mode="db.label.number.mode" match="appendix">
  <xsl:number format="A" value="
              count(preceding-sibling::appendix) + 1 +
              count(parent::part/preceding-sibling::part/appendix)"/>
</xsl:template>

<xsl:template mode="db.label.number.mode" match="article">
  <xsl:number format="I" value="
              count(preceding-sibling::article) + 1 +
              count(parent::part/preceding-sibling::part/article)"/>
</xsl:template>

<xsl:template mode="db.label.number.mode" match="chapter">
  <xsl:number value="
              count(preceding-sibling::chapter) + 1 +
              count(parent::part/preceding-sibling::part/chapter)"/>
</xsl:template>

<xsl:template mode="db.label.number.mode" match="question">
  <!-- FIXME -->
</xsl:template>

<xsl:template mode="db.label.number.mode" match="reference">
  <xsl:number format="I" value="
              count(preceding-sibling::reference) + 1 +
              count(parent::part/preceding-sibling::part/reference)"/>
</xsl:template>

<xsl:template mode="db.label.number.mode" match="
              refentry | refsect1   | refsect2 | refsect3 | refsection |
              sect1    | sect2      | sect3    | sect4    | sect5      |
              section  | simplesect ">
  <xsl:if test="local-name(..) != 'article'   and
                local-name(..) != 'partintro' and
                local-name(..) != 'preface'   ">
    <xsl:call-template name="db.label.number">
      <xsl:with-param name="node" select=".."/>
    </xsl:call-template>
    <xsl:text>.</xsl:text>
  </xsl:if>
  <xsl:number level="single" format="1" count="
              refentry | refsect1   | refsect2 | refsect3 | refsection |
              sect1    | sect2      | sect3    | sect4    | sect5      |
              section  | simplesect "/>
</xsl:template>

<xsl:template mode="db.label.number.mode" match="
              book  | bibliography | colophon | glossary |
              index | preface      | set      | setindex "/>

<xsl:template mode="db.label.number.mode" match="synopfragment">
  <xsl:value-of select="count(preceding-sibling::synopfragment) + 1"/>
</xsl:template>

<xsl:template mode="db.label.number.mode" match="title | subtitle">
  <xsl:call-template name="db.label.number">
    <xsl:with-param name="node" select=".."/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db.label.number.mode" match="*">
  <xsl:call-template name="db.label.number">
    <xsl:with-param name="node" select=".."/>
  </xsl:call-template>
</xsl:template>

<!-- OK below -->

<!-- = example = -->
<xsl:template mode="db.label.number.mode" match="example">
  <xsl:choose>
    <xsl:when test="ancestor::appendix or ancestor::chapter">
      <xsl:call-template name="format.example.number">
        <xsl:with-param name="node" select="."/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="format.example.number.flat"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- = figure = -->
<xsl:template mode="db.label.number.mode" match="figure">
  <xsl:choose>
    <xsl:when test="ancestor::appendix or ancestor::chapter">
      <xsl:call-template name="format.figure.number">
        <xsl:with-param name="node" select="."/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="format.figure.number.flat"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- = part = -->
<xsl:template mode="db.label.number.mode" match="part">
  <xsl:call-template name="format.part.number">
    <xsl:with-param name="node" select="."/>
  </xsl:call-template>
</xsl:template>

<!-- = table = -->
<xsl:template mode="db.label.number.mode" match="table">
  <xsl:choose>
    <xsl:when test="ancestor::appendix or ancestor::chapter">
      <xsl:call-template name="format.table.number">
        <xsl:with-param name="node" select="."/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="format.table.number.flat"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
