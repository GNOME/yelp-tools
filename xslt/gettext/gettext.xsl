<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                xmlns:msg="http://www.gnome.org/~shaunm/gnome-doc-utils/xsl-format"
		exclude-result-prefixes="doc"
                version="1.0">

<xsl:variable name="l10n" select="document('l10n.xml')"/>
<xsl:key name="msgid" match="msg:msg" use="msg:msgid"/>

<doc:title>Gettext</doc:title>


<!-- == gettext.locale ===================================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>gettext.locale</name>
  <description>
    The top-level locale of the document
  </description>
</parameter>

<xsl:param name="gettext.locale">
  <xsl:choose>
    <xsl:when test="/*/@xml:lang">
      <xsl:value-of select="/*/@xml:lang"/>
    </xsl:when>
    <xsl:when test="/*/@lang">
      <xsl:value-of select="/*/@lang"/>
    </xsl:when>
  </xsl:choose>
</xsl:param>


<!-- == gettext.language =================================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>gettext.language</name>
  <description>
    The language part of the top-level locale of the document
  </description>
</parameter>

<xsl:param name="gettext.language">
  <xsl:choose>
    <xsl:when test="contains($gettext.locale, '_')">
      <xsl:value-of select="substring-before($gettext.locale, '_')"/>
    </xsl:when>
    <xsl:when test="contains($gettext.locale, '@')">
      <xsl:value-of select="substring-before($gettext.locale, '@')"/>
    </xsl:when>
    <xsl:when test="contains($gettext.locale, '_')">
      <xsl:value-of select="substring-before($gettext.locale, '@')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$gettext.locale"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>


<!-- == gettext.region ===================================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>gettext.region</name>
  <description>
    The region part of the top-level locale of the document
  </description>
</parameter>

<xsl:param name="gettext.region">
  <xsl:variable name="aft" select="substring-after($gettext.locale, '_')"/>
  <xsl:choose>
    <xsl:when test="contains($aft, '@')">
      <xsl:value-of select="substring-before($aft, '@')"/>
    </xsl:when>
    <xsl:when test="contains($aft, '.')">
      <xsl:value-of select="substring-before($aft, '.')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$aft"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>


<!-- == gettext.variant ==================================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>gettext.variant</name>
  <description>
    The variant part of the top-level locale of the document
  </description>
</parameter>

<xsl:param name="gettext.variant">
  <xsl:variable name="aft" select="substring-after($gettext.locale, '@')"/>
  <xsl:choose>
    <xsl:when test="contains($aft, '.')">
      <xsl:value-of select="substring-before($aft, '.')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$aft"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>


<!-- == gettext.charset ==================================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>gettext.charset</name>
  <description>
    The charset part of the top-level locale of the document
  </description>
</parameter>

<xsl:param name="gettext.charset">
  <xsl:if test="contains($gettext.locale, '.')">
    <xsl:value-of select="substring-after($gettext.locale, '.')"/>
  </xsl:if>
</xsl:param>

<!-- == gettext ============================================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>gettext</name>
  <description>
    Look up a translated string
  </description>
  <parameter>
    <name>msgid</name>
    <description>
      The id of the string to look up, usually the string in the C locale
    </description>
  </parameter>
  <parameter>
    <name>lang</name>
    <description>
      The locale to use when looking up the translated string
    </description>
  </parameter>
  <parameter>
    <name>lang_lang</name>
    <description>
      The language portion of the locale to use
    </description>
  </parameter>
  <parameter>
    <name>lang_region</name>
    <description>
      The region portion of the locale to use
    </description>
  </parameter>
  <parameter>
    <name>lang_variant</name>
    <description>
      The variant portion of the locale to use
    </description>
  </parameter>
  <parameter>
    <name>lang_charset</name>
    <description>
      The charset portion of the locale to use
    </description>
  </parameter>
  <parameter>
    <name>number</name>
    <description>
      The cardinality for plural-form lookups
    </description>
  </parameter>
  <parameter>
    <name>form</name>
    <description>
      The form name for plural-form lookups
    </description>
  </parameter>
</template>

