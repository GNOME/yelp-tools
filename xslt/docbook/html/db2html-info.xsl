<?xml version='1.0' encoding='utf-8'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:ref="http://www.gnome.org/~shaunm/mallard/reference"
		exclude-result-prefixes="ref"
                version="1.0">

<ref:title>Titlepages</ref:title>


<!-- == db2html.info == -->

<ref:refname>db2html.info</ref:refname>
<ref:refpurpose>
  Render the titlepage of a block-level element
</ref:refpurpose>

<xsl:template name="db2html.info">
  <xsl:param name="node" select="."/>
  <xsl:param name="info" select="'FIXME'"/>
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth_in_chunk">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth_of_chunk">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>

  <div class="local-name($info)">
    <xsl:call-template name="db2html.anchor">
      <xsl:with-param name="name" select="local-name($info)"/>
    </xsl:call-template>
    <xsl:call-template name="db2html.info.title">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="info" select="$info"/>
    </xsl:call-template>
    <xsl:call-template name="db2html.info.subtitle">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="info" select="$info"/>
    </xsl:call-template>
    <xsl:call-template name="db2html.info.authors">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="info" select="$info"/>
    </xsl:call-template>
    <xsl:call-template name="db2html.info.editors">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="info" select="$info"/>
    </xsl:call-template>
    <xsl:call-template name="db2html.info.collabs">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="info" select="$info"/>
    </xsl:call-template>
    <xsl:call-template name="db2html.info.translators">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="info" select="$info"/>
    </xsl:call-template>
    <xsl:call-template name="db2html.info.publishers">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="info" select="$info"/>
    </xsl:call-template>
    <xsl:call-template name="db2html.info.othercredits">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="info" select="$info"/>
    </xsl:call-template>
  </div>
</xsl:template>


<!-- == db2html.info.title == -->

<ref:refname>db2html.info.title</ref:refname>
<ref:refpurpose>
  Render the title of a titlepage
</ref:refpurpose>

<xsl:template name="db2html.info.title">
  <xsl:param name="node" select="."/>
  <xsl:param name="info" select="'FIXME'"/>
  <xsl:choose>
    <xsl:when test="$info/title">
      <h1>
	<xsl:apply-templates mode="db2html.info.mode"
			     select="$info/title/node()"/>
      </h1>
    </xsl:when>
    <xsl:when test="$node/title">
      <h1>
	<xsl:apply-templates mode="db2html.info.mode"
			     select="$node/title/node()"/>
      </h1>
    </xsl:when>
  </xsl:choose>
</xsl:template>


<!-- == db2html.info.subtitle == -->

<ref:refname>db2html.info.subtitle</ref:refname>
<ref:refpurpose>
  Render the subtitle of a titlepage
</ref:refpurpose>

<xsl:template name="db2html.info.subtitle">
  <xsl:param name="node" select="."/>
  <xsl:param name="info" select="'FIXME'"/>
  <xsl:choose>
    <xsl:when test="$info/subtitle">
      <h1>
	<xsl:apply-templates mode="db2html.info.mode"
			     select="$info/subtitle/node()"/>
      </h1>
    </xsl:when>
    <xsl:when test="$node/subtitle">
      <h1>
	<xsl:apply-templates mode="db2html.info.mode"
			     select="$node/subtitle/node()"/>
      </h1>
    </xsl:when>
  </xsl:choose>
</xsl:template>


<!-- == db2html.info.authors == -->

<ref:refname>db2html.info.authors</ref:refname>
<ref:refpurpose>
  Render the author credits in a titlepage
</ref:refpurpose>

<xsl:template name="db2html.info.authors">
  <xsl:param name="node" select="."/>
  <xsl:param name="info" select="'FIXME'"/>
  <xsl:variable name="authors" select="
		$info/author     | $info/authorgroup/author     |
		$info/corpauthor | $info/authorgroup/corpauthor "/>
  <xsl:if test="$authors">
    <div>
      <h2 class="author">
	<xsl:call-template name="ngettext">
	  <xsl:with-param name="msgid" select="'Author'"/>
	  <xsl:with-param name="msgid_plural" select="'Authors'"/>
	  <xsl:with-param name="num" select="count($authors)"/>
	</xsl:call-template>
      </h2>
      <dl>
	<xsl:apply-templates mode="db2html.info.mode" select="$authors"/>
      </dl>
    </div>
  </xsl:if>
</xsl:template>


<!-- == db2html.info.editors == -->

<ref:refname>db2html.info.editors</ref:refname>
<ref:refpurpose>
  Render the editor credits in a titlepage
</ref:refpurpose>

