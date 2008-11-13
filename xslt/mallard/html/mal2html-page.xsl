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
                xmlns:mal="http://www.gnome.org/~shaunm/mallard"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

<!--!!==========================================================================
Mallard to HTML - Pages

REMARK: Describe this module
-->


<!--**==========================================================================
mal2html.page.copyright
Outputs the copyright notice at the bottom of a page
$node: The top-level #{page} element

REMARK: Describe this template
-->
<xsl:template name="db2html.page.copyrights">
  <xsl:param name="node"/>
  <div class="copyrights">
    <xsl:for-each select="$node/mal:info/mal:copyright">
      <div class="copyright">
        <!-- FIXME: i18n -->
        <xsl:value-of select="concat('© ', mal:year, ' ', mal:name)"/>
      </div>
    </xsl:for-each>
  </div>
</xsl:template>


<!--**==========================================================================
mal2html.page.pagelinks
Outputs the automatic links from a guide page or guide section
$node: The #{page} or #{section} element containing the links

REMARK: Describe this template
-->
<xsl:template name="mal2html.page.pagelinks">
  <xsl:param name="node" select="."/>
  <xsl:variable name="id">
    <xsl:choose>
      <xsl:when test="$node/self::mal:section">
        <xsl:value-of select="concat(ancestor::mal:page[1]/@id, '#', @id)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@id"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="pagelinks"
                select="$node/mal:info/mal:link[@type = 'topic']"/>
  <!-- FIXME: // selectors are slow -->
  <!-- FIXME: exclude $pagelinks from $guidelinks -->
  <xsl:variable name="guidelinks"
                select="$cache//*[mal:info/mal:link[@type = 'guide'][@xref = $id]]"/>
  <xsl:if test="$pagelinks or $guidelinks">
    <div class="pagelinks">
      <xsl:for-each select="$pagelinks">
        <xsl:variable name="linkid">
          <xsl:choose>
            <xsl:when test="contains(@xref, '#')">
              <xsl:value-of select="@xref"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat(@xref, '#', @xref)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="position">
          <xsl:choose>
            <xsl:when test="last() = 1 and count($guidelinks) = 0">
              <xsl:text>only</xsl:text>
            </xsl:when>
            <xsl:when test="position() = 1">
              <xsl:text>first</xsl:text>
            </xsl:when>
            <xsl:when test="position() = last() and count($guidelinks) = 0">
              <xsl:text>last</xsl:text>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:for-each select="$cache">
          <xsl:call-template name="mal2html.page.pagelink">
            <xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="page" select="key('cache_key', $linkid)"/>
            <xsl:with-param name="position" select="$position"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:for-each>
      <xsl:for-each select="$guidelinks">
        <xsl:sort select="mal:info/mal:link[@type = 'guide'][@xref = $id]/@weight"
                  data-type="number" order="descending"/>
        <!-- FIXME: lang -->
        <xsl:sort select="mal:info/mal:title[@type = 'sort']"
                  data-type="text" order="ascending"/>
        <xsl:call-template name="mal2html.page.pagelink">
          <xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="page" select="."/>
          <xsl:with-param name="position">
            <xsl:choose>
              <xsl:when test="last() = 1 and count($pagelinks) = 0">
                <xsl:text>only</xsl:text>
              </xsl:when>
              <xsl:when test="position() = 1 and count($pagelinks) = 0">
                <xsl:text>first</xsl:text>
              </xsl:when>
              <xsl:when test="position() = last()">
                <xsl:text>last</xsl:text>
              </xsl:when>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>
    </div>
  </xsl:if>
</xsl:template>


<!--**==========================================================================
mal2html.page.pagelink
Outputs an automatic link block from a guide to a page
$node: The #{guide} or #{section} element containing the link
$page: The element from the cache file of the page being linked to
$position: The position of this link in the list, either 'first', 'last', or ''

