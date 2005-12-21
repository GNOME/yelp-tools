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
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Titlepages</doc:title>


<!-- == db2html.info ======================================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.info</name>
  <purpose>
    Render the titlepage of a block-level element
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The element for which to generate a titlepage
    </purpose>
  </parameter>
  <parameter>
    <name>info</name>
    <purpose>
      The info element containing metadata
    </purpose>
  </parameter>
</template>

<xsl:template name="db2html.info">
  <xsl:param name="node" select="."/>
  <xsl:param name="info"/>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth_of_chunk">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>
  <html>
    <head>
      <xsl:call-template name="db2html.css"/>
    </head>
    <body>
      <div class="body">
        <div class="{local-name($info)}">
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
          <xsl:call-template name="db2html.info.copyrights">
            <xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="info" select="$info"/>
          </xsl:call-template>
          <xsl:apply-templates mode="db2html.info.mode" select="$info/legalnotice"/>
          <xsl:apply-templates mode="db2html.info.mode" select="$info/revhistory"/>
        </div>
      </div>
    </body>
  </html>
</xsl:template>


<!-- == db2html.info.title ================================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.info.title</name>
  <purpose>
    Render the title of a titlepage
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The element for which a titlepage is being generated
    </purpose>
  </parameter>
  <parameter>
    <name>info</name>
    <purpose>
      The info element containing metadata
    </purpose>
  </parameter>
</template>

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


<!-- == db2html.info.subtitle ============================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.info.subtitle</name>
  <purpose>
    Render the subtitle of a titlepage
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The element for which a titlepage is being generated
    </purpose>
  </parameter>
  <parameter>
    <name>info</name>
    <purpose>
      The info element containing metadata
    </purpose>
  </parameter>
</template>

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


<!-- == db2html.info.authors =============================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.info.authors</name>
  <purpose>
    Render the author credits in a titlepage
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The element for which a titlepage is being generated
    </purpose>
  </parameter>
  <parameter>
    <name>info</name>
    <purpose>
      The info element containing metadata
    </purpose>
  </parameter>
</template>

<xsl:template name="db2html.info.authors">
  <xsl:param name="node" select="."/>
  <xsl:param name="info" select="'FIXME'"/>
  <xsl:variable name="authors" select="
                $info/author     | $info/authorgroup/author     |
                $info/corpauthor | $info/authorgroup/corpauthor "/>
  <xsl:if test="$authors">
    <div>
      <h2 class="author">
        <xsl:call-template name="l10n.gettext">
          <xsl:with-param name="msgid" select="'Author'"/>
          <xsl:with-param name="number" select="count($authors)"/>
        </xsl:call-template>
      </h2>
      <dl>
        <xsl:apply-templates mode="db2html.info.mode" select="$authors"/>
      </dl>
    </div>
  </xsl:if>
</xsl:template>


<!-- == db2html.info.editors =============================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.info.editors</name>
  <purpose>
    Render the editor credits in a titlepage
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The element for which a titlepage is being generated
    </purpose>
  </parameter>
  <parameter>
    <name>info</name>
    <purpose>
      The info element containing metadata
    </purpose>
  </parameter>
</template>

<xsl:template name="db2html.info.editors">
  <xsl:param name="node" select="."/>
  <xsl:param name="info" select="'FIXME'"/>
  <xsl:variable name="editors" select="
                $info/editor | $info/authorgroup/editor"/>
  <xsl:if test="$editors">
    <div>
      <h2 class="editor">
        <xsl:call-template name="l10n.gettext">
          <xsl:with-param name="msgid" select="'Editor'"/>
          <xsl:with-param name="number" select="count($editors)"/>
        </xsl:call-template>
      </h2>
      <dl>
        <xsl:apply-templates mode="db2html.info.mode" select="$editors"/>
      </dl>
    </div>
  </xsl:if>
</xsl:template>


<!-- == db2html.info.collabs =============================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.info.collabs</name>
  <purpose>
    Render the collaborator credits in a titlepage
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The element for which a titlepage is being generated
    </purpose>
  </parameter>
  <parameter>
    <name>info</name>
    <purpose>
      The info element containing metadata
    </purpose>
  </parameter>
</template>

