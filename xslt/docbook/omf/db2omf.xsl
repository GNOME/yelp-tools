<?xml version='1.0' encoding='utf-8'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:ref="http://www.gnome.org/~shaunm/mallard/refentry"
		exclude-result-prefixes="ref"
                version="1.0">

<ref:title>DocBook to ScrollKeeper OMF</ref:title>


<!-- == db2omf.lang == -->

<ref:refname>db2omf.lang</ref:refname>
<ref:refpurpose>
  The written language of the referenced document
</ref:refpurpose>

<xsl:param name="db2omf.lang" select="/*/@lang | /*/@xml:lang"/>


<!-- == db2omf.omf_in == -->

<ref:refname>db2omf.omf_in</ref:refname>
<ref:refpurpose>
  Path to the .omf.in file containing common fields
</ref:refpurpose>

<xsl:param name="db2omf.omf_in"/>

<xsl:variable name="omf_in" select="document($db2omf.omf_in)"/>


<!-- == db2omf.omf == -->

<ref:refname>db2omf.omf</ref:refname>
<ref:refpurpose>
  Generate the top-level <ref:xmltag>omf</ref:xmltag> and all its children
</ref:refpurpose>

<xsl:template name="db2omf.omf" match="/">
  <xsl:param name="info" select="*[substring(local-name(.), -4, 4) = 'info']"/>
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


<!-- == db2omf.creator == -->

<ref:refname>db2omf.creator</ref:refname>
<ref:refpurpose>
  Generate all <ref:xmltag>creator</ref:xmltag> elements
</ref:refpurpose>

<xsl:template name="db2omf.creator">
  <xsl:param name="info" select="*[substring(local-name(.), -4, 4) = 'info']"/>
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


<!-- == db2omf.maintainer == -->

<ref:refname>db2omf.maintainer</ref:refname>
<ref:refpurpose>
  Generate all <ref:xmltag>maintainer</ref:xmltag> elements
</ref:refpurpose>

<xsl:template name="db2omf.maintainer">
  <xsl:param name="info" select="*[substring(local-name(.), -4, 4) = 'info']"/>
  <!-- FIXME -->
</xsl:template>


<!-- == db2omf.contributor == -->

<ref:refname>db2omf.contributor</ref:refname>
<ref:refpurpose>
  Generate all <ref:xmltag>contributor</ref:xmltag> elements
</ref:refpurpose>

<xsl:template name="db2omf.contributor">
  <xsl:param name="info" select="*[substring(local-name(.), -4, 4) = 'info']"/>
  <!-- FIXME -->
</xsl:template>


<!-- == db2omf.title == -->

<ref:refname>db2omf.title</ref:refname>
<ref:refpurpose>
  Generate the <ref:xmltag>title</ref:xmltag> element
</ref:refpurpose>

<xsl:template name="db2omf.title">
  <xsl:param name="info" select="*[substring(local-name(.), -4, 4) = 'info']"/>
  <title>
    <xsl:choose>
      <xsl:when test="$info/title">
	<xsl:value-of select="$info/title"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="title"/>
      </xsl:otherwise>
    </xsl:choose>
  </title>
</xsl:template>


<!-- == db2omf.date == -->

<ref:refname>db2omf.date</ref:refname>
<ref:refpurpose>
  Generate the <ref:xmltag>date</ref:xmltag> element
</ref:refpurpose>

<xsl:template name="db2omf.date">
  <xsl:param name="info" select="*[substring(local-name(.), -4, 4) = 'info']"/>
  <!-- FIXME -->
</xsl:template>


<!-- == db2omf.version == -->

<ref:refname>db2omf.version</ref:refname>
<ref:refpurpose>
  Generate the <ref:xmltag>version</ref:xmltag> element
</ref:refpurpose>

<xsl:template name="db2omf.version">
  <xsl:param name="info" select="*[substring(local-name(.), -4, 4) = 'info']"/>

  <xsl:variable name="identifier" select="$info/revhistory/revision[1]/revnumber"/>
  <xsl:variable name="date" select="$info/revhistory/revision[1]/date"/>

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


