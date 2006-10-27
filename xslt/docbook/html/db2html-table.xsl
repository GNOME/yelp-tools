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
DocBook to HTML - Tables

REMARK: This needs lots of talk about CALS
-->


<!--@@==========================================================================
db2html.table.rule_color
The color used for alternating-color rules on table rows

REMARK: Describe this param
-->
<xsl:param name="db2html.table.rule_color" select="'#F0F0F0'"/>


<!--**==========================================================================
db2html.table.css
Outputs CSS that controls the appearance of table elements

REMARK: Describe this template
-->
<xsl:template name="db2html.table.css">
<xsl:text>
table {
  border-collapse: collapse;
  border: solid 1px;
  -moz-border-radius: 5px;
}
</xsl:text>
<xsl:if test="$db2html.table.rule_color">
  <xsl:text>tr.odd { background-color: </xsl:text>
  <xsl:value-of select="$db2html.table.rule_color"/>
  <xsl:text> }</xsl:text>
</xsl:if><xsl:text>
td { padding: 4px 0.83em 4px 0.83em; }
th { padding-left: 0.8em; padding-right: 0.83em; }
thead {
  border-top: solid 2px;
  border-bottom: solid 2px;
}
tfoot {
  border-top: solid 2px;
  border-bottom: solid 2px;
}
td + td {
  border-left: solid 1px;
}
tbody {
  border: solid 1px;
  -moz-border-radius: 5px;
}
</xsl:text>
</xsl:template>


<!--**==========================================================================
db2html.entry.colnum
Calculates the column number for an #{entry} element
$colspecs: The #{colspec} elements currently in scope
$spanspecs: The #{spanspec} elements currently in scope
$entry: The #{entry} element to process
$colnum: The default column number, as passed by the preceding sibling

REMARK: This template needs to be explained in detail, but I forgot how it works.
-->
<xsl:template name="db2html.entry.colnum">
  <xsl:param name="colspecs"/>
  <xsl:param name="spanspecs"/>
  <xsl:param name="entry" select="."/>
  <xsl:param name="colnum" select="0"/>
  <xsl:choose>
    <xsl:when test="$entry/@spanname">
      <xsl:variable name="spanspec"
                    select="$spanspecs[@spanname = $entry/@spanname]"/>
      <xsl:variable name="colspec"
                    select="$colspecs[@colname = $spanspec/@namest]"/>
      <xsl:call-template name="db2html.colspec.colnum">
        <xsl:with-param name="colspecs" select="$colspecs"/>
        <xsl:with-param name="spanspecs" select="$spanspecs"/>
        <xsl:with-param name="colspec" select="$colspec"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$entry/@colname">
      <xsl:variable name="colspec"
                    select="$colspecs[@colname = $entry/@colname]"/>
      <xsl:call-template name="db2html.colspec.colnum">
        <xsl:with-param name="colspecs" select="$colspecs"/>
        <xsl:with-param name="spanspecs" select="$spanspecs"/>
        <xsl:with-param name="colspec" select="$colspec"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$entry/@namest">
      <xsl:variable name="colspec"
                    select="$colspecs[@colname = $entry/@namest]"/>
      <xsl:call-template name="db2html.colspec.colnum">
        <xsl:with-param name="colspecs" select="$colspecs"/>
        <xsl:with-param name="spanspecs" select="$spanspecs"/>
        <xsl:with-param name="colspec" select="$colspec"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$colnum"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--**==========================================================================
db2html.colspec.colnum
Calculates the column number for a #{colspec} element
$colspecs: The #{colspec} elements currently in scope
$spanspecs: The #{spanspec} elements currently in scope
$colspec: The #{colspec} element to process