<xsl:template name="db2html.info.collabs">
  <xsl:param name="node" select="."/>
  <xsl:param name="info" select="'FIXME'"/>
  <xsl:variable name="collabs" select="
                $info/collab | $info/authorgroup/collab"/>
  <xsl:if test="$collabs">
    <div>
      <h2 class="collab">
        <xsl:call-template name="l10n.gettext">
          <xsl:with-param name="msgid" select="'Collaborator'"/>
          <xsl:with-param name="number" select="count($collabs)"/>
        </xsl:call-template>
      </h2>
      <dl>
        <xsl:apply-templates mode="db2html.info.mode" select="$collabs"/>
      </dl>
    </div>
  </xsl:if>
</xsl:template>


<!-- == db2html.info.translators =========================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.info.translators</name>
  <purpose>
    Render the translator credits in a titlepage
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The element for which a titlepage is being generated
    </purpose>
  </parameter>
  <parameter>
    <name>info</name>
    <purpose>
      The info element containing metadata
    </purpose>
  </parameter>
</template>

<xsl:template name="db2html.info.translators">
  <xsl:param name="node" select="."/>
  <xsl:param name="info" select="'FIXME'"/>
  <xsl:variable name="translators" select="
                $info/corpcredit[@role = 'translator']               |
                $info/othercredit[@role = 'translator']              |
                $info/authorgroup/corpcredit[@role = 'translator']   |
                $info/authorgroup/othercredit[@role = 'translator']  "/>
  <xsl:if test="$translators">
    <div>
      <h2 class="translator">
        <xsl:call-template name="l10n.gettext">
          <xsl:with-param name="msgid" select="'Translator'"/>
          <xsl:with-param name="number" select="count($translators)"/>
        </xsl:call-template>
      </h2>
      <dl>
        <xsl:apply-templates mode="db2html.info.mode" select="$translators"/>
      </dl>
    </div>
  </xsl:if>
</xsl:template>


<!-- == db2html.info.publishers ============================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.info.publishers</name>
  <purpose>
    Render the publisher credits in a titlepage
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The element for which a titlepage is being generated
    </purpose>
  </parameter>
  <parameter>
    <name>info</name>
    <purpose>
      The info element containing metadata
    </purpose>
  </parameter>
</template>

<xsl:template name="db2html.info.publishers">
  <xsl:param name="node" select="."/>
  <xsl:param name="info" select="'FIXME'"/>
  <xsl:variable name="publishers" select="$info/publisher"/>
  <xsl:if test="$publishers">
    <div>
      <h2 class="publisher">
        <xsl:call-template name="l10n.gettext">
          <xsl:with-param name="msgid" select="'Publisher'"/>
          <xsl:with-param name="number" select="count($publishers)"/>
        </xsl:call-template>
      </h2>
      <dl>
        <xsl:apply-templates mode="db2html.info.mode" select="$publishers"/>
      </dl>
    </div>
  </xsl:if>
</xsl:template>


<!-- == db2html.info.othercredits ========================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.info.othercredits</name>
  <purpose>
    Render all other credits in a titlepage
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The element for which a titlepage is being generated
    </purpose>
  </parameter>
  <parameter>
    <name>info</name>
    <purpose>
      The info element containing metadata
    </purpose>
  </parameter>
</template>

<xsl:template name="db2html.info.othercredits">
  <xsl:param name="node" select="."/>
  <xsl:param name="info" select="'FIXME'"/>
  <xsl:variable name="othercredits" select="
                $info/conbrib                                        |
                $info/corpcredit[@role != 'translator']              |
                $info/othercredit[@role != 'translator']             |
                $info/authorgroup/corpcredit[@role != 'translator']  |
                $info/authorgroup/othercredit[@role != 'translator'] "/>
  <xsl:if test="$othercredits">
    <div>
      <h2 class="othercredit">
        <xsl:call-template name="l10n.gettext">
          <xsl:with-param name="msgid" select="'Other Contributor'"/>
          <xsl:with-param name="number" select="count($othercredits)"/>
        </xsl:call-template>
      </h2>
      <dl>
        <xsl:apply-templates mode="db2html.info.mode" select="$othercredits"/>
      </dl>
    </div>
  </xsl:if>
</xsl:template>


<!-- == db2html.info.copyrights ============================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.info.copyrights</name>
  <purpose>
    Render the copyrights in a titlepage
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The element for which a titlepage is being generated
    </purpose>
  </parameter>
  <parameter>
    <name>info</name>
    <purpose>
      The info element containing metadata
    </purpose>
  </parameter>
</template>