REMARK: Describe this template
-->
<xsl:template name="mal2html.page.pagelink">
  <xsl:param name="node" select="."/>
  <xsl:param name="page"/>
  <xsl:param name="position"/>
  <xsl:variable name="xref">
    <xsl:choose>
      <xsl:when test="$page/self::mal:section">
        <xsl:value-of select="$page/ancestor::mal:page[1]/@id"/>
        <xsl:text>#</xsl:text>
        <xsl:value-of select="$page/@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$page/@id"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="linkid">
    <xsl:choose>
      <xsl:when test="contains($xref, '#')">
        <xsl:value-of select="$xref"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($xref, '#', $xref)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="mal.link.target">
        <xsl:with-param name="xref" select="$xref"/>
      </xsl:call-template>
    </xsl:attribute>
    <div>
      <xsl:attribute name="class">
        <xsl:text>pagelink</xsl:text>
        <xsl:choose>
          <xsl:when test="$position = 'only'">
            <xsl:text> pagelink-only</xsl:text>
          </xsl:when>
          <xsl:when test="$position = 'first'">
            <xsl:text> pagelink-first</xsl:text>
          </xsl:when>
          <xsl:when test="$position = 'last'">
            <xsl:text> pagelink-last</xsl:text>
          </xsl:when>
        </xsl:choose>
      </xsl:attribute>
      <!-- FIXME: call a common linkifier? -->
      <div class="title">
        <xsl:call-template name="mal.link.content">
          <xsl:with-param name="node" select="."/>
          <xsl:with-param name="xref" select="$xref"/>
        </xsl:call-template>
      </div>
      <xsl:for-each select="$cache">
        <xsl:variable name="desc"
                      select="key('cache_key', $linkid)/mal:info/mal:desc[1]"/>
        <xsl:if test="$desc">
          <div class="desc">
            <!-- FIXME: should desc contain inline or block? -->
            <xsl:apply-templates mode="mal2html.inline.mode" select="$desc/node()"/>
          </div>
        </xsl:if>
      </xsl:for-each>
    </div>
  </a>
</xsl:template>


<!--**==========================================================================
mal2html.page.seealsolinks
Outputs the automatic seealso links from a page related pages
$node: The #{topic} or #{section} element containing the links