REMARK: This template needs to be explained in detail, but I forgot how it works.
-->
<xsl:template name="db2html.colspec.colnum">
  <xsl:param name="colspecs"/>
  <xsl:param name="spanspecs"/>
  <xsl:param name="colspec" select="."/>
  <xsl:choose>
    <xsl:when test="$colspec/@colnum">
      <xsl:value-of select="$colspec/@colnum"/>
    </xsl:when>
    <xsl:when test="$colspec/preceding-sibling::colspec">
      <xsl:variable name="prec.colspec.colnum">
        <xsl:call-template name="db2html.colspec.colnum">
          <xsl:with-param name="colspecs"  select="$colspecs"/>
          <xsl:with-param name="spanspecs" select="$spanspecs"/>
          <xsl:with-param name="colspec"
                          select="$colspec/preceding-sibling::colspec[1]"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="$prec.colspec.colnum + 1"/>
    </xsl:when>
    <xsl:otherwise>1</xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--**==========================================================================
db2html.entry.colspan
Calculates the #{colspan} for an #{entry} element
$colspecs: The #{colspec} elements currently in scope
$spanspecs: The #{spanspec} elements currently in scope
$entry: The #{entry} element to process

REMARK: This template needs to be explained in detail, but I forgot how it works.
-->
<xsl:template name="db2html.entry.colspan">
  <xsl:param name="colspecs"/>
  <xsl:param name="spanspecs"/>
  <xsl:param name="entry" select="."/>
  <xsl:variable name="namest">
    <xsl:choose>
      <xsl:when test="$entry/@spanname">
        <xsl:value-of
         select="$spanspecs[@spanname = $entry/@spanname]/@namest"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$entry/@namest"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="nameend">
    <xsl:choose>
      <xsl:when test="$entry/@spanname">
        <xsl:value-of
         select="$spanspecs[@spanname = $entry/@spanname]/@nameend"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$entry/@nameend"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="colnumst">
    <xsl:call-template name="db2html.colspec.colnum">
      <xsl:with-param name="colspecs"  select="$colspecs"/>
      <xsl:with-param name="spanspecs" select="$spanspecs"/>
      <xsl:with-param name="colspec"   select="$colspecs[@colname = $namest]"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="colnumend">
    <xsl:call-template name="db2html.colspec.colnum">
      <xsl:with-param name="colspecs"  select="$colspecs"/>
      <xsl:with-param name="spanspecs" select="$spanspecs"/>
      <xsl:with-param name="colspec"   select="$colspecs[@colname = $nameend]"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$namest = '' or $nameend = ''">1</xsl:when>
    <xsl:when test="$colnumend &gt; $colnumst">
      <xsl:value-of select="$colnumend - $colnumst + 1"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$colnumst - $colnumend + 1"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--**==========================================================================
db2html.entry.style
Generates the #{style} attribute for an #{entry} element
$colspecs: The #{colspec} elements currently in scope
$spanspecs: The #{spanspec} elements currently in scope

REMARK: This template needs to be explained in detail, but I forgot how it works.
-->
<xsl:template name="db2html.entry.style">
  <!-- FIXME: we should pass in the entry node -->
  <xsl:param name="colspecs"/>
  <xsl:param name="spanspecs"/>
  <xsl:param name="colsep" select="false()"/>
  <xsl:param name="rowsep" select="false()"/>
  <xsl:if test="(following-sibling::*) and (
          (@colsep = '1') or
          ($colspecs[@colname = current()/@colname]/@colsep = '1')    or
          ($colspecs[@colname = current()/@nameend]/@colsep = '1')    or
          ($spanspecs[@spanname = current()/@spanname]/@colsep = '1') or
          ($colsep = '1' and (
            (@colsep != '0') or
            ($colspecs[@colname = current()/@colname]/@colsep != '0')    or
            ($colspecs[@colname = current()/@nameend]/@colsep != '0')    or
            ($spanspecs[@spanname = current()/@spanname]/@colsep != '0')
          )) )">
    <xsl:text>border-right: outset 1px; </xsl:text>
  </xsl:if>
  <xsl:if test="(../following-sibling::*) and (
          (@rowsep = '1') or
          ($colspecs[@colname = current()/@colname]/@rowsep = '1')    or
          ($colspecs[@colname = current()/@namest]/@rowsep = '1')     or
          ($spanspecs[@spanname = current()/@spanname]/@rowsep = '1') or
          ($rowsep = '1' and (
            (@rowsep != '0') or
            ($colspecs[@colname = current()/@colname]/@rowsep != '0') or
            ($colspecs[@colname = current()/@namest]/@rowsep != '0') or
            ($spanspecs[@spanname = current()/@spanname]/@rowsep != '0')
          )) )">
    <xsl:text>border-bottom: outset 1px; </xsl:text>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="@align">
      <xsl:text>text-align: </xsl:text>
      <xsl:value-of select="@align"/>
      <xsl:text>; </xsl:text>
    </xsl:when>
    <xsl:when test="$colspecs[@colname = current()/@colname]/@align">
      <xsl:text>text-align: </xsl:text>
      <xsl:value-of
       select="$colspecs[@colname = current()/@colname]/@align"/>
      <xsl:text>; </xsl:text>
    </xsl:when>
    <xsl:when test="$colspecs[@colname = current()/@namest]/@align">
      <xsl:text>text-align: </xsl:text>
      <xsl:value-of
       select="$colspecs[@colname = current()/@namest]/@align"/>
      <xsl:text>; </xsl:text>
    </xsl:when>
    <xsl:when test="$spanspecs[@spanname = current()/@spanname]/@align">
      <xsl:text>text-align: </xsl:text>
      <xsl:value-of
       select="$spanspecs[@spanname = current()/@spanname]/@align"/>
      <xsl:text>; </xsl:text>
    </xsl:when>
    <xsl:when test="../../../@align">
      <xsl:text>text-align: </xsl:text>
      <xsl:value-of select="../../../@align"/>
      <xsl:text>; </xsl:text>
    </xsl:when>
  </xsl:choose>
  <xsl:choose>
    <xsl:when test="@valign">
      <xsl:text>vertical-align: </xsl:text>
      <xsl:value-of select="@valign"/>
      <xsl:text>; </xsl:text>
    </xsl:when>
    <xsl:when test="$colspecs[@colname = current()/@colname]/@valign">
      <xsl:text>vertical-align: </xsl:text>
      <xsl:value-of
       select="$colspecs[@colname = current()/@colname]/@valign"/>
      <xsl:text>; </xsl:text>
    </xsl:when>
    <xsl:when test="$colspecs[@colname = current()/@namest]/@valign">
      <xsl:text>vertical-align: </xsl:text>
      <xsl:value-of
       select="$colspecs[@colname = current()/@namest]/@valign"/>
      <xsl:text>; </xsl:text>
    </xsl:when>
    <xsl:when test="$spanspecs[@spanname = current()/@spanname]/@valign">
      <xsl:text>vertical-align: </xsl:text>
      <xsl:value-of
       select="$spanspecs[@spanname = current()/@spanname]/@valign"/>
      <xsl:text>; </xsl:text>
    </xsl:when>
    <xsl:when test="../@valign">
      <xsl:text>vertical-align: </xsl:text>
      <xsl:value-of select="../@valign"/>
      <xsl:text>; </xsl:text>
    </xsl:when>
    <xsl:when test="../../@valign">
      <xsl:text>vertical-align: </xsl:text>
      <xsl:value-of select="../../@valign"/>
      <xsl:text>; </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>vertical-align: top; </xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--**==========================================================================
db2html.spanstr
FIXME

REMARK: This template needs to be explained in detail, but I forgot how it works.
-->
<xsl:template name="db2html.spanstr">
  <xsl:param name="colspecs"/>
  <xsl:param name="spanspecs"/>
  <xsl:param name="spanstr"/>
  <xsl:param name="row"    select="."/>
  <xsl:param name="entry"  select="$row/*[1]"/>
  <xsl:param name="colnum" select="1"/>
  <xsl:param name="entry.colnum">
    <xsl:call-template name="db2html.entry.colnum">
      <xsl:with-param name="colspecs"  select="$colspecs"/>
      <xsl:with-param name="spanspecs" select="$spanspecs"/>
      <xsl:with-param name="entry"     select="$entry"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="entry.colspan">
    <xsl:choose>
      <xsl:when test="$entry/@spanname or $entry/@namest">
        <xsl:call-template name="db2html.entry.colspan">
          <xsl:with-param name="colspecs"  select="$colspecs"/>
          <xsl:with-param name="spanspecs" select="$spanspecs"/>
          <xsl:with-param name="entry"     select="$entry"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:variable name="following.spanstr">
    <xsl:call-template name="db2html.spanstr.pop">
      <xsl:with-param name="colspecs"  select="$colspecs"/>
      <xsl:with-param name="spanspecs" select="$spanspecs"/>
      <xsl:with-param name="colspan"   select="$entry.colspan"/>
      <xsl:with-param name="spanstr"   select="$spanstr"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$spanstr != '' and not(starts-with($spanstr, '0:'))">
      <xsl:value-of select="substring-before($spanstr, ':') - 1"/>
      <xsl:text>:</xsl:text>
      <xsl:call-template name="db2html.spanstr">
        <xsl:with-param name="colspecs"  select="$colspecs"/>
        <xsl:with-param name="spanspecs" select="$spanspecs"/>
        <xsl:with-param name="spanstr"   select="substring-after($spanstr, ':')"/>
        <xsl:with-param name="row"       select="$row"/>
        <xsl:with-param name="entry"     select="$entry"/>
        <xsl:with-param name="colnum"    select="$colnum + 1"/>
        <xsl:with-param name="entry.colnum"  select="$entry.colnum"/>
        <xsl:with-param name="entry.colspan" select="$entry.colspan"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$entry.colnum &gt; $colnum">
      <xsl:text>0:</xsl:text>
      <xsl:call-template name="db2html.spanstr">
        <xsl:with-param name="colspecs"  select="$colspecs"/>
        <xsl:with-param name="spanspecs" select="$spanspecs"/>
        <xsl:with-param name="spanstr"   select="$following.spanstr"/>
        <xsl:with-param name="row"       select="$row"/>
        <xsl:with-param name="entry"     select="$entry"/>
        <xsl:with-param name="colnum"    select="$colnum + $entry.colspan"/>
        <xsl:with-param name="entry.colnum"  select="$entry.colnum"/>
        <xsl:with-param name="entry.colspan" select="$entry.colspan"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="copy-string">
        <xsl:with-param name="count" select="$entry.colspan"/>
        <xsl:with-param name="string">
          <xsl:choose>
            <xsl:when test="$entry/@morerows">
              <xsl:value-of select="$entry/@morerows"/>
            </xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
          </xsl:choose>
          <xsl:text>:</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:if test="$entry/following-sibling::*">
        <xsl:call-template name="db2html.spanstr">
          <xsl:with-param name="colspecs"  select="$colspecs"/>
          <xsl:with-param name="spanspecs" select="$spanspecs"/>
          <xsl:with-param name="spanstr"   select="$following.spanstr"/>
          <xsl:with-param name="row"       select="$row"/>
          <xsl:with-param name="entry"     select="$entry/following-sibling::*[1]"/>
          <xsl:with-param name="colnum"    select="$colnum + $entry.colspan"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--**==========================================================================
db2html.spanstr.pop
Calculates the remaining spans after an #{entry} element
$colspecs: The #{colspec} elements currently in scope
$spanspecs: The #{spanspec} elements currently in scope
$colspan: The number of columns to pop
$spanstr: The string representation of the column spans

REMARK: This template needs to be explained in detail, but I forgot how it works.
-->
<xsl:template name="db2html.spanstr.pop">
  <xsl:param name="colspecs"/>
  <xsl:param name="spanspecs"/>
  <xsl:param name="colspan" select="1"/>
  <xsl:param name="spanstr" select="''"/>
  <xsl:choose>
    <xsl:when test="$colspan &gt; 0">
      <xsl:call-template name="db2html.spanstr.pop">
        <xsl:with-param name="colspecs"  select="$colspecs"/>
        <xsl:with-param name="spanspecs" select="$spanspecs"/>
        <xsl:with-param name="colspan"   select="$colspan - 1"/>
        <xsl:with-param name="spanstr"   select="substring-after($spanstr, ':')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$spanstr"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--#* copy-string -->
<xsl:template name="copy-string">
  <xsl:param name="count" select="1"/>
  <xsl:param name="string"/>
  <xsl:if test="$count &gt; 0">
    <xsl:value-of select="$string"/>
    <xsl:call-template name="copy-string">
      <xsl:with-param name="count" select="$count - 1"/>
      <xsl:with-param name="string" select="$string"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<!-- == Matched Templates == -->

<!-- = entry | entrytbl = -->
<xsl:template match="entry | entrytbl">
  <xsl:param name="colspecs"/>
  <xsl:param name="spanspecs"/>
  <xsl:param name="colsep" select="false()"/>
  <xsl:param name="rowsep" select="false()"/>
  <xsl:param name="colnum" select="1"/>
  <xsl:param name="spanstr"/>
  <xsl:param name="entry.colnum">
    <xsl:call-template name="db2html.entry.colnum">
      <xsl:with-param name="colspecs"  select="$colspecs"/>
      <xsl:with-param name="spanspecs" select="$spanspecs"/>
      <xsl:with-param name="entry"     select="."/>
      <xsl:with-param name="colnum"    select="$colnum"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="entry.colspan">
    <xsl:choose>
      <xsl:when test="@spanname or @namest">
        <xsl:call-template name="db2html.entry.colspan">
          <xsl:with-param name="colspecs"  select="$colspecs"/>
          <xsl:with-param name="spanspecs" select="$spanspecs"/>
          <xsl:with-param name="entry"     select="."/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:variable name="following.spanstr">
    <xsl:call-template name="db2html.spanstr.pop">
      <xsl:with-param name="colspecs"  select="$colspecs"/>
      <xsl:with-param name="spanspecs" select="$spanspecs"/>
      <xsl:with-param name="colspan"   select="$entry.colspan"/>
      <xsl:with-param name="spanstr"   select="$spanstr"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="element">
    <xsl:choose>
      <xsl:when test="
                local-name(../..) = 'thead' or
                local-name(../..) = 'tfoot' ">th</xsl:when>
      <xsl:otherwise>td</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="style">
    <xsl:call-template name="db2html.entry.style">
      <xsl:with-param name="colspecs"  select="$colspecs"/>
      <xsl:with-param name="spanspecs" select="$spanspecs"/>
      <xsl:with-param name="colsep"    select="$colsep"/>
      <xsl:with-param name="rowsep"    select="$rowsep"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$spanstr != '' and not(starts-with($spanstr, '0:'))">
      <xsl:apply-templates select=".">
        <xsl:with-param name="colspecs"  select="$colspecs"/>
        <xsl:with-param name="spanspecs" select="$spanspecs"/>
        <xsl:with-param name="colnum"    select="$colnum + 1"/>
        <xsl:with-param name="spanstr"   select="substring-after($spanstr, ':')"/>
        <xsl:with-param name="entry.colnum" select="$entry.colnum"/>
        <xsl:with-param name="entry.colspan" select="$entry.colspan"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="$entry.colnum &gt; $colnum">
      <td>
        <xsl:if test="$style">
          <xsl:attribute name="style">
            <xsl:value-of select="$style"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:text>&#160;</xsl:text>
      </td>
      <xsl:apply-templates select=".">
        <xsl:with-param name="colspecs"  select="$colspecs"/>
        <xsl:with-param name="spanspecs" select="$spanspecs"/>
        <xsl:with-param name="colnum"    select="$colnum + 1"/>
        <xsl:with-param name="spanstr"   select="substring-after($spanstr, ':')"/>
        <xsl:with-param name="entry.colnum"  select="$entry.colnum"/>
        <xsl:with-param name="entry.colspan" select="$entry.colspan"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="char">
        <xsl:choose>
          <xsl:when test="@char">
            <xsl:value-of select="@char"/>
          </xsl:when>
          <xsl:when test="$colspecs[@colname = current()/@colname]/@char">
            <xsl:value-of
             select="$colspecs[@colname = current()/@colname]/@char"/>
          </xsl:when>
          <xsl:when test="$colspecs[@colname = current()/@namest]/@char">
            <xsl:value-of
             select="$colspecs[@colname = current()/@namest]/@char"/>
          </xsl:when>
          <xsl:when test="$spanspecs[@spanname = current()/@spanname]/@char">
            <xsl:value-of
             select="$spanspecs[@spanname = current()/@spanname]/@char"/>
          </xsl:when>
          <xsl:when test="../../../@char">
            <xsl:value-of select="../../@char"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="charoff">
        <xsl:choose>
          <xsl:when test="@charoff">
            <xsl:value-of select="@charoff"/>
          </xsl:when>
          <xsl:when test="$colspecs[@colname = current()/@colname]/@charoff">
            <xsl:value-of
             select="$colspecs[@colname = current()/@colname]/@charoff"/>
          </xsl:when>
          <xsl:when test="$colspecs[@colname = current()/@namest]/@charoff">
            <xsl:value-of
             select="$colspecs[@colname = current()/@namest]/@charoff"/>
          </xsl:when>
          <xsl:when test="$spanspecs[@spanname = current()/@spanname]/@charoff">
            <xsl:value-of
             select="$spanspecs[@spanname = current()/@spanname]/@charoff"/>
          </xsl:when>
          <xsl:when test="../../../@charoff">
            <xsl:value-of select="../../@charoff"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:element name="{$element}" namespace="http://www.w3.org/1999/xhtml">
        <xsl:if test="$style != ''">
          <xsl:attribute name="style">
            <xsl:value-of select="$style"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="@morerows &gt; 0">
          <xsl:attribute name="rowspan">
            <xsl:value-of select="@morerows + 1"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="$entry.colspan &gt; 1">
          <xsl:attribute name="colspan">
            <xsl:value-of select="$entry.colspan"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="$char != ''">
          <xsl:attribute name="char">
            <xsl:value-of select="$char"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="$charoff != ''">
          <xsl:attribute name="charoff">
            <xsl:value-of select="$charoff"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
      </xsl:element>
      <xsl:apply-templates select="following-sibling::*[1]">
        <xsl:with-param name="colspecs"  select="$colspecs"/>
        <xsl:with-param name="spanspecs" select="$spanspecs"/>
        <xsl:with-param name="colsep"    select="$colsep"/>
        <xsl:with-param name="rowsep"    select="$rowsep"/>
        <xsl:with-param name="colnum"    select="$colnum + $entry.colspan"/>
        <xsl:with-param name="spanstr"   select="$following.spanstr"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- = row = -->
<xsl:template match="row">
  <xsl:param name="colspecs"/>
  <xsl:param name="spanspecs"/>
  <xsl:param name="colsep" select="false()"/>
  <xsl:param name="rowsep" select="false()"/>
  <xsl:param name="spanstr"/>
  <tr>
    <xsl:if test="name(..) = 'tbody'">
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="count(preceding-sibling::row) mod 2">odd</xsl:when>
          <xsl:otherwise>even</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates select="*[1]">
      <xsl:with-param name="colspecs" select="$colspecs"/>
      <xsl:with-param name="spanspecs" select="$spanspecs"/>
      <xsl:with-param name="colsep" select="$colsep"/>
      <xsl:with-param name="rowsep" select="
                      (@rowsep = '1') or ((@rowsep != '0') and $rowsep)"/>
      <xsl:with-param name="spanstr" select="$spanstr"/>
    </xsl:apply-templates>
  </tr>
  <xsl:if test="following-sibling::row">
    <xsl:apply-templates select="following-sibling::row[1]">
      <xsl:with-param name="colspecs"  select="$colspecs"/>
      <xsl:with-param name="spanspecs" select="$spanspecs"/>
      <xsl:with-param name="colsep"    select="$colsep"/>
      <xsl:with-param name="rowsep"    select="$rowsep"/>
      <xsl:with-param name="spanstr">
        <xsl:call-template name="db2html.spanstr">
          <xsl:with-param name="colspecs" select="$colspecs"/>
          <xsl:with-param name="spanspecs" select="$spanspecs"/>
          <xsl:with-param name="spanstr" select="$spanstr"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

