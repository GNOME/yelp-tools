<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                xmlns:exsl="http://exslt.org/common"
                exclude-result-prefixes="doc"
                extension-element-prefixes="exsl"
                version="1.0">

<doc:title>Chunking</doc:title>


<!-- == db.chunk.chunk_top ================================================= -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.chunk.chunk_top</name>
  <purpose>
    Whether the top-level chunk should be output with the chunking mechanism
  </purpose>
</parameter>

<xsl:param name="db.chunk.chunk_top" select="false()"/>


<!-- == db.chunk.max_depth ================================================= -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.chunk.max_depth</name>
  <purpose>
    The maximum depth for chunking sections
  </purpose>
</parameter>

<xsl:param name="db.chunk.max_depth">
  <xsl:choose>
    <xsl:when test="number(processing-instruction('db.chunk.max_depth'))">
      <xsl:value-of
       select="number(processing-instruction('db.chunk.max_depth'))"/>
    </xsl:when>
    <xsl:when test="/book">
      <xsl:value-of select="2"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="1"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>


<!-- == db.chunk.basename ================================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.chunk.basename</name>
  <purpose>
    The basename of the output file, without an extension
  </purpose>
</parameter>

<xsl:param name="db.chunk.basename"/>


<!-- == db.chunk.extension ================================================= -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.chunk.extension</name>
  <purpose>
    The default file extension for new output documents
  </purpose>
</parameter>

<xsl:param name="db.chunk.extension"/>


<!-- == db.chunk.cover_basename ============================================ -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.chunk.cover_basename</name>
  <purpose>
    The filename for the coversheet
  </purpose>
</parameter>

<xsl:param name="db.chunk.cover_basename"
           select="concat($db.chunk.basename, '-cover')"/>


<!-- == db.chunk.info_basename ============================================= -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.chunk.info_basename</name>
  <purpose>
    The filename for the titlepage
  </purpose>
</parameter>

<xsl:param name="db.chunk.info_basename"
           select="concat($db.chunk.basename, '-info')"/>


<!-- == db.chunk.index_basename ============================================ -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.chunk.index_basename</name>
  <purpose>
    The filename for the index
  </purpose>
</parameter>

<xsl:param name="db.chunk.index_basename"
           select="concat($db.chunk.basename, '-index')"/>


<!-- == db.chunk.toc_basename ============================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.chunk.toc_basename</name>
  <purpose>
    The filename for the table of contents
  </purpose>
</parameter>

<xsl:param name="db.chunk.toc_basename"
           select="concat($db.chunk.basename, '-toc')"/>


<!-- == db.chunk =========================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.chunk</name>
  <purpose>
    Create a new output document
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The source element for the output document
    </purpose>
  </parameter>
  <parameter>
    <name>info</name>
    <purpose>
      The info child element
    </purpose>
  </parameter>
  <parameter>
    <name>template</name>
    <purpose>
      The named template to call to create the document
    </purpose>
  </parameter>
  <parameter>
    <name>href</name>
    <purpose>
      The name of the file for the new document
    </purpose>
  </parameter>
  <parameter>
    <name>depth_of_chunk</name>
    <purpose>
      The depth of new output document
    </purpose>
  </parameter>
  <para>
    The <template>db.chunk</template> template creates a new output
    document using the <xmltag>exsl:document</xmltag> extension element.
    This template calls <template>db.chunk.content</template> to create
    the content of the document, passing through all parameters.  This
    allows you to override the chunking mechanism without having to
    duplicate the content-generation code.
  </para>
</template>

<xsl:template name="db.chunk">
  <xsl:param name="node" select="."/>
  <xsl:param name="info"/>
  <xsl:param name="template"/>
  <xsl:param name="href">
    <xsl:choose>
      <xsl:when test="$template = 'cover'">
        <xsl:value-of select="$db.chunk.cover_basename"/>
      </xsl:when>
      <xsl:when test="$template = 'info'">
        <xsl:value-of select="$db.chunk.info_basename"/>
      </xsl:when>
      <xsl:when test="$template = 'index'">
        <xsl:value-of select="$db.chunk.index_basename"/>
      </xsl:when>
      <xsl:when test="$template = 'toc'">
        <xsl:value-of select="$db.chunk.toc_basename"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$node/@id"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$db.chunk.extension"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>
  <exsl:document href="{$href}">
    <xsl:call-template name="db.chunk.content">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="info" select="$info"/>
      <xsl:with-param name="template" select="$template"/>
      <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
    </xsl:call-template>
  </exsl:document>
</xsl:template>


<!-- == db.chunk.content =================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.chunk.content</name>
  <purpose>
    Create the content of a new output document
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The source element for the content
    </purpose>
  </parameter>
  <parameter>
    <name>info</name>
    <purpose>
      The info child element
    </purpose>
  </parameter>
  <parameter>
    <name>template</name>
    <purpose>
      The named template to call to create the content
    </purpose>
  </parameter>
  <parameter>
    <name>depth_of_chunk</name>
    <purpose>
      The depth of new output document
    </purpose>
  </parameter>
  <para>
    The <template>db.chunk.content</template> creates the actual content
    of a new output document.  It should generally only be called by
    <template>db.chunk</template>.
  </para>
  <para>
    The content can be generated either by calling a named template or by
    applying matched templates.  If <parameter>template</parameter> is set
    to a known value, the template with that name is called.  Otherwise,
    matched templates will be applied to <parameter>node</parameter> in
    the mode <mode>db.chunk.mode</mode>.  Since XSLT doesn't allow the
    name of a  called template to be an attribute value template, the
    value of <parameter>template</parameter> must come from a fixed
    vocabulary.  Currently, the supported values are
    <literal>'cover'</literal>, <literal>'info'</literal>,
    <literal>'toc'</literal>, and <literal>'index'</literal>.
  </para>
  <para>
    This template will always pass the <parameter>depth_in_chunk</parameter>
    and <parameter>depth_of_chunk</parameter> parameters with appropriate
    values to the templates it calls.  Additionally, the parameter
    <parameter>node</parameter> will be passed to all named templates.
  </para>