REMARK: Describe this template
-->
<xsl:template name="mal2html.page.seealsolinks">
  <xsl:param name="node" select="."/>
  <xsl:variable name="depth"
                select="count($node/ancestor::mal:section) + 2"/>
  <xsl:variable name="id">
    <xsl:choose>
      <xsl:when test="$node/self::mal:section">
        <xsl:value-of select="concat(ancestor::mal:page[1]/@id, '#', @id)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@id"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- FIXME: // is slow -->
  <xsl:variable name="inlinks"
                select="$cache//*[mal:info/mal:link[@type = 'seealso'][@xref = $id]]"/>
  <xsl:variable name="outlinks"
                select="$node/mal:info/mal:link[@type = 'seealso']"/>
  <xsl:variable name="pagelinks"
                select="$cache//*[mal:info/mal:link[@type = 'topic'][@xref = $id]]"/>
  <xsl:variable name="guidelinks"
                select="$node/mal:info/mal:link[@type = 'guide']"/>
  <xsl:if test="$inlinks or $outlinks or $pagelinks or $guidelinks">
    <div class="section seealsosection">
      <div class="header">
        <xsl:element name="{concat('h', $depth)}">
          <xsl:attribute name="class">
            <xsl:text>title</xsl:text>
          </xsl:attribute>
          <!-- FIXME: i18n -->
          <xsl:text>See Also</xsl:text>
        </xsl:element>
      </div>
      <div class="seealsolinks">
        <ul class="seealsolinks">
          <xsl:for-each select="$pagelinks">
            <xsl:variable name="position">
              <xsl:choose>
                <xsl:when test="last() = 1 and count($guidelinks) = 0">
                  <xsl:text>only</xsl:text>
                </xsl:when>
                <xsl:when test="position() = 1">
                  <xsl:text>first</xsl:text>
                </xsl:when>
                <xsl:when test="position() = last() and count($guidelinks) = 0">
                  <xsl:text>last</xsl:text>
                </xsl:when>
              </xsl:choose>
            </xsl:variable>
            <xsl:call-template name="mal2html.page.seealsolink">
              <xsl:with-param name="node" select="$node"/>
              <xsl:with-param name="page" select="."/>
              <xsl:with-param name="position" select="$position"/>
            </xsl:call-template>
          </xsl:for-each>
          <!-- FIXME: exclude pagelinks -->
          <xsl:for-each select="$guidelinks">
            <xsl:variable name="linkid">
              <xsl:choose>
                <xsl:when test="contains(@xref, '#')">
                  <xsl:value-of select="@xref"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="concat(@xref, '#', @xref)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="position">
              <xsl:choose>
                <xsl:when test="last() = 1 and count($pagelinks) = 0">
                  <xsl:text>only</xsl:text>
                </xsl:when>
                <xsl:when test="position() = 1 and count($pagelinks) = 0">
                  <xsl:text>first</xsl:text>
                </xsl:when>
                <xsl:when test="position() = last()">
                  <xsl:text>last</xsl:text>
                </xsl:when>
              </xsl:choose>
            </xsl:variable>
            <xsl:for-each select="$cache">
              <xsl:call-template name="mal2html.page.seealsolink">
                <xsl:with-param name="node" select="$node"/>
                <xsl:with-param name="page" select="key('cache_key', $linkid)"/>
                <xsl:with-param name="position" select="$position"/>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:for-each>

          <xsl:if test="($pagelinks or $guidelinks) and ($inlinks or $outlinks)">
            <li class="seealsolinksep"/>
          </xsl:if>

          <xsl:for-each select="$inlinks">
            <xsl:call-template name="mal2html.page.seealsolink">
              <xsl:with-param name="node" select="$node"/>
              <xsl:with-param name="page" select="."/>
              <xsl:with-param name="position">
                <xsl:choose>
                  <xsl:when test="last() = 1 and count($outlinks) = 0">
                    <xsl:text>only</xsl:text>
                  </xsl:when>
                  <xsl:when test="position() = 1">
                    <xsl:text>first</xsl:text>
                  </xsl:when>
                  <xsl:when test="position() = last() and count($outlinks) = 0">
                    <xsl:text>last</xsl:text>
                  </xsl:when>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:for-each>
          <xsl:for-each select="$outlinks">
            <xsl:variable name="linkid">
              <xsl:choose>
                <xsl:when test="contains(@xref, '#')">
                  <xsl:value-of select="@xref"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="concat(@xref, '#', @xref)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="position">
              <xsl:choose>
                <xsl:when test="last() = 1 and count($inlinks) = 0">
                  <xsl:text>only</xsl:text>
                </xsl:when>
                <xsl:when test="position() = 1 and count($inlinks) = 0">
                  <xsl:text>first</xsl:text>
                </xsl:when>
                <xsl:when test="position() = last()">
                  <xsl:text>last</xsl:text>
                </xsl:when>
              </xsl:choose>
            </xsl:variable>
            <xsl:for-each select="$cache">
              <xsl:call-template name="mal2html.page.seealsolink">
                <xsl:with-param name="node" select="$node"/>
                <xsl:with-param name="page" select="key('cache_key', $linkid)"/>
                <xsl:with-param name="position" select="$position"/>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:for-each>
        </ul>
      </div>
    </div>

  </xsl:if>
  <xsl:if test="$inlinks or $outlinks">
  </xsl:if>
</xsl:template>


<!--**==========================================================================
mal2html.page.seealsolink
Outputs an automatic link block for a seealso link
$node: The #{topic} or #{section} element containing the link
$page: The element from the cache file of the page being linked to
$position: The position of this link in the list, either 'first', 'last', or ''

REMARK: Describe this template
-->
<xsl:template name="mal2html.page.seealsolink">
  <xsl:param name="node" select="."/>
  <xsl:param name="page"/>
  <xsl:param name="position"/>
  <xsl:variable name="xref">
    <xsl:choose>
      <xsl:when test="$page/self::mal:section">
        <xsl:value-of select="$page/ancestor::mal:page[1]/@id"/>
        <xsl:text>#</xsl:text>
        <xsl:value-of select="$page/@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$page/@id"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <li class="seealsolink">
    <xsl:attribute name="class">
      <xsl:text>seealsolink</xsl:text>
      <xsl:choose>
        <xsl:when test="$position = 'only'">
          <xsl:text> seealsolink-only</xsl:text>
        </xsl:when>
        <xsl:when test="$position = 'first'">
          <xsl:text> seealsolink-first</xsl:text>
        </xsl:when>
        <xsl:when test="$position = 'last'">
          <xsl:text> seealsolink-last</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:attribute>
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="mal.link.target">
          <xsl:with-param name="xref" select="$xref"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:call-template name="mal.link.content">
        <xsl:with-param name="node" select="."/>
        <xsl:with-param name="xref" select="$xref"/>
      </xsl:call-template>
    </a>
  </li>
</xsl:template>


<!-- == Matched Templates == -->

