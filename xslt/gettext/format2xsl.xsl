<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msg="http://www.gnome.org/~shaunm/gnome-doc-utils/xsl-format"
		xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                xmlns:xslt="http://www.example.com/XSLT"
		exclude-result-prefixes="doc"
                version="1.0">

<xsl:namespace-alias stylesheet-prefix="xslt" result-prefix="xsl"/>

<xsl:output method="xml" encoding="UTF-8"/>

<!-- == format2xsl == -->
<xsl:template name="format2xsl">
  <xsl:param name="msgstr"/>
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
            <!-- FIXME: numbers -->
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

<!-- == msg:msg == -->
<xsl:template match="msg:msg">
  <xsl:choose>
    <xsl:when test="(count(msg:msgstr) != 1)     and
                    not(count(msg:msgstr) = 2       and
                        msg:msgstr[not(@xml:lang)]  and
                        msg:msgstr[@xml:lang = 'C'] )">
      <xslt:choose>
        <xsl:for-each select="msg:msgstr">
          <xsl:sort select="contains(@xml:lang, '@') and contains(@xml:lang, '.')"
                    order="descending"/>
          <xsl:sort select="contains(@xml:lang, '.')" order="descending"/>
          <xsl:sort select="contains(@xml:lang, '@')" order="descending"/>
          <xsl:sort select="contains(@xml:lang, '_')" order="descending"/>
          <xsl:sort select="string-length(@xml:lang)" order="descending"/>
          <xsl:variable name="lang_lang">
            <xsl:choose>
              <xsl:when test="contains(@xml:lang, '_')">
                <xsl:value-of select="substring-before(@xml:lang, '_')"/>
              </xsl:when>
              <xsl:when test="contains(@xml:lang, '@')">
                <xsl:value-of select="substring-before(@xml:lang, '@')"/>
              </xsl:when>
              <xsl:when test="contains(@xml:lang, '.')">
                <xsl:value-of select="substring-before(@xml:lang, '.')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@xml:lang"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="lang_sans_lang">
            <xsl:value-of select="substring-after(@xml:lang, $lang_lang)"/>
          </xsl:variable>
          <xsl:variable name="lang_region">
            <xsl:if test="starts-with($lang_sans_lang, '_')">
              <xsl:choose>
                <xsl:when test="contains($lang_sans_lang, '@')">
                  <xsl:value-of select="substring-after(
                                substring-before($lang_sans_lang, '@'),
                                '_')"/>
                </xsl:when>
                <xsl:when test="contains($lang_sans_lang, '.')">
                  <xsl:value-of select="substring-after(
                                substring-before($lang_sans_lang, '.'),
                                '_')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring-after($lang_sans_lang, '_')"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
          </xsl:variable>
          <xsl:variable name="lang_sans_region">
            <xsl:choose>
              <xsl:when test="$lang_region">
                <xsl:value-of select="substring-after($lang_sans_lang,
                                        concat('_', $lang_region))"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$lang_sans_lang"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="lang_variant">
            <xsl:if test="starts-with($lang_sans_region, '@')">
              <xsl:choose>
                <xsl:when test="contains($lang_sans_region, '.')">
                  <xsl:value-of select="substring-after(
                                          substring-before($lang_sans_region, '.'),
                                          '@')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring-after($lang_sans_region, '@')"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
          </xsl:variable>
          <xsl:variable name="lang_sans_variant">
            <xsl:choose>
              <xsl:when test="$lang_variant">
                <xsl:value-of select="substring-after($lang_sans_region,
                                        concat('@', $lang_region))"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$lang_sans_region"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="lang_charset">
            <xsl:if test="starts-with($lang_sans_variant, '.')">
              <xsl:value-of select="substring-after($lang_sans_variant, '.')"/>
            </xsl:if>
          </xsl:variable>
          <xsl:variable name="element">
            <xsl:choose>
              <xsl:when test="@xml:lang != '' and @xml:lang != 'C'">
                <xsl:text>xslt:when</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>xslt:otherwise</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:if test="not(@xml:lang = '' and ../msg:msg[@xml:lang = 'C'])">
            <xsl:element name="{$element}">
              <xsl:if test="$element = 'xslt:when'">
                <xsl:attribute name="test">
                  <xsl:text>$lang_lang = '</xsl:text>
                  <xsl:value-of select="$lang_lang"/>
                  <xsl:text>'</xsl:text>
                  <xsl:if test="$lang_region != ''">
                    <xsl:text> and $lang_region = '</xsl:text>
                    <xsl:value-of select="$lang_region"/>
                    <xsl:text>'</xsl:text>
                  </xsl:if>
                  <xsl:if test="$lang_variant != ''">
                    <xsl:text> nand $lang_variant = '</xsl:text>
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
              <xsl:call-template name="format2xsl">
                <xsl:with-param name="msgstr" select="."/>
                <xsl:with-param name="template" select="../.."/>
                <xsl:with-param name="lang" select="@xml:lang"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:if>
        </xsl:for-each>
      </xslt:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="format2xsl">
        <xsl:with-param name="msgstr">
          <xsl:choose>
            <xsl:when test="msg:msgstr[@xml:lang = 'C']">
              <xsl:value-of select="msg:msgstr[@xml:lang = 'C']"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="msg:msgstr[1]"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="template" select=".."/>
        <xsl:with-param name="lang" select="'C'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- == xsl:apply-templates == -->
