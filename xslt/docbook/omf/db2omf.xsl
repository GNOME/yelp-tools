<?xml version='1.0' encoding='utf-8'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
		exclude-result-prefixes="doc"
                version="1.0">

<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<doc:title>DocBook to ScrollKeeper OMF</doc:title>


<!-- == db2omf.lang ======================================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.lang</name>
  <description>
    The written language of the referenced document
  </description>
</parameter>

<xsl:param name="db2omf.lang" select="/*/@lang | /*/@xml:lang"/>


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
    <xsl:call-template name="db2omf.creator">
      <xsl:with-param name="info" select="$info"/>
    </xsl:call-template>
    <xsl:call-template name="db2omf.maintainer">
      <xsl:with-param name="info" select="$info"/>
    </xsl:call-template>
    <xsl:call-template name="db2omf.contributor">
      <xsl:with-param name="info" select="$info"/>
    </xsl:call-template>
    <xsl:call-template name="db2omf.title">
      <xsl:with-param name="info" select="$info"/>
    </xsl:call-template>
    <xsl:call-template name="db2omf.date">
      <xsl:with-param name="info" select="$info"/>
    </xsl:call-template>
    <xsl:call-template name="db2omf.version">
      <xsl:with-param name="info" select="$info"/>
    </xsl:call-template>
    <xsl:call-template name="db2omf.subject">
      <xsl:with-param name="info" select="$info"/>
    </xsl:call-template>
    <xsl:call-template name="db2omf.description">
      <xsl:with-param name="info" select="$info"/>
    </xsl:call-template>
    <xsl:call-template name="db2omf.type">
      <xsl:with-param name="info" select="$info"/>
    </xsl:call-template>
    <xsl:call-template name="db2omf.format">
      <xsl:with-param name="info" select="$info"/>
    </xsl:call-template>
    <xsl:call-template name="db2omf.identifier">
      <xsl:with-param name="info" select="$info"/>
    </xsl:call-template>
    <xsl:call-template name="db2omf.language">
      <xsl:with-param name="info" select="$info"/>
    </xsl:call-template>
    <xsl:call-template name="db2omf.relation">
      <xsl:with-param name="info" select="$info"/>
    </xsl:call-template>
    <xsl:call-template name="db2omf.rights">
      <xsl:with-param name="info" select="$info"/>
    </xsl:call-template>
  </omf>
</xsl:template>


<!-- == db2omf.creator ===================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.creator</name>
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

<xsl:template name="db2omf.creator">
  <xsl:param name="info"
	     select="*[substring(local-name(.), string-length(local-name(.)) - 3)
		       = 'info']"/>
  <xsl:for-each select="$info/author | $info/authorgroup/author">
    <!-- FIXME: We should put a personname formatter in docbook/common -->
    <creator>
      <xsl:for-each select="personname/honorific | honorific">
	<xsl:value-of select="."/>
	<xsl:text> </xsl:text>
      </xsl:for-each>
      <xsl:value-of select="personname/firstname | firstname"/>
      <xsl:text> </xsl:text>
      <xsl:for-each select="personname/othername | othername">
	<xsl:value-of select="."/>
	<xsl:text> </xsl:text>
      </xsl:for-each>
      <xsl:value-of select="personname/surname | surname"/>
      <xsl:text> </xsl:text>
      <xsl:for-each select="personname/lineage | lineage">
	<xsl:value-of select="."/>
	<xsl:text> </xsl:text>
      </xsl:for-each>
    </creator>
  </xsl:for-each>
  <xsl:for-each select="$info/corpauthor | $info/authorgroup/corpauthor">
    <creator>
      <xsl:value-of select="."/>
    </creator>
  </xsl:for-each>
</xsl:template>


<!-- == db2omf.maintainer ================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.maintainer</name>
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

<xsl:template name="db2omf.maintainer">
  <xsl:param name="info"
	     select="*[substring(local-name(.), string-length(local-name(.)) - 3)
		       = 'info']"/>
  <!-- FIXME -->
</xsl:template>


<!-- == db2omf.contributor ================================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.contributor</name>
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

<xsl:template name="db2omf.contributor">
  <xsl:param name="info"
	     select="*[substring(local-name(.), string-length(local-name(.)) - 3)
		       = 'info']"/>
  <!-- FIXME -->
</xsl:template>


<!-- == db2omf.title ======================================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.title</name>
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

<xsl:template name="db2omf.title">
  <xsl:param name="info"
	     select="*[substring(local-name(.), string-length(local-name(.)) - 3)
		       = 'info']"/>
  <xsl:variable name="title" select="($info/title | title)[1]"/>
  <xsl:if test="not($title)">
    <xsl:message>
      <xsl:text>Missing title element</xsl:text>
    </xsl:message>
  </xsl:if>
  <title>
    <xsl:value-of select="$title"/>
  </title>
</xsl:template>


<!-- == db2omf.date ======================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.date</name>
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

