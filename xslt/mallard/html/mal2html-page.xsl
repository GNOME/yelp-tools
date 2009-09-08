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
                xmlns:str="http://exslt.org/strings"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

<!--!!==========================================================================
Mallard to HTML - Pages

REMARK: Describe this module
-->


<xsl:param name="mal2html.editor_mode" select="false()"/>


<!--**==========================================================================
mal2html.page.copyright
Outputs the copyright notice at the bottom of a page
$node: The top-level #{page} element

REMARK: Describe this template
-->
<xsl:template name="mal2html.page.copyrights">
  <xsl:param name="node"/>
  <div class="copyrights">
    <xsl:for-each select="$node/mal:info/mal:credit[mal:years]">
      <div class="copyright">
        <!-- FIXME: i18n, multi-year, email -->
        <xsl:value-of select="concat('© ', mal:years, ' ', mal:name)"/>
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
        <xsl:value-of select="concat($node/ancestor::mal:page[1]/@id, '#', $node/@id)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$node/@id"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="pagelinks"
                select="$node/mal:info/mal:link[@type = 'topic']"/>
  <!-- FIXME: // selectors are slow -->
  <xsl:variable name="guidelinks"
                select="$mal.cache//*[mal:info/mal:link[@type = 'guide'][@xref = $id]]
                                     [not(@id = $pagelinks/@xref)]"/>
  <xsl:if test="$pagelinks or $guidelinks">
    <div class="pagelinks">
      <xsl:choose>
        <xsl:when test="contains(concat(' ', $node/@style, ' '), ' 2column ')">
          <xsl:variable name="coltot" select="ceiling(count($pagelinks | $guidelinks) div 2)"/>
          <table class="twocolumn"><tr>
            <td class="twocolumnleft">
              <xsl:for-each select="$pagelinks[position() &lt;= $coltot]">
                <xsl:variable name="xref" select="@xref"/>
                <xsl:for-each select="$mal.cache">
                  <xsl:call-template name="mal2html.page.pagelink">
                    <xsl:with-param name="source" select="$node"/>
                    <xsl:with-param name="target" select="key('mal.cache.key', $xref)"/>
                  </xsl:call-template>
                </xsl:for-each>
              </xsl:for-each>
              <xsl:for-each select="$guidelinks">
                <xsl:sort select="mal:info/mal:link[@type = 'guide'][@xref = $id]/@weight"
                          data-type="number" order="descending"/>
                <!-- FIXME: lang -->
                <xsl:sort select="mal:info/mal:title[@type = 'sort']"
                          data-type="text" order="ascending"/>
                <xsl:if test="(position() + count($pagelinks)) &lt;= $coltot">
                  <xsl:call-template name="mal2html.page.pagelink">
                    <xsl:with-param name="source" select="$node"/>
                    <xsl:with-param name="target" select="."/>
                  </xsl:call-template>
                </xsl:if>
              </xsl:for-each>
            </td>
            <td class="twocolumnright">
              <xsl:for-each select="$pagelinks[position() &gt; $coltot]">
                <xsl:variable name="xref" select="@xref"/>
                <xsl:for-each select="$mal.cache">
                  <xsl:call-template name="mal2html.page.pagelink">
                    <xsl:with-param name="source" select="$node"/>
                    <xsl:with-param name="target" select="key('mal.cache.key', $xref)"/>
                  </xsl:call-template>
                </xsl:for-each>
              </xsl:for-each>
              <xsl:for-each select="$guidelinks">
                <xsl:sort select="mal:info/mal:link[@type = 'guide'][@xref = $id]/@weight"
                          data-type="number" order="descending"/>
                <!-- FIXME: lang -->
                <xsl:sort select="mal:info/mal:title[@type = 'sort']"
                          data-type="text" order="ascending"/>
                <xsl:if test="(position() + count($pagelinks)) &gt; $coltot">
                  <xsl:call-template name="mal2html.page.pagelink">
                    <xsl:with-param name="source" select="$node"/>
                    <xsl:with-param name="target" select="."/>
                  </xsl:call-template>
                </xsl:if>
              </xsl:for-each>
            </td>
          </tr></table>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="$pagelinks">
            <xsl:variable name="xref" select="@xref"/>
            <xsl:for-each select="$mal.cache">
              <xsl:call-template name="mal2html.page.pagelink">
                <xsl:with-param name="source" select="$node"/>
                <xsl:with-param name="target" select="key('mal.cache.key', $xref)"/>
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
              <xsl:with-param name="source" select="$node"/>
              <xsl:with-param name="target" select="."/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:if>
