<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
		exclude-result-prefixes="doc"
                version="1.0">

<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<xsl:include href="../common/db-common.xsl"/>

<doc:title>DocBook to ScrollKeeper OMF</doc:title>


<!-- == db2omf.basename ==================================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.basename</name>
  <description>
    The basename of the referenced document
  </description>
</parameter>

<xsl:param name="db2omf.basename"/>


<!-- == db2omf.format ====================================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.format</name>
  <description>
    The format of the referenced document
  </description>
</parameter>

<xsl:param name="db2omf.format"/>


<!-- == db2omf.mime ======================================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.mime</name>
  <description>
    The MIME type of the referenced document, docbook or html
  </description>
</parameter>

<xsl:param name="db2omf.mime" select="'text/xml'"/>


<!-- == db2omf.dtd ========================================================= -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.dtd</name>
  <description>
    The FPI of the DocBook version used
  </description>
</parameter>

<xsl:param name="db2omf.dtd"/>


<!-- == db2omf.lang ======================================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.lang</name>
  <description>
    The written language of the referenced document
  </description>
</parameter>

<xsl:param name="db2omf.lang" select="/*/@lang | /*/@xml:lang"/>


<!-- == db2omf.omf_dir ===================================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.omf_dir</name>
  <description>
    The top-level ScrollKeeper OMF directory
  </description>
</parameter>

<xsl:param name="db2omf.omf_dir"/>


<!-- == db2omf.help_dir ==================================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.help_dir</name>
  <description>
    The top-level directory where documentation is installed
  </description>
</parameter>

<xsl:param name="db2omf.help_dir"/>


<!-- == db2omf.omf_in ====================================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.omf_in</name>
  <description>
    Path to the .omf.in file containing common fields
  </description>
</parameter>

<xsl:param name="db2omf.omf_in"/>

<xsl:variable name="omf_in" select="document($db2omf.omf_in)"/>


<!-- == db2omf.omf ========================================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.omf</name>
  <description>
    Generate the top-level <xmltag>omf</xmltag> and all its children
  </description>
  <parameter>
    <name>info</name>
    <description>
      The info element containing metadata
    </description>
  </parameter>
</template>

<xsl:template name="db2omf.omf" match="/*">
  <xsl:param name="info"
	     select="*[substring(local-name(.), string-length(local-name(.)) - 3)
		       = 'info']"/>
  <omf>
    <resource>
      <xsl:call-template name="db2omf.omf.creator">
        <xsl:with-param name="info" select="$info"/>
      </xsl:call-template>
      <xsl:call-template name="db2omf.omf.maintainer">
        <xsl:with-param name="info" select="$info"/>
      </xsl:call-template>
      <xsl:call-template name="db2omf.omf.contributor">
        <xsl:with-param name="info" select="$info"/>
      </xsl:call-template>
      <xsl:call-template name="db2omf.omf.title">
        <xsl:with-param name="info" select="$info"/>
      </xsl:call-template>
      <xsl:call-template name="db2omf.omf.date">
        <xsl:with-param name="info" select="$info"/>
      </xsl:call-template>
      <xsl:call-template name="db2omf.omf.version">
        <xsl:with-param name="info" select="$info"/>
      </xsl:call-template>
      <xsl:call-template name="db2omf.omf.subject">
        <xsl:with-param name="info" select="$info"/>
      </xsl:call-template>
      <xsl:call-template name="db2omf.omf.description">
        <xsl:with-param name="info" select="$info"/>
      </xsl:call-template>
      <xsl:call-template name="db2omf.omf.type">
        <xsl:with-param name="info" select="$info"/>
      </xsl:call-template>
      <xsl:call-template name="db2omf.omf.format">
        <xsl:with-param name="info" select="$info"/>
      </xsl:call-template>
      <xsl:call-template name="db2omf.omf.identifier">
        <xsl:with-param name="info" select="$info"/>
      </xsl:call-template>
      <xsl:call-template name="db2omf.omf.language">
        <xsl:with-param name="info" select="$info"/>
      </xsl:call-template>
      <xsl:call-template name="db2omf.omf.relation">
        <xsl:with-param name="info" select="$info"/>
      </xsl:call-template>
      <xsl:call-template name="db2omf.omf.rights">
        <xsl:with-param name="info" select="$info"/>
      </xsl:call-template>
    </resource>
  </omf>
</xsl:template>


<!-- == db2omf.omf.creator ================================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.omf.creator</name>
  <description>
    Generate all <xmltag>creator</xmltag> elements
  </description>
  <parameter>
    <name>info</name>
    <description>
      The info element containing metadata
    </description>
  </parameter>
</template>

