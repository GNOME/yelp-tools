<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Automatic Labels</doc:title>


<!-- == db2html.label ====================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.label</name>
  <description>
    Generate the label for an element
  </description>
  <parameter>
    <name>node</name>
    <description>
      The element for which to generate a label
    </description>
  </parameter>
  <para>
    This template generates the label used for some sectioning and
    block-level elements.  For instance, this would generate strings
    such as Section 14.3 or Table 5-2.  The template simply applies
    the mode <mode>db2html.label.mode</mode> to the element.  To
    change the behavior of a particular type of element, you should
    always override the mode template for that type of element.
  </para>
  <para>
    Overriding the <template>db2html.label</template> template should only
    be done if you wish to change the labelling mechanism completely, or
    you wish to wrap the labelling mechanism (for instance, with a caching
    extension).  Do not override this template to suppress label prefixes
    in titles.
  </para>
  <para>
    Most labels contain a name portion and a number portion.  Templates
    should generally call <template>db2html.label.name</template> and
    <template>db2html.label.number</template> to generate these portions.
  </para>
</template>

<xsl:template name="db2html.label">
  <xsl:param name="node" select="."/>
  <xsl:choose>
    <xsl:when test="$node/@label">
      <xsl:value-of select="$node/@label"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="db2html.label.mode" select="$node"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- == db2html.label.mode ================================================= -->

<mode xmlns="http://www.gnome.org/~shaunm/xsldoc">>
<name>db2html.label.mode</name>
<FIXME/>
</mode>

<xsl:template mode="db2html.label.mode" match="
              appendix  | article    | book      | bibliography | chapter    |
              colophon  | example    | figure    | glossary     | index      |
              part      | preface    | reference | refsect1     | refsect2   |
              refsect3  | refsection | refentry  | sect1        | sect2      |
              sect3     | sect4      | sect5     | section      | set        |
              setindex  | simplesect | table     ">
  <xsl:call-template name="db2html.label.name"/>
  <xsl:text> </xsl:text>
  <xsl:call-template name="db2html.label.number"/>
</xsl:template>

<xsl:template mode="db2html.label.mode" match="answer | question">
  <xsl:variable name="qandaset" select="ancestor::qandaset[1]"/>
  <xsl:choose>
    <xsl:when test="label">
      <xsl:apply-templates select="label/node()"/>
    </xsl:when>
    <xsl:when test="$qandaset/@defaultlabel = 'none'"/>
    <xsl:when test="$qandaset/@defaultlabel = 'qanda'">
      <xsl:call-template name="db2html.label.name"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="db2html.label.number"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template mode="db2html.label.mode" match="synopfragment">
  <xsl:text>(</xsl:text>
  <xsl:call-template name="db2html.label.number"/>
  <xsl:text>)</xsl:text>
</xsl:template>

<xsl:template mode="db2html.label.mode" match="title | subtitle">
  <xsl:call-template name="db2html.label">
    <xsl:with-param name="node" select=".."/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.mode" match="
              appendixinfo | articleinfo  | bibliographyinfo | bookinfo     |
              chapterinfo  | glossaryinfo | indexinfo        | partinfo     |
              prefaceinfo  | refentryinfo | referenceinfo    | refsect1info |
              refsect2info | refsect3info | refsectioninfo   | sect1info    |
              sect2info    | sect3info    | sect4info        | sect5info    |
              sectioninfo  | setindexinfo | setinfo          ">
  <xsl:call-template name="db2html.label.name"/>
</xsl:template>

<xsl:template mode="db2html.label.mode" match="*"/>


<!-- == db2html.label.name ================================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.label.name</name>
  <description>
    Generate the name portion of a label
  </description>
  <parameter>
    <name>node</name>
    <description>
      The element for which to generate a name
    </description>
  </parameter>
  <para>
    This template generates the name portion of the label used for some
    sectioning and block-level elements.  The template simply applies the
    mode <mode>db2html.label.name.mode</mode> to the element.  To change
    the behavior of a particular type of element, you should always override
    the mode template for that type of element.
  </para>
  <para>
    Overriding the <template>db2html.label.name</template> template should
    only be done if you wish to change the naming mechanism completely, or
    you wish to wrap the naming mechanism (for instance, with a caching
    extension).
  </para>
