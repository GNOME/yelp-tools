<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<!--
If you add a template to this stylesheet, put it under an appropriate header
that states why this element is suppressed.  Some elements are simply not
supported, while other elements are expected only to be processed in certain
modes because of the DocBook content model.
-->

<!-- Only occur in db2html.info.mode -->
<xsl:template match="affiliation"/>
<xsl:template match="author"/>
<xsl:template match="authorblurb"/>
<xsl:template match="authorgroup"/>
<xsl:template match="collab"/>
<xsl:template match="collabname"/>
<xsl:template match="copyright"/>
<xsl:template match="editor"/>
<xsl:template match="holder"/>
<xsl:template match="othercredit"/>
<xsl:template match="personblurb"/>
<xsl:template match="publisher"/>
<xsl:template match="publishername"/>
<xsl:template match="year"/>

<!-- Only occur in db2html.cmdsynopsis.mode -->
<xsl:template match="arg"/>
<xsl:template match="group"/>
<xsl:template match="sbr"/>
<xsl:template match="synopfragment"/>
<xsl:template match="synopfragmentref"/>

<!-- Only occur in db2html.funcsynopsis.mode -->
<xsl:template match="funcsynopsisinfo"/>

</xsl:stylesheet>