<!-- == db2omf.subject == -->

<ref:refname>db2omf.subject</ref:refname>
<ref:refpurpose>
  Generate the <ref:xmltag>subject</ref:xmltag> element
</ref:refpurpose>

<xsl:template name="db2omf.subject">
  <xsl:param name="info" select="*[substring(local-name(.), -4, 4) = 'info']"/>
  <xsl:variable name="subject" select="$omf_in/omf/resource/subject"/>
  <xsl:if test="not($subject)">
    <xsl:message>
      <xsl:text>Missing subject in .omf.in file</xsl:text>
    </xsl:message>
  </xsl:if>
  <subject>
    <xsl:value-of select="$subject"/>
  </subject>
</xsl:template>


<!-- == db2omf.description == -->

<ref:refname>db2omf.description</ref:refname>
<ref:refpurpose>
  Generate the <ref:xmltag>description</ref:xmltag> element
</ref:refpurpose>

<xsl:template name="db2omf.description">
  <xsl:param name="info" select="*[substring(local-name(.), -4, 4) = 'info']"/>

  <xsl:variable name="description" select="$info/abstract[@role = 'description']"/>

  <xsl:if test="not($description)">
    <xsl:message>
      <xsl:text>Missing abstract with role description</xsl:text>
    </xsl:message>
  </xsl:if>

  <description>
    <!-- FIXME: a smarter textification would be good -->
    <xsl:value-of select="$description"/>
  </description>
</xsl:template>


<!-- == db2omf.type == -->

<ref:refname>db2omf.type</ref:refname>
<ref:refpurpose>
  Generate the <ref:xmltag>type</ref:xmltag> element
</ref:refpurpose>

<xsl:template name="db2omf.type">
  <xsl:param name="info" select="*[substring(local-name(.), -4, 4) = 'info']"/>
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


<!-- == db2omf.format == -->

<ref:refname>db2omf.format</ref:refname>
<ref:refpurpose>
  Generate the <ref:xmltag>format</ref:xmltag> element
</ref:refpurpose>

<xsl:template name="db2omf.format">
  <xsl:param name="info" select="*[substring(local-name(.), -4, 4) = 'info']"/>
  <!-- FIXME -->
</xsl:template>


<!-- == db2omf.identifier == -->

<ref:refname>db2omf.identifier</ref:refname>
<ref:refpurpose>
  Generate the <ref:xmltag>identifier</ref:xmltag> element
</ref:refpurpose>

<xsl:template name="db2omf.identifier">
  <xsl:param name="info" select="*[substring(local-name(.), -4, 4) = 'info']"/>
  <!-- FIXME -->
</xsl:template>


<!-- == db2omf.language == -->

<ref:refname>db2omf.language</ref:refname>
<ref:refpurpose>
  Generate the <ref:xmltag>language</ref:xmltag> element
</ref:refpurpose>

<xsl:template name="db2omf.language">
  <xsl:param name="info" select="*[substring(local-name(.), -4, 4) = 'info']"/>
  <!-- FIXME -->
</xsl:template>


<!-- == db2omf.relation == -->

<ref:refname>db2omf.relation</ref:refname>
<ref:refpurpose>
  Generate the <ref:xmltag>relation</ref:xmltag> element
</ref:refpurpose>

<xsl:template name="db2omf.relation">
  <xsl:param name="info" select="*[substring(local-name(.), -4, 4) = 'info']"/>
  <xsl:variable name="seriesid" select="$omf_in/omf/resource/relation"/>
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


<!-- == db2omf.rights == -->

<ref:refname>db2omf.rights</ref:refname>
<ref:refpurpose>
  Generate the <ref:xmltag>rights</ref:xmltag> element
</ref:refpurpose>

<xsl:template name="db2omf.rights">
  <xsl:param name="info" select="*[substring(local-name(.), -4, 4) = 'info']"/>
  <!-- FIXME -->
</xsl:template>

</xsl:stylesheet>