</template>

<xsl:template name="db2html.label.name">
  <xsl:param name="node" select="."/>
  <xsl:apply-templates mode="db2html.label.name.mode" select="$node"/>
</xsl:template>


<!-- == db2html.label.name.mode ============================================ -->

<mode xmlns="http://www.gnome.org/~shaunm/xsldoc">>
<name>db2html.label.name.mode</name>
<FIXME/>
</mode>

<xsl:template mode="db2html.label.name.mode" match="answer">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'A'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="appendixinfo">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'About This Appendix'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="articleinfo">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'About This Article'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="bibliographyinfo">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'About This Bibliography'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="bookinfo">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'About This Book'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="chapterinfo">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'About This Chapter'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="glossaryinfo">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'About This Glossary'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="indexinfo | setindexinfo">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'About This Index'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="partinfo">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'About This Part'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="question">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Q'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="prefaceinfo">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'About This Preface'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="refentryinfo">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'About This Entry'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="referenceinfo">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'About This Reference'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="
              refsect1info | refsect2info | refsect3info | refsectioninfo |
              sect1info    | sect2info    | sect3info    | sect4info      |
              sect5info    | sectioninfo  ">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'About This Section'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="setinfo">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'About This Set'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="appendix">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Appendix'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="article">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Article'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="book">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Book'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="bibliography">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Bigliography'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="caution">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Caution'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="chapter">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Chapter'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="colophon">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Colophon'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="dedication">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Dedication'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="example">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Example'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="figure">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Figure'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="glossary">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Glossary'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="important">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Important'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="index">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Index'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="msgaud">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Message Audience'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="msglevel">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Message Level'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="msgorig">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Message Origin'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="note">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Note'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="part">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Part'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="preface">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Preface'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="reference">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Reference'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="refentry">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Reference Entry'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="
              refsect1 | refsect2 | refsect3 | refsection">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Reference Section'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="
              sect1 | sect2 | sect3 | sect4 | section | simplesect">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Section'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="setindex">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Set Index'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="table">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Table'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="tip">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Tip'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="warning">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Warning'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="title | subtitle">
  <xsl:call-template name="db2html.label.name">
    <xsl:with-param name="node" select=".."/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.name.mode" match="*">
  <xsl:call-template name="gettext">
    <xsl:with-param name="msgid" select="'Unknown'"/>
  </xsl:call-template>
</xsl:template>


<!-- == db2html.label.number =============================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.label.number</name>
  <description>
    Generate the number portion of a label
  </description>
  <parameter>
    <name>node</name>
    <description>
      The element for which to generate a number
    </description>
  </parameter>
  <para>
    This template generates the number portion of the label used for some
    sectioning and block-level elements.  The template simply applies the
    mode <mode>db2html.label.number.mode</mode> to the element.  To change
    the behavior of a particular type of element, then, you should always
    override the mode template for that type of element.
  </para>
  <para>
    Overriding the <template>db2html.label.number</template> template should
    only be done if you wish to change the numbering mechanism completely,
    or you wish to wrap the numbering mechanism (for instance, with a caching
    extension).
  </para>
</template>

<xsl:template name="db2html.label.number">
  <xsl:param name="node" select="."/>
  <xsl:apply-templates mode="db2html.label.number.mode" select="$node"/>
</xsl:template>


<!-- == db2html.label.number.mode ============================================ -->

<mode xmlns="http://www.gnome.org/~shaunm/xsldoc">>
<name>db2html.label.number.mode</name>
<FIXME/>
</mode>

<xsl:template mode="db2html.label.number.mode" match="answer">
  <!-- FIXME -->
</xsl:template>

<xsl:template mode="db2html.label.number.mode" match="appendix">
  <xsl:number format="A" value="
              count(preceding-sibling::appendix) + 1 +
              count(parent::part/preceding-sibling::part/appendix)"/>
</xsl:template>

