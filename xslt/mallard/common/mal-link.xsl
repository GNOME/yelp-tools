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
                xmlns:mal="http://projectmallard.org/1.0/"
                version="1.0">

<!--!!==========================================================================
Mallard Links
-->


<!--@@==========================================================================
mal.cache.file
The location of the cache file
-->
<xsl:param name="mal.cache.file"/>
<xsl:param name="mal.cache" select="document($mal.cache.file)/mal:cache"/>
<xsl:key name="mal.cache.key" match="mal:page | mal:section" use="@id"/>


<!--**==========================================================================
mal.link.content
Generates the content for a #{link} element
$link: The #{link} or other element creating the link
$xref: The #{xref} attribute of ${link}
$href: The #{href} attribute of ${link}
$role: A link role, used to select the appropriate title
-->
<xsl:template name="mal.link.content">
  <xsl:param name="link" select="."/>
  <xsl:param name="xref" select="$link/@xref"/>
  <xsl:param name="href" select="$link/@href"/>
  <xsl:param name="role" select="''"/>
  <xsl:choose>
    <xsl:when test="contains($xref, '/')">
      <!--
      This is a link to another document, which we don't handle in these
      stylesheets.  Extensions such as library or yelp should override
      this template to provide this functionality.
      -->
      <xsl:choose>
        <xsl:when test="$href">
          <xsl:value-of select="$href"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$xref"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="fullid">
        <xsl:choose>
          <xsl:when test="contains($xref, '#')">
            <xsl:variable name="pageid" select="substring-before($xref, '#')"/>
            <xsl:variable name="sectionid" select="substring-after($xref, '#')"/>
            <xsl:if test="$pageid = ''">
              <xsl:value-of select="$link/ancestor::mal:page/@id"/>
            </xsl:if>
            <xsl:value-of select="concat($pageid, '#', $sectionid)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$xref"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:for-each select="$mal.cache">
        <xsl:variable name="titles" select="key('mal.cache.key', $fullid)
                                           /mal:info/mal:title[@type = 'link']"/>
        <xsl:choose>
          <xsl:when test="$role != '' and $titles[@role = $role]">
            <xsl:apply-templates mode="mal.link.content.mode"
                                 select="$titles[@role = $role][1]/node()"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="mal.link.content.mode"
                                 select="$titles[not(@role)][1]/node()"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--%%==========================================================================
mal.link.content.mode
Renders the content of a link from a title

This mode is applied to the contents of a #{title} element by *{mal.link.content}.
By default, it returns the string value of its input.  Stylesheets that import
this module should override this to call their inline mode.
-->
<xsl:template mode="mal.link.content.mode" match="* | text()">
  <xsl:value-of select="."/>
</xsl:template>


<!--**==========================================================================
mal.link.target
Generates the target for a #{link} element
$link: The #{link} or other element creating the link
$xref: The #{xref} attribute of ${link}
$href: The #{href} attribute of ${link}
-->
<xsl:template name="mal.link.target">
  <xsl:param name="link" select="."/>
  <xsl:param name="xref" select="$link/@xref"/>
  <xsl:param name="href" select="$link/@href"/>
  <xsl:choose>
    <xsl:when test="string($xref) = ''">
      <xsl:value-of select="$href"/>
    </xsl:when>
    <xsl:when test="contains($xref, '/')">
      <!--
      This is a link to another document, which we don't handle in these
      stylesheets.  Extensions such as library or yelp should override
      this template to provide this functionality.
      -->
      <xsl:value-of select="$href"/>
    </xsl:when>
    <xsl:when test="contains($xref, '#')">
      <xsl:variable name="pageid" select="substring-before($xref, '#')"/>
      <xsl:variable name="sectionid" select="substring-after($xref, '#')"/>
      <xsl:if test="$pageid != ''">
        <xsl:value-of select="concat($pageid, $mal.chunk.extension)"/>
      </xsl:if>
      <xsl:value-of select="concat('#', $sectionid)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat($xref, $mal.chunk.extension)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--**==========================================================================
mal.link.tooltip
Generates the tooltip for a #{link} or other linking element
$link: The #{link} or other element creating the link
$xref: The #{xref} attribute of ${link}
$href: The #{href} attribute of ${link}
-->
<xsl:template name="mal.link.tooltip">
  <xsl:param name="link" select="."/>
  <xsl:param name="xref" select="$link/@xref"/>
  <xsl:param name="href" select="$link/@href"/>
  <xsl:choose>
    <xsl:when test="string($xref) != ''">
      <!-- FIXME -->
    </xsl:when>
    <xsl:when test="starts-with($href, 'mailto:')">
      <xsl:variable name="address" select="substring-after($href, 'mailto:')"/>
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'email.tooltip'"/>
        <xsl:with-param name="string" select="$address"/>
        <xsl:with-param name="format" select="true()"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="normalize-space($href)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