</xsl:template>


<!--**==========================================================================
mal2html.page.pagelink
Outputs an automatic link block from a guide to a page
$source: The #{page} or #{section} element containing the link
$target: The element from the cache file of the page being linked to

REMARK: Describe this template
-->
<xsl:template name="mal2html.page.pagelink">
  <xsl:param name="source" select="."/>
  <xsl:param name="target"/>
  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="mal.link.target">
        <xsl:with-param name="link" select="$source"/>
        <xsl:with-param name="xref" select="$target/@id"/>
      </xsl:call-template>
    </xsl:attribute>
    <div class="pagelink">
      <div class="title">
        <xsl:call-template name="mal.link.content">
          <xsl:with-param name="link" select="$source"/>
          <xsl:with-param name="xref" select="$target/@id"/>
          <xsl:with-param name="role" select="'topic'"/>
        </xsl:call-template>

        <xsl:if test="$mal2html.editor_mode">
          <xsl:variable name="page" select="$target/ancestor-or-self::mal:page[1]"/>
          <xsl:variable name="date">
            <xsl:for-each select="$page/mal:info/mal:revision">
              <xsl:sort select="@date" data-type="text" order="descending"/>
              <xsl:if test="position() = 1">
                <xsl:value-of select="@date"/>
              </xsl:if>
            </xsl:for-each>
          </xsl:variable>
          <xsl:variable name="revision"
                        select="$page/mal:info/mal:revision[@date = $date][last()]"/>
          <xsl:if test="$revision/@status != '' and $revision/@status != 'final'">
            <xsl:text> </xsl:text>
            <span>
              <xsl:attribute name="class">
                <xsl:value-of select="concat('status status-', $revision/@status)"/>
              </xsl:attribute>
              <!-- FIXME: i18n -->
              <xsl:choose>
                <xsl:when test="$revision/@status = 'stub'">
                  <xsl:call-template name="l10n.gettext">
                    <xsl:with-param name="msgid" select="'Stub'"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$revision/@status = 'incomplete'">
                  <xsl:call-template name="l10n.gettext">
                    <xsl:with-param name="msgid" select="'Incomplete'"/>
                   </xsl:call-template>
                </xsl:when>
                <xsl:when test="$revision/@status = 'draft'">
                  <xsl:call-template name="l10n.gettext">
                    <xsl:with-param name="msgid" select="'Draft'"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$revision/@status = 'review'">
                  <xsl:call-template name="l10n.gettext">
                    <xsl:with-param name="msgid" select="'Ready for review'"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$revision/@status = 'final'">
                  <xsl:call-template name="l10n.gettext">
                    <xsl:with-param name="msgid" select="'Final'"/>
                  </xsl:call-template>
                </xsl:when>
              </xsl:choose>
            </span>
          </xsl:if>
        </xsl:if>
      </div>
      <xsl:if test="$target/mal:info/mal:desc">
        <div class="desc">
          <xsl:apply-templates mode="mal2html.inline.mode"
                               select="$target/mal:info/mal:desc[1]/node()"/>
        </div>
      </xsl:if>
    </div>
  </a>
</xsl:template>


<!--**==========================================================================
mal2html.page.autolinks
Outputs the automatic links from a page to related pages
$node: The #{topic} or #{section} element containing the links

