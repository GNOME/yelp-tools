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
                xmlns:fxi="faux://www.w3.org/2001/XInclude"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                exclude-result-prefixes="doc fxi xi"
                version="1.0">

<xsl:namespace-alias stylesheet-prefix="fxi" result-prefix="xi"/>
<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<doc:title>Documenting XSLT Stylesheets</doc:title>


<!-- == xsldoc.id ========================================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>xsldoc.id</name>
  <purpose>
    The id of the top-level element in the output
  </purpose>
</parameter>

<xsl:param name="xsldoc.id"/>


<!-- == xsldoc.toplevel_element ============================================ -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>xsldoc.toplevel_element</name>
  <purpose>
    The top-level element in the generated DocBook
  </purpose>
  <para>
    The <parameter>xsldoc.toplevel_element</parameter> parameter defines
    the top-level element used in the generated DocBook.  Allowed values are
    <literal>'article'</literal>, <literal>'appendix'</literal>,
    <literal>'chapter'</literal>, and
    <literal>'section'</literal>.  The default is
    <literal>'section'</literal>.  This may also be set by the
    <xmltag role="xmlpi">xsldoc.toplevel_element</xmltag>
    processing instruction in the source RELAX-NG file.
  </para>
</parameter>

<xsl:param name="xsldoc.toplevel_element">
  <xsl:choose>
    <xsl:when test="processing-instruction('xsldoc.toplevel_element')">
      <xsl:value-of select="processing-instruction('xsldoc.toplevel_element')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'section'"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>


<!-- == xsldoc.checks ====================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>xsldoc.checks</name>
  <purpose>
    Perform some checks on the source file
  </purpose>
</template>

<xsl:template name="xsldoc.checks">
  <xsl:variable name="stylesheet" select="."/>

  <!-- Check for orphaned doc:parameter -->
  <xsl:for-each select="doc:parameter">
    <xsl:if test="not(following-sibling::*[1]/
                        self::xsl:param[@name = current()/doc:name])">
      <xsl:message>
        <xsl:value-of select="$xsldoc.id"/>
        <xsl:text>: Orphaned doc:parameter </xsl:text>
        <xsl:value-of select="doc:name"/>
      </xsl:message>
    </xsl:if>
  </xsl:for-each>

  <!-- Check for undocumented xsl:param -->
  <xsl:for-each select="xsl:param[not(@doc:private = 'true')]">
    <xsl:if test="not(preceding-sibling::*[1]/
                        self::doc:parameter[doc:name = current()/@name])">
      <xsl:message>
        <xsl:value-of select="$xsldoc.id"/>
        <xsl:text>: Undocumented xsl:param </xsl:text>
        <xsl:value-of select="@name"/>
      </xsl:message>
    </xsl:if>
  </xsl:for-each>

  <!-- Check for orphaned doc:template -->
  <xsl:for-each select="doc:template">
    <xsl:if test="not(following-sibling::*[1]/
                        self::xsl:template[@name = current()/doc:name])">
      <xsl:message>
        <xsl:value-of select="$xsldoc.id"/>
        <xsl:text>: Orphaned doc:template </xsl:text>
        <xsl:value-of select="doc:name"/>
      </xsl:message>
    </xsl:if>
  </xsl:for-each>

  <!-- Check for undocumented xsl:template[@name] -->
  <xsl:for-each select="xsl:template[@name][not(@doc:private = 'true')]">
    <xsl:if test="not(preceding-sibling::*[1]/
                        self::doc:template[doc:name = current()/@name])">
      <xsl:message>
        <xsl:value-of select="$xsldoc.id"/>
        <xsl:text>: Undocumented xsl:template </xsl:text>
        <xsl:value-of select="@name"/>
      </xsl:message>
    </xsl:if>
  </xsl:for-each>

  <!-- Check for orphaned doc:mode -->
  <xsl:for-each select="doc:mode">
    <xsl:if test="not($stylesheet/xsl:template[@mode = current()/doc:name])">
      <xsl:if test="not($stylesheet/xsl:template//
                          xsl:call-template[@mode = current()/doc:name])">
        <xsl:message>
          <xsl:value-of select="$xsldoc.id"/>
          <xsl:text>: Orphaned doc:mode </xsl:text>
          <xsl:value-of select="doc:name"/>
        </xsl:message>
      </xsl:if>
    </xsl:if>
  </xsl:for-each>

  <!-- Check for undocumented xsl:template/@mode -->
  <xsl:for-each select="xsl:template[@mode]">
    <xsl:if test="not(preceding-sibling::xsl:template[@mode = current()/@mode])">
      <xsl:if test="not(preceding-sibling::doc:mode[doc:name = current()/@mode])">
        <xsl:message>
          <xsl:value-of select="$xsldoc.id"/>
          <xsl:text>: Undocumented xsl:template/@mode </xsl:text>
          <xsl:value-of select="@mode"/>
        </xsl:message>
      </xsl:if>
    </xsl:if>
  </xsl:for-each>

  <!-- Check for undocumented xsl:call-template/@mode -->
  <xsl:for-each select="xsl:template//xsl:call-template[@mode]">
    <xsl:if test="not($stylesheet/doc:mode[doc:name = current()/@mode])">
      <xsl:message>
        <xsl:value-of select="$xsldoc.id"/>
        <xsl:text>: Undocumented xsl:call-template/@mode </xsl:text>
        <xsl:value-of select="@mode"/>
      </xsl:message>
    </xsl:if>
  </xsl:for-each>