<xsl:template name="gettext">
  <xsl:param name="msgid"/>
  <xsl:param name="lang" select="ancestor-or-self::*[@lang][1]/@lang"/>
  <xsl:param name="lang_lang">
    <xsl:call-template name="gettext.get.language">
      <xsl:with-param name="lang" select="$lang"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="lang_region">
    <xsl:call-template name="gettext.get.region">
      <xsl:with-param name="lang" select="$lang"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="lang_variant">
    <xsl:call-template name="gettext.get.variant">
      <xsl:with-param name="lang" select="$lang"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="lang_charset">
    <xsl:call-template name="gettext.get.charset">
      <xsl:with-param name="lang" select="$lang"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="number"/>
  <xsl:param name="form">
    <xsl:call-template name="gettext.plural_form">
      <xsl:with-param name="number" select="$number"/>
      <xsl:with-param name="lang" select="$lang"/>
      <xsl:with-param name="lang_lang" select="$lang_lang"/>
      <xsl:with-param name="lang_region" select="$lang_region"/>
      <xsl:with-param name="lang_variant" select="$lang_variant"/>
      <xsl:with-param name="lang_charset" select="$lang_charset"/>
    </xsl:call-template>
  </xsl:param>

  <xsl:for-each select="$l10n">
    <xsl:variable name="msg" select="key('msgid', $msgid)"/>

    <xsl:choose>
      <!-- fe_fi@fo.fum -->
      <xsl:when test="($lang_region and $lang_variant and $lang_charset) and 
                $msg/msg:msgstr[@xml:lang = concat(
                $lang_lang, '_', $lang_region, '@', $lang_variant, '.', $lang_charset)]">
        <xsl:call-template name="gettext.get">
          <xsl:with-param
           name="msgstr" select="$msg/msg:msgstr[@xml:lang = concat(
           $lang_lang, '_', $lang_region, '@', $lang_variant, '.', $lang_charset)]"/>
          <xsl:with-param name="form" select="$form"/>
        </xsl:call-template>
      </xsl:when>
      <!-- fe_fi@fo -->
      <xsl:when test="($lang_region and $lang_variant) and
                $msg/msg:msgstr[@xml:lang = concat(
                $lang_lang, '_', $lang_region, '@', $lang_variant)]">
        <xsl:call-template name="gettext.get">
          <xsl:with-param
           name="msgstr" select="$msg/msg:msgstr[@xml:lang = concat(
           $lang_lang, '_', $lang_region, '@', $lang_variant)]"/>
          <xsl:with-param name="form" select="$form"/>
        </xsl:call-template>
      </xsl:when>
      <!-- fe@fo.fum -->
      <xsl:when test="($lang_variant and $lang_charset) and
                $msg/msg:msgstr[@xml:lang = concat(
                $lang_lang, '@', $lang_variant, '.', $lang_charset)]">
        <xsl:call-template name="gettext.get">
          <xsl:with-param
           name="msgstr" select="$msg/msg:msgstr[@xml:lang = concat(
           $lang_lang, '@', $lang_variant, '.', $lang_charset)]"/>
          <xsl:with-param name="form" select="$form"/>
        </xsl:call-template>
      </xsl:when>
      <!-- fe@fo -->
      <xsl:when test="($lang_variant) and
                $msg/msg:msgstr[@xml:lang = concat($lang_lang, '@', $lang_variant)]">
        <xsl:call-template name="gettext.get">
          <xsl:with-param
           name="msgstr" select="$msg/msg:msgstr[@xml:lang = concat(
           $lang_lang, '@', $lang_variant)]"/>
          <xsl:with-param name="form" select="$form"/>
        </xsl:call-template>
      </xsl:when>
      <!-- fe_fi.fum -->
      <xsl:when test="($lang_region and $lang_charset) and
                $msg/msg:msgstr[@xml:lang = concat(
                $lang_lang, '_', $lang_region, '.', $lang_charset)]">
        <xsl:call-template name="gettext.get">
          <xsl:with-param
           name="msgstr" select="$msg/msg:msgstr[@xml:lang = concat(
           $lang_lang, '_', $lang_region, '.', $lang_charset)]"/>
          <xsl:with-param name="form" select="$form"/>
        </xsl:call-template>
      </xsl:when>
      <!-- fe_fi -->
      <xsl:when test="($lang_region) and
                $msg/msg:msgstr[@xml:lang = concat($lang_lang, '_', $lang_region)]">
        <xsl:call-template name="gettext.get">
          <xsl:with-param
           name="msgstr" select="$msg/msg:msgstr[@xml:lang = concat(
           $lang_lang, '_', $lang_region)]"/>
          <xsl:with-param name="form" select="$form"/>
        </xsl:call-template>
      </xsl:when>
      <!-- fe.fum -->
      <xsl:when test="($lang_charset) and
                $msg/msg:msgstr[@xml:lang = concat($lang_lang, '.', $lang_charset)]">
        <xsl:call-template name="gettext.get">
          <xsl:with-param
           name="msgstr" select="$msg/msg:msgstr[@xml:lang = concat(
           $lang_lang, '.', $lang_charset)]"/>
          <xsl:with-param name="form" select="$form"/>
        </xsl:call-template>
      </xsl:when>
      <!-- fe -->
      <xsl:when test="$msg/msg:msgstr[@xml:lang = $lang_lang]">
        <xsl:call-template name="gettext.get">
          <xsl:with-param name="msgstr" select="$msg/msg:msgstr[@xml:lang = $lang_lang]"/>
          <xsl:with-param name="form" select="$form"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "C" -->
      <xsl:when test="$msg/msg:msgstr[@xml:lang = 'C']">
        <xsl:call-template name="gettext.get">
          <xsl:with-param name="msgstr" select="$msg/msg:msgstr[@xml:lang = 'C']"/>
          <xsl:with-param name="form" select="$form"/>
        </xsl:call-template>
      </xsl:when>
      <!-- not() -->
      <xsl:when test="$msg/msg:msgstr[not(@xml:lang)]">
        <xsl:call-template name="gettext.get">
          <xsl:with-param name="msgstr" select="$msg/msg:msgstr[not(@xml:lang)]"/>
          <xsl:with-param name="form" select="$form"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>No translation available for string '</xsl:text>
          <xsl:value-of select="$msgid"/>
          <xsl:text>'.</xsl:text>
        </xsl:message>
        <xsl:value-of select="$msgid"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