<xsl:template mode="db2html.label.number.mode" match="article">
  <xsl:number format="I" value="
              count(preceding-sibling::article) + 1 +
              count(parent::part/preceding-sibling::part/article)"/>
</xsl:template>

<xsl:template mode="db2html.label.number.mode" match="chapter">
  <xsl:number value="
              count(preceding-sibling::chapter) + 1 +
              count(parent::part/preceding-sibling::part/chapter)"/>
</xsl:template>

<xsl:template mode="db2html.label.number.mode" match="part">
  <xsl:number format="I" value="count(preceding-sibling::part) + 1"/>
</xsl:template>

<xsl:template mode="db2html.label.number.mode" match="question">
  <!-- FIXME -->
</xsl:template>

<xsl:template mode="db2html.label.number.mode" match="reference">
  <xsl:number format="I" value="
              count(preceding-sibling::reference) + 1 +
              count(parent::part/preceding-sibling::part/reference)"/>
</xsl:template>

<xsl:template mode="db2html.label.number.mode" match="
              refentry | refsect1   | refsect2 | refsect3 | refsection |
              sect1    | sect2      | sect3    | sect4    | sect5      |
              section  | simplesect ">
  <xsl:choose>
    <xsl:when test="
              local-name(..) = 'article'   or
              local-name(..) = 'partintro' or
              local-name(..) = 'preface'   ">
      <xsl:number value="
                  count(preceding-sibling::*[name(.) = name(current())]) + 1"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="db2html.label.number">
        <xsl:with-param name="node" select=".."/>
      </xsl:call-template>
      <xsl:text>.</xsl:text>
      <xsl:number value="
                  count(preceding-sibling::*
                  [local-name(.) = local-name(current())]) + 1"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template mode="db2html.label.number.mode" match="
              book  | bibliography | colophon | glossary |
              index | preface      | set      | setindex "/>

<xsl:template mode="db2html.label.number.mode" match="synopfragment">
  <xsl:value-of select="count(preceding-sibling::synopfragment) + 1"/>
</xsl:template>

<xsl:template mode="db2html.label.number.mode" match="title | subtitle">
  <xsl:call-template name="db2html.label.number">
    <xsl:with-param name="node" select=".."/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.number.mode" match="*">
  <xsl:call-template name="db2html.label.number">
    <xsl:with-param name="node" select=".."/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db2html.label.number.mode" match="example | figure | table">
  <xsl:variable name="section" select="
                ancestor::*[parent::article][
                local-name(.) = 'refentry' or local-name(.) = 'sect1' or
                local-name(.) = 'section'  or local-name(.) = 'simplesect'
                ]"/>
  <xsl:variable name="parent">
    <xsl:choose>
      <xsl:when test="$section">
        <xsl:call-template name="db2html.label.number">
          <xsl:with-param name="node" select="$section[last()]"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="chapter" select="
                      ancestor::*[
                      local-name(.) = 'appendix' or local-name(.) = 'chapter'
                      ]"/>
        <xsl:if test="$chapter">
          <xsl:call-template name="db2html.label.number">
            <xsl:with-param name="node" select="$chapter[1]"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="num">
    <xsl:choose>
      <xsl:when test="$section">
        <xsl:value-of select="count(
                      ancestor-or-self::*[
                      ancestor::refentry[parent::article]   |
                      ancestor::sect1[parent::article]      |
                      ancestor::section[parent::article]    |
                      ancestor::simplesect[parent::article]
                      ]/preceding-sibling::*/descendant-or-self::*[
                      name(.) = name(current())
                      ]) + 1"/>
      </xsl:when>
      <xsl:when test="
                ancestor::*[
                local-name(.) = 'appendix' or local-name(.) = 'chapter'
                ]">
        <xsl:value-of select="count(
                      ancestor-or-self::*[
                      ancestor::appendix | ancestor::chapter
                      ]/preceding-sibling::*/descendant-or-self::*[
                      name(.) = name(current())
                      ]) + 1"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="count(preceding::*[name(.) = name(current())]) + 1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="not($parent)">
      <xsl:number value="$num"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$parent"/>
      <xsl:text>-</xsl:text>
      <xsl:number value="$num"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
