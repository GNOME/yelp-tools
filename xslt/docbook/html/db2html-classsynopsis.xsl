<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Class Synopses</doc:title>


<!-- == Variables ========================================================== -->
<!-- == (possible candidates for params) == -->

<xsl:variable name="cpp.tab" select="'&#160;&#160;&#160;&#160;'"/>
<xsl:variable name="python.tab" select="'&#160;&#160;&#160;&#160;'"/>


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

  <div class="{local-name(.)}">
    <xsl:call-template name="db2html.anchor"/>
    <pre class="$language">
      <xsl:choose>
        <xsl:when test="$language = 'cpp'">
          <xsl:apply-templates mode="db2html.class.cpp.mode" select="."/>
        </xsl:when>
        <xsl:when test="$language = 'python'">
          <xsl:apply-templates mode="db2html.class.cpp.mode" select="."/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>
            <xsl:text>No information about the language '</xsl:text>
            <xsl:value-of select="$language"/>
            <xsl:text>' for classsynopsis.</xsl:text>
          </xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </pre>
  </div>
</xsl:template>

<!-- = classsynopsisinfo = -->
<xsl:template match="classsynopsisinfo">
  <xsl:apply-templates/>
</xsl:template>

<!-- = ooclass = -->
<xsl:template match="ooclass">
  <span class="ooclass" style="font-family: monospace;">
    <xsl:for-each select="modifier | classname">
      <xsl:if test="position() != 1">
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </span>
</xsl:template>

<!-- = ooexception = -->
<xsl:template match="ooexception">
  <span class="ooexception" style="font-family: monospace;">
    <xsl:for-each select="modifier | exceptionname">
      <xsl:if test="position() != 1">
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </span>
</xsl:template>

<!-- = oointerface = -->
<xsl:template match="oointerface">
  <span class="oointerface" style="font-family: monospace;">
    <xsl:for-each select="modifier | interfacename">
      <xsl:if test="position() != 1">
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </span>
</xsl:template>

<!-- = methodparam/parameter = -->
<xsl:template match="methodparam/parameter">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="mono" select="true()"/>
    <xsl:with-param name="italic" select="true()"/>
  </xsl:call-template>
</xsl:template>


<!-- == class.cpp.modifier ================================================= -->

<xsl:template name="class.cpp.modifier" doc:private="true">
  <!-- For C++, we expect the first modifier to be the visibility -->
  <xsl:if test="../self::classsynopsis">
    <xsl:variable name="pres" select="
                  preceding-sibling::constructorsynopsis |
                  preceding-sibling::destructorsynopsis  |
                  preceding-sibling::fieldsynopsis       |
                  preceding-sibling::methodsynopsis      "/>
    <xsl:if test="not($pres[modifier][last()][modifier[1] = current()/modifier[1]])">
      <xsl:if test="$pres">
        <xsl:text>&#x000A;</xsl:text>
      </xsl:if>
      <xsl:apply-templates select="modifier[1]"/>
      <xsl:text>:&#x000A;</xsl:text>
    </xsl:if>
  </xsl:if>
</xsl:template>


<!-- == db2html.class.cpp.mode ============================================= -->

<xsl:template mode="db2html.class.cpp.mode" match="*">
  <xsl:apply-templates select="."/>
</xsl:template>

<!-- = classsynopsis = -->
<xsl:template mode="db2html.class.cpp.mode" match="classsynopsis">
  <xsl:if test="@class = 'class' or not(@class)">
    <span class="ooclass">
      <xsl:for-each select="ooclass[1]/modifier">
        <xsl:if test="position() != 1">
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:apply-templates mode="db2html.class.cpp.mode" select="."/>
      </xsl:for-each>
      <xsl:text> class </xsl:text>
      <xsl:apply-templates mode="db2html.class.cpp.mode"
                           select="ooclass[1]/classname"/>
    </span>
    <xsl:if test="ooclass[2]">
      <xsl:text> : </xsl:text>
      <xsl:for-each select="ooclass[position() != 1]">
        <xsl:if test="position() != 1">
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:apply-templates mode="db2html.class.cpp.mode" select="."/>
      </xsl:for-each>
    </xsl:if>
    <xsl:text>&#x000A;{&#x000A;</xsl:text>
    <xsl:apply-templates mode="db2html.class.cpp.mode"
                         select="
                           classsynopsisinfo   |
                           constructorsynopsis | destructorsynopsis |
                           fieldsynopsis       | methodsynopsis     "/>
    <xsl:text>}&#x000A;</xsl:text>
  </xsl:if>
</xsl:template>