REMARK: Describe this template
-->
<xsl:template name="mal2html.page.autolinks">
  <xsl:param name="node" select="."/>
  <xsl:variable name="depth"
                select="count($node/ancestor::mal:section) + 2"/>
  <xsl:variable name="id">
    <xsl:choose>
      <xsl:when test="$node/self::mal:section">
        <xsl:value-of select="concat($node/ancestor::mal:page[1]/@id, '#', $node/@id)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$node/@id"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- FIXME: // is slow -->
  <xsl:variable name="inlinks"
                select="$mal.cache//*[mal:info/mal:link[@type = 'seealso'][@xref = $id]]"/>
  <xsl:variable name="outlinks"
                select="$node/mal:info/mal:link[@type = 'seealso']"/>
  <xsl:variable name="pagelinks"
                select="$mal.cache//*[mal:info/mal:link[@type = 'topic'][@xref = $id]]"/>
  <xsl:variable name="guidelinks"
                select="$node/mal:info/mal:link[@type = 'guide']"/>
  <xsl:if test="$inlinks or $outlinks or $pagelinks or $guidelinks">
    <div class="section autolinkssection">
      <div class="header">
        <xsl:element name="{concat('h', $depth)}" namespace="{$mal2html.namespace}">
          <xsl:attribute name="class">
            <xsl:text>title</xsl:text>
          </xsl:attribute>
          <!-- FIXME: i18n -->
          <xsl:call-template name="l10n.gettext">
            <xsl:with-param name="msgid" select="'Further Reading'"/>
          </xsl:call-template>
        </xsl:element>
      </div>
      <div class="autolinks">
        <xsl:if test="$pagelinks or $guidelinks">
          <div class="title"><span>
            <!-- FIXME: i18n -->
            <xsl:call-template name="l10n.gettext">
                <xsl:with-param name="msgid" select="'More About'"/>
            </xsl:call-template>
          </span></div>
          <ul>
            <xsl:for-each select="$pagelinks">
              <xsl:call-template name="mal2html.page.autolink">
                <xsl:with-param name="page" select="."/> 
                <xsl:with-param name="role" select="'guide'"/>
             </xsl:call-template>
            </xsl:for-each>
            <!-- FIXME: exclude pagelinks -->
            <xsl:for-each select="$guidelinks">
              <xsl:call-template name="mal2html.page.autolink">
                <xsl:with-param name="xref" select="@xref"/>
                <xsl:with-param name="role" select="'guide'"/>
              </xsl:call-template>
            </xsl:for-each>
          </ul>
        </xsl:if>

        <xsl:if test="$inlinks or $outlinks">
          <div class="title"><span>
            <!-- FIXME: i18n -->
            <xsl:call-template name="l10n.gettext">
                <xsl:with-param name="msgid" select="'See Also'"/>
            </xsl:call-template>
          </span></div>
          <ul>
            <xsl:for-each select="$inlinks">
              <xsl:call-template name="mal2html.page.autolink">
                <xsl:with-param name="page" select="."/>
                <xsl:with-param name="role" select="'seealso'"/>
              </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$outlinks">
              <xsl:call-template name="mal2html.page.autolink">
                <xsl:with-param name="xref" select="@xref"/>
                <xsl:with-param name="role" select="'seealso'"/>
              </xsl:call-template>
            </xsl:for-each>
          </ul>
        </xsl:if>
      </div>
    </div>
  </xsl:if>
</xsl:template>


<!--**==========================================================================
mal2html.page.autolink
Outputs an automatic link for a related page
$page: The element from the cache file of the page being linked to

REMARK: Describe this template
-->
<xsl:template name="mal2html.page.autolink">
  <xsl:param name="page"/>
  <xsl:param name="xref" select="$page/@id"/>
  <xsl:param name="role" select="''"/>
  <li class="autolink">
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="mal.link.target">
          <xsl:with-param name="xref" select="$xref"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:call-template name="mal.link.content">
        <xsl:with-param name="node" select="."/>
        <xsl:with-param name="xref" select="$xref"/>
        <xsl:with-param name="role" select="$role"/>
      </xsl:call-template>
    </a>
    <xsl:for-each select="$mal.cache">
      <xsl:variable name="desc" select="key('mal.cache.key', $xref)/mal:info/mal:desc"/>
      <xsl:if test="$desc">
        <span class="desc">
          <xsl:text> &#x2014; </xsl:text>
          <xsl:apply-templates mode="mal2html.inline.mode" select="$desc/node()"/>
        </span>
      </xsl:if>
    </xsl:for-each>
  </li>
</xsl:template>


<!--**==========================================================================
mal2html.page.linktrails
FIXME

