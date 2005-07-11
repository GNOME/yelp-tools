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
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Automatic Tables of Contents</doc:title>


<!-- == db2html.autotoc.css ================================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.autotoc.css</name>
  <purpose>
    Create CSS for tables of contents
  </purpose>
</template>

<xsl:template name="db2html.autotoc.css">
  <xsl:text>
    div[class~="autotoc"] { margin-left: 2em; padding: 0em; }
    div[class~="autotoc"] ul { margin-left: 0em; padding-left: 0em; }
    div[class~="autotoc"] ul li {
      margin-right: 0em;
      padding: 0em;
      list-style-type: none;
    }
  </xsl:text>
</xsl:template>


<!-- == db2html.autotoc ==================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.autotoc.flat</name>
  <purpose>
    Create a table of contents
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The node for which to create a table of contents
    </purpose>
  </parameter>
  <parameter>
    <name>info</name>
    <purpose>
      The info child element of <parameter>node</parameter>
    </purpose>
  </parameter>
  <parameter>
    <name>divisions</name>
    <purpose>
      The division-level child elements of <parameter>node</parameter>
    </purpose>
  </parameter>
  <parameter>
    <name>toc_depth</name>
    <purpose>
      How deep to create table of content entries
    </purpose>
  </parameter>
  <parameter>
    <name>depth_of_chunk</name>
    <purpose>
      The depth of the containing chunk in the document
    </purpose>
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
  <div class="autotoc">
    <ul>
      <xsl:apply-templates mode="db2html.autotoc.mode" select="$divisions">
        <xsl:with-param name="toc_depth" select="$toc_depth - 1"/>
      </xsl:apply-templates>
    </ul>
  </div>
</xsl:template>


<!-- == db2html.autotoc.mode =============================================== -->

<xsl:template mode="db2html.autotoc.mode" match="*">
  <xsl:param name="toc_depth" select="0"/>
  <li>
    <span class="label">
      <xsl:call-template name="db.label">
        <xsl:with-param name="node" select="."/>
        <xsl:with-param name="role" select="'li'"/>
      </xsl:call-template>
    </span>
    <xsl:call-template name="db2html.xref">
      <xsl:with-param name="linkend" select="@id"/>
      <xsl:with-param name="target" select="."/>
      <xsl:with-param name="xrefstyle" select="'role:title'"/>
    </xsl:call-template>
    <xsl:if test="$toc_depth &gt; 0">
      <xsl:call-template name="db2html.autotoc">
        <xsl:with-param name="toc_depth" select="$toc_depth"/>
        <xsl:with-param name="divisions"
                        select="*[contains($db.chunk.chunks_,
                                    concat(' ', local-name(.), ' '))]"/>
      </xsl:call-template>
    </xsl:if>
  </li>
</xsl:template>

<!-- = refentry = -->
<xsl:template mode="db2html.autotoc.mode" match="refentry">
  <xsl:param name="toc_depth" select="0"/>
  <li>
    <xsl:call-template name="db2html.xref">
      <xsl:with-param name="linkend" select="@id"/>
      <xsl:with-param name="target" select="."/>
      <xsl:with-param name="xrefstyle" select="'role:title'"/>
    </xsl:call-template>
    <xsl:if test="refnamediv/refpurpose">
      <!-- FIXME: I18N -->
      <xsl:text> — </xsl:text>
      <xsl:apply-templates select="refnamediv/refpurpose[1]"/>
    </xsl:if>
  </li>
</xsl:template>

</xsl:stylesheet>
