<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                xmlns:exsl="http://exslt.org/common"
                exclude-result-prefixes="doc"
                extension-element-prefixes="exsl"
                version="1.0">

<doc:title>Chunking</doc:title>


<!-- == db.chunk.max_depth ================================================= -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.chunk.max_depth</name>
  <description>
    The maximum depth for chunking sections
  </description>
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


<!-- == db.chunk.extension ================================================= -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.chunk.extension</name>
  <description>
    The default file extension for new output documents
  </description>
</parameter>

<xsl:param name="db.chunk.extension"/>


<!-- == db.chunk.chunk ===================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.chunk.chunk</name>
  <description>
    Create a new output document
  </description>
  <parameter>
    <name>node</name>
    <description>
      The source element for the output document
    </description>
  </parameter>
  <parameter>
    <name>template</name>
    <description>
      The named template to call to create the document
    </description>
  </parameter>
  <parameter>
    <name>href</name>
    <description>
      The name of the file for the new document
    </description>
  </parameter>
  <parameter>
    <name>depth_of_chunk</name>
    <description>
      The depth of new output document
    </description>
  </parameter>
  <para>
    The <template>db.chunk.chunk</template> template creates a new output
    document using the <xmltag>exsl:document</xmltag> extension element.
    This template calls <template>db.chunk.content</template> to create
    the content of the document, passing through all parameters.  This
    allows you to override the chunking mechanism without having to
    duplicate the content-generation code.
  </para>
</template>

<xsl:template name="db.chunk.chunk">
  <xsl:param name="node" select="."/>
  <xsl:param name="template"/>
  <xsl:param name="href" select="concat($node/@id, $db.chunk.extension)"/>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>
  <exsl:document href="{$href}">
    <xsl:call-template name="db.chunk.content">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="template" select="$template"/>
      <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
    </xsl:call-template>
  </exsl:document>
</xsl:template>


<!-- == db.chunk.content =================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.chunk.content</name>
  <description>
    Create the content of a new output document
  </description>
  <parameter>
    <name>node</name>
    <description>
      The source element for the content
    </description>
  </parameter>
  <parameter>
    <name>template</name>
    <description>
      The named template to call to create the content
    </description>
  </parameter>
  <parameter>
    <name>depth_of_chunk</name>
    <description>
      The depth of new output document
    </description>
  </parameter>
  <para>
    The <template>db.chunk.content</template> creates the actual content
    of a new output document.  It should generally only be called by
    <template>db.chunk.chunk</template>.
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
    values to the templates it calls.  Additionally, the
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
  <description>
    Determine the depth of an element in the containing chunk
  </description>
  <parameter>
    <name>node</name>
    <description>
      The element for which to determine the depth
    </description>
  </parameter>
</template>

<xsl:template name="db.chunk.depth-in-chunk">
  <xsl:param name="node" select="."/>
  <!-- FIXME -->
</xsl:template>


<!-- == db.chunk.depth-of-chunk ============================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.chunk.depth-of-chunk</name>
  <description>
    Determine the depth of the containing chunk in the document
  </description>
  <parameter>
    <name>node</name>
    <description>
      The element for which to determine the depth
    </description>
  </parameter>
</template>

<xsl:template name="db.chunk.depth-of-chunk">
  <xsl:param name="node" select="."/>
<!--
  <xsl:message><xsl:value-of select="local-name($node)"/></xsl:message>
-->
  <!-- FIXME -->
</xsl:template>

</xsl:stylesheet>