<!-- = / = -->
<xsl:template match="/">
  <!-- FIXME: find a way to just select the version element -->
  <xsl:variable name="date">
    <xsl:for-each select="mal:page/mal:info/mal:version">
      <xsl:sort select="@date" data-type="text" order="descending"/>
      <xsl:if test="position() = 1">
        <xsl:value-of select="@date"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="version"
                select="mal:page/mal:info/mal:version[@date = $date][last()]"/>
  <html>
    <head>
      <title>
        <xsl:value-of select="mal:page/mal:title"/>
      </title>
      <xsl:call-template name="mal2html.css"/>
    </head>
    <body>
      <!-- FIXME: only in editor mode -->
      <xsl:if test="$version/@status != ''">
        <xsl:attribute name="class">
          <xsl:value-of select="concat(' status-', $version/@status)"/>
        </xsl:attribute>
        <div class="version">
          <!-- FIXME: i18n -->
          <div class="title">Version Information</div>
          <p class="version">
            <xsl:text>Version </xsl:text>
            <xsl:value-of select="$version/@number"/>
            <xsl:text> on </xsl:text>
            <xsl:value-of select="$version/@date"/>
            <xsl:text> (</xsl:text>
            <xsl:choose>
              <xsl:when test="$version/@status = 'stub'">
                <xsl:text>Stub</xsl:text>
              </xsl:when>
              <xsl:when test="$version/@status = 'incomplete'">
                <xsl:text>Incomplete</xsl:text>
              </xsl:when>
              <xsl:when test="$version/@status = 'draft'">
                <xsl:text>Draft</xsl:text>
              </xsl:when>
              <xsl:when test="$version/@status = 'review'">
                <xsl:text>Ready for review</xsl:text>
              </xsl:when>
              <xsl:when test="$version/@status = 'final'">
                <xsl:text>Final</xsl:text>
              </xsl:when>
            </xsl:choose>
            <xsl:text>)</xsl:text>
          </p>
          <xsl:apply-templates mode="mal2html.block.mode" select="$version/*"/>
        </div>
      </xsl:if>
      <div class="body">
        <xsl:apply-templates select="mal:page"/>
      </div>
      <xsl:call-template name="db2html.page.copyrights">
        <xsl:with-param name="node" select="mal:page"/>
      </xsl:call-template>
    </body>
  </html>
</xsl:template>

<!-- = guide = -->
<xsl:template match="mal:page">
  <div class="header">
    <xsl:apply-templates mode="mal2html.block.mode"
                         select="mal:title | mal:subtitle"/>
  </div>
  <div class="contents">
    <xsl:apply-templates
        mode="mal2html.block.mode"
        select="*[not(self::mal:section | self::mal:title | self::mal:subtitle)]"/>
    <xsl:if test="@type = 'guide'">
      <xsl:call-template name="mal2html.page.pagelinks"/>
    </xsl:if>
  </div>
  <xsl:apply-templates select="mal:section"/>
  <xsl:call-template name="mal2html.page.seealsolinks">
    <xsl:with-param name="node" select="."/>
  </xsl:call-template>
</xsl:template>

<!-- = section = -->
<xsl:template match="mal:section">
  <div class="section" id="{@id}">
    <div class="header">
      <xsl:apply-templates mode="mal2html.block.mode"
                           select="mal:title | mal:subtitle"/>
    </div>
    <div class="contents">
      <xsl:apply-templates
          mode="mal2html.block.mode"
          select="*[not(self::mal:section | self::mal:title | self::mal:subtitle)]"/>
      <xsl:if test="/mal:page/@type = 'guide'">
        <xsl:call-template name="mal2html.page.pagelinks"/>
      </xsl:if>
    </div>
    <xsl:apply-templates select="mal:section"/>
    <xsl:call-template name="mal2html.page.seealsolinks">
      <xsl:with-param name="node" select="."/>
    </xsl:call-template>
  </div>
</xsl:template>

<!-- = title = -->
<xsl:template mode="mal2html.block.mode" match="mal:title">
  <xsl:variable name="depth"
                select="count(ancestor::mal:section) + 1"/>
  <xsl:element name="{concat('h', $depth)}">
    <xsl:attribute name="class">
      <xsl:text>title</xsl:text>
    </xsl:attribute>
    <xsl:apply-templates mode="mal2html.inline.mode"/>
  </xsl:element>
</xsl:template>

</xsl:stylesheet>
