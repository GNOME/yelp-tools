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
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                exclude-result-prefixes="doc"
                version="1.0">

<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<doc:title>Documenting RELAX NG Schemes</doc:title>


<!-- == rngdoc.id ========================================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>rngdoc.id</name>
  <purpose>
    The id of the top-level element in the output
  </purpose>
</parameter>

<xsl:param name="rngdoc.id"/>


<!-- == rngdoc.toplevel_element ============================================ -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>rngdoc.toplevel_element</name>
  <purpose>
    The top-level element in the generated DocBook
  </purpose>
  <para>
    The <parameter>rngdoc.toplevel_element</parameter> parameter defines the
    top-level element used in the generated DocBook.  Allowed values are
    <literal>'article'</literal>, <literal>'appendix'</literal>,
    <literal>'chapter'</literal>, and <literal>'section'</literal>.
    The default is <literal>'section'</literal>.  This may also be set by
    the <xmltag role="xmlpi">rngdoc.toplevel_element</xmltag> processing
    instruction in the source RELAX-NG file.
  </para>
</parameter>

<xsl:param name="rngdoc.toplevel_element">
  <xsl:choose>
    <xsl:when test="processing-instruction('rngdoc.toplevel_element')">
      <xsl:value-of select="processing-instruction('rngdoc.toplevel_element')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'section'"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>


<!-- == Matched Templates == -->

<!-- = /rng:grammar = -->
<xsl:template match="/rng:grammar">
  <xsl:variable name="toplevel_element">
    <xsl:choose>
      <xsl:when test="
		$rngdoc.toplevel_element = 'article'   or
		$rngdoc.toplevel_element = 'appendix'  or
		$rngdoc.toplevel_element = 'chapter'   or
		$rngdoc.toplevel_element = 'reference' or
		$rngdoc.toplevel_element = 'section'   ">
	<xsl:value-of select="$rngdoc.toplevel_element"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:message terminate="yes">
	  <xsl:text>Unsupported value of $rngdoc.toplevel_element: </xsl:text>
	  <xsl:value-of select="$rngdoc.toplevel_element"/>
	</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:element name="{$toplevel_element}">
    <xsl:apply-templates select="ref:title"/>
    <xsl:apply-templates select="rng:start"/>
    <xsl:apply-templates select="rng:define"/>
    <xsl:apply-templates select="rng:div"/>
  </xsl:element>
</xsl:template>

<!-- = rng:div = -->
<xsl:template match="rng:div">
  <section>
    <xsl:if test="@ref:role">
      <xsl:attribute name="role">
	<xsl:value-of select="@ref:role"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates select="ref:title"/>
    <xsl:apply-templates select="ref:subtitle"/>
    <xsl:apply-templates mode="refentry.mode" select="rng:start"/>
    <xsl:apply-templates mode="refentry.mode" select="rng:define"/>
    <xsl:apply-templates mode="refentry.mode" select="rng:div"/>
  </section>
</xsl:template>

<!-- = rng:define = -->
<xsl:template mode="refentry.mode" match="rng:define">
  <xsl:choose>
    <xsl:when test="ref:refname">
      <refentry id="{ref:refname}" role="define">
	<refnamediv>
	  <xsl:apply-templates select="ref:refname"/>
	  <xsl:apply-templates select="ref:refpurpose"/>
	</refnamediv>
	<xsl:apply-templates select="
	    ref:*[local-name(.) != 'refname' and local-name(.) != 'refpurpose']"/>
      </refentry>
    </xsl:when>
    <xsl:otherwise>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
      
<!-- = rng:element = -->
<xsl:template mode="refentry.mode" match="rng:element">
</xsl:template>

<!-- = rng:include = -->
<xsl:template match="rng:include">
</xsl:template>

<!-- = ref:title = -->
<xsl:template match="ref:title">
  <title>
    <xsl:apply-templates/>
  </title>
</xsl:template>

<!-- = ref:subtitle = -->
<xsl:template match="ref:subtitle">
  <title>
    <xsl:apply-templates/>
  </title>
</xsl:template>

<!-- = ref:refname = -->
<xsl:template match="ref:refname">
  <refname>
    <xsl:apply-templates/>
  </refname>
</xsl:template>

<!-- = ref:refpurpose = -->
<xsl:template match="ref:refpurpose">
  <refentry>
    <xsl:apply-templates/>
  </refentry>
</xsl:template>

</xsl:stylesheet>