</template>

<xsl:template name="db.chunk.content">
  <xsl:param name="node" select="."/>
  <xsl:param name="template"/>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:choose>
    <xsl:when test="$template = 'cover'">
      <xsl:call-template name="cover">
        <xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="depth_in_chunk" select="0"/>
        <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$template = 'info'">
      <xsl:call-template name="info">
        <xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="info" select="$info"/>
        <xsl:with-param name="depth_in_chunk" select="0"/>
        <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$template = 'toc'">
      <xsl:call-template name="toc">
        <xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="depth_in_chunk" select="0"/>
        <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$template = 'index'">
      <xsl:call-template name="index">
        <xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="depth_in_chunk" select="0"/>
        <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="db.chunk.mode" select="$node">
        <xsl:with-param name="depth_in_chunk" select="0"/>
        <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- == db.chunk.depth-in-chunk ============================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.chunk.depth-in-chunk</name>
  <purpose>
    Determine the depth of an element in the containing chunk
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The element for which to determine the depth
    </purpose>
  </parameter>
</template>

<xsl:template name="db.chunk.depth-in-chunk">
  <xsl:param name="node" select="."/>
  <xsl:variable name="divs" select="count(
      $node/ancestor-or-self::appendix     | $node/ancestor-or-self::article      |
      $node/ancestor-or-self::book         | $node/ancestor-or-self::bibliography |
      $node/ancestor-or-self::chapter      | $node/ancestor-or-self::colophon     |
      $node/ancestor-or-self::glossary     | $node/ancestor-or-self::index        |
      $node/ancestor-or-self::part         | $node/ancestor-or-self::preface      |
      $node/ancestor-or-self::reference    | $node/ancestor-or-self::refentry     |
      $node/ancestor-or-self::refsect1     | $node/ancestor-or-self::refsect2     |
      $node/ancestor-or-self::refsect3     | $node/ancestor-or-self::refsection   |
      $node/ancestor-or-self::sect1        | $node/ancestor-or-self::sect2        |
      $node/ancestor-or-self::sect3        | $node/ancestor-or-self::sect4        |
      $node/ancestor-or-self::sect5        | $node/ancestor-or-self::section      |
      $node/ancestor-or-self::set          | $node/ancestor-or-self::setindex     |
      $node/ancestor-or-self::simplesect   )"/>
  <xsl:choose>
    <xsl:when test="$divs &lt; $db.chunk.max_depth">
      <xsl:value-of select="count($node/ancestor-or-self::*) - $divs"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="count($node/ancestor-or-self::*) - $db.chunk.max_depth"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- == db.chunk.depth-of-chunk ============================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.chunk.depth-of-chunk</name>
  <purpose>
    Determine the depth of the containing chunk in the document
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The element for which to determine the depth
    </purpose>
  </parameter>
</template>

<xsl:template name="db.chunk.depth-of-chunk">
  <xsl:param name="node" select="."/>
  <xsl:variable name="divs" select="count(
      $node/ancestor::appendix     | $node/ancestor::article      |
      $node/ancestor::book         | $node/ancestor::bibliography |
      $node/ancestor::chapter      | $node/ancestor::colophon     |
      $node/ancestor::glossary     | $node/ancestor::index        |
      $node/ancestor::part         | $node/ancestor::preface      |
      $node/ancestor::reference    | $node/ancestor::refentry     |
      $node/ancestor::refsect1     | $node/ancestor::refsect2     |
      $node/ancestor::refsect3     | $node/ancestor::refsection   |
      $node/ancestor::sect1        | $node/ancestor::sect2        |
      $node/ancestor::sect3        | $node/ancestor::sect4        |
      $node/ancestor::sect5        | $node/ancestor::section      |
      $node/ancestor::set          | $node/ancestor::setindex     |
      $node/ancestor::simplesect   )"/>
  <xsl:choose>
    <xsl:when test="$divs &lt; $db.chunk.max_depth">
      <xsl:value-of select="$divs"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$db.chunk.max_depth"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- == db.chunk.chunk-id ================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.chunk.chunk-id</name>
  <purpose>
    Determine the id of the containing chunk of an element
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The element for which to find the containing chunk id
    </purpose>
  </parameter>
  <parameter>
    <name>depth_in_chunk</name>
    <purpose>
      The depth of <parameter>node</parameter> in the containing chunk
    </purpose>
  </parameter>
</template>

<xsl:template name="db.chunk.chunk-id">
  <xsl:param name="node" select="."/>
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:value-of select="ancestor-or-self::*[$depth_in_chunk + 1]/@id"/>
</xsl:template>


<!-- == Matched Templates ================================================== -->

<xsl:template match="/">
  <xsl:choose>
    <xsl:when test="$db.chunk.chunk_top">
      <xsl:call-template name="db.chunk">
        <xsl:with-param name="node" select="*"/>
        <xsl:with-param name="depth_of_chunk" select="0"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="db.chunk.mode" select="*">
        <xsl:with-param name="depth_in_chunk" select="0"/>
        <xsl:with-param name="depth_of_chunk" select="0"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