<!-- = constructorsynopsis = -->
<xsl:template mode="db2html.class.cpp.mode" match="constructorsynopsis">
  <xsl:call-template name="class.cpp.modifier"/>
  <xsl:value-of select="$cpp.tab"/>
  <xsl:for-each select="modifier[position() != 1]">
    <xsl:if test="position() != 1">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.cpp.mode" select="."/>
  </xsl:for-each>
  <xsl:if test="modifier[2]">
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="methodname">
      <xsl:apply-templates mode="db2html.class.cpp.mode" select="methodname"/>
    </xsl:when>
    <xsl:when test="../self::classsynopsis[ooclass]">
      <span class="methodname">
        <xsl:value-of select="../ooclass/classname"/>
      </span>
    </xsl:when>
  </xsl:choose>
  <xsl:text>(</xsl:text>
  <xsl:for-each select="methodparam">
    <xsl:if test="position() != 1">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.cpp.mode" select="."/>
  </xsl:for-each>
  <xsl:text>);&#x000A;</xsl:text>
</xsl:template>

<!-- = destructorsynopsis = -->
<xsl:template mode="db2html.class.cpp.mode" match="destructorsynopsis">
  <xsl:call-template name="class.cpp.modifier"/>
  <xsl:value-of select="$cpp.tab"/>
  <xsl:for-each select="modifier[position() != 1]">
    <xsl:if test="position() != 1">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.cpp.mode" select="."/>
  </xsl:for-each>
  <xsl:if test="modifier[2]">
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="methodname">
      <xsl:apply-templates mode="db2html.class.cpp.mode" select="methodname"/>
    </xsl:when>
    <xsl:when test="../self::classsynopsis[ooclass]">
      <span class="methodname">
        <xsl:text>~</xsl:text>
        <xsl:value-of select="../ooclass/classname"/>
      </span>
    </xsl:when>
  </xsl:choose>
  <xsl:text>(</xsl:text>
  <xsl:for-each select="methodparam">
    <!-- FIXME: should we do each methodparam on its own line? -->
    <xsl:if test="position() != 1">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.cpp.mode" select="."/>
  </xsl:for-each>
  <xsl:text>);&#x000A;</xsl:text>
</xsl:template>

<!-- = fieldsynopsis = -->
<xsl:template mode="db2html.class.cpp.mode" match="fieldsynopsis">
  <xsl:call-template name="class.cpp.modifier"/>
  <xsl:value-of select="$cpp.tab"/>
  <xsl:for-each select="modifier[position() != 1]">
    <xsl:if test="position() != 1">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.cpp.mode" select="."/>
  </xsl:for-each>
  <xsl:if test="modifier[2]">
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:if test="type">
    <xsl:apply-templates mode="db2html.class.cpp.mode" select="type"/>
  </xsl:if>
  <xsl:if test="modifier[2] or type">
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="db2html.class.cpp.mode" select="varname"/>
  <xsl:if test="initializer">
    <xsl:text> = </xsl:text>
    <xsl:apply-templates mode="db2html.class.cpp.mode" select="initializer"/>
  </xsl:if>
  <xsl:text>;&#x000A;</xsl:text>
</xsl:template>

<!-- = methodparam = -->
<xsl:template mode="db2html.class.cpp.mode" match="methodparam">
  <span class="methodparam">
    <xsl:for-each select="*">
      <xsl:if test="position() != 1">
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:apply-templates mode="db2html.class.cpp.mode" select="."/>
    </xsl:for-each>
  </span>
</xsl:template>

<!-- = methodsynopsis = -->
<xsl:template mode="db2html.class.cpp.mode" match="methodsynopsis">
  <xsl:call-template name="class.cpp.modifier"/>
  <xsl:value-of select="$cpp.tab"/>
  <!-- Parens for document order -->
  <xsl:for-each select="(methodname/preceding-sibling::modifier)[position() != 1]">
    <xsl:if test="position() != 1">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.cpp.mode" select="."/>
  </xsl:for-each>
  <xsl:if test="methodname/preceding-sibling::modifier[2]">
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="db2html.class.cpp.mode" select="type | void"/>
  <xsl:text> </xsl:text>
  <xsl:apply-templates mode="db2html.class.cpp.mode" select="methodname"/>
  <xsl:text>(</xsl:text>
  <xsl:for-each select="methodparam">
    <xsl:if test="position() != 1">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.cpp.mode" select="."/>
  </xsl:for-each>
  <xsl:text>);&#x000A;</xsl:text>
</xsl:template>


<!-- == db2html.class.python.mode ========================================== -->

<xsl:template mode="db2html.class.python.mode" match="*">
  <xsl:apply-templates select="."/>
</xsl:template>

<!-- = classsynopsis = -->
<!--
<xsl:template mode="db2html.class.python.mode" match="classsynopsis">
  <xsl:if test="@class = 'class' or not(@class)">
    <span class="ooclass">
      <xsl:for-each select="ooclass[1]/modifier">
        <xsl:if test="position() != 1">
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:apply-templates mode="db2html.class.python.mode" select="."/>
      </xsl:for-each>
      <xsl:text> class </xsl:text>
      <xsl:apply-templates mode="db2html.class.python.mode"
                           select="ooclass[1]/classname"/>
    </span>
    <xsl:if test="ooclass[2]">
      <xsl:text> : </xsl:text>
      <xsl:for-each select="ooclass[position() != 1]">
        <xsl:if test="position() != 1">
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:apply-templates mode="db2html.class.python.mode" select="."/>
      </xsl:for-each>
    </xsl:if>
    <xsl:text>&#x000A;{&#x000A;</xsl:text>
    <xsl:apply-templates mode="db2html.class.python.mode"
                         select="
                           classsynopsisinfo   |
                           constructorsynopsis | destructorsynopsis |
                           fieldsynopsis       | methodsynopsis     "/>
    <xsl:text>}&#x000A;</xsl:text>
  </xsl:if>