<xsl:template name="db2omf.omf.creator">
  <xsl:param name="info"
             select="*[substring(local-name(.), string-length(local-name(.)) - 3)
                       = 'info']"/>
  <xsl:variable name="creators"
                select="$info/author     | $info/authorgroup/author    |
                        $info/corpauthor | $info/authorgroup/corpauthor"/>
  <xsl:if test="not($creators)">
    <xsl:message>
      <xsl:text>db2omf: Missing author element</xsl:text>
    </xsl:message>
  </xsl:if>
  <xsl:for-each select="$creators">
    <creator>
      <xsl:if test="email">
        <xsl:value-of select="email"/>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:text>(</xsl:text>
      <xsl:choose>
        <xsl:when test="self::corpauthor">
          <xsl:value-of select="."/>
        </xsl:when>
        <xsl:when test="personname">
          <xsl:call-template name="db.personname">
            <xsl:with-param name="node" select="personname"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="db.personname"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>)</xsl:text>
    </creator>
  </xsl:for-each>
</xsl:template>


<!-- == db2omf.omf.maintainer ============================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.omf.maintainer</name>
  <description>
    Generate all <xmltag>maintainer</xmltag> elements
  </description>
  <parameter>
    <name>info</name>
    <description>
      The info element containing metadata
    </description>
  </parameter>
</template>

