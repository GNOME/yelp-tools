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
		xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                xmlns:msg="http://www.gnome.org/~shaunm/gnome-doc-utils/l10n"
                xmlns:math="http://exslt.org/math"
		exclude-result-prefixes="doc"
                extension-element-prefixes="math"
                version="1.0">

<doc:title>Localized Numbers</doc:title>

<xsl:include href="gettext.xsl"/>


<!-- == l10n.number ======================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>l10n.number</name>
  <purpose>
    Format a number according to a localized numbering system
  </purpose>
  <parameter>
    <name>value</name>
    <purpose>
      The numeric value of the number to format
    </purpose>
  </parameter>
  <parameter>
    <name>format</name>
    <purpose>
      The identifier of the numbering system to use
    </purpose>
  </parameter>
</template>

<xsl:template name="l10n.number">
  <xsl:param name="value"/>
  <xsl:param name="format"/>
  <xsl:choose>
    <xsl:when test="$format='decimal' or $format='1'">
      <xsl:number format="1" value="$value"/>
    </xsl:when>
    <xsl:when test="$format='lower-alpha' or $format='a'">
      <xsl:number format="a" value="$value"/>
    </xsl:when>
    <xsl:when test="$format='upper-alpha' or $format='A'">
      <xsl:number format="A" value="$value"/>
    </xsl:when>
    <xsl:when test="$format='lower-roman' or $format='i'">
      <xsl:number format="i" value="$value"/>
    </xsl:when>
    <xsl:when test="$format='upper-roman' or $format='I'">
      <xsl:number format="I" value="$value"/>
    </xsl:when>
    <xsl:when test="$format='ionic-lower' or $format='ionic-upper'">
      <xsl:call-template name="l10n.number.ionic">
        <xsl:with-param name="value" select="$value"/>
        <xsl:with-param name="format" select="$format"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$format='persian-decimal'">
      <xsl:call-template name="l10n.number.numeric">
        <xsl:with-param name="value" select="$value"/>
        <xsl:with-param name="digits" select="'۰۱۲۳۴۵۶۷۸۹'"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$format='serbian-lower-alpha'">
      <xsl:call-template name="l10n.number.alphabetic">
        <xsl:with-param name="value" select="$value"/>
        <xsl:with-param name="alphabet"
                        select="'абвгдђежзијклљмнњопрстћуфхцчџш'"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$format='serbian-upper-alpha'">
      <xsl:call-template name="l10n.number.alphabetic">
        <xsl:with-param name="value" select="$value"/>
        <xsl:with-param name="alphabet"
                        select="'АБВГДЂЕЖЗИЈКЛЉМНЊОПРСТЋУФХЦЧЏШ'"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$format='thai-alpha'">
      <xsl:call-template name="l10n.number.alphabetic">
        <xsl:with-param name="value" select="$value"/>
        <xsl:with-param name="alphabet"
                        select="'กขคงจฉชซฌญฎฏฐฑฒณดตถทธนบปผฝพฟภมยรฤลฦวศษสหฬอฮ'"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$format='thai-decimal'">
      <xsl:call-template name="l10n.number.numeric">
        <xsl:with-param name="value" select="$value"/>
        <xsl:with-param name="digits" select="'๐๑๒๓๔๕๖๗๘๙'"/>
      </xsl:call-template>
    </xsl:when>
  </xsl:choose>
</xsl:template>


<!-- == l10n.number.alphabetic ============================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>l10n.number.alphabetic</name>
  <purpose>
    Format a number using an alphabet
  </purpose>
  <parameter>
    <name>value</name>
    <purpose>
      The numeric value of the number to format
    </purpose>
  </parameter>
  <parameter>
    <name>alphabet</name>
    <purpose>
      A string containing the alphabet to use
    </purpose>
  </parameter>
</template>

<xsl:template name="l10n.number.alphabetic">
  <xsl:param name="value"/>
  <xsl:param name="alphabet"/>
  <xsl:variable name="length" select="string-length($alphabet)"/>
  <xsl:choose>
    <xsl:when test="$value &lt;= 0">
      <xsl:number format="1" value="$value"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="digit">
        <xsl:choose>
          <xsl:when test="$value mod $length = 0">
            <xsl:value-of select="$length"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$value mod $length"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="$value - $digit != 0">
        <xsl:call-template name="l10n.number.alphabetic">
          <xsl:with-param name="value" select="($value - $digit) div $length"/>
          <xsl:with-param name="alphabet" select="$alphabet"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:value-of select="substring($alphabet, $digit, 1)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- == l10n.number.numeric ================================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>l10n.number.numeric</name>
  <purpose>
    Format a number using a numeric system with any radix
  </purpose>
  <parameter>
    <name>value</name>
    <purpose>
      The numeric value of the number to format
    </purpose>
  </parameter>
  <parameter>
    <name>digits</name>
    <purpose>
      A string containing the digits to use, starting with zero
    </purpose>
  </parameter>
</template>