<xsl:template match="xsl:apply-templates">
  <xslt:apply-templates>
    <xsl:if test="@select">
      <xsl:attribute name="select">
        <xsl:value-of select="@select"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@mode">
      <xsl:attribute name="mode">
        <xsl:value-of select="@mode"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </xslt:apply-templates>
</xsl:template>

<!-- == xsl:call-template == -->
<xsl:template match="xsl:call-template">
  <xslt:call-template name="{@name}">
    <xsl:apply-templates/>
  </xslt:call-template>
</xsl:template>

<!-- == xsl:param == -->
<xsl:template match="xsl:param">
  <xslt:param name="{@name}">
    <xsl:if test="@select">
      <xsl:attribute name="select">
        <xsl:value-of select="@select"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </xslt:param>
</xsl:template>

<!-- == xsl:template == -->
<xsl:template match="xsl:template">
  <xslt:template name="{@name}">
    <xslt:param name="lang" select="/*/@lang"/>
    <xsl:apply-templates select="xsl:param"/>
    <xslt:variable name="lang_lang">
      <xslt:choose>
        <xslt:when test="contains($lang, '_')">
          <xslt:value-of select="substring-before($lang, '_')"/>
        </xslt:when>
        <xslt:when test="contains($lang, '@')">
          <xslt:value-of select="substring-before($lang, '@')"/>
        </xslt:when>
        <xslt:when test="contains($lang, '.')">
          <xslt:value-of select="substring-before($lang, '.')"/>
        </xslt:when>
        <xslt:otherwise>
          <xslt:value-of select="$lang"/>
        </xslt:otherwise>
      </xslt:choose>
    </xslt:variable>
    <xslt:variable name="lang_sans_lang">
      <xslt:value-of select="substring-after($lang, $lang_lang)"/>
    </xslt:variable>
    <xslt:variable name="lang_region">
      <xslt:if test="starts-with($lang_sans_lang, '_')">
        <xslt:choose>
          <xslt:when test="contains($lang_sans_lang, '@')">
            <xslt:value-of select="substring-after(
                                     substring-before($lang_sans_lang, '@'),
                                     '_')"/>
          </xslt:when>
          <xslt:when test="contains($lang_sans_lang, '.')">
            <xslt:value-of select="substring-after(
                                     substring-before($lang_sans_lang, '.'),
                                     '_')"/>
          </xslt:when>
          <xslt:otherwise>
            <xslt:value-of select="substring-after($lang_sans_lang, '_')"/>
          </xslt:otherwise>
        </xslt:choose>
      </xslt:if>
    </xslt:variable>
    <xslt:variable name="lang_sans_region">
      <xslt:choose>
        <xslt:when test="$lang_region">
          <xslt:value-of select="substring-after($lang_sans_lang,
                                   concat('_', $lang_region))"/>
        </xslt:when>
        <xslt:otherwise>
          <xslt:value-of select="$lang_sans_lang"/>
        </xslt:otherwise>
      </xslt:choose>
    </xslt:variable>
    <xslt:variable name="lang_variant">
      <xslt:if test="starts-with($lang_sans_region, '@')">
        <xslt:choose>
          <xslt:when test="contains($lang_sans_region, '.')">
            <xslt:value-of select="substring-after(
                                     substring-before($lang_sans_region, '.'),
                                     '@')"/>
          </xslt:when>
          <xslt:otherwise>
            <xslt:value-of select="substring-after($lang_sans_region, '@')"/>
          </xslt:otherwise>
        </xslt:choose>
      </xslt:if>
    </xslt:variable>
    <xslt:variable name="lang_sans_variant">
      <xslt:choose>
        <xslt:when test="$lang_variant">
          <xslt:value-of select="substring-after($lang_sans_region,
                                   concat('@', $lang_region))"/>
        </xslt:when>
        <xslt:otherwise>
          <xslt:value-of select="$lang_sans_region"/>
        </xslt:otherwise>
      </xslt:choose>
    </xslt:variable>
    <xslt:variable name="lang_charset">
      <xslt:if test="starts-with($lang_sans_variant, '.')">
        <xslt:value-of select="substring-after($lang_sans_variant, '.')"/>
      </xslt:if>
    </xslt:variable>
    <xsl:choose>
      <xsl:when test="count(msg:msg) != 1">
        <xslt:choose>
          <xsl:for-each select="msg:msg">
            <xslt:when test="$role = '{@role}'">
              <xsl:apply-templates select="."/>
            </xslt:when>
          </xsl:for-each>
        </xslt:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="msg:msg"/>
      </xsl:otherwise>
    </xsl:choose>
  </xslt:template>
</xsl:template>

<!-- == xsl:stylesheet == -->
<xsl:template match="xsl:stylesheet">
  <xslt:stylesheet version="1.0">
    <xsl:apply-templates/>
  </xslt:stylesheet>
</xsl:template>

<!-- == xsl:value-of == -->
<xsl:template match="xsl:value-of">
  <xslt:value-of select="{@select}"/>
</xsl:template>

<!-- == xsl:with-param == -->
<xsl:template match="xsl:with-param">
  <xslt:with-param name="{@name}">
    <xsl:if test="@select">
      <xsl:attribute name="select">
        <xsl:value-of select="@select"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </xslt:with-param>
</xsl:template>

</xsl:stylesheet>