<xsl:template name="db2html.info.copyrights">
  <xsl:param name="node" select="."/>
  <xsl:param name="info" select="'FIXME'"/>
  <xsl:variable name="copyrights" select="$info/copyright"/>
  <xsl:if test="$copyrights">
    <div>
      <h2 class="copyright">
        <xsl:call-template name="l10n.gettext">
          <xsl:with-param name="msgid" select="'Copyright'"/>
          <xsl:with-param name="number" select="count($copyrights)"/>
        </xsl:call-template>
      </h2>
      <dl>
        <xsl:apply-templates mode="db2html.info.mode" select="$copyrights"/>
      </dl>
    </div>
  </xsl:if>
</xsl:template>


<!-- == Matched Templates == -->

<!-- = authorblurb/title = -->
<xsl:template match="authorblurb/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

<!-- = legalnotice/title = -->
<xsl:template match="legalnotice/title">
  <h2>
    <xsl:apply-templates/>
  </h2>
</xsl:template>

<!-- = personblurb/title = -->
<xsl:template match="personblurb/title">
  <xsl:call-template name="db2html.title.simple"/>
</xsl:template>

<!-- = db2html.info.mode == affiliation = -->
<xsl:template mode="db2html.info.mode" match="affiliation">
  <dd class="affiliation">
    <i>
      <xsl:call-template name="l10n.gettext">
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
    <xsl:variable name="node" select="(. | personname)[last()]"/>
    <xsl:call-template name="db.personname">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
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

<!-- = db2html.info.mode == collab = -->
<xsl:template mode="db2html.info.mode" match="collab">
  <dt class="collab">
    <xsl:apply-templates mode="db2html.info.mode" select="collabname"/>
  </dt>
  <xsl:apply-templates mode="db2html.info.mode"
                       select="affiliation[orgname]"/>
</xsl:template>

<!-- = db2html.info.mode == collabname = -->
<xsl:template mode="db2html.info.mode" match="collabname">
  <span class="collabname">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<!-- = db2html.info.mode == corpauthor = -->
<xsl:template mode="db2html.info.mode" match="corpauthor">
  <dt class="corpauthor">
    <!-- Can occur outside db2html.info.mode, so apply those templates -->
    <xsl:apply-templates select="."/>
  </dt>
</xsl:template>

<!-- = db2html.info.mode == corpcredit = -->
<xsl:template mode="db2html.info.mode" match="corpname">
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
    <!-- Can occur outside db2html.info.mode, so apply those templates -->
    <xsl:apply-templates select="."/>
  </dt>
</xsl:template>

<!-- = db2html.info.mode == copyright = -->
<xsl:template mode="db2html.info.mode" match="copyright">
  <dt class="copyright">
    <xsl:call-template name="l10n.gettext">
      <xsl:with-param name="msgid" select="'Copyright'"/>
    </xsl:call-template>
    <xsl:text>&#x00A0;©&#x00A0;</xsl:text>
    <xsl:for-each select="year">
      <xsl:if test="position() != 1">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:apply-templates mode="db2html.info.mode" select="."/>
    </xsl:for-each>
    <xsl:text>&#x00A0;&#x00A0;</xsl:text>
    <xsl:for-each select="holder">
      <xsl:if test="position() != 1">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:apply-templates mode="db2html.info.mode" select="."/>
    </xsl:for-each>
  </dt>
</xsl:template>

<!-- = db2html.info.mode == editor = -->
<xsl:template mode="db2html.info.mode" match="date">
  <xsl:apply-templates select="."/>
</xsl:template>

<!-- = db2html.info.mode == editor = -->
<xsl:template mode="db2html.info.mode" match="editor">
  <dt class="editor">
    <xsl:variable name="node" select="(. | personname)[last()]"/>
    <xsl:call-template name="db.personname">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
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
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'Email'"/>
      </xsl:call-template>
      <xsl:text>: </xsl:text>
    </i>
    <!-- Can occur outside db2html.info.mode, so apply those templates -->
    <xsl:apply-templates select="."/>
  </dd>
</xsl:template>

<!-- = db2html.info.mode == holder = -->
<xsl:template mode="db2html.info.mode" match="holder">
  <span class="holder">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<!-- = db2html.info.mode == legalnotice = -->
<xsl:template mode="db2html.info.mode" match="legalnotice">
  <div class="legalnotice">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:if test="not(title)">
      <h2>
        <xsl:call-template name="l10n.gettext">
          <xsl:with-param name="msgid" select="'Legal Notice'"/>
        </xsl:call-template>
      </h2>
    </xsl:if>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<!-- = db2html.info.mode == orgname = -->
<xsl:template mode="db2html.info.mode" match="orgname">
  <!-- Can occur outside db2html.info.mode, so apply those templates -->
  <xsl:apply-templates select="."/>
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
    <xsl:variable name="node" select="(. | personname)[last()]"/>
    <xsl:call-template name="db.personname">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
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