</xsl:template>


<!-- == xsldoc.summary ===================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>xsldoc.summary</name>
  <purpose>
    Generate the Synopsis section
  </purpose>
</template>

<xsl:template name="xsldoc.summary">
  <xsl:variable name="parameterQ">
    <xsl:choose>
      <xsl:when test="doc:parameter">
        <xsl:text>1</xsl:text>
      </xsl:when>
      <xsl:when test="xsl:include[@doc:summary = 'true']">
        <xsl:for-each select="xsl:include[@doc:summary = 'true']">
          <xsl:if test="document(@href)/xsl:stylesheet/doc:parameter">
            <xsl:text>1</xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="templateQ">
    <xsl:choose>
      <xsl:when test="doc:template">
        <xsl:text>1</xsl:text>
      </xsl:when>
      <xsl:when test="xsl:include[@doc:summary = 'true']">
        <xsl:for-each select="xsl:include[@doc:summary = 'true']">
          <xsl:if test="document(@href)/xsl:stylesheet/doc:template">
            <xsl:text>1</xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="modeQ">
    <xsl:choose>
      <xsl:when test="doc:mode">
        <xsl:text>1</xsl:text>
      </xsl:when>
      <xsl:when test="xsl:include[@doc:summary = 'true']">
        <xsl:for-each select="xsl:include[@doc:summary = 'true']">
          <xsl:if test="document(@href)/xsl:stylesheet/doc:mode">
            <xsl:text>1</xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:if test="$parameterQ != ''">
    <variablelist>
      <title>Parameters</title>
      <xsl:apply-templates mode="xsldoc.summary.mode" select="doc:parameter"/>
      <xsl:for-each select="xsl:include[@doc:summary = 'true']">
        <xsl:apply-templates mode="xsldoc.summary.mode"
                             select="document(@href)/xsl:stylesheet/doc:parameter"/>
      </xsl:for-each>
    </variablelist>
  </xsl:if>
  <xsl:if test="$templateQ != ''">
    <variablelist>
      <title>Templates</title>
      <xsl:apply-templates mode="xsldoc.summary.mode" select="doc:template"/>
      <xsl:for-each select="xsl:include[@doc:summary = 'true']">
        <xsl:apply-templates mode="xsldoc.summary.mode"
                             select="document(@href)/xsl:stylesheet/doc:template"/>
      </xsl:for-each>
    </variablelist>
  </xsl:if>
  <xsl:if test="$modeQ != ''">
    <variablelist>
      <title>Modes</title>
      <xsl:apply-templates mode="xsldoc.summary.mode" select="doc:mode"/>
      <xsl:for-each select="xsl:include[@doc:summary = 'true']">
        <xsl:apply-templates mode="xsldoc.summary.mode"
                             select="document(@href)/xsl:stylesheet/doc:mode"/>
      </xsl:for-each>
    </variablelist>
  </xsl:if>
  <xsl:if test="$parameterQ = '' and $templateQ = '' and $modeQ = ''">
    <para>FIXME: Nothing to see here</para>
  </xsl:if>
  <xsl:apply-templates mode="xsldoc.refentry.mode" select="doc:parameter"/>
  <xsl:apply-templates mode="xsldoc.refentry.mode" select="doc:template"/>
  <xsl:apply-templates mode="xsldoc.refentry.mode" select="doc:mode"/>