</xsl:template>
-->

<!-- = constructorsynopsis = -->
<!--
<xsl:template mode="db2html.class.python.mode" match="constructorsynopsis">
  <xsl:call-template name="class.python.modifier"/>
  <xsl:value-of select="$cpp.tab"/>
  <xsl:for-each select="modifier[position() != 1]">
    <xsl:if test="position() != 1">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.python.mode" select="."/>
  </xsl:for-each>
  <xsl:if test="modifier[2]">
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="methodname">
      <xsl:apply-templates mode="db2html.class.python.mode" select="methodname"/>
    </xsl:when>
    <xsl:when test="../self::classsynopsis[ooclass]">
      <span class="methodname">
        <xsl:value-of select="../ooclass/classname"/>
      </span>
    </xsl:when>
  </xsl:choose>
  <xsl:text>(</xsl:text>
  <xsl:for-each select="methodparam">
    <xsl:if test="position() != 1">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.python.mode" select="."/>
  </xsl:for-each>
  <xsl:text>);&#x000A;</xsl:text>
</xsl:template>
-->

<!-- = destructorsynopsis = -->
<!--
<xsl:template mode="db2html.class.python.mode" match="destructorsynopsis">
  <xsl:call-template name="class.python.modifier"/>
  <xsl:value-of select="$cpp.tab"/>
  <xsl:for-each select="modifier[position() != 1]">
    <xsl:if test="position() != 1">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.python.mode" select="."/>
  </xsl:for-each>
  <xsl:if test="modifier[2]">
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="methodname">
      <xsl:apply-templates mode="db2html.class.python.mode" select="methodname"/>
    </xsl:when>
    <xsl:when test="../self::classsynopsis[ooclass]">
      <span class="methodname">
        <xsl:text>~</xsl:text>
        <xsl:value-of select="../ooclass/classname"/>
      </span>
    </xsl:when>
  </xsl:choose>
  <xsl:text>(</xsl:text>
  <xsl:for-each select="methodparam">
    <xsl:if test="position() != 1">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.python.mode" select="."/>
  </xsl:for-each>
  <xsl:text>);&#x000A;</xsl:text>
</xsl:template>
-->

<!-- = fieldsynopsis = -->
<!--
<xsl:template mode="db2html.class.python.mode" match="fieldsynopsis">
  <xsl:call-template name="class.python.modifier"/>
  <xsl:value-of select="$cpp.tab"/>
  <xsl:for-each select="modifier[position() != 1]">
    <xsl:if test="position() != 1">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.python.mode" select="."/>
  </xsl:for-each>
  <xsl:if test="modifier[2]">
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:if test="type">
    <xsl:apply-templates mode="db2html.class.python.mode" select="type"/>
  </xsl:if>
  <xsl:if test="modifier[2] or type">
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="db2html.class.python.mode" select="varname"/>
  <xsl:if test="initializer">
    <xsl:text> = </xsl:text>
    <xsl:apply-templates mode="db2html.class.python.mode" select="initializer"/>
  </xsl:if>
  <xsl:text>;&#x000A;</xsl:text>
</xsl:template>
-->

<!-- = methodparam = -->
<!--
<xsl:template mode="db2html.class.python.mode" match="methodparam">
  <span class="methodparam">
    <xsl:for-each select="*">
      <xsl:if test="position() != 1">
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:apply-templates mode="db2html.class.python.mode" select="."/>
    </xsl:for-each>
  </span>
</xsl:template>
-->

<!-- = methodsynopsis = -->
<!--
<xsl:template mode="db2html.class.python.mode" match="methodsynopsis">
  <xsl:call-template name="class.python.modifier"/>
  <xsl:value-of select="$cpp.tab"/>
  <xsl:for-each select="modifier[position() != 1]">
    <xsl:if test="position() != 1">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.python.mode" select="."/>
  </xsl:for-each>
  <xsl:if test="modifier[2]">
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="db2html.class.python.mode" select="type | void"/>
  <xsl:text> </xsl:text>
  <xsl:apply-templates mode="db2html.class.python.mode" select="methodname"/>
  <xsl:text>(</xsl:text>
  <xsl:for-each select="methodparam">
    <xsl:if test="position() != 1">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.python.mode" select="."/>
  </xsl:for-each>
  <xsl:text>);&#x000A;</xsl:text>
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

</xsl:stylesheet>
