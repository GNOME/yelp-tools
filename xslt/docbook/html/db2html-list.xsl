<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Lists</doc:title>


<!-- ======================================================================= -->
<!-- == itemizedlist ======================================================= -->

<!-- = itemizedlist = -->
<xsl:template match="itemizedlist">
  <div class="itemizedlist">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:apply-templates select="*[name(.) != 'listitem']"/>
    <ul>
      <xsl:if test="@mark">
        <xsl:attribute name="style">
          <xsl:text>list-style-type: </xsl:text>
          <xsl:choose>
            <xsl:when test="@mark = 'bullet'">disc</xsl:when>
            <xsl:when test="@mark = 'box'">square</xsl:when>
            <xsl:otherwise><xsl:value-of select="@mark"/></xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@spacing = 'compact'">
        <xsl:attribute name="compact">
          <xsl:value-of select="@spacing"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="listitem"/>
    </ul>
  </div>
</xsl:template>

<!-- = itemizedlist/listitem = -->
<xsl:template match="itemizedlist/listitem">
  <li>
    <xsl:if test="@override">
      <xsl:attribute name="style">
        <xsl:text>list-style-type: </xsl:text>
        <xsl:choose>
          <xsl:when test="@override = 'bullet'">disc</xsl:when>
          <xsl:when test="@override = 'box'">square</xsl:when>
          <xsl:otherwise><xsl:value-of select="@override"/></xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>
    <xsl:call-template name="db2html.anchor"/>
    <xsl:apply-templates/>
  </li>
</xsl:template>


<!-- ======================================================================= -->
<!-- == orderedlist ======================================================== -->


<!-- == db2html.orderedlist.start ========================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.orderedlist.start</name>
  <description>
    Determine the starting number for an ordered list
  </description>
  <parameter>
    <name>node</name>
    <description>
      The <xmltag>orderedlist</xmltag> element
    </description>
  </parameter>
</template>

<xsl:template name="orderedlist.start">
  <xsl:param name="node" select="."/>
  <xsl:choose>
    <xsl:when test="@continutation != 'continues'">1</xsl:when>
    <xsl:otherwise>
      <xsl:variable name="prevlist"
                    select="preceding::orderedlist[1]"/>
      <xsl:choose>
        <xsl:when test="count($prevlist) = 0">1</xsl:when>
        <xsl:otherwise>
          <xsl:variable name="prevlength" select="count($prevlist/listitem)"/>
          <xsl:variable name="prevstart">
            <xsl:call-template name="orderedlist.start">
              <xsl:with-param name="node" select="$prevlist"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:value-of select="$prevstart + $prevlength"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- = orderedlist = -->
<xsl:template match="orderedlist">
  <xsl:variable name="start">
    <xsl:choose>
      <xsl:when test="@continuation = 'continues'">
        <xsl:call-template name="orderedlist.start"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <div class="orderedlist">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:apply-templates select="*[name(.) != 'listitem']"/>
    <ol>
      <xsl:if test="@numeration">
        <xsl:attribute name="type">
          <xsl:choose>
            <xsl:when test="@numeration = 'arabic'">1</xsl:when>
            <xsl:when test="@numeration = 'loweralpha'">a</xsl:when>
            <xsl:when test="@numeration = 'lowerroman'">i</xsl:when>
            <xsl:when test="@numeration = 'upperalpha'">A</xsl:when>
            <xsl:when test="@numeration = 'upperroman'">I</xsl:when>
            <xsl:otherwise>1</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$start != '1'">
        <xsl:attribute name="start">
          <xsl:value-of select="$start"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@spacing = 'compact'">
        <xsl:attribute name="compact">
          <xsl:value-of select="@spacing"/>
        </xsl:attribute>
      </xsl:if>
      <!-- FIXME: @inheritnum -->
      <xsl:apply-templates select="listitem"/>
    </ol>
  </div>
</xsl:template>

<!-- = orderedlist/listitem = -->
<xsl:template match="orderedlist/listitem">
  <li>
    <xsl:if test="@override">
      <xsl:attribute name="value">
        <xsl:value-of select="@override"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:call-template name="db2html.anchor"/>
    <xsl:apply-templates/>
  </li>