<!-- = db2html.info.mode == revdescription = -->
<xsl:template mode="db2html.info.mode" match="revdescription">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = db2html.info.mode == revhistory = -->
<xsl:template mode="db2html.info.mode" match="revhistory">
  <div class="revhistory">
    <xsl:call-template name="db2html.anchor"/>
    <h2>
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'Revision History'"/>
      </xsl:call-template>
    </h2>
    <xsl:apply-templates mode="db2html.info.mode"/>
  </div>
</xsl:template>

<!-- = db2html.info.mode == revision = -->
<xsl:template mode="db2html.info.mode" match="revision">
  <div class="revision">
    <xsl:apply-templates mode="db2html.info.mode" select="date"/>
    <xsl:text>: </xsl:text>
    <xsl:apply-templates mode="db2html.info.mode" select="revnumber"/>
    <xsl:if test="revremark">
      <xsl:text>; </xsl:text>
    </xsl:if>
<!--
    <xsl:apply-templates mode="db2html.info.mode"
                         select="revremark | revdescription"/>
-->
    <xsl:if test="author | authorinitials | revdescription/para[@role='author']">
      <xsl:text> (</xsl:text>
      <xsl:for-each
       select="author | authorinitials | revdescription/para[@role='author']">
        <xsl:if test="position() != 1">
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="self::para">
            <xsl:apply-templates/>
          </xsl:when>
          <xsl:when test="self::authorinitials">
            <xsl:apply-templates select="."/>
          </xsl:when>
          <xsl:when test="personname">
            <xsl:call-template name="db.personname">
              <xsl:with-param name="node" select="personname"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="db.personname">
              <xsl:with-param name="node" select="."/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <xsl:text>)</xsl:text>
    </xsl:if>
  </div>
</xsl:template>

<!-- = db2html.info.mode == revnumber = -->
<xsl:template mode="db2html.info.mode" match="revnumber">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = db2html.info.mode == revremark = -->
<xsl:template mode="db2html.info.mode" match="revremark">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- = db2html.info.mode == year = -->
<xsl:template mode="db2html.info.mode" match="year">
  <span class="year">
    <xsl:apply-templates/>
  </span>
</xsl:template>


<!-- == db.chunk.info.content.mode ========================================= -->

<!-- = * = -->
<xsl:template mode="db.chunk.info.content.mode" match="*"/>

<!-- = appendix = -->
<xsl:template mode="db.chunk.info.content.mode" match="appendix">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.info">
    <xsl:with-param name="info" select="appendixinfo"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = article = -->
<xsl:template mode="db.chunk.info.content.mode" match="article">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.info">
    <xsl:with-param name="info" select="articleinfo"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = book = -->
<xsl:template mode="db.chunk.info.content.mode" match="book">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.info">
    <xsl:with-param name="info" select="bookinfo"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = chapter = -->
<xsl:template mode="db.chunk.info.content.mode" match="chapter">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.info">
    <xsl:with-param name="info" select="chapterinfo"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = glossary = -->
<xsl:template mode="db.chunk.info.content.mode" match="glossary">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.info">
    <xsl:with-param name="info" select="glossaryinfo"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = part = -->
<xsl:template mode="db.chunk.info.content.mode" match="part">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.info">
    <xsl:with-param name="info" select="partinfo"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = preface = -->
<xsl:template mode="db.chunk.info.content.mode" match="preface">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.info">
    <xsl:with-param name="info" select="prefaceinfo"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = sect1 = -->
<xsl:template mode="db.chunk.info.content.mode" match="sect1">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.info">
    <xsl:with-param name="info" select="sect1info"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = sect2 = -->
<xsl:template mode="db.chunk.info.content.mode" match="sect2">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.info">
    <xsl:with-param name="info" select="sect2info"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = sect3 = -->
<xsl:template mode="db.chunk.info.content.mode" match="sect3">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.info">
    <xsl:with-param name="info" select="sect3info"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = sect4 = -->
<xsl:template mode="db.chunk.info.content.mode" match="sect4">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.info">
    <xsl:with-param name="info" select="sect4info"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = sect5 = -->
<xsl:template mode="db.chunk.info.content.mode" match="sect5">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.info">
    <xsl:with-param name="info" select="sect5info"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = section = -->
<xsl:template mode="db.chunk.info.content.mode" match="section">
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.info">
    <xsl:with-param name="info" select="sectioninfo"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
