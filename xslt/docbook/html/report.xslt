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
	<xsl:value-of select="count(element[not(template[not(@mode)])])"/>
	<xsl:text> unmatched elements</xsl:text>
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
	      <xsl:for-each select="template[not(@mode)]">
		<xsl:if test="position() != 1">
		  <br/>
		</xsl:if>
		<span class="file">
		  <xsl:value-of select="@href"/>
		</span>
	      </xsl:for-each>
	    </td>
	    <td>
	      <xsl:for-each select="template[@mode]">
		<xsl:if test="position() != 1">
		  <br/>
		</xsl:if>
		<span class="file">
		  <xsl:value-of select="@href"/>
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