<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Class Synopses</doc:title>


<!-- == db2html.classsynopsis.language ===================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.classsynopsis.language</name>
  <description>
    The default language for <xmltag>classsynopsis</xmltag> elements
  </description>
</parameter>

<xsl:param name="db2html.classsynopsis.language">
  <xsl:choose>
    <xsl:when test="processing-instruction('db2html.classsynopsis.language')">
      <xsl:value-of
       select="processing-instruction('db2html.classsynopsis.language')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'cpp'"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>


<!-- == Matched Templates ================================================== -->

<!-- = *synopsis = -->
<xsl:template match="
              classsynopsis  | constructorsynopsis | fieldsynopsis |
              methodsynopsis | destructorsynopsis  ">
  <xsl:param name="language">
    <xsl:choose>
      <xsl:when test="@language">
        <xsl:value-of select="@language"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$db2html.classsynopsis.language"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <xsl:choose>
    <xsl:when test="$language = 'cpp'">
      <xsl:apply-templates mode="db2html.classsynopsis.cpp.mode" select="."/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>No information about the language '</xsl:text>
        <xsl:value-of select="$language"/>
        <xsl:text>' for classsynopsis.</xsl:text>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- = classsynopsisinfo = -->
<xsl:template match="classsynopsisinfo">
  <xsl:apply-templates/>
</xsl:template>


<!-- == db2html.classsynopsis.cpp.mode ===================================== -->

<!--
<xsl:template mode="db2html.classsynopsis.cpp.mode" match="*">
	<xsl:apply-templates select="."/>
</xsl:template>

<xsl:template mode="db2html.classsynopsis.cpp.mode" match="classsynopsis">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="db2html.classsynopsis.cpp.mode" match="classsynopsisinfo">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="db2html.classsynopsis.cpp.mode" match="classname">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="db2html.classsynopsis.cpp.mode" match="constructorsynopsis">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="db2html.classsynopsis.cpp.mode" match="destructorsynopsis">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="db2html.classsynopsis.cpp.mode" match="exceptionname">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="db2html.classsynopsis.cpp.mode" match="fieldsynopsis">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="db2html.classsynopsis.cpp.mode" match="initializer">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="db2html.classsynopsis.cpp.mode" match="interfacename">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="db2html.classsynopsis.cpp.mode" match="methodname">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="db2html.classsynopsis.cpp.mode" match="methodparam">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="db2html.classsynopsis.cpp.mode" match="methodsynopsis">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="db2html.classsynopsis.cpp.mode" match="modifier">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="db2html.classsynopsis.cpp.mode" match="ooclass">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="db2html.classsynopsis.cpp.mode" match="ooexception">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="db2html.classsynopsis.cpp.mode" match="oointerface">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="db2html.classsynopsis.cpp.mode" match="parameter">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="db2html.classsynopsis.cpp.mode" match="type">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="db2html.classsynopsis.cpp.mode" match="varname">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="db2html.classsynopsis.cpp.mode" match="void">
	<xsl:call-template name="FIXME"/>
</xsl:template>

-->
<!-- == classsynopsis.idl ================================================== -->
<!--
<xsl:template mode="classsynopsis.idl" match="*">
	<xsl:apply-templates select="."/>
</xsl:template>

<xsl:template mode="classsynopsis.idl" match="classsynopsis">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.idl" match="classsynopsisinfo">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.idl" match="classname">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.idl" match="constructorsynopsis">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.idl" match="destructorsynopsis">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.idl" match="exceptionname">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.idl" match="fieldsynopsis">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.idl" match="initializer">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.idl" match="interfacename">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.idl" match="methodname">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.idl" match="methodparam">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.idl" match="methodsynopsis">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.idl" match="modifier">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.idl" match="ooclass">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.idl" match="ooexception">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.idl" match="oointerface">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.idl" match="parameter">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.idl" match="type">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.idl" match="varname">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.idl" match="void">
	<xsl:call-template name="FIXME"/>
</xsl:template>
-->

<!-- == classsynopsis.java ================================================= -->
<!--
<xsl:template mode="classsynopsis.java" match="*">
	<xsl:apply-templates select="."/>
</xsl:template>

