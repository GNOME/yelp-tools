<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msg="http://www.gnome.org/~shaunm/gnome-doc-utils/xsl-format"
		xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                xmlns:xslt="http://www.example.com/XSLT"
		exclude-result-prefixes="doc"
                version="1.0">

<xsl:namespace-alias stylesheet-prefix="xslt" result-prefix="xsl"/>

<xsl:include href="gettext.xsl"/>

<xsl:output method="xml" encoding="UTF-8"/>

<!-- == format2xsl == -->
<xsl:template name="format2xsl" mode="format2xsl.mode" match="text()">
  <xsl:param name="msgstr" select="."/>
  <xsl:param name="msgstr_cur" select="$msgstr"/>
  <xsl:param name="template"/>
  <xsl:param name="lang"/>
  <xsl:choose>
    <xsl:when test="contains($msgstr_cur, '%')">
      <xsl:choose>
        <xsl:when test="starts-with(substring-after($msgstr_cur, '%'), '%')">
          <xslt:text>
            <xsl:value-of select="substring-before($msgstr_cur, '%')"/>
            <xsl:text>%</xsl:text>
          </xslt:text>
        </xsl:when>
        <xsl:otherwise>
          <xslt:text>
            <xsl:value-of select="substring-before($msgstr_cur, '%')"/>
          </xslt:text>
          <xsl:variable name="type"
                        select="substring-before(
                                  substring-after($msgstr_cur, '%'),
                                  '{')"/>
          <xsl:variable name="name"
                        select="substring-before(
                                  substring-after($msgstr_cur, '{'),
                                  '}')"/>
          <xsl:variable name="msgstr_aft"
                        select="substring-after($msgstr_cur, '}')"/>
          <xsl:variable name="arg"
                        select="$template/msg:arg[@name = $name]"/>
          <xsl:if test="not($arg)">
            <xsl:message terminate="yes">
              <xsl:value-of select="concat(
                            'format2xsl: Error in template ', $template/@name,
                            ', format string for ', $lang, ' references ', $name,
                            ' but no such argument exists')"/>
            </xsl:message>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="$type = 't'">
              <xsl:if test="not($arg/xsl:apply-templates or $arg/xsl:call-template)">
                <xsl:message terminate="yes">
                  <xsl:value-of select="concat(
                                'format2xsl: Error in template ', $template/@name,
                                ', format string for argument ', $name,
                                ' in locale ', $lang,
                                ' is type ', $type,
                                ' but template calls ', local-name($arg/*[1])
                                )"/>
                </xsl:message>
              </xsl:if>
              <xsl:apply-templates select="$arg/*"/>
            </xsl:when>
            <xsl:when test="$type = 's'">
              <xsl:if test="not($arg/xsl:value-of)">
                <xsl:message terminate="yes">
                  <xsl:value-of select="concat(
                                'format2xsl: Error in template ', $template/@name,
                                ', format string for argument ', $name,
                                ' is type ', $type,
                                ' but template calls ', local-name($arg/*[1])
                                )"/>
                </xsl:message>
              </xsl:if>
              <xsl:apply-templates select="$arg/*"/>
            </xsl:when>
            <xsl:when test="$type = 'a' or $type = 'A' or
                            $type = 'i' or $type = 'I' or
                            $type = '1' ">
              <xsl:if test="not($arg/xsl:number)">
                <xsl:message terminate="yes">
                  <xsl:value-of select="concat(
                                'format2xsl: Error in template ', $template/@name,
                                ', format string for argument ', $name,
                                ' is type ', $type,
                                ' but template calls ', local-name($arg/*[1])
                                )"/>
                </xsl:message>
              </xsl:if>
              <xsl:apply-templates select="$arg/*">
                <xsl:with-param name="format" select="$type"/>
              </xsl:apply-templates>
            </xsl:when>
          </xsl:choose>
          <xsl:call-template name="format2xsl">
            <xsl:with-param name="msgstr" select="$msgstr"/>
            <xsl:with-param name="msgstr_cur" select="$msgstr_aft"/>
            <xsl:with-param name="template" select="$template"/>
            <xsl:with-param name="lang" select="$lang"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xslt:text>
        <xsl:value-of select="$msgstr_cur"/>
      </xslt:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template mode="format2xsl.mode" match="msg:msgstr">
  <xsl:param name="template"/>
  <xsl:param name="lang"/>
  <xsl:choose>
    <xsl:when test="xsl:template">
      <xsl:apply-templates select="xsl:template/node()"/>
    </xsl:when>
    <xsl:when test="msg:msgstr[@role]">
      <xslt:choose>
        <xsl:for-each select="msg:msgstr[@role]">
          <xslt:when test="$role = '{@role}'">
            <xsl:apply-templates mode="format2xsl.mode" select=".">
              <xsl:with-param name="template" select="$template"/>
              <xsl:with-param name="lang" select="$lang"/>
            </xsl:apply-templates>
          </xslt:when>
        </xsl:for-each>
        <xsl:choose>
          <xsl:when test="msg:msgstr[not(@role)]">
            <xslt:otherwise>
              <xsl:apply-templates mode="format2xsl.mode"
                                   select="msg:msgstr[not(@role)][1]">
                <xsl:with-param name="template" select="$template"/>
                <xsl:with-param name="lang" select="$lang"/>
              </xsl:apply-templates>
            </xslt:otherwise>
          </xsl:when>
          <xsl:otherwise>
            <xslt:message>
              <xslt:text>No translation for </xslt:text>
              <xslt:text><xsl:value-of select="$template/@name"/></xslt:text>
              <xslt:text> with role </xslt:text>
              <xslt:value-of select="$role"/>
            </xslt:message>
          </xsl:otherwise>
        </xsl:choose>
      </xslt:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:for-each select="node()">
        <xsl:apply-templates mode="format2xsl.mode" select=".">
          <xsl:with-param name="template" select="$template"/>
          <xsl:with-param name="lang" select="$lang"/>
        </xsl:apply-templates>
      </xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template mode="format2xsl.mode" match="*">
  <xsl:param name="template"/>
  <xsl:param name="lang"/>
  <xslt:variable name="name">
    <xslt:call-template name="format2xsl.element.name">
      <xslt:with-param name="name" select="'{local-name(.)}'"/>
      <xslt:with-param name="namespace" select="'{namespace-uri(.)}'"/>
    </xslt:call-template>
  </xslt:variable>
  <xslt:variable name="namespace">
    <xslt:call-template name="format2xsl.element.namespace">
      <xslt:with-param name="name" select="'{local-name(.)}'"/>
      <xslt:with-param name="namespace" select="'{namespace-uri(.)}'"/>
    </xslt:call-template>
  </xslt:variable>
  <xslt:element>
    <xsl:attribute name="name">
      <xsl:text>{$name}</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="namespace">
      <xsl:text>{$namespace}</xsl:text>
    </xsl:attribute>
    <xsl:for-each select="* | text()">
      <xsl:apply-templates mode="format2xsl.mode" select=".">
        <xsl:with-param name="template" select="$template"/>
        <xsl:with-param name="lang" select="$lang"/>
      </xsl:apply-templates>
    </xsl:for-each>
  </xslt:element>
</xsl:template>

<!-- == msg:msg == -->
<xsl:template match="msg:msg">
  <xsl:variable name="msg" select="."/>
  <xsl:choose>
    <xsl:when test="(count(msg:msgstr[string(.) != $msg/@id]) != 1)  and
                    not(count(msg:msgstr[string(.) != $msg/@id]) = 2 and
                        msg:msgstr[not(@xml:lang)]  and
                        msg:msgstr[@xml:lang = 'C'] )">
      <xslt:choose>
        <xsl:for-each select="msg:msgstr[string(.) != $msg/@id]">
          <xsl:sort select="contains(@xml:lang, '@') and contains(@xml:lang, '.')"
                    order="descending"/>
          <xsl:sort select="contains(@xml:lang, '.')" order="descending"/>
          <xsl:sort select="contains(@xml:lang, '@')" order="descending"/>
          <xsl:sort select="contains(@xml:lang, '_')" order="descending"/>
          <xsl:sort select="string-length(@xml:lang)" order="descending"/>
          <xsl:variable name="lang_language">
            <xsl:call-template name="gettext.get.language">
              <xsl:with-param name="lang" select="@xml:lang"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="lang_region">
            <xsl:call-template name="gettext.get.region">
              <xsl:with-param name="lang" select="@xml:lang"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="lang_variant">
            <xsl:call-template name="gettext.get.variant">
              <xsl:with-param name="lang" select="@xml:lang"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="lang_charset">
            <xsl:call-template name="gettext.get.charset">
              <xsl:with-param name="lang" select="@xml:lang"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="element">
            <xsl:choose>
              <xsl:when test="@xml:lang and @xml:lang != 'C'">
                <xsl:text>xslt:when</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>xslt:otherwise</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:if test="@xml:lang or not(../msg:msgstr[@xml:lang = 'C'])">
            <xsl:element name="{$element}">
              <xsl:if test="$element = 'xslt:when'">
                <xsl:attribute name="test">
                  <xsl:text>$lang_language = '</xsl:text>
                  <xsl:value-of select="$lang_language"/>
                  <xsl:text>'</xsl:text>
                  <xsl:if test="$lang_region != ''">
                    <xsl:text> and $lang_region = '</xsl:text>
                    <xsl:value-of select="$lang_region"/>
                    <xsl:text>'</xsl:text>
                  </xsl:if>
                  <xsl:if test="$lang_variant != ''">
                    <xsl:text> and $lang_variant = '</xsl:text>
                    <xsl:value-of select="$lang_variant"/>
                    <xsl:text>'</xsl:text>
                  </xsl:if>
                  <xsl:if test="$lang_charset != ''">
                    <xsl:text> and $lang_charset = '</xsl:text>
                    <xsl:value-of select="$lang_charset"/>
                    <xsl:text>'</xsl:text>
                  </xsl:if>
                </xsl:attribute>
              </xsl:if>
              <xsl:apply-templates mode="format2xsl.mode" select=".">
                <xsl:with-param name="template" select="../.."/>
                <xsl:with-param name="lang" select="@xml:lang"/>
              </xsl:apply-templates>
            </xsl:element>
          </xsl:if>
        </xsl:for-each>
      </xslt:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="msg:msgstr[@xml:lang = 'C']">
          <xsl:for-each select="msg:msgstr[@xml:lang = 'C'][1]">
            <xsl:apply-templates mode="format2xsl.mode" select=".">
              <xsl:with-param name="template" select="../.."/>
              <xsl:with-param name="lang" select="'C'"/>
            </xsl:apply-templates>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="msg:msgstr[1]">
            <xsl:apply-templates mode="format2xsl.mode" select=".">
              <xsl:with-param name="template" select="../.."/>
              <xsl:with-param name="lang" select="'C'"/>
            </xsl:apply-templates>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- == -->
<xsl:template match="*">
  <xsl:copy>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<!-- == doc:template == -->
<xsl:template match="doc:template">
  <xsl:variable name="doc_template" select="."/>
  <xsl:variable name="xsl_template" select="following-sibling::xsl:template[1]"/>
  <xsl:copy>
    <xsl:for-each select="node()">
      <xsl:apply-templates select="."/>
      <xsl:if test="self::doc:purpose">
        <xsl:if test="not($doc_template/doc:parameter[doc:name='lang'])">
          <doc:parameter>
            <doc:name>lang</doc:name>
            <doc:purpose>
              The language language to use for formatting
            </doc:purpose>
          </doc:parameter>
        </xsl:if>
      </xsl:if>
    </xsl:for-each>
  </xsl:copy>
</xsl:template>

<!-- == xsl:* == -->
<xsl:template match="xsl:*">
  <xsl:copy>
    <xsl:for-each select="attribute::*">
      <xsl:copy/>
    </xsl:for-each>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<!-- == xsl:apply-templates == -->
<xsl:template match="xsl:apply-templates">
  <xslt:apply-templates>
    <xsl:for-each select="attribute::*">
      <xsl:copy/>
    </xsl:for-each>
    <xsl:apply-templates/>
  </xslt:apply-templates>
</xsl:template>

<!-- == xsl:number == -->
<xsl:template match="xsl:number">
  <xsl:param name="format"/>
  <xslt:number>
    <xsl:if test="$format">
      <xsl:attribute name="format">
        <xsl:value-of select="$format"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:for-each select="attribute::*">
      <xsl:if test="not(self::format and $format)">
        <xsl:copy/>
      </xsl:if>
    </xsl:for-each>
  </xslt:number>
</xsl:template>

<!-- == xsl:template == -->
<xsl:template match="xsl:template">
  <xslt:template name="{@name}">
    <xsl:apply-templates select="xsl:param"/>
    <xslt:param name="lang" select="$node/ancestor-or-self::*[@lang][1]/@lang"/>
    <xslt:variable name="lang_language">
      <xslt:call-template name="gettext.get.language">
        <xslt:with-param name="lang" select="$lang"/>
      </xslt:call-template>
    </xslt:variable>
    <xslt:variable name="lang_region">
      <xslt:call-template name="gettext.get.region">
        <xslt:with-param name="lang" select="$lang"/>
      </xslt:call-template>
    </xslt:variable>
    <xslt:variable name="lang_variant">
      <xslt:call-template name="gettext.get.variant">
        <xslt:with-param name="lang" select="$lang"/>
      </xslt:call-template>
    </xslt:variable>
    <xslt:variable name="lang_charset">
      <xslt:call-template name="gettext.get.charset">
        <xslt:with-param name="lang" select="$lang"/>
      </xslt:call-template>
    </xslt:variable>
    <xsl:apply-templates select="msg:msg"/>
  </xslt:template>
</xsl:template>

<!-- == xsl:stylesheet == -->
<xsl:template match="xsl:stylesheet">
  <xslt:stylesheet version="1.0">
    <xsl:apply-templates/>
  </xslt:stylesheet>
</xsl:template>

</xsl:stylesheet>
