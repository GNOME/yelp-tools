<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:ref="http://www.gnome.org/~shaunm/mallard/reference"
		exclude-result-prefixes="ref"
                version="1.0">

<ref:title>Command Synopses</ref:title>

<!-- == db2html.cmdsynopsis.sepchar == -->

<ref:refname>db2html.cmdsynopsis.sepchar</ref:refname>
<ref:refpurpose>
  The default value for the <ref:parameter>sepchar</ref:parameter> paramter
</ref:refpurpose>

<xsl:param name="db2html.cmdsynopsis.sepchar" select="' '"/>


<!-- == db2html.arg.choice == -->

<ref:refname>db2html.arg.choice</ref:refname>
<ref:refpurpose>
  The default value of the <ref:parameter>choice</ref:parameter> paramter
  for <ref:xmltag>arg</ref:xmltag> elements
</ref:refpurpose>

<xsl:param name="db2html.arg.choice" select="'opt'"/>


<!-- == db2html.arg.rep == -->

<ref:refname>db2html.arg.rep</ref:refname>
<ref:refpurpose>
  The default value of the <ref:parameter>rep</ref:parameter> paramter
  for <ref:xmltag>arg</ref:xmltag> elements
</ref:refpurpose>

<xsl:param name="db2html.arg.rep" select="'norepeat'"/>


<!-- == db2html.group.choice == -->

<ref:refname>db2html.group.choice</ref:refname>
<ref:refpurpose>
  The default value of the <ref:parameter>choice</ref:parameter> paramter
  for <ref:xmltag>group</ref:xmltag> elements
</ref:refpurpose>

<xsl:param name="db2html.group.choice" select="'opt'"/>


<!-- == db2html.group.rep == -->

<ref:refname>db2html.group.rep</ref:refname>
<ref:refpurpose>
  The default value of the <ref:parameter>rep</ref:parameter> paramter
  for <ref:xmltag>group</ref:xmltag> elements
</ref:refpurpose>

<xsl:param name="db2html.group.rep" select="'norepeat'"/>


<!-- == db2html.cmdsynopsis == -->

<ref:refname>db2html.cmdsynopsis</ref:refname>
<ref:refpurpose>
  Process <ref:xmltag>cmdsynopsis</ref:xmltag> elements
</ref:refpurpose>
<ref:para>
  This template is called for all <ref:xmltag>cmdsynopsis</ref:xmltag>
  elements.  Child elements are processed with the mode
  <ref:function>db2html.cmdsynopsis.mode</ref:function>.
  You may override templates in this mode to customize the behavior
  of elements inside <ref:xmltag>cmdsynopsis</ref:xmltag>.
</ref:para>
<ref:para>
  The <ref:parameter>sepchar</ref:parameter> is passed to the templates
  in <ref:function>db2html.cmdsynopsis.mode</ref:function>.  If you
  override a template in this mode, you should pass this parameter
  through as well.
</ref:para>

<xsl:template name="db2html.cmdsynopsis">
  <xsl:param name="sepchar">
    <xsl:choose>
      <xsl:when test="@sepchar">
	<xsl:value-of select="@sepchar"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$db2html.cmdsynopsis.sepchar"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <div class="cmdsynopsis">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:for-each select="command | arg | group | sbr">
      <xsl:if test="position != 1">
	<xsl:value-of select="$sepchar"/>
      </xsl:if>
      <xsl:apply-templates mode="db2html.cmdsynopsis.mode">
	<xsl:with-param name="sepchar" select="$sepchar"/>
      </xsl:apply-templates>
    </xsl:for-each>
    <xsl:apply-templates mode="db2html.cmdsynopsis.mode"
			 select="synopfragment">
      <xsl:with-param name="sepchar" select="$sepchar"/>
    </xsl:apply-templates>
  </div>
</xsl:template>

<xsl:template match="cmdsynopsis">
  <xsl:call-template name="db2html.cmdsynopsis"/>
</xsl:template>


<!-- == Matched Templates == -->