<xsl:template mode="classsynopsis.java" match="classsynopsis">
	<div class="{name(.)}"><pre class="java">
		<xsl:choose>
			<xsl:when test="@class = 'interface'">
				<xsl:call-template name="FIXME"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="ooclass[1]/modifier">
					<xsl:apply-templates mode="classsynopsis.java" select="."/>
					<xsl:text> </xsl:text>
				</xsl:for-each>
				<xsl:text>class </xsl:text>
				<xsl:apply-templates mode="classsynopsis.java" select="ooclass[1]"/>
				<xsl:if test="ooclass[position() &gt; 1]">
					<xsl:text> extends</xsl:text>
					<xsl:for-each select="ooclass[position() &gt; 1]">
						<xsl:text> </xsl:text>
						<xsl:apply-templates mode="classsynopsis.java" select="."/>
						<xsl:if test="following-sibling::ooclass">
							<xsl:text>,</xsl:text>
						</xsl:if>
					</xsl:for-each>
					<xsl:if test="oointerface|ooexception">
						<xsl:value-of select="concat($newline, $tab_java)"/>
					</xsl:if>
				</xsl:if>
				<xsl:if test="oointerface">
					<xsl:text>implements</xsl:text>
					<xsl:for-each select="oointerface">
						<xsl:text> </xsl:text>
						<xsl:apply-templates mode="classsynopsis.java" select="."/>
						<xsl:if test="following-sibling::oointerface">
							<xsl:text>,</xsl:text>
						</xsl:if>
					</xsl:for-each>
					<xsl:if test="ooexception">
						<xsl:value-of select="concat($newline, $tab_java)"/>
					</xsl:if>
				</xsl:if>
				<xsl:if test="ooexception">
					<xsl:text>throws</xsl:text>
					<xsl:for-each select="ooexception">
						<xsl:text> </xsl:text>
						<xsl:apply-templates mode="classsynopsis.java" select="."/>
						<xsl:if test="following-sibling::ooexception">
							<xsl:text>,</xsl:text>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$newline"/>
		<xsl:text>{</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:apply-templates mode="classsynopsis.java" select="
			constructorsynopsis	| destructorsynopsis	| fieldsynopsis	|
			methodsynopsis			| classsynopsis		"/>
		<xsl:text>}</xsl:text>
	</pre></div>
</xsl:template>

<xsl:template mode="classsynopsis.java" match="classsynopsisinfo">
	<xsl:apply-templates mode="classsynopsis.java"/>
</xsl:template>

<xsl:template mode="classsynopsis.java" match="constructorsynopsis">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.java" match="destructorsynopsis">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.java" match="fieldsynopsis">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.java" match="initializer">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.java" match="methodparam">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.java" match="methodsynopsis">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.java" match="
		classname		| exceptionname	| interfacename	| methodname	|
		modifier			| parameter			| type				| varname		">
	<span class="{name(.)}">
		<xsl:apply-templates mode="classsynopsis.java"/>
	</span>
</xsl:template>

<xsl:template mode="classsynopsis.java" match="ooclass">
	<span class="{name(.)}">
		<xsl:apply-templates mode="classsynopsis.java" select="classname"/>
	</span>
</xsl:template>

<xsl:template mode="classsynopsis.java" match="oointerface">
	<span class="{name(.)}">
		<xsl:apply-templates mode="classsynopsis.java" select="interfacename"/>
	</span>
</xsl:template>

<xsl:template mode="classsynopsis.java" match="ooexception">
	<span class="{name(.)}">
		<xsl:apply-templates mode="classsynopsis.java" select="exceptionname"/>
	</span>
</xsl:template>

<xsl:template mode="classsynopsis.java" match="void">
	<span class="{name(.)}">void</span>
</xsl:template>
-->

<!-- == classsynopsis.python ================================================= -->
<!--
<xsl:template mode="classsynopsis.python" match="*">
	<xsl:apply-templates select="."/>
</xsl:template>

<xsl:template mode="classsynopsis.python" match="classsynopsis">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.python" match="classsynopsisinfo">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.python" match="classname">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.python" match="constructorsynopsis">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.python" match="destructorsynopsis">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.python" match="exceptionname">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.python" match="fieldsynopsis">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.python" match="initializer">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.python" match="interfacename">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.python" match="methodname">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.python" match="methodparam">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.python" match="methodsynopsis">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.python" match="modifier">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.python" match="ooclass">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.python" match="ooexception">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.python" match="oointerface">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.python" match="parameter">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.python" match="type">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.python" match="varname">
	<xsl:call-template name="FIXME"/>
</xsl:template>

<xsl:template mode="classsynopsis.python" match="void">
	<xsl:call-template name="FIXME"/>
</xsl:template>
-->

</xsl:stylesheet>
