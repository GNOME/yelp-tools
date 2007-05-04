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
DocBook to HTML - Bibliographies

REMARK: Describe this module
-->


<!--** =========================================================================
db2html.bibliography.css
Outputs CSS that controls the appearance of bibliograpies
-->
<xsl:template name="db2html.bibliography.css">
<xsl:text>
* + div.biblioentry { margin-top: 1.2em; }
* + div.bibliomixed { margin-top: 1.2em; }
</xsl:text>
</xsl:template>


<!-- == Matched Templates == -->

<!-- = bibliography = -->
<xsl:template match="bibliography">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>

  <xsl:call-template name="db2html.division.div">
    <xsl:with-param name="divisions" select="bibliodiv"/>
    <xsl:with-param name="title_content">
      <xsl:if test="not(title) and not(bibliographyinfo/title)">
        <xsl:call-template name="l10n.gettext">
          <xsl:with-param name="msgid" select="'Bibliography'"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:with-param>
    <xsl:with-param name="info" select="glossaryinfo"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
    <xsl:with-param name="chunk_divisions" select="false()"/>
  </xsl:call-template>
</xsl:template>

<!-- = bibliodiv = -->
<xsl:template match="bibliodiv">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.div">
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = bibliomixed = -->
<xsl:template match="bibliomixed">
  <div class="bibliomixed block-indent">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:choose>
      <xsl:when test="*[1]/self::abbrev">
        <xsl:call-template name="db.label">
          <xsl:with-param name="node" select="."/>
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="abbrev[1]/following-sibling::*"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="@xreflabel | @id">
          <xsl:call-template name="db.label">
            <xsl:with-param name="node" select="."/>
          </xsl:call-template>
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<!-- = bibliomset = -->
<xsl:template match="bibliomset">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = bibliomisc = -->
<xsl:template match="bibliomisc">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>


<!--
Cooked bibliography entries allow certain otherwise block-level
elemets to be inline elements, so we special-case them here.
-->

<!-- = biblio*/abstract = -->
<xsl:template match="bibliomixed/abstract | bibliomset/abstract">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = biblio*/address = -->
<xsl:template match="bibliomixed/address | bibliomset/address">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = biblio*/affiliation = -->
<xsl:template match="bibliomixed/affiliation | bibliomset/affiliation">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = biblio*/author = -->
<xsl:template match="bibliomixed/author | bibliomset/author">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = biblio*/authorblurb = -->
<xsl:template match="bibliomixed/authorblurb | bibliomset/authorblurb">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = biblio*/authorgroup = -->
<xsl:template match="bibliomixed/authorgroup | bibliomset/authorgroup">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = biblio*/personblurb = -->
<xsl:template match="bibliomixed/personblurb | bibliomset/personblurb">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = biblio*/shortaffil = -->
<xsl:template match="bibliomixed/shortaffil | bibliomset/shortaffil">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = biblio*/title = -->
<xsl:template match="bibliomixed/title | bibliomset/title">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="italic" select="true()"/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