<!-- = table = -->
<xsl:template match="table | informaltable">
  <div class="table block-indent">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:apply-templates select="title"/>
    <!-- FIXME: I have no idea what I'm supposed to do with textobject -->
    <xsl:choose>
      <xsl:when test="graphic | mediaobject">
        <xsl:apply-templates select="graphic | mediaobject"/>
      </xsl:when>
      <xsl:when test="tgroup">
        <xsl:apply-templates select="tgroup"/>
      </xsl:when>
      <!-- I am not going to allow the neurotic mixing of HTML and CALS
           that the DTD does. -->
      <xsl:when test="tr">
        <xsl:apply-templates select="col | colgroup | tr"/>
        <xsl:apply-templates select="caption"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="thead"/>
        <xsl:apply-templates select="tbody"/>
        <xsl:apply-templates select="tfoot"/>
        <xsl:apply-templates select="caption"/>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<!-- = tgroup = -->
<xsl:template match="tgroup">
  <xsl:variable name="style">
    <xsl:if test="../@frame = 'all'">
      <xsl:text>border: solid 1px; </xsl:text>
    </xsl:if>
    <xsl:if test="../@frame = 'none'">
      <xsl:text>border: none; </xsl:text>
    </xsl:if>
    <xsl:if test="../@frame = 'bottom' or ../@frame = 'topbot'">
      <xsl:text>border-bottom: solid 1px; </xsl:text>
    </xsl:if>
    <xsl:if test="../@frame = 'top' or ../@frame = 'topbot'">
      <xsl:text>border-top: solid 1px; </xsl:text>
    </xsl:if>
    <xsl:if test="../@frame = 'sides'">
      <xsl:text>border-left: solid 1px; border-right: outset 1px; </xsl:text>
    </xsl:if>
  </xsl:variable>
  <table>
    <xsl:if test="../title">
      <xsl:attribute name="summary">
        <xsl:value-of select="../title"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="../@pgwide = '1'">
      <xsl:attribute name="width">100%</xsl:attribute>
    </xsl:if>
    <xsl:if test="string($style) != ''">
      <xsl:attribute name="style">
        <xsl:value-of select="$style"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates select="thead">
      <xsl:with-param name="colspecs" select="colspec"/>
      <xsl:with-param name="spanspecs" select="spanspec"/>
      <xsl:with-param name="colsep" select="@colsep = '1'"/>
      <xsl:with-param name="rowsep" select="@rowsep = '1'"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="tbody">
      <xsl:with-param name="colspecs" select="colspec"/>
      <xsl:with-param name="spanspecs" select="spanspec"/>
      <xsl:with-param name="colsep" select="@colsep = '1'"/>
      <xsl:with-param name="rowsep" select="@rowsep = '1'"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="tfoot">
      <xsl:with-param name="colspecs" select="colspec"/>
      <xsl:with-param name="spanspecs" select="spanspec"/>
      <xsl:with-param name="colsep" select="@colsep = '1'"/>
      <xsl:with-param name="rowsep" select="@rowsep = '1'"/>
    </xsl:apply-templates>
  </table>
</xsl:template>

<!-- = tbody | tfoot | thead = -->
<xsl:template match="tbody | tfoot | thead">
  <xsl:param name="colspecs"/>
  <xsl:param name="spanspecs"/>
  <xsl:param name="colsep" select="false()"/>
  <xsl:param name="rowsep" select="false()"/>
  <xsl:element name="{local-name(.)}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:if test="@valign">
      <xsl:attribute name="valign">
        <xsl:value-of select="@valign"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="tr">
        <xsl:apply-templates select="tr"/>
      </xsl:when>
      <xsl:when test="colspec">
        <xsl:apply-templates select="row[1]">
          <xsl:with-param name="colspecs" select="colspec"/>
          <xsl:with-param name="spanspecs" select="spanspec"/>
          <xsl:with-param name="colsep" select="$colsep"/>
          <xsl:with-param name="rowsep" select="$rowsep"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="row[1]">
          <xsl:with-param name="colspecs" select="$colspecs"/>
          <xsl:with-param name="spanspecs" select="$spanspecs"/>
          <xsl:with-param name="colsep" select="$colsep"/>
          <xsl:with-param name="rowsep" select="$rowsep"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:element>
</xsl:template>

<!--
This template strips the p tag around single-paragraph table cells to avoid
introducing extra spacing.
-->
<xsl:template match="entry/para[
              not(preceding-sibling::* or following-sibling::*)]">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

</xsl:stylesheet>