<xsl:template name="db2html.info.editors">
  <xsl:param name="node" select="."/>
  <xsl:param name="info" select="'FIXME'"/>
  <xsl:variable name="editors" select="
		$info/editor | $info/authorgroup/editor"/>
  <xsl:if test="$editors">
    <div>
      <h2 class="editor">
	<xsl:call-template name="ngettext">
	  <xsl:with-param name="msgid" select="'Editor'"/>
	  <xsl:with-param name="msgid_plural" select="'Editors'"/>
	  <xsl:with-param name="num" select="count($editors)"/>
	</xsl:call-template>
      </h2>
      <dl>
	<xsl:apply-templates mode="db2html.info.mode" select="$editors"/>
      </dl>
    </div>
  </xsl:if>
</xsl:template>


<!-- == db2html.info.collabs == -->

<ref:refname>db2html.info.collabs</ref:refname>
<ref:refpurpose>
  Render the collaborator credits in a titlepage
</ref:refpurpose>

<xsl:template name="db2html.info.collabs">
  <xsl:param name="node" select="."/>
  <xsl:param name="info" select="'FIXME'"/>
  <xsl:variable name="collabs" select="
		$info/collab | $info/authorgroup/collab"/>
  <xsl:if test="$collabs">
    <div>
      <h2 class="collab">
	<xsl:call-template name="ngettext">
	  <xsl:with-param name="msgid" select="'Collaborator'"/>
	  <xsl:with-param name="msgid_plural" select="'Collaborators'"/>
	  <xsl:with-param name="num" select="count($collabs)"/>
	</xsl:call-template>
      </h2>
      <dl>
	<xsl:apply-templates mode="db2html.info.mode" select="$collabs"/>
      </dl>
    </div>
  </xsl:if>
</xsl:template>


<!-- == db2html.info.translators == -->

<ref:refname>db2html.info.translators</ref:refname>
<ref:refpurpose>
  Render the translator credits in a titlepage
</ref:refpurpose>