<xsl:template name="gettext.get" doc:private="true">
  <xsl:param name="msgstr"/>
  <xsl:param name="form"/>
  <xsl:choose>
    <xsl:when test="$msgstr/msg:msgstr[@form]">
      <xsl:choose>
        <xsl:when test="$msgstr/msg:msgstr[@form = $form]">
          <xsl:value-of select="$msgstr/msg:msgstr[@form = $form]"/>
        </xsl:when>
        <xsl:when test="$msgstr/msg:msgstr[not(@form)]">
          <xsl:value-of select="$msgstr/msg:msgstr[not(@form)]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>
            <xsl:text>No translation for </xsl:text>
            <xsl:value-of select="$msgstr/preceding-sibling::msg:msgid"/>
            <xsl:text> with plural form </xsl:text>
            <xsl:value-of select="$form"/>
          </xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$msgstr"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- == gettext.plural_form ================================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>gettext</name>
  <description>
    Extract the plural form string for a cardinality
  </description>
  <parameter>
    <name>number</name>
    <description>
      The cardinality of plural form
    </description>
  </parameter>
  <parameter>
    <name>lang</name>
    <description>
      The locale to use when looking up the translated string
    </description>
  </parameter>
  <parameter>
    <name>lang_lang</name>
    <description>
      The language portion of the locale to use
    </description>
  </parameter>
  <parameter>
    <name>lang_region</name>
    <description>
      The region portion of the locale to use
    </description>
  </parameter>
  <parameter>
    <name>lang_variant</name>
    <description>
      The variant portion of the locale to use
    </description>
  </parameter>
  <parameter>
    <name>lang_charset</name>
    <description>
      The charset portion of the locale to use
    </description>
  </parameter>
</template>