<xsl:template name="l10n.number.numeric">
  <xsl:param name="value"/>
  <xsl:param name="digits"/>
  <xsl:param name="length" select="string-length($digits)"/>
  <xsl:choose>
    <xsl:when test="$value &lt; 0">
      <!-- FIXME: We need to localize the negative sign -->
      <xsl:text>-</xsl:text>
      <xsl:call-template name="l10n.number.numeric">
        <xsl:with-param name="value" select="math:abs($value)"/>
        <xsl:with-param name="digits" select="$digits"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="digit" select="$value mod $length"/>
      <xsl:if test="$value - $digit != 0">
        <xsl:call-template name="l10n.number.numeric">
          <xsl:with-param name="value" select="($value - $digit) div $length"/>
          <xsl:with-param name="digits" select="$digits"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:value-of select="substring($digits, $digit + 1, 1)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- == l10n.number.ionic ================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>l10n.number.ionic</name>
  <purpose>
    Format a number using the Ionic numeral system
  </purpose>
  <parameter>
    <name>value</name>
    <purpose>
      The numeric value of the number to format
    </purpose>
  </parameter>
  <parameter>
    <name>format</name>
    <purpose>
      Which format to use
    </purpose>
  </parameter>
  <para>See <ulink url="http://en.wikipedia.org/wiki/Greek_numerals"/>.</para>
</template>

<xsl:template name="l10n.number.ionic">
  <xsl:param name="value"/>
  <xsl:param name="format" select="'ionic-lower'"/>
  <xsl:choose>
    <xsl:when test="$value &lt; 1 or $value &gt; 999999">
      <xsl:number format="1" value="$value"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="l10n.number.ionic.private">
        <xsl:with-param name="value" select="$value"/>
        <xsl:with-param name="format" select="'ionic-lower'"/>
        <xsl:with-param name="level" select="1"/>
      </xsl:call-template>
      <xsl:text>´</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="l10n.number.ionic.private" doc:private="true">
  <xsl:param name="value"/>
  <xsl:param name="format" select="'ionic-lower'"/>
  <xsl:param name="level" select="1"/>
  <xsl:param name="stigma" select="false()"/>
  <xsl:variable name="digit" select="$value mod 10"/>
  <xsl:if test="$value - $digit &gt; 0">
    <xsl:call-template name="l10n.number.ionic.private">
      <xsl:with-param name="value" select="($value - $digit) div 10"/>
      <xsl:with-param name="format" select="$format"/>
      <xsl:with-param name="level" select="$level + 1"/>
      <xsl:with-param name="stigma" select="$stigma"/>
    </xsl:call-template>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="$format='ionic-lower'">
      <xsl:choose>
        <xsl:when test="$digit = 0"/>
        <xsl:when test="not($stigma) and $digit = 6 and $level = 1">
          <xsl:text>στ</xsl:text>
        </xsl:when>
        <xsl:when test="$level = 1 or $level = 4">
          <xsl:if test="$level = 4">
            <xsl:text>,</xsl:text>
          </xsl:if>
          <xsl:value-of select="substring('αβγδεϛζηθ', $digit, 1)"/>
        </xsl:when>
        <xsl:when test="$level = 2 or $level = 5">
          <xsl:if test="$level = 5">
            <xsl:text>,</xsl:text>
          </xsl:if>
          <xsl:value-of select="substring('ικλμνξοπϟ', $digit, 1)"/>
        </xsl:when>
        <xsl:when test="$level = 3 or $level = 6">
          <xsl:if test="$level = 6">
            <xsl:text>,</xsl:text>
          </xsl:if>
          <xsl:value-of select="substring('ρστυφχψωϡ', $digit, 1)"/>
        </xsl:when>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="$format='ionic-upper'">
      <xsl:choose>
        <xsl:when test="$digit = 0"/>
        <xsl:when test="not($stigma) and $digit = 6 and $level = 1">
          <xsl:text>ΣΤ</xsl:text>
        </xsl:when>
        <xsl:when test="not($stigma) and $digit = 6 and $level = 1">
          <xsl:text>,Σ,Τ</xsl:text>
        </xsl:when>
        <xsl:when test="$level = 1 or $level = 4">
          <xsl:if test="$level = 4">
            <xsl:text>,</xsl:text>
          </xsl:if>
          <xsl:value-of select="substring('ΑΒΓΔΕϚΖΗΘ', $digit, 1)"/>
        </xsl:when>
        <xsl:when test="$level = 2 or $level = 5">
          <xsl:if test="$level = 5">
            <xsl:text>,</xsl:text>
          </xsl:if>
          <xsl:value-of select="substring('ΙΚΛΜΝΞΟΠϘ', $digit, 1)"/>
        </xsl:when>
        <xsl:when test="$level = 3 or $level = 6">
          <xsl:if test="$level = 6">
            <xsl:text>,</xsl:text>
          </xsl:if>
          <xsl:value-of select="substring('ΡΣΤΥΦΧΨΩϠ', $digit, 1)"/>
        </xsl:when>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$digit"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