</xsl:template>


<!-- == xsldoc.refentry.mode =============================================== -->

<mode xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>xsldoc.refentry.mode</name>
</mode>

<!-- = doc:mode = -->
<xsl:template mode="xsldoc.refentry.mode" match="doc:mode">
  <refentry id="mode_{doc:name}">
    <indexterm>
      <primary> 
        <xsl:value-of select="doc:name"/>
      </primary>
    </indexterm>
    <refnamediv>
      <refname>
        <xsl:value-of select="doc:name"/>
      </refname>
      <refpurpose>
        <xsl:apply-templates select="doc:purpose"/>
      </refpurpose>
    </refnamediv>
    <refsection>
      <title>Description</title>
      <xsl:if test="not(doc:description/node())">
        <para>This mode has no description</para>
      </xsl:if>
      <xsl:apply-templates mode="xsldoc.docbook.mode"
                           select="doc:description/node()"/>
    </refsection>
    <xsl:for-each select="doc:section">
      <refsection>
        <xsl:apply-templates mode="xsldoc.docbook.mode" select="*"/>
      </refsection>
    </xsl:for-each>
  </refentry>
</xsl:template>

<!-- = doc:parameter = -->
<xsl:template mode="xsldoc.refentry.mode" match="doc:parameter">
  <refentry id="param_{doc:name}">
    <indexterm>
      <primary> 
        <xsl:value-of select="doc:name"/>
      </primary>
    </indexterm>
    <refnamediv>
      <refname>
        <xsl:apply-templates mode="xsldoc.docbook.mode"
                             select="doc:name/node()"/>
      </refname>
      <refpurpose>
        <xsl:apply-templates mode="xsldoc.docbook.mode"
                             select="doc:purpose/node()"/>
      </refpurpose>
    </refnamediv>
    <refsection>
      <title>Description</title>
      <xsl:if test="not(doc:description/node())">
        <para>This parameter has no description</para>
      </xsl:if>
      <xsl:apply-templates mode="xsldoc.docbook.mode"
                           select="doc:description/node()"/>
    </refsection>
    <xsl:for-each select="doc:section">
      <refsection>
        <xsl:apply-templates mode="xsldoc.docbook.mode" select="*"/>
      </refsection>
    </xsl:for-each>
  </refentry>
</xsl:template>

<!-- = doc:template = -->
<xsl:template mode="xsldoc.refentry.mode" match="doc:template">
  <refentry id="template_{doc:name}">
    <indexterm>
      <primary> 
        <xsl:value-of select="doc:name"/>
      </primary>
    </indexterm>
    <refnamediv>
      <refname>
        <xsl:apply-templates mode="xsldoc.docbook.mode"
                             select="doc:name/node()"/>
      </refname>
      <refpurpose>
        <xsl:apply-templates mode="xsldoc.docbook.mode"
                             select="doc:purpose/node()"/>
      </refpurpose>
    </refnamediv>
    <refsection>
      <title>Parameters</title>
      <xsl:choose>
        <xsl:when test="doc:parameter">
          <variablelist>
            <xsl:for-each select="doc:parameter">
              <varlistentry>
                <term>
                  <parameter>
                    <xsl:apply-templates mode="xsldoc.docbook.mode"
                                         select="doc:name/node()"/>
                  </parameter>
                </term>
                <listitem>
                  <para>
                    <xsl:apply-templates mode="xsldoc.docbook.mode"
                                         select="doc:purpose/node()"/>
                  </para>
                  <xsl:apply-templates mode="xsldoc.docbook.mode"
                                       select="doc:description/node()"/>
                </listitem>
              </varlistentry>
            </xsl:for-each>
          </variablelist>
        </xsl:when>
        <xsl:otherwise>
          <para>This template has no parameters.</para>
        </xsl:otherwise>
      </xsl:choose>
    </refsection>
    <xsl:if test="doc:description">
      <refsection>
        <title>Description</title>
        <xsl:apply-templates mode="xsldoc.docbook.mode"
                             select="doc:description/node()"/>
      </refsection>
    </xsl:if>
    <xsl:for-each select="doc:section">
      <refsection>
        <xsl:apply-templates mode="xsldoc.docbook.mode" select="*"/>
      </refsection>
    </xsl:for-each>
  </refentry>