REMARK: Describe this template
-->
<xsl:template name="mal2html.page.linktrails">
  <xsl:param name="node" select="."/>
  <xsl:param name="id">
    <xsl:choose>
      <xsl:when test="$node/self::mal:page or contains($node/@id, '#')">
        <xsl:value-of select="$node/@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$node/ancestor::mal:page/@id"/>
        <xsl:text>#</xsl:text>
        <xsl:value-of select="$node/@id"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="trailid" select="$id"/>
  <xsl:param name="trail" select="''"/>
  <xsl:variable name="traillist" select="str:split($trail, ':')"/>
  <xsl:if test="count($traillist) &lt; 5">
    <xsl:choose>
      <xsl:when test="$id = 'index'">
        <xsl:if test="$trail != ''">
          <xsl:variable name="fulltrail"
                        select="str:split(concat($trailid, $trail), ':')"/>
          <div class="linktrail">
            <xsl:for-each select="$fulltrail">
              <a class="linktrail">
                <xsl:attribute name="href">
                  <xsl:call-template name="mal.link.target">
                    <xsl:with-param name="xref" select="."/>
                  </xsl:call-template>
                </xsl:attribute>
                <xsl:call-template name="mal.link.content">
                  <xsl:with-param name="xref" select="."/>
                  <xsl:with-param name="role" select="'guide'"/>
                </xsl:call-template>
              </a>
              <xsl:text> » </xsl:text>
            </xsl:for-each>
          </div>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="guidelinks"
                      select="$node/mal:info/mal:link[@type = 'guide']"/>
        <xsl:variable name="pagelinks"
                      select="$mal.cache//*[mal:info/mal:link[@type = 'topic'][@xref = $id]]"/>
        <xsl:if test="not($guidelinks or $pagelinks) and $node/self::mal:section">
          <xsl:call-template name="mal2html.page.linktrails">
            <xsl:with-param name="node" select="$node/ancestor::mal:page"/>
            <xsl:with-param name="trailid" select="$trailid"/>
            <xsl:with-param name="trail" select="$trail"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:variable name="newtrail">
          <xsl:choose>
            <xsl:when test="$trail = ''">
              <xsl:text>:</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat(':', $trailid, $trail)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:for-each select="$guidelinks">
          <xsl:variable name="fullid">
            <xsl:choose>
              <xsl:when test="contains(@xref, '#')">
                <xsl:variable name="pageid" select="substring-before(@xref, '#')"/>
                <xsl:variable name="sectionid" select="substring-after(@xref, '#')"/>
                <xsl:if test="$pageid = ''">
                  <xsl:value-of select="ancestor::mal:page/@id"/>
                </xsl:if>
                <xsl:value-of select="concat($pageid, '#', $sectionid)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@xref"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:for-each select="$mal.cache">
            <xsl:call-template name="mal2html.page.linktrails">
              <xsl:with-param name="node" select="key('mal.cache.key', $fullid)"/>
              <xsl:with-param name="trail" select="$newtrail"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:for-each>
        <xsl:for-each select="$pagelinks">
          <xsl:call-template name="mal2html.page.linktrails">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="trail" select="$newtrail"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>


<!-- == Matched Templates == -->

<!-- = / = -->
<xsl:template match="/">
  <xsl:choose>
    <xsl:when test="$mal.chunk.chunk_top">
      <xsl:call-template name="mal.chunk">
        <xsl:with-param name="node" select="mal:page"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="mal.chunk.content.mode" select="mal:page"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- = mal:page % mal.chunk.content.mode = -->
