<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:template match="/report">
  <html>
    <head>
      <title>Stylesheet Report</title>
      <style type="text/css">
        body { font-family: sans-serif; }
	th { text-align: left; }
	td { vertical-align: top; padding: 0.2em; }
	tr[class="odd"] { background-color: #EEEEEE; }
	span[class="file"] { color: #102070; }
	span[class="mode"] { color: #702010; }
        a { color: #945904; text-decoration: none; }
        a:hover { text-decoration: underline; }
      </style>
    </head>
    <body>
      <p>
	<xsl:variable name="total" select="count(element)"/>
	<xsl:variable name="matched"
		      select="count(element[@name =
		      /report/file/template[not(@mode)]/@match])"/>
	<xsl:variable name="unmatched" select="$total - $matched"/>

	<xsl:value-of select="$unmatched"/>
	<xsl:text> unmatched elements</xsl:text>
	<br/>
	<xsl:value-of select="$matched"/>
	<xsl:text> matched elements</xsl:text>
	<br/>
	<xsl:value-of select="$total"/>
	<xsl:text> total elements</xsl:text>
	<br/>
	<xsl:number value="($matched div $total) * 100"/>
	<xsl:text>% of elements matched</xsl:text>
      </p>
      <table>
	<tr>
	  <th>Element</th>
	  <th>Simple Matches</th>
	  <th>Mode Matches</th>
	</tr>
	<xsl:for-each select="element">
	  <tr>
	    <xsl:if test="position() mod 2 = 1">
	      <xsl:attribute name="class">
		<xsl:text>odd</xsl:text>
	      </xsl:attribute>
	    </xsl:if>
	    <td>
	      <span class="element">
		<a href="{concat('http://www.docbook.org/tdg/en/html/',
                                 @name, '.html')}">
                  <xsl:value-of select="@name"/>
                </a>
	      </span>
	    </td>
	    <td>
	      <xsl:for-each select="
		/report/file/template[not(@mode)][@match=current()/@name]">
		<xsl:if test="position() != 1">
		  <br/>
		</xsl:if>
		<span class="file">
		  <xsl:value-of select="../@href"/>
		</span>
	      </xsl:for-each>
	    </td>
	    <td>
	      <xsl:for-each select="
		/report/file/template[@mode][@match=current()/@name]">
		<xsl:if test="position() != 1">
		  <br/>
		</xsl:if>
		<span class="file">
		  <xsl:value-of select="../@href"/>
		</span>
		<xsl:text> in </xsl:text>
		<span class="mode">
		  <xsl:value-of select="@mode"/>
		</span>
	      </xsl:for-each>
	    </td>
	  </tr>
	</xsl:for-each>
      </table>
    </body>
  </html>
</xsl:template>

<xsl:template match="/_report">
  <report>
    <xsl:apply-templates/>
  </report>
</xsl:template>

<xsl:template match="_element">
  <element name="{@name}"/>
</xsl:template>

<xsl:template match="_file">
  <file href="{@href}">
    <xsl:apply-templates/>
  </file>
</xsl:template>

<xsl:template match="_template">
  <xsl:call-template name="tokenize.template">
    <xsl:with-param name="string" select="normalize-space(@match)"/>
    <xsl:with-param name="mode" select="@mode"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="tokenize.template">
  <xsl:param name="mode" select="false()"/>
  <xsl:param name="depth" select="0"/>
  <xsl:param name="before" select="''"/>
  <xsl:param name="string"/>
  <xsl:variable name="firstchar">
    <xsl:choose>
      <xsl:when test="contains($string, '[') and
                      not(contains(substring-before($string, '['), '|')) and
                      not(contains(substring-before($string, '['), ']')) ">
        <xsl:text>[</xsl:text>
      </xsl:when>
      <xsl:when test="contains($string, ']') and
                      not(contains(substring-before($string, ']'), '|')) and
                      not(contains(substring-before($string, ']'), '[')) ">
        <xsl:text>]</xsl:text>
      </xsl:when>
      <xsl:when test="contains($string, '|') and
                      not(contains(substring-before($string, '|'), '[')) and
                      not(contains(substring-before($string, '|'), ']')) ">
        <xsl:text>|</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text></xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="not(contains($string, '|'))">
      <template match="{normalize-space(concat($before, $string))}">
	<xsl:if test="$mode">
	  <xsl:attribute name="mode">
	    <xsl:value-of select="$mode"/>
	  </xsl:attribute>
	</xsl:if>
      </template>
    </xsl:when>
    <xsl:when test="$firstchar = '['">
      <xsl:call-template name="tokenize.template">
	<xsl:with-param name="mode" select="$mode"/>
        <xsl:with-param name="depth" select="$depth + 1"/>
        <xsl:with-param name="before"
                        select="concat($before,
                                       substring-before($string, '['),
                                       '[')"/>
        <xsl:with-param name="string" select="substring-after($string, '[')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$depth != 0">
      <xsl:call-template name="tokenize.template">
	<xsl:with-param name="mode" select="$mode"/>
        <xsl:with-param name="depth" select="$depth - 1"/>
        <xsl:with-param name="before"
                        select="concat($before,
                                       substring-before($string, ']'),
                                       ']')"/>
        <xsl:with-param name="string" select="substring-after($string, ']')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <template match="{normalize-space(
		          concat($before, substring-before($string, '|')))}">
	<xsl:if test="$mode">
	  <xsl:attribute name="mode">
	    <xsl:value-of select="$mode"/>
	  </xsl:attribute>
	</xsl:if>
      </template>
      <xsl:call-template name="tokenize.template">
	<xsl:with-param name="mode" select="$mode"/>
        <xsl:with-param name="depth" select="0"/>
        <xsl:with-param name="before" select="''"/>
        <xsl:with-param name="string" select="substring-after($string, '|')"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