</xsl:template>


<!-- == xsldoc.summary.mode ================================================ -->

<mode xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>xsldoc.summary.mode</name>
</mode>

<!-- = doc:mode = -->
<xsl:template mode="xsldoc.summary.mode" match="doc:mode">
  <varlistentry>
    <term>
      <link linkend="mode_{doc:name}">
        <function role="mode">
          <xsl:apply-templates mode="xsldoc.docbook.mode"
                               select="doc:name/node()"/>
        </function>
      </link>
    </term>
    <listitem>
      <para>
        <xsl:apply-templates mode="xsldoc.docbook.mode"
                             select="doc:purpose"/>
      </para>
    </listitem>
  </varlistentry>
</xsl:template>

<!-- = doc:parameter = -->
<xsl:template mode="xsldoc.summary.mode" match="doc:parameter">
  <varlistentry>
    <term>
      <link linkend="param_{doc:name}">
        <parameter>
          <xsl:value-of select="doc:name"/>
        </parameter>
      </link>
    </term>
    <listitem>
      <para>
        <xsl:apply-templates select="doc:purpose"/>
      </para>
    </listitem>
  </varlistentry>
</xsl:template>

<!-- = doc:template = -->
<xsl:template mode="xsldoc.summary.mode" match="doc:template">
  <varlistentry>
    <term>
      <link linkend="template_{doc:name}">
        <function role="template">
          <xsl:value-of select="doc:name"/>
        </function>
      </link>
    </term>
    <listitem>
      <para>
        <xsl:apply-templates select="doc:purpose"/>
      </para>
    </listitem>
  </varlistentry>
</xsl:template>


<!-- == xsldoc.docbook.mode ================================================ -->

<mode xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>xsldoc.docbook.mode</name>
</mode>

<xsl:template mode="xsldoc.docbook.mode" match="doc:xmltag">
  <xsl:element name="sgmltag">
    <xsl:for-each select="attribute::*">
      <xsl:copy/>
    </xsl:for-each>
    <xsl:for-each select="* | text()">
      <xsl:apply-templates mode="xsldoc.docbook.mode" select="."/>
    </xsl:for-each>
  </xsl:element>
</xsl:template>

<xsl:template mode="xsldoc.docbook.mode" match="doc:*">
  <xsl:element name="{local-name(.)}">
    <xsl:for-each select="attribute::*">
      <xsl:copy/>
    </xsl:for-each>
    <xsl:for-each select="* | text()">
      <xsl:apply-templates mode="xsldoc.docbook.mode" select="."/>
    </xsl:for-each>
  </xsl:element>
</xsl:template>

<xsl:template mode="xsldoc.docbook.mode" match="*">
  <xsl:copy>
    <xsl:for-each select="node()">
      <xsl:apply-templates mode="xsldoc.docbook.mode" select="."/>
    </xsl:for-each>
  </xsl:copy>
</xsl:template>


<!-- == xsldoc.params ====================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>xsldoc.params</name>
  <purpose>
    Generate the Parameters section
  </purpose>
</template>

