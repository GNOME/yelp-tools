# Copyright (c) 2004, 2005, 2006 Danilo Segan <danilo@gnome.org>.
# Copyright (c) 2006 Claude Paroz <paroz@email.ch>.
#
# This file is part of xml2po.
#
# xml2po is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# xml2po is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with xml2po; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#

# This implements special instructions for handling XHTML documents
# in a better way, particularly to extract some attributes in HTML tags

class xhtmlXmlMode:
    """Class for special handling of XHTML document types."""
    def getIgnoredTags(self):
        "Returns array of tags to be ignored."
        return []

    def getFinalTags(self):
        "Returns array of tags to be considered 'final'."
        return ['p', 'li', 'pre']

    def getTreatedAttributes(self):
        "Returns array of tag attributes which content is to be translated"
        return ['title','alt']

    def getSpacePreserveTags(self):
        "Returns array of tags in which spaces are to be preserved."
        return ['pre']

    def preProcessXml(self, doc, msg):
        "Preprocess a document and perhaps adds some messages."
        pass

    def postProcessXmlTranslation(self, doc, language, translators):
        """Sets a language and translators in "doc" tree.

        "translators" is a string consisted of translator credits.
        "language" is a simple string.
        "doc" is a libxml2.xmlDoc instance."""
        pass

    def getStringForTranslators(self):
        """Returns None or a string to be added to PO files.

        Common example is 'translator-credits'."""
        return None

    def getCommentForTranslators(self):
        """Returns a comment to be added next to string for crediting translators.

        It should explain the format of the string provided by getStringForTranslators()."""
        return None