<xsl:template name="db2html.info.translators">
  <xsl:param name="node" select="."/>
  <xsl:param name="info" select="'FIXME'"/>
  <xsl:variable name="translators" select="
		$info/othercredit[@role = 'translator]              |
		$info/authorgroup/othercredit[@role = 'translator'] "/>
  <xsl:if test="$translators">
    <div>
      <h2 class="translator">
	<xsl:call-template name="ngettext">
	  <xsl:with-param name="msgid" select="'Translator'"/>
	  <xsl:with-param name="msgid_plural" select="'Translators'"/>
	  <xsl:with-param name="num" select="count($translators)"/>
	</xsl:call-template>
      </h2>
      <dl>
	<xsl:apply-templates mode="db2html.info.mode" select="$translators"/>
      </dl>
    </div>
  </xsl:if>
</xsl:template>


<!-- == db2html.info.publishers == -->

<ref:refname>db2html.info.publishers</ref:refname>
<ref:refpurpose>
  Render the publisher credits in a titlepage
</ref:refpurpose>

<xsl:template name="db2html.info.publishers">
  <xsl:param name="node" select="."/>
  <xsl:param name="info" select="'FIXME'"/>
  <xsl:variable name="publishers" select="$info/publisher"/>
  <xsl:if test="$publishers">
    <div>
      <h2 class="publisher">
	<xsl:call-template name="ngettext">
	  <xsl:with-param name="msgid" select="'Publisher'"/>
	  <xsl:with-param name="msgid_plural" select="'Publishers'"/>
	  <xsl:with-param name="num" select="count($publishers)"/>
	</xsl:call-template>
      </h2>
      <dl>
	<xsl:apply-templates mode="db2html.info.mode" select="$publishers"/>
      </dl>
    </div>
  </xsl:if>
</xsl:template>


<!-- == db2html.info.othercredits == -->

<ref:refname>db2html.info.othercredits</ref:refname>
<ref:refpurpose>
  Render all other credits in a titlepage
</ref:refpurpose>

<xsl:template name="db2html.info.othercredits">
  <xsl:param name="node" select="."/>
  <xsl:param name="info" select="'FIXME'"/>
  <xsl:variable name="othercredits" select="
		$info/conbrib                                       |
		$info/othercredit[@role != 'translator']            |
		$info/authorgroup/othercredi[@role != 'translator'] "/>
  <xsl:if test="$othercredits">
    <div>
      <h2 class="othercredit">
	<xsl:call-template name="gettext">
	  <xsl:with-param name="msgid" select="'Other Credits'"/>
	</xsl:call-template>
      </h2>
      <dl>
	<xsl:apply-templates mode="db2html.info.mode" select="$othercredits"/>
      </dl>
    </div>
  </xsl:if>
</xsl:template>


<!-- == Matched Templates == -->

<!-- = authorblurb/title = -->
<xsl:template match="authorblurb/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

<!-- = personblurb/title = -->
<xsl:template match="personblurb/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

<!-- = db2html.info.mode == affiliation = -->
<xsl:template mode="db2html.info.mode" match="affiliation">
  <dd class="affiliation">
    <i>
      <xsl:call-template name="gettext">
	<xsl:with-param name="msgid" select="'Affiliation'"/>
      </xsl:call-template>
      <xsl:text>: </xsl:text>
    </i>
    <xsl:apply-templates mode="db2html.info.mode" select="orgname"/>
  </dd>
</xsl:template>

<!-- = db2html.info.mode == author = -->
<xsl:template mode="db2html.info.mode" match="author">
  <dt class="author">
    <xsl:call-template name="db2html.personname"/>
  </dt>
  <xsl:apply-templates mode="db2html.info.mode"
		       select="affiliation[orgname]"/>
  <xsl:apply-templates mode="db2html.info.mode"
		       select="email | address/email"/>
  <xsl:apply-templates mode="db2html.info.mode"
		       select="authorblurb | personblurb"/>
</xsl:template>

<!-- = db2html.info.mode == authorgroup = -->
<xsl:template mode="db2html.info.mode" match="authorgroup">
  <!-- This should never happen.  We include it for clarity in the reports. -->
</xsl:template>

<!-- = db2html.info.mode == authorblurb = -->
<xsl:template mode="db2html.info.mode" match="authorblurb">
  <dd class="authorblurb">
    <xsl:apply-templates/>
  </dd>
</xsl:template>

<!-- = db2html.info.mode == corpauthor = -->
<xsl:template mode="db2html.info.mode" match="corpauthor">
  <dt class="corpauthor">
    <!-- Can occur outside db2html.info.mode, so apply those templates -->
    <xsl:apply-templates select="."/>
  </dt>
</xsl:template>

<!-- = db2html.info.mode == editor = -->
<xsl:template mode="db2html.info.mode" match="editor">
  <dt class="editor">
    <xsl:call-template name="db2html.personname"/>
  </dt>
  <xsl:apply-templates mode="db2html.info.mode"
		       select="affiliation[orgname]"/>
  <xsl:apply-templates mode="db2html.info.mode"
		       select="email | address/email"/>
  <xsl:apply-templates mode="db2html.info.mode"
		       select="authorblurb | personblurb"/>
</xsl:template>

<!-- = db2html.info.mode == email = -->
<xsl:template mode="db2html.info.mode" match="email">
  <dd class="affiliation">
    <i>
      <xsl:call-template name="gettext">
	<xsl:with-param name="msgid" select="'Email'"/>
      </xsl:call-template>
      <xsl:text>: </xsl:text>
    </i>
    <!-- Can occur outside db2html.info.mode, so apply those templates -->
    <xsl:apply-templates select="."/>
  </dd>
</xsl:template>

<!-- = db2html.info.mode == orgname = -->
<xsl:template mode="db2html.info.orgname" match="orgname">
  <!-- FIXME -->
</xsl:template>

<!-- = db2html.info.mode == othercredit = -->
<xsl:template mode="db2html.info.mode" match="othercredit">
  <dt>
    <xsl:attribute name="class">
      <xsl:choose>
	<xsl:when test="@role = 'translator'">
	  <xsl:text>translator</xsl:text>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:text>othercredit</xsl:text>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:call-template name="db2html.personname"/>
  </dt>
  <xsl:apply-templates mode="db2html.info.mode"
		       select="affiliation[orgname]"/>
  <xsl:apply-templates mode="db2html.info.mode"
		       select="email | address/email"/>
  <xsl:apply-templates mode="db2html.info.mode"
		       select="authorblurb | personblurb"/>
</xsl:template>

<!-- = db2html.info.mode == personblurb = -->
<xsl:template mode="db2html.info.mode" match="personblurb">
  <dd class="personblurb">
    <xsl:apply-templates/>
  </dd>
</xsl:template>

<!-- = db2html.info.mode == publisher = -->
<xsl:template mode="db2html.info.mode" match="publisher">
  <dt class="publisher">
    <xsl:apply-templates mode="db2html.info.mode"/>
  </dt>
</xsl:template>

<!-- = db2html.info.mode == publishername = -->
<xsl:template mode="db2html.info.mode" match="publishername">
  <span class="publishername">
    <xsl:apply-templates/>
  </span>
</xsl:template>

</xsl:stylesheet>