<xsl:template name="db2omf.date">
  <xsl:param name="info"
	     select="*[substring(local-name(.), string-length(local-name(.)) - 3)
		       = 'info']"/>
  <!-- FIXME -->
</xsl:template>


<!-- == db2omf.version ===================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.version</name>
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

<xsl:template name="db2omf.version">
  <xsl:param name="info"
	     select="*[substring(local-name(.), string-length(local-name(.)) - 3)
		       = 'info']"/>
  <xsl:variable name="identifier"
		select="$info/revhistory/revision[1]/revnumber"/>
  <xsl:variable name="date"
		select="$info/revhistory/revision[1]/date"/>
  <xsl:if test="not($identifier)">
    <xsl:message>
      <xsl:text>Missing revnumber element in revhistory</xsl:text>
    </xsl:message>
  </xsl:if>
  <xsl:if test="not($date)">
    <xsl:message>
      <xsl:text>Missing date element in revhistory</xsl:text>
    </xsl:message>
  </xsl:if>
  <version>
    <xsl:attribute name="identifier">
      <xsl:value-of select="$identifier"/>
    </xsl:attribute>
    <xsl:attribute name="date">
      <xsl:value-of select="$date"/>
    </xsl:attribute>
    <!-- FIXME: -->
    <xsl:attribute name="description"/>
  </version>
</xsl:template>


<!-- == db2omf.subject ===================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.subject</name>
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

<xsl:template name="db2omf.subject">
  <xsl:param name="info"
	     select="*[substring(local-name(.), string-length(local-name(.)) - 3)
		       = 'info']"/>
  <xsl:variable name="subject" select="$omf_in/omf/resource/subject"/>
  <xsl:if test="not($subject)">
    <xsl:message>
      <xsl:text>Missing subject in .omf.in file</xsl:text>
    </xsl:message>
  </xsl:if>
  <subject>
    <xsl:attribute name="category">
      <xsl:value-of select="$subject/@category"/>
    </xsl:attribute>
  </subject>
</xsl:template>


<!-- == db2omf.description ================================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.description</name>
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

<xsl:template name="db2omf.description">
  <xsl:param name="info"
	     select="*[substring(local-name(.), string-length(local-name(.)) - 3)
		       = 'info']"/>
  <xsl:variable name="description" select="$info/abstract[@role = 'description']"/>
  <xsl:if test="not($description)">
    <xsl:message>
      <xsl:text>Missing abstract element with role description</xsl:text>
    </xsl:message>
  </xsl:if>
  <description>
    <!-- FIXME: a smarter textification would be good -->
    <xsl:value-of select="$description"/>
  </description>
</xsl:template>


<!-- == db2omf.type ======================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.type</name>
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

<xsl:template name="db2omf.type">
  <xsl:param name="info"
	     select="*[substring(local-name(.), string-length(local-name(.)) - 3)
		       = 'info']"/>
  <xsl:variable name="type" select="$omf_in/omf/resource/type"/>
  <xsl:if test="not($type)">
    <xsl:message>
      <xsl:text>Missing type in .omf.in file</xsl:text>
    </xsl:message>
  </xsl:if>
  <type>
    <xsl:value-of select="$type"/>
  </type>
</xsl:template>


<!-- == db2omf.format ====================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.format</name>
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

<xsl:template name="db2omf.format">
  <xsl:param name="info"
	     select="*[substring(local-name(.), string-length(local-name(.)) - 3)
		       = 'info']"/>
  <!-- FIXME -->
</xsl:template>


<!-- == db2omf.identifier ================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.identifier</name>
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

<xsl:template name="db2omf.identifier">
  <xsl:param name="info"
	     select="*[substring(local-name(.), string-length(local-name(.)) - 3)
		       = 'info']"/>
  <!-- FIXME -->
</xsl:template>


<!-- == db2omf.language ==================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.language</name>
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

<xsl:template name="db2omf.language">
  <xsl:param name="info"
	     select="*[substring(local-name(.), string-length(local-name(.)) - 3)
		       = 'info']"/>
  <!-- FIXME -->
</xsl:template>


<!-- == db2omf.relation ==================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.relation</name>
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

<xsl:template name="db2omf.relation">
  <xsl:param name="info"
	     select="*[substring(local-name(.), string-length(local-name(.)) - 3)
		       = 'info']"/>
  <xsl:variable name="relation" select="$omf_in/omf/resource/relation"/>
  <xsl:if test="not($relation)">
    <xsl:message>
      <xsl:text>Missing relation in .omf.in file</xsl:text>
    </xsl:message>
  </xsl:if>
  <relation>
    <xsl:attribute name="seriesid">
      <xsl:value-of select="$relation/@seriesid"/>
    </xsl:attribute>
  </relation>
</xsl:template>


<!-- == db2omf.rights ====================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2omf.rights</name>
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

<xsl:template name="db2omf.rights">
  <xsl:param name="info"
	     select="*[substring(local-name(.), string-length(local-name(.)) - 3)
		       = 'info']"/>
  <!-- FIXME -->
</xsl:template>

</xsl:stylesheet>