<xsl:template name="gettext.plural_form">
  <xsl:param name="number" select="1"/>
  <xsl:param name="lang" select="$gettext.locale"/>
  <xsl:param name="lang_lang">
    <xsl:call-template name="gettext.get.language">
      <xsl:with-param name="lang" select="$lang"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="lang_region">
    <xsl:call-template name="gettext.get.region">
      <xsl:with-param name="lang" select="$lang"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="lang_variant">
    <xsl:call-template name="gettext.get.variant">
      <xsl:with-param name="lang" select="$lang"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="lang_charset">
    <xsl:call-template name="gettext.get.charset">
      <xsl:with-param name="lang" select="$lang"/>
    </xsl:call-template>
  </xsl:param>

  <xsl:choose>
    <xsl:when test="$num = 1">
      <xsl:text>singular</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>plural</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- == gettext.get.language =============================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>gettext.get.language</name>
  <description>
    Extract the language part of a locale
  </description>
  <parameter>
    <name>lang</name>
    <description>
      The locale string from which to extract the language string
    </description>
  </parameter>
</template>

<xsl:template name="gettext.get.language">
  <xsl:param name="lang" select="ancestor-or-self::*[@lang][1]/@lang"/>
  <xsl:choose>
    <xsl:when test="$lang = $gettext.locale">
      <xsl:value-of select="$gettext.language"/>
    </xsl:when>
    <xsl:when test="contains($lang, '_')">
      <xsl:value-of select="substring-before($lang, '_')"/>
    </xsl:when>
    <xsl:when test="contains($lang, '@')">
      <xsl:value-of select="substring-before($lang, '@')"/>
    </xsl:when>
    <xsl:when test="contains($lang, '_')">
      <xsl:value-of select="substring-before($lang, '@')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$lang"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- == gettext.get.region ================================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>gettext.get.region</name>
  <description>
    Extract the region part of a locale
  </description>
  <parameter>
    <name>lang</name>
    <description>
      The locale string from which to extract the region string
    </description>
  </parameter>
</template>

<xsl:template name="gettext.get.region">
  <xsl:param name="lang" select="ancestor-or-self::*[@lang][1]/@lang"/>
  <xsl:choose>
    <xsl:when test="$lang = $gettext.locale">
      <xsl:value-of select="$gettext.region"/>
    </xsl:when>
    <xsl:when test="contains($lang, '_')">
      <xsl:variable name="aft" select="substring-after($lang, '_')"/>
      <xsl:choose>
        <xsl:when test="contains($aft, '@')">
          <xsl:value-of select="substring-before($aft, '@')"/>
        </xsl:when>
        <xsl:when test="contains($aft, '.')">
          <xsl:value-of select="substring-before($aft, '.')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$aft"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>
</xsl:template>


<!-- == gettext.get.variant ================================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>gettext.get.variant</name>
  <description>
    Extract the variant part of a locale
  </description>
  <parameter>
    <name>lang</name>
    <description>
      The locale string from which to extract the variant string
    </description>
  </parameter>
</template>

<xsl:template name="gettext.get.variant">
  <xsl:param name="lang" select="ancestor-or-self::*[@lang][1]/@lang"/>
  <xsl:choose>
    <xsl:when test="$lang = $gettext.locale">
      <xsl:value-of select="$gettext.variant"/>
    </xsl:when>
    <xsl:when test="contains($lang, '@')">
      <xsl:variable name="aft" select="substring-after($lang, '@')"/>
      <xsl:choose>
        <xsl:when test="contains($aft, '.')">
          <xsl:value-of select="substring-before($aft, '.')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$aft"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>
</xsl:template>


<!-- == gettext.get.charset ================================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>gettext.get.charset</name>
  <description>
    Extract the charset part of a locale
  </description>
  <parameter>
    <name>lang</name>
    <description>
      The locale string from which to extract the charset string
    </description>
  </parameter>
</template>

<xsl:template name="gettext.get.charset">
  <xsl:param name="lang" select="ancestor-or-self::*[@lang][1]/@lang"/>
  <xsl:choose>
    <xsl:when test="$lang = $gettext.locale">
      <xsl:value-of select="$gettext.charset"/>
    </xsl:when>
    <xsl:when test="contains($lang, '.')">
      <xsl:value-of select="substring-after($lang, '.')"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
