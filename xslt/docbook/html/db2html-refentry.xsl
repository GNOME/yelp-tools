<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Reference Pages</doc:title>


<xsl:template match="refentry">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>

  <!-- FIXME: title -->

  <div class="refnamedivs">
    <xsl:call-template name="db2html.title.header">
      <xsl:with-param name="node" select="refnamediv"/>
      <xsl:with-param name="referent" select="refnamediv"/>
      <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk + 2"/>
      <xsl:with-param name="referent_depth_in_chunk" select="$depth_in_chunk + 1"/>
      <xsl:with-param name="title_content">
        <xsl:call-template name="gettext">
          <xsl:with-param name="msgid" select="'Name'"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates select="refnamediv"/>
  </div>
  <xsl:apply-templates select="refsynopsisdiv | refsect1 | refsection">
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk + 1"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="refnamediv">
  <div class="refnamediv">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:for-each select="refname">
      <xsl:if test="position() != 1">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:apply-templates select="."/>
    </xsl:for-each>
    <xsl:text> — </xsl:text>
    <xsl:apply-templates select="refpurpose"/>
  </div>
</xsl:template>

<xsl:template match="refsynopsisdiv">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <div class="refsynopsisdiv">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:if test="not(title)">
      <xsl:call-template name="db2html.title.header">
        <xsl:with-param name="node" select="."/>
        <xsl:with-param name="referent" select="."/>
        <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk + 1"/>
        <xsl:with-param name="referent_depth_in_chunk" select="$depth_in_chunk"/>
        <xsl:with-param name="title_content">
          <xsl:call-template name="gettext">
            <xsl:with-param name="msgid" select="'Synopsis'"/>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:apply-templates>
      <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk + 1"/>
    </xsl:apply-templates>
  </div>
</xsl:template>

</xsl:stylesheet>