<xsl:template mode="mal.chunk.content.mode" match="mal:page">
  <!-- FIXME: find a way to just select the version element -->
  <xsl:variable name="date">
    <xsl:for-each select="mal:info/mal:revision">
      <xsl:sort select="@date" data-type="text" order="descending"/>
      <xsl:if test="position() = 1">
        <xsl:value-of select="@date"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="revision"
                select="mal:info/mal:revision[@date = $date][last()]"/>
  <html>
    <head>
      <title>
        <xsl:value-of select="mal:title"/>
      </title>
      <xsl:call-template name="mal2html.css"/>
    </head>
    <body>
      <div class="head">
        <xsl:call-template name="mal2html.page.linktrails">
          <xsl:with-param name="node" select="."/>
        </xsl:call-template>
      </div>
      <div class="body">
        <xsl:if test="$mal2html.editor_mode and $revision/@status != ''">
          <div class="version">
            <!-- FIXME: i18n -->
            <div class="title">
              <xsl:choose>
                <xsl:when test="$revision/@status = 'stub'">
                  <xsl:call-template name="l10n.gettext">
                    <xsl:with-param name="msgid" select="'Stub'"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$revision/@status = 'incomplete'">
                  <xsl:call-template name="l10n.gettext">
                    <xsl:with-param name="msgid" select="'Incomplete'"/>
                   </xsl:call-template>
                </xsl:when>
                <xsl:when test="$revision/@status = 'draft'">
                  <xsl:call-template name="l10n.gettext">
                    <xsl:with-param name="msgid" select="'Draft'"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$revision/@status = 'review'">
                  <xsl:call-template name="l10n.gettext">
                    <xsl:with-param name="msgid" select="'Ready for review'"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$revision/@status = 'final'">
                  <xsl:call-template name="l10n.gettext">
                    <xsl:with-param name="msgid" select="'Final'"/>
                  </xsl:call-template>
                </xsl:when>
              </xsl:choose>
            </div>
            <p class="version">
              <!-- FIXME: i18n -->
              <xsl:text>Version </xsl:text>
              <xsl:value-of select="$revision/@version"/>
              <xsl:text> on </xsl:text>
              <xsl:value-of select="$revision/@date"/>
            </p>
            <xsl:apply-templates mode="mal2html.block.mode" select="$revision/*"/>
          </div>
        </xsl:if>
        <xsl:apply-templates select="."/>
      </div>
      <xsl:call-template name="mal2html.page.copyrights">
        <xsl:with-param name="node" select="."/>
      </xsl:call-template>
    </body>
  </html>
</xsl:template>

<!-- = page = -->
<xsl:template match="mal:page">
  <div class="header">
    <xsl:apply-templates mode="mal2html.title.mode" select="mal:title"/>
    <xsl:apply-templates mode="mal2html.title.mode" select="mal:subtitle"/>
  </div>
  <div class="contents">
    <xsl:for-each
        select="mal:*[not(self::mal:section or self::mal:title or self::mal:subtitle)
                and ($mal2html.editor_mode or not(self::mal:comment)
                or processing-instruction('mal2html.show_comment'))]">
      <xsl:apply-templates mode="mal2html.block.mode" select=".">
        <xsl:with-param name="first_child" select="position() = 1"/>
      </xsl:apply-templates>
    </xsl:for-each>
    <xsl:if test="@type = 'guide'">
      <xsl:call-template name="mal2html.page.pagelinks"/>
    </xsl:if>
  </div>
  <xsl:apply-templates select="mal:section"/>
  <xsl:call-template name="mal2html.page.autolinks">
    <xsl:with-param name="node" select="."/>
  </xsl:call-template>
</xsl:template>

<!-- = section = -->
<xsl:template match="mal:section">
  <div class="section" id="{@id}">
    <div class="header">
      <xsl:apply-templates mode="mal2html.title.mode" select="mal:title"/>
      <xsl:apply-templates mode="mal2html.title.mode" select="mal:subtitle"/>
    </div>
    <div class="contents">
      <xsl:for-each
          select="mal:*[not(self::mal:section or self::mal:title or self::mal:subtitle)
                  and ($mal2html.editor_mode or not(self::mal:comment)
                  or processing-instruction('mal2html.show_comment'))]">
        <xsl:apply-templates mode="mal2html.block.mode" select=".">
          <xsl:with-param name="first_child" select="position() = 1"/>
        </xsl:apply-templates>
      </xsl:for-each>
      <xsl:if test="/mal:page/@type = 'guide'">
        <xsl:call-template name="mal2html.page.pagelinks"/>
      </xsl:if>
    </div>
    <xsl:apply-templates select="mal:section"/>
    <xsl:call-template name="mal2html.page.autolinks">
      <xsl:with-param name="node" select="."/>
    </xsl:call-template>
  </div>
</xsl:template>

<!-- = subtitle = -->
<xsl:template mode="mal2html.title.mode" match="mal:subtitle">
  <!-- FIXME -->
</xsl:template>

<!-- = title = -->
<xsl:template mode="mal2html.title.mode" match="mal:title">
  <xsl:variable name="depth"
                select="count(ancestor::mal:section) + 1"/>
  <xsl:element name="{concat('h', $depth)}" namespace="{$mal2html.namespace}">
    <xsl:attribute name="class">
      <xsl:text>title</xsl:text>
    </xsl:attribute>
    <xsl:apply-templates mode="mal2html.inline.mode"/>
  </xsl:element>
</xsl:template>

</xsl:stylesheet>
