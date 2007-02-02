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

<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:mal='http://www.gnome.org/~shaunm/mallard'
                version='1.0'>

<xsl:output omit-xml-declaration="yes"/>

<xsl:template match='mal:guide'>
  <mal:guide id='{@id}'><mal:info>
    <xsl:copy-of select='mal:info/*'/>
  </mal:info>
  <xsl:apply-templates select='mal:section'/>
  </mal:guide>
</xsl:template>

<xsl:template match='mal:topic'>
  <mal:topic id='{@id}'><mal:info>
    <xsl:copy-of select='mal:info/*'/>
  </mal:info>
  <xsl:apply-templates select='mal:section'/>
  </mal:topic>
</xsl:template>

<xsl:template match='mal:section'>
  <mal:section id='{@id}'><mal:info>
    <xsl:copy-of select='mal:info/*'/>
  </mal:info>
  <xsl:apply-templates select='mal:section'/>
  </mal:section>
</xsl:template>

</xsl:stylesheet>
