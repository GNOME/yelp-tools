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
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

<!--!!==========================================================================
DocBook to HTML - Command Synopses

REMARK: Describe this module
-->


<!--@@==========================================================================
db2html.cmdsynopsis.sepchar
The default value for the #{sepchar} parameter

REMARK: Describe this param
-->
<xsl:param name="db2html.cmdsynopsis.sepchar" select="' '"/>


<!--@@==========================================================================
db2html.arg.choice
The default value of the #{choice} parameter for #{arg} elements

REMARK: Describe this param
-->
<xsl:param name="db2html.arg.choice" select="'opt'"/>


<!--@@==========================================================================
db2html.arg.rep
The default value of the #{rep} parameter for #{arg} elements

REMARK: Describe this param
-->
<xsl:param name="db2html.arg.rep" select="'norepeat'"/>


<!--@@==========================================================================
db2html.group.choice
The default value of the #{choice} parameter for #{group} elements

REMARK: Describe this param
-->
<xsl:param name="db2html.group.choice" select="'opt'"/>


<!--@@==========================================================================
db2html.group.rep
The default value of the #{rep} parameter for #{group} elements

REMARK: Describe this param
-->
<xsl:param name="db2html.group.rep" select="'norepeat'"/>


<!--**==========================================================================
db2html.cmdsynopsis.css
Outputs CSS that controls the appearance of command synopsi elements

REMARK: Describe this template
-->
<xsl:template name="db2html.cmdsynopsis.css">
<xsl:text>
div.cmdsynopsis { font-family: monospace; }
</xsl:text>
</xsl:template>


<!-- == Matched Templates == -->

<!-- = arg = -->
<xsl:template match="arg">
  <xsl:param name="sepchar">
    <xsl:choose>
      <xsl:when test="ancestor::cmdsynopsis[1][@sepchar]">
        <xsl:value-of select="ancestor::cmdsynopsis[1]/@sepchar"/>
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
      <xsl:apply-templates>
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

<!-- = cmdsynopsis = -->
<xsl:template match="cmdsynopsis">
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
      <xsl:if test="position() != 1">
        <xsl:value-of select="$sepchar"/>
      </xsl:if>
      <xsl:apply-templates select=".">
        <xsl:with-param name="sepchar" select="$sepchar"/>
      </xsl:apply-templates>
    </xsl:for-each>
    <xsl:apply-templates select="synopfragment">
      <xsl:with-param name="sepchar" select="$sepchar"/>
    </xsl:apply-templates>
  </div>
</xsl:template>

<!-- = group = -->
<xsl:template match="group">
  <xsl:param name="sepchar">
    <xsl:choose>
      <xsl:when test="ancestor::cmdsynopsis[1][@sepchar]">
        <xsl:value-of select="ancestor::cmdsynopsis[1]/@sepchar"/>
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
          <xsl:value-of select="concat($sepchar, '|', $sepchar)"/>
        </xsl:if>
        <xsl:apply-templates select=".">
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
<xsl:template match="sbr">
  <br class="sbr"/>
</xsl:template>

<!-- = synopfragment = -->
<xsl:template match="synopfragment">
  <xsl:param name="sepchar">
    <xsl:choose>
      <xsl:when test="ancestor::cmdsynopsis[1][@sepchar]">
        <xsl:value-of select="ancestor::cmdsynopsis[1]/@sepchar"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$db2html.cmdsynopsis.sepchar"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <div class="synopfragment">
    <xsl:call-template name="db2html.anchor"/>
    <i><xsl:call-template name="db.label"/></i>
    <xsl:apply-templates>
      <xsl:with-param name="sepchar" select="$sepchar"/>
    </xsl:apply-templates>
  </div>
</xsl:template>

<!-- = synopfragmentref = -->
<xsl:template match="synopfragmentref">
  <xsl:call-template name="db2html.xref"/>
</xsl:template>

</xsl:stylesheet>