<xsl:template name="xsldoc.params">
  <xsl:variable name="params"
                select="ref:refname[following-sibling::xsl:*[1]/self::xsl:param]"/>
  <xsl:if test="$params">
    <section>
      <xsl:attribute name="id">
        <xsl:value-of select="concat($xsldoc.id, '-params')"/>
      </xsl:attribute>
      <title>Stylesheet Parameters</title>
      <xsl:for-each select="$params">
        <refentry>
          <refnamediv>
            <refname>
              <xsl:apply-templates/>
            </refname>
            <xsl:if test="following-sibling::ref:*[1]/self::ref:refpurpose">
              <refpurpose>
                <xsl:apply-templates select="following-sibling::ref:*[1]"/>
              </refpurpose>
            </xsl:if>
          </refnamediv>
        </refentry>
      </xsl:for-each>
    </section>
  </xsl:if>
</xsl:template>


<!-- == xsldoc.named ======================================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>xsldoc.named</name>
  <purpose>
    Generate the Named Templates section
  </purpose>
</template>

<xsl:template name="xsldoc.named">
  <xsl:variable name="named"
                select="ref:refname
                          [following-sibling::xsl:*[1]
                            /self::xsl:template[@name]]"/>
  <xsl:if test="$named">
    <section>
      <xsl:attribute name="id">
        <xsl:value-of select="concat($xsldoc.id, '-named')"/>
      </xsl:attribute>
      <title>Named Templates</title>
      <xsl:for-each select="$named">
        <refentry>
          <refnamediv>
            <refname>
              <xsl:apply-templates/>
            </refname>
            <xsl:if test="following-sibling::ref:*[1]/self::ref:refpurpose">
              <refpurpose>
                <xsl:apply-templates select="following-sibling::ref:*[1]"/>
              </refpurpose>
            </xsl:if>
          </refnamediv>
        </refentry>
      </xsl:for-each>
    </section>
  </xsl:if>
</xsl:template>


<!-- == xsldoc.includes ==================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>xsldoc.includes</name>
  <purpose>
    Include external files
  </purpose>
</template>

<xsl:template name="xsldoc.includes">
  <xsl:for-each select="xsl:include[@doc:include='true']">
    <fxi:include>
      <xsl:attribute name="href">
        <xsl:call-template name="_hrefify"/>
      </xsl:attribute>
    </fxi:include>
  </xsl:for-each>
</xsl:template>

<xsl:template name="_hrefify" doc:private="true">
  <xsl:param name="href" select="@href"/>
  <xsl:choose>
    <xsl:when test="contains($href, '/')">
      <xsl:call-template name="_hrefify">
        <xsl:with-param name="href" select="substring-after($href, '/')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="substring($href, string-length($href) - 3, 4) = '.xsl'">
      <xsl:value-of select="concat(substring($href, 1, string-length($href) - 3),
                                   'xml')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$href"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- == Matched Templates ================================================== -->

<!-- = /xsl:stylesheet = -->
<xsl:template match="/xsl:stylesheet">
  <xsl:variable name="toplevel_element">
    <xsl:choose>
      <xsl:when test="
                $xsldoc.toplevel_element = 'article'   or
                $xsldoc.toplevel_element = 'appendix'  or
                $xsldoc.toplevel_element = 'chapter'   or
                $xsldoc.toplevel_element = 'section'   ">
        <xsl:value-of select="$xsldoc.toplevel_element"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="yes">
          <xsl:text>Unsupported value of $xsldoc.toplevel_element: </xsl:text>
          <xsl:value-of select="$xsldoc.toplevel_element"/>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:element name="{$toplevel_element}" namespace="">
    <xsl:attribute name="id">
      <xsl:value-of select="concat($toplevel_element, '-', $xsldoc.id)"/>
    </xsl:attribute>
    <title>
      <xsl:apply-templates mode="xsldoc.docbook.mode"
                           select="doc:title[1]/node()"/>
    </title>
    <xsl:call-template name="xsldoc.checks"/>
    <xsl:call-template name="xsldoc.summary"/>
    <xsl:call-template name="xsldoc.includes"/>
    <!--
      <xsl:call-template name="xsldoc.params"/>
      <xsl:call-template name="xsldoc.named"/>
      <section>
      <xsl:attribute name="id">
      <xsl:value-of select="concat($xsldoc.id, '-matched')"/>
      </xsl:attribute>
      <title>Matched Templates</title>
      </section>
    -->
  </xsl:element>
</xsl:template>

</xsl:stylesheet>