<!-- = arg = -->
<xsl:template mode="db2html.cmdsynopsis.mode" match="arg">
  <xsl:param name="sepchar">
    <xsl:choose>
      <xsl:when test="ancestor::cmdsynopsis[1][@sepchar]">
	<xsl:value-of select="ancesotr::cmdsynopsis[1]/@sepchar"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$db2html.cmdsynopsis.sepchar"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="choice">
    <xsl:choose>
      <xsl:when test="@choice">
	<xsl:value-of select="@choice"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$db2html.arg.choice"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="rep">
    <xsl:choose>
      <xsl:when test="@rep">
	<xsl:value-of select="@rep"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$db2html.arg.rep"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <span class="arg-punc">
    <xsl:choose>
      <xsl:when test="$choice = 'plain'"/>
      <xsl:when test="$choice = 'req'">
	<xsl:text>{</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>[</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <span class="arg">
      <xsl:apply-templates mode="db2html.cmdsynopsis.mode">
	<xsl:with-param name="sepchar" select="$sepchar"/>
      </xsl:apply-templates>
    </span>
    <xsl:if test="$rep = 'repeat'">
      <xsl:text>...</xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$choice = 'plain'"/>
      <xsl:when test="$choice = 'req'">
	<xsl:text>}</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>]</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </span>
</xsl:template>

<!-- = group = -->
<xsl:template mode="db2html.cmdsynopsis.mode" match="group">
  <xsl:param name="sepchar">
    <xsl:choose>
      <xsl:when test="ancestor::cmdsynopsis[1][@sepchar]">
	<xsl:value-of select="ancesotr::cmdsynopsis[1]/@sepchar"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$db2html.cmdsynopsis.sepchar"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="choice">
    <xsl:choose>
      <xsl:when test="@choice">
	<xsl:value-of select="@choice"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$db2html.group.choice"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="rep">
    <xsl:choose>
      <xsl:when test="@rep">
	<xsl:value-of select="@rep"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$db2html.group.rep"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <span class="group-punc">
    <xsl:choose>
      <xsl:when test="$choice = 'plain'">
	<xsl:text>(</xsl:text>
      </xsl:when>
      <xsl:when test="$choice = 'req'">
	<xsl:text>{</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>[</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <span class="group">
      <xsl:for-each select="*">
	<xsl:if test="local-name(.) = 'arg' and position() != 1">
	  <xsl:value-of select="concat($sepchar, '|', $sepchar"/>
	</xsl:if>
	<xsl:apply-templates mode="db2html.cmdsynopsis.mode" select=".">
	  <xsl:with-param name="sepchar" select="$sepchar"/>
	</xsl:apply-templates>
      </xsl:for-each>
    </span>
    <xsl:choose>
      <xsl:when test="$choice = 'plain'">
	<xsl:text>)</xsl:text>
      </xsl:when>
      <xsl:when test="$choice = 'req'">
	<xsl:text>}</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>]</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$rep = 'repeat'">
      <xsl:text>...</xsl:text>
    </xsl:if>
  </span>
</xsl:template>

<!-- = sbr = -->
<xsl:template mode="db2html.cmdsynopsis.mode" match="sbr">
  <br class="sbr"/>
</xsl:template>

<!-- = synopfragment = -->
<xsl:template mode="db2html.cmdsynopsis.mode" match="synopfragment">
  <xsl:param name="sepchar">
    <xsl:choose>
      <xsl:when test="ancestor::cmdsynopsis[1][@sepchar]">
	<xsl:value-of select="ancesotr::cmdsynopsis[1]/@sepchar"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$db2html.cmdsynopsis.sepchar"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <div class="synopfragment">
    <xsl:call-template name="db2html.anchor"/>
    <i><xsl:call-template name="db2html.label"/></i>
    <xsl:apply-templates mode="db2html.cmdsynopsis.mode">
      <xsl:with-param name="sepchar" select="$sepchar"/>
    </xsl:apply-templates>
  </div>
</xsl:template>

<!-- = synopfragmentref = -->
<xsl:template mode="db2html.cmdsynopsis.mode" match="synopfragmentref">
  <xsl:call-template name="db2html.xref"/>
</xsl:template>

<!-- = node() = -->
<xsl:template mode="db2html.cmdsynopsis.mode" match="node()">
  <xsl:apply-templates select="."/>
</xsl:template>

</xsl:stylesheet>