</xsl:template>


<!-- ======================================================================= -->
<!-- == procedure ========================================================== -->

<!-- = procedure = -->
<xsl:template match="procedure">
  <div class="procedure">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:apply-templates select="*[name(.) != 'step']"/>
    <xsl:choose>
      <xsl:when test="count(step) = 1">
        <ul>
          <xsl:apply-templates select="step"/>
        </ul>
      </xsl:when>
      <xsl:otherwise>
        <ol>
          <xsl:apply-templates select="step"/>
        </ol>
      </xsl:otherwise>
    </xsl:choose>
  </div>	
</xsl:template>

<!-- FIXME: Do something with @performance -->

<!-- = step = -->
<xsl:template match="step">
  <li>
    <xsl:apply-templates/>
  </li>
</xsl:template>

<!-- = substeps = -->
<xsl:template match="substeps">
  <xsl:variable name="depth" select="count(ancestor::substeps)"/>
  <div class="substeps">
    <xsl:call-template name="db2html.anchor"/>
    <ol>
      <xsl:attribute name="type">
        <xsl:choose>
          <xsl:when test="$depth mod 3 = 0">a</xsl:when>
          <xsl:when test="$depth mod 3 = 1">i</xsl:when>
          <xsl:when test="$depth mod 3 = 2">1</xsl:when>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates/>
    </ol>
  </div>
</xsl:template>


<!-- ======================================================================= -->
<!-- == segmentedlist ====================================================== -->

<!-- FIXME: Implement tabular segmentedlists -->

<!-- = segmentedlist = -->
<xsl:template match="segmentedlist">
  <div class="segmentedlist">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:apply-templates select="title"/>
    <xsl:apply-templates select="seglistitem"/>
  </div>
</xsl:template>

<!-- = seglistitem = -->
<xsl:template match="seglistitem">
  <xsl:param name="position" select="count(preceding-sibling::seglistitem) + 1"/>
  <div class="seglistitem">
    <div>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="($position mod 2) = 1">
            <xsl:value-of select="'odd'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'even'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates/>
    </div>
  </div>
</xsl:template>

<!-- = segtitle = -->
<xsl:template match="segtitle">
  <b>
    <xsl:apply-templates/>
    <xsl:text>: </xsl:text>
  </b>
</xsl:template>

<!-- = seg = -->
<xsl:template match="seg">
  <xsl:variable name="position" select="count(preceding-sibling::seg) + 1"/>
  <p>
    <xsl:if test="$position = 1">
      <xsl:attribute name="class">
        <xsl:text>segfirst</xsl:text>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates select="../../segtitle[position() = $position]"/>
    <xsl:apply-templates/>
  </p>
</xsl:template>

<!-- ======================================================================= -->
<!-- == simplelist ========================================================= -->

<!--
<xsl:template match="simplelist">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template match="member">
	<xsl:call-template name="FIXME"/>
</xsl:template>
-->

<!-- ======================================================================= -->
<!-- == variablelist ======================================================= -->

<!--
<xsl:template match="variablelist">
	<div class="variablelist">
		<xsl:call-template name="db2html.anchor"/>
		<xsl:apply-templates select="*[name(.) != 'varlistentry']"/>
		<dl>
			<xsl:apply-templates select="varlistentry"/>
		</dl>
	</div>
</xsl:template>

<xsl:template match="varlistentry">
	<dt>
		<xsl:call-template name="db2html.anchor"/>
		<xsl:for-each select="term">
			<xsl:if test="position() != 1">
				<xsl:text>, </xsl:text>
			</xsl:if>
			<xsl:apply-templates select="."/>
		</xsl:for-each>
	</dt>
	<xsl:apply-templates select="listitem"/>
</xsl:template>

<xsl:template match="varlistentry/listitem">
	<dd>
		<xsl:call-template name="db2html.anchor"/>
		<xsl:apply-templates/>
	</dd>
</xsl:template>

<xsl:template match="term">
	<xsl:call-template name="inline"/>
</xsl:template>
-->

</xsl:stylesheet>