<xsl:template name="db2omf.omf.maintainer">
  <xsl:param name="info"
             select="*[substring(local-name(.), string-length(local-name(.)) - 3)
                       = 'info']"/>
  <xsl:variable name="maintainers"
                select="$info/author[@role='maintainer']        |
                        $info/corpauthor[@role='maintainer']    |
                        $info/editor[@role='maintainer']        |
                        $info/othercredit[@role='maintainer']   |
                        $info/authorgroup/*[@role='maintainer'] "/>
  <xsl:if test="not($maintainers)">
    <xsl:message>
      <xsl:text>db2omf: Missing element with role maintainer</xsl:text>
    </xsl:message>
  </xsl:if>
  <xsl:for-each select="$maintainers">
    <maintainer>
      <xsl:if test="email">
        <xsl:value-of select="email"/>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:text>(</xsl:text>
      <xsl:choose>
        <xsl:when test="self::corpauthor">
          <xsl:value-of select="."/>
        </xsl:when>
        <xsl:when test="personname">
          <xsl:call-template name="db.personname">
            <xsl:with-param name="node" select="personname"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="db.personname"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>)</xsl:text>
    </maintainer>
  </xsl:for-each>
</xsl:template>


<!-- == db2omf.omf.contributor ============================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.omf.contributor</name>
  <description>
    Generate all <xmltag>contributor</xmltag> elements
  </description>
  <parameter>
    <name>info</name>
    <description>
      The info element containing metadata
    </description>
  </parameter>
</template>

<xsl:template name="db2omf.omf.contributor">
  <xsl:param name="info"
             select="*[substring(local-name(.), string-length(local-name(.)) - 3)
                       = 'info']"/>
  <xsl:variable name="contributors"
                select="$info/editor      | $info/authorgroup/editor      |
                        $info/othercredit | $info/authorgroup/othercredit "/>
  <xsl:for-each select="$contributors">
    <contributor>
      <xsl:if test="email">
        <xsl:value-of select="email"/>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:text>(</xsl:text>
      <xsl:choose>
        <xsl:when test="self::corpauthor">
          <xsl:value-of select="."/>
        </xsl:when>
        <xsl:when test="personname">
          <xsl:call-template name="db.personname">
            <xsl:with-param name="node" select="personname"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="db.personname"/>
        </xsl:otherwise>
      </xsl:choose>
    </contributor>
    <xsl:text>)</xsl:text>
  </xsl:for-each>
</xsl:template>


<!-- == db2omf.omf.title =================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.omf.title</name>
  <description>
    Generate the <xmltag>title</xmltag> element
  </description>
  <parameter>
    <name>info</name>
    <description>
      The info element containing metadata
    </description>
  </parameter>
</template>

<xsl:template name="db2omf.omf.title">
  <xsl:param name="info"
	     select="*[substring(local-name(.), string-length(local-name(.)) - 3)
		       = 'info']"/>
  <xsl:variable name="title" select="($info/title | title)[1]"/>
  <xsl:if test="not($title)">
    <xsl:message>
      <xsl:text>db2omf: Missing title element</xsl:text>
    </xsl:message>
  </xsl:if>
  <title>
    <xsl:value-of select="$title"/>
  </title>
</xsl:template>


<!-- == db2omf.omf.date ==================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.omf.date</name>
  <description>
    Generate the <xmltag>date</xmltag> element
  </description>
  <parameter>
    <name>info</name>
    <description>
      The info element containing metadata
    </description>
  </parameter>
</template>

<xsl:template name="db2omf.omf.date">
  <xsl:param name="info"
	     select="*[substring(local-name(.), string-length(local-name(.)) - 3)
		       = 'info']"/>
  <xsl:variable name="date" select="$info/revhistory/revision[1]/date"/>
  <xsl:if test="not($date)">
    <xsl:message>
      <xsl:text>db2omf: Missing revision element in revhistory</xsl:text>
    </xsl:message>
  </xsl:if>
  <date>
    <xsl:value-of select="$date"/>
  </date>
</xsl:template>


<!-- == db2omf.omf.version ================================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.omf.version</name>
  <description>
    Generate the <xmltag>version</xmltag> element
  </description>
  <parameter>
    <name>info</name>
    <description>
      The info element containing metadata
    </description>
  </parameter>
</template>

<xsl:template name="db2omf.omf.version">
  <xsl:param name="info"
	     select="*[substring(local-name(.), string-length(local-name(.)) - 3)
		       = 'info']"/>
  <xsl:variable name="revnumber"
		select="$info/revhistory/revision[1]/revnumber"/>
  <xsl:variable name="date"
		select="$info/revhistory/revision[1]/date"/>
  <xsl:if test="not($revnumber)">
    <xsl:message>
      <xsl:text>db2omf: Missing revnumber element in revhistory</xsl:text>
    </xsl:message>
  </xsl:if>
  <xsl:if test="not($date)">
    <xsl:message>
      <xsl:text>db2omf: Missing date element in revhistory</xsl:text>
    </xsl:message>
  </xsl:if>
  <version>
    <xsl:attribute name="identifier">
      <xsl:value-of select="$revnumber"/>
    </xsl:attribute>
    <xsl:attribute name="date">
      <xsl:value-of select="$date"/>
    </xsl:attribute>
    <!-- FIXME:
    <xsl:attribute name="description"/>
    -->
  </version>
</xsl:template>


<!-- == db2omf.omf.subject ================================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.omf.subject</name>
  <description>
    Generate the <xmltag>subject</xmltag> element
  </description>
  <parameter>
    <name>info</name>
    <description>
      The info element containing metadata
    </description>
  </parameter>
</template>

<xsl:template name="db2omf.omf.subject">
  <xsl:param name="info"
	     select="*[substring(local-name(.), string-length(local-name(.)) - 3)
		       = 'info']"/>
  <xsl:variable name="subject" select="$omf_in/omf/resource/subject"/>
  <xsl:if test="not($subject)">
    <xsl:message>
      <xsl:text>db2omf: Missing subject in </xsl:text>
      <xsl:value-of select="$db2omf.omf_in"/>
    </xsl:message>
  </xsl:if>
  <xsl:copy-of select="$subject"/>
</xsl:template>


<!-- == db2omf.omf.description ============================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.omf.description</name>
  <description>
    Generate the <xmltag>description</xmltag> element
  </description>
  <parameter>
    <name>info</name>
    <description>
      The info element containing metadata
    </description>
  </parameter>
</template>

<xsl:template name="db2omf.omf.description">
  <xsl:param name="info"
	     select="*[substring(local-name(.), string-length(local-name(.)) - 3)
		       = 'info']"/>
  <xsl:variable name="description" select="$info/abstract[@role = 'description']"/>
  <xsl:if test="not($description)">
    <xsl:message>
      <xsl:text>db2omf: Missing abstract element with role description</xsl:text>
    </xsl:message>
  </xsl:if>
  <description>
    <!-- FIXME: a smarter textification would be good -->
    <xsl:value-of select="$description"/>
  </description>
</xsl:template>


<!-- == db2omf.omf.type ==================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.omf.type</name>
  <description>
    Generate the <xmltag>type</xmltag> element
  </description>
  <parameter>
    <name>info</name>
    <description>
      The info element containing metadata
    </description>
  </parameter>
</template>

<xsl:template name="db2omf.omf.type">
  <xsl:param name="info"
	     select="*[substring(local-name(.), string-length(local-name(.)) - 3)
		       = 'info']"/>
  <xsl:variable name="type" select="$omf_in/omf/resource/type"/>
  <xsl:if test="not($type)">
    <xsl:message>
      <xsl:text>db2omf: Missing type in </xsl:text>
      <xsl:value-of select="$db2omf.omf_in"/>
    </xsl:message>
  </xsl:if>
  <type>
    <xsl:value-of select="$type"/>
  </type>
</xsl:template>


<!-- == db2omf.omf.format ================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.omf.format</name>
  <description>
    Generate the <xmltag>format</xmltag> element
  </description>
  <parameter>
    <name>info</name>
    <description>
      The info element containing metadata
    </description>
  </parameter>
</template>

<xsl:template name="db2omf.omf.format">
  <xsl:param name="info"
	     select="*[substring(local-name(.), string-length(local-name(.)) - 3)
		       = 'info']"/>
  <format>
    <xsl:choose>
      <xsl:when test="$db2omf.mime = 'text/xml'">
        <xsl:attribute name="mime">
          <xsl:value-of select="text/xml"/>
        </xsl:attribute>
        <xsl:attribute name="dtd">
          <xsl:value-of select="$db2omf.dtd"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="$db2omf.mime = 'text/html'">
        <xsl:attribute name="mime">
          <xsl:value-of select="text/html"/>
        </xsl:attribute>
        <!-- FIXME:
        <xsl:attribute name="dtd"/>
        -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>db2omf: Unknown value of db2omf.mime: </xsl:text>
          <xsl:value-of select="$db2omf.mime"/>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </format>
</xsl:template>


<!-- == db2omf.omf.identifier ============================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.omf.identifier</name>
  <description>
    Generate the <xmltag>identifier</xmltag> element
  </description>
  <parameter>
    <name>info</name>
    <description>
      The info element containing metadata
    </description>
  </parameter>
</template>

<xsl:template name="db2omf.omf.identifier">
  <xsl:param name="info"
	     select="*[substring(local-name(.), string-length(local-name(.)) - 3)
		       = 'info']"/>
  <identifier>
    <xsl:attribute name="url">
      <xsl:value-of select="$db2omf.help_dir"/>
      <xsl:if test="not(substring($db2omf.help_dir,
                                  string-length($db2omf.help_dir)) = '/')">
        <xsl:text>/</xsl:text>
      </xsl:if>
      <xsl:value-of select="$db2omf.basename"/>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="$db2omf.lang"/>
      <xsl:if test="not(substring($db2omf.lang,
                                  string-length($db2omf.lang)) = '/')">
        <xsl:text>/</xsl:text>
      </xsl:if>
      <xsl:value-of select="$db2omf.basename"/>
      <xsl:choose>
        <xsl:when test="$db2omf.format = 'docbook'">
          <xsl:text>.xml</xsl:text>
        </xsl:when>
        <xsl:when test="$db2omf.format = 'html'">
          <xsl:text>.html</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>
            <xsl:text>db2omf: Unknown value of db2omf.format: </xsl:text>
            <xsl:value-of select="$db2omf.format"/>
          </xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </identifier>
</xsl:template>


<!-- == db2omf.omf.language ================================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.omf.language</name>
  <description>
    Generate the <xmltag>language</xmltag> element
  </description>
  <parameter>
    <name>info</name>
    <description>
      The info element containing metadata
    </description>
  </parameter>
</template>

<xsl:template name="db2omf.omf.language">
  <xsl:param name="info"
	     select="*[substring(local-name(.), string-length(local-name(.)) - 3)
		       = 'info']"/>
  <language code="{$db2omf.lang}"/>
</xsl:template>


<!-- == db2omf.omf.relation ================================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.omf.relation</name>
  <description>
    Generate the <xmltag>relation</xmltag> element
  </description>
  <parameter>
    <name>info</name>
    <description>
      The info element containing metadata
    </description>
  </parameter>
</template>

<xsl:template name="db2omf.omf.relation">
  <xsl:param name="info"
	     select="*[substring(local-name(.), string-length(local-name(.)) - 3)
		       = 'info']"/>
  <xsl:variable name="relation" select="$omf_in/omf/resource/relation"/>
  <xsl:if test="not($relation)">
    <xsl:message>
      <xsl:text>db2omf: Missing relation in </xsl:text>
      <xsl:value-of select="$db2omf.omf_in"/>
    </xsl:message>
  </xsl:if>
  <xsl:copy-of select="$relation"/>
</xsl:template>


<!-- == db2omf.omf.rights ================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.omf.rights</name>
  <description>
    Generate the <xmltag>rights</xmltag> element
  </description>
  <parameter>
    <name>info</name>
    <description>
      The info element containing metadata
    </description>
  </parameter>
</template>

<xsl:template name="db2omf.omf.rights">
  <xsl:param name="info"
	     select="*[substring(local-name(.), string-length(local-name(.)) - 3)
		       = 'info']"/>
  <xsl:variable name="rights" select="$omf_in/omf/resource/rights"/>
  <xsl:if test="not($rights)">
    <xsl:message>
      <xsl:text>db2omf: Missing rights in </xsl:text>
      <xsl:value-of select="$db2omf.omf_in"/>
    </xsl:message>
  </xsl:if>
  <xsl:copy-of select="$rights"/>
</xsl:template>

</xsl:stylesheet>
