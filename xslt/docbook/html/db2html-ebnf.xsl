<?xml version='1.0' encoding='utf-8'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
		exclude-result-prefixes="doc"
                version="1.0">

<doc:title>EBNF Elements</doc:title>


<!-- == Matched Templates == -->

<!-- = constraint = -->

<!-- = constraintdef = -->

<!-- = lhs = -->

<!-- = nonterminal = -->

<!-- = production = -->

<!-- = productionrecap = -->

<!-- = productionset = -->
<xsl:template match="productionset">
  <div class="productionset">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:apply-templates select="title"/>
    <table class="productionset">
      <xsl:apply-templates select="production | productionrecap"/>
    </table>
  </div>
</xsl:template>

<!-- = productionset/title = -->
<xsl:template match="productionset/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

<!-- = rhs = -->

</xsl:stylesheet>
