<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:template match="/report">
  <html>
    <head>
      <title>Stylesheet Report</title>
      <style type="text/css">
	th { text-align: left; }
	td { vertical-align: top; padding: 0.2em; }
	tr[class="odd"] { background-color: #EEEEEE; }
	span[class="file"] { color: #102070; }
	span[class="mode"] { color: #702010; }
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
		<xsl:value-of select="@name"/>
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

</xsl:stylesheet>