<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Automatic Tables of Contents</doc:title>


<!-- == db2html.autotoc.label ============================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.autotoc.label</name>
  <description>
    Generate a label for an entry in a table of contents
  </description>
  <parameter>
    <name>node</name>
    <description>
      The element for which to generate a label
    </description>
  </parameter>
</template>

<xsl:template name="db2html.autotoc.label">
  <xsl:param name="node" select="."/>
  <xsl:apply-templates mode="db2html.autotoc.label.mode" select="$node"/>
</xsl:template>


<!-- == db2html.autotoc.label.mode ========================================= -->

<xsl:template mode="db2html.autotoc.label.mode" match="*">
  <!-- FIXME -->
  <span class="label">
    <xsl:call-template name="db2html.label"/>
    <xsl:text> </xsl:text>
  </span>
</xsl:template>


<!-- == db2html.autotoc ==================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.autotoc.flat</name>
  <description>
    Create a table of contents
  </description>
  <parameter>
    <name>node</name>
    <description>
      The node for which to create a table of contents
    </description>
  </parameter>
  <parameter>
    <name>info</name>
    <description>
      The info child element of <parameter>node</parameter>
    </description>
  </parameter>
  <parameter>
    <name>divisions</name>
    <description>
      The division-level child elements of <parameter>node</parameter>
    </description>
  </parameter>
  <parameter>
    <name>toc_depth</name>
    <description>
      How deep to create table of content entries
    </description>
  </parameter>
  <parameter>
    <name>depth_of_chunk</name>
    <description>
      The depth of the containing chunk in the document
    </description>
  </parameter>
</template>

<xsl:template name="db2html.autotoc">
  <xsl:param name="node" select="."/>
  <xsl:param name="info"/>
  <xsl:param name="divisions"/>
  <xsl:param name="toc_depth" select="1"/>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>
  <!-- FIXME: fix up, do stuff with $info, etc. -->
  <ul>
    <xsl:apply-templates mode="db2html.autotoc.mode" select="$divisions">
      <xsl:with-param name="toc_depth" select="$toc_depth - 1"/>
    </xsl:apply-templates>
  </ul>
</xsl:template>


<!-- == db2html.autotoc.mode =============================================== -->

<xsl:template mode="db2html.autotoc.mode" match="*">
  <xsl:param name="toc_depth" select="0"/>
  <!-- FIXME -->
  <li>
    <xsl:call-template name="db2html.autotoc.label"/>
    <xsl:apply-templates select="title/node()"/>
    <xsl:if test="$toc_depth &gt; 0">
      <xsl:call-template name="db2html.autotoc">
        <xsl:with-param name="toc_depth" select="$toc_depth"/>
      </xsl:call-template>
    </xsl:if>
  </li>
</xsl:template>

</xsl:stylesheet>
