#!/usr/bin/python -u
# Copyright (c) 2004 Danilo Segan <danilo@kvota.net>.
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

# xml2po -- translate XML documents
VERSION = "1.0.5"

# Versioning system (I use this for a long time, so lets explain it to
# those Linux-versioning-scheme addicts):
#   1.0.* are unstable, development versions
#   1.1 will be first stable release (release 1), and 1.1.* bugfix releases
#   2.0.* will be unstable-feature-development stage (milestone 1)
#   2.1.* unstable development betas (milestone 2)
#   2.2 second stable release (release 2), and 2.2.* bugfix releases
#   ...
#
import sys
import libxml2
import gettext
import os
import re

class MessageOutput:
    def __init__(self):
        self.messages = []
        self.comments = {}
        self.linenos = {}

    def setFilename(self, filename):
        self.filename = filename

    def outputMessage(self, text, lineno = 0, comment = None, spacepreserve = 0):
        """Adds a string to the list of messages."""
        if (text.strip() != ''):
            t = escapePoString(normalizeString(text, not spacepreserve))
            if not t in self.messages:
                self.messages.append(t)
                if t in self.linenos.keys():
                    self.linenos[t].append((self.filename, lineno))
                else:
                    self.linenos[t] = [ (self.filename, lineno) ]
                if comment and not t in self.comments:
                    self.comments[t] = comment
            else:
                if t in self.linenos.keys():
                    self.linenos[t].append((self.filename, lineno))
                else:
                    self.linenos[t] = [ (self.filename, lineno) ]
                if comment and not t in self.comments:
                    self.comments[t] = comment

    def outputAll(self, out):
        for k in self.messages:
            if k in self.comments:
                out.write("#. %s\n" % (self.comments[k].replace("\n","\n#. ")))
            references = ""
            for reference in self.linenos[k]:
                references += "%s:%d " % (reference[0], reference[1])
            out.write("#: %s\n" % (references))
            out.write("msgid \"%s\"\n" % (k))
            out.write("msgstr \"\"\n\n")



def normalizeNode(node):
    #print node.content
    if not node:
        return
    elif isSpacePreserveNode(node):
        return
    elif node.isText():
        if node.isBlankNode():
            node.setContent('')
        else:
            node.setContent(re.sub('\s+',' ', node.content))

    elif node.children:
        child = node.children
        while child:
            normalizeNode(child)
            child = child.next

def normalizeString(text, ignorewhitespace = 1):
    """Normalizes string to be used as key for gettext lookup.

    Removes all unnecessary whitespace."""
    if not ignorewhitespace:
        return text
    try:
        # Lets add document DTD so entities are resolved
        dtd = doc.intSubset()
        tmp = dtd.serialize() + '<norm>%s</norm>' % text
    except:
        tmp = '<norm>%s</norm>' % text

    try:
        tree = libxml2.parseMemory(tmp,len(tmp))
        newnode = tree.getRootElement()
    except:
        print >> sys.stderr, """Error while normalizing string as XML:\n"%s"\n""" % (text)
        return text

    normalizeNode(newnode)

    result = ''
    child = newnode.children
    while child:
        result += child.serialize('utf-8')
        child = child.next

    result = re.sub('^ ','', result)
    result = re.sub(' $','', result)
    
    return result

def stringForEntity(node):
    """Replaces entities in the node."""
    text = node.serialize()
    try:
        # Lets add document DTD so entities are resolved
        dtd = node.doc.intSubset()
        tmp = dtd.serialize() + '<norm>%s</norm>' % text
        next = 1
    except:
        tmp = '<norm>%s</norm>' % text
        next = 0

    ctxt = libxml2.createDocParserCtxt(tmp)
    ctxt.replaceEntities(1)
    ctxt.parseDocument()
    tree = ctxt.doc()
    if next:
        newnode = tree.children.next
    else:
        newnode = tree.children

    result = ''
    child = newnode.children
    while child:
        result += child.serialize('utf-8')
        child = child.next

    return result


def escapePoString(text):
    return text.replace('\\','\\\\').replace('"', "\\\"").replace("\n","\\n").replace("\t","\\t")

def unEscapePoString(text):
    return text.replace('\\"', '"').replace('\\\\','\\')

def getTranslation(text, spacepreserve = 0):
    """Returns a translation via gettext for specified snippet.

    text may be a string when it is used verbatim, or a tuple (pair), with
    first component being a string, and the other being a list of replacements.
    """
    text = normalizeString(text, not spacepreserve)
    if (text.strip() == ''):
        return text
    file = open(mofile, "rb")
    if file:
        gt = gettext.GNUTranslations(file)
        if gt:
            return gt.gettext(text)
    return text

def startTagForNode(node):
    if not node:
        return 0

    result = node.name
    params = ''
    if node.properties:
        for p in node.properties:
            if p.type == 'attribute':
                # This part sucks
                try:
                    params += ' %s:%s="%s"' % (p.ns().name, p.name, p.content)
                except:
                    params += ' %s="%s"' % (p.name, p.content)
    return result+params
        
def isFinalNode(node):
    if automatic:
        auto = autoNodeIsFinal(node)
        # Check if any of the parents is also autoNodeIsFinal,
        # and if it is, don't consider this node a final one
        parent = node.parent
        while parent and auto:
            auto = not autoNodeIsFinal(parent)
            parent = parent.parent
        return auto
    #node.type =='text' or not node.children or
    if node.type == 'element' and node.name in ultimate_tags:
        return 1
    return 0

def ignoreNode(node):
    if automatic:
        if node.type in ('dtd', 'comment'):
            return 1
        else:
            return 0
    else:
        if isFinalNode(node):
            return 0
        if node.name in ignored_tags or node.type in ('dtd', 'comment'):
            return 1
        return 0

def isSpacePreserveNode(node):
    pres = node.getSpacePreserve()
    if pres == 1:
        return 1
    else:
        if CurrentXmlMode and (node.name in CurrentXmlMode.getSpacePreserveTags()):
            return 1
        else:
            return 0

def getCommentForNode(node):
    """Walk through previous siblings until a comment is found, or other element.

    Only whitespace is allowed between comment and current node."""
    prev = node.prev
    while prev and prev.type == 'text' and prev.content.strip() == '':
        prev = prev.prev
    if prev and prev.type == 'comment':
        return prev.content.strip()
    else:
        return None

def replaceNodeContentsWithText(node,text):
    """Replaces all subnodes of a node with contents of text treated as XML."""
    #print >> sys.stderr, text
    if node.children:
        tmp = '<%s>%s</%s>' % (startTagForNode(node), text, node.name)
        try:
            newnode = libxml2.parseMemory(tmp,len(tmp))
        except:
            print >> sys.stderr, """Error while parsing translation as XML:\n"%s"\n""" % (text)
            return
        free = node.children
        while free:
            next = free.next
            free.unlinkNode()
            free = next
        node.addChildList(newnode.children.children)
    else:
        node.setContent(text)

def processFinalTag(node, outtxt):
    """node must be isFinalTag, this must be checked before calling this function."""
    global semitrans
    if mode == 'merge':
        outtxt = getTranslation(outtxt, isSpacePreserveNode(node))
        for i in semitrans.keys():
            outtxt = outtxt.replace('<placeholder-%d/>' % (i), semitrans[i])
        replaceNodeContentsWithText(node,outtxt)
    else:
        if node.name not in ignored_tags:
            msg.outputMessage(outtxt, node.lineNo(), getCommentForNode(node), isSpacePreserveNode(node))
    return outtxt

def autoNodeIsFinal(node):
    """Returns 1 if node is text node, contains non-whitespace text nodes or entities."""
    final = 0
    if node.isText() and node.content.strip()!='':
        return 1
    child = node.children
    while child:
        if child.type in ['text'] and  child.content.strip()!='':
            final = 1
            break
        child = child.next

    return final


def worthOutputting(node):
    """Returns 1 if node is "worth outputting", otherwise 0.

    Node is "worth outputting", if none of the parents
    isFinalNode, and it contains non-blank text and entities.
    """
    worth = 1
    parent = node.parent
    while parent:
        if isFinalNode(parent):
            worth = 0
            break
        parent = parent.parent
    if not worth:
        return 0

    return autoNodeIsFinal(node)
    
def processElementTag(node):
    """Process node with node.type == 'element'."""
    if node.type == 'element':
        global PlaceHolder
        global semitrans
        final = isFinalNode(node)
        outtxt = ''
        if final:
            storeholder = PlaceHolder
            PlaceHolder = 0
            storesemi = semitrans
            semitrans = {}
        child = node.children
        while child:
            if isFinalNode(child):
                PlaceHolder += 1
                newmsg = doSerialize(child)
                result = '<placeholder-%d/>' % (PlaceHolder)
                if mode=='merge':
                    semitrans[PlaceHolder] = getTranslation(newmsg, isSpacePreserveNode(node))
            else:
                result = doSerialize(child)
            outtxt += result
            child = child.next

        if final:
            outtxt = processFinalTag(node, outtxt)
            PlaceHolder = storeholder
            semitrans = storesemi
            return '<%s>%s</%s>' % (startTagForNode(node), outtxt, node.name)
        else:
            if worthOutputting(node):
                if mode == 'merge':
                    replaceNodeContentsWithText(node,getTranslation(outtxt, isSpacePreserveNode(node)))
                else:
                    msg.outputMessage(outtxt, node.lineNo(), getCommentForNode(node), isSpacePreserveNode(node))
            return '<%s>%s</%s>' % (startTagForNode(node), outtxt, node.name)
    else:
        raise Exception("You must pass node with node.type=='element'.")


def isExternalGeneralParsedEntity(node):
    if (node and node.type=='entity_ref'):
        try:
            # it would be nice if debugDumpNode could use StringIO, but it apparently cannot
            tmp = file(".xml2po-entitychecking","w+")
            node.debugDumpNode(tmp,0)
            tmp.seek(0)
            tmpstr = tmp.read()
            tmp.close()
            os.remove(".xml2po-entitychecking")
        except:
            # We fail silently, and replace all entities if we cannot
            # write .xml2po-entitychecking
            # !!! This is not very nice thing to do, but I don't know if
            #     raising an exception is any better
            return 0
        if tmpstr.find('EXTERNAL_GENERAL_PARSED_ENTITY') != -1:
            return 1
        else:
            return 0
    else:
        return 0

def doSerialize(node):
    """Serializes a node and its children, emitting PO messages along the way.

    node is the node to serialize, first indicates whether surrounding
    tags should be emitted as well.
    """
    if ignoreNode(node):
        return ''
    elif not node.children:
        return node.serialize("utf-8")
    elif node.type == 'entity_ref':
        if isExternalGeneralParsedEntity(node):
            return node.serialize('utf-8')
        else:
            return stringForEntity(node) #content #content #serialize("utf-8")
    elif node.type == 'entity_decl':
        return node.serialize() #'<%s>%s</%s>' % (startTagForNode(node), node.content, node.name)
    elif node.type == 'text':
        return node.serialize()
    elif node.type == 'element':
        return processElementTag(node)
    else:
        child = node.children
        outtxt = ''
        while child:
            outtxt += doSerialize(child)
            child = child.next
        return outtxt

    
def read_finaltags(filelist):
    if CurrentXmlMode:
        return CurrentXmlMode.getFinalTags()
    else:
        defaults = ['para', 'title', 'releaseinfo', 'revnumber',
                    'date', 'itemizedlist', 'orderedlist',
                    'variablelist', 'varlistentry', 'term' ]
        return defaults

def read_ignoredtags(filelist):
    if CurrentXmlMode:
        return CurrentXmlMode.getIgnoredTags()
    else:
        defaults = ['itemizedlist', 'orderedlist', 'variablelist',
                    'varlistentry' ]
        return defaults

def tryToUpdate(allargs, lang):
    # Remove "-u" and "--unicode-options"
    command = allargs[0]
    args = allargs[1:]
    opts, args = getopt.getopt(args, 'avhm:t:o:p:u:',
                               ['automatic-tags','version', 'help', 'merge', 'translation=',
                                'output=', 'po-file=', 'update-translation=' ])
    for opt, arg in opts:
        if opt in ('-a', '--automatic-tags'):
            command += " -a"
        elif opt in ('-m', '--mode'):
            command += " -m %s" % arg
        elif opt in ('-o', '--output'):
            sys.stderr.write("Error: Option '-o' is not yet supported when updating translations directly.\n")
            sys.exit(8)
        elif opt in ('-v', '--version'):
            print VERSION
            sys.exit(0)
        elif opt in ('-h', '--help'):
            sys.stderr.write("Error: If you want help, please use `%s --help' without '-u' option.\n" % (allargs[0]))
            sys.exit(9)
        elif opt in ('-u', '--update-translation'):
            pass
        else:
            sys.stderr.write("Error: Option `%s' is not supported with option `-u'.\n" % (opt))
            sys.exit(9)

    while args:
        command += " " + args.pop()

    file = lang + ".po"

    sys.stderr.write("Merging translations for %s: " % (lang))
    result = os.system("%s | msgmerge -o .tmp.%s.po %s -" % (command, lang, file))
    if result:
        sys.exit(10)
    else:
        result = os.system("mv .tmp.%s.po %s" % (lang, file))
        if result:
            sys.stderr.write("Error: cannot rename file.\n")
            sys.exit(11)
        else:
            os.system("msgfmt -cv -o /dev/null %s" % (file))
            sys.exit(0)

def load_mode(modename):
    #import imp
    #found = imp.find_module(modename, submodes_path)
    #module = imp.load_module(modename, found[0], found[1], found[2])
    try:
        sys.path.append(submodes_path)
        module = __import__(modename)
        modeModule = '%sXmlMode' % modename
        return getattr(module, modeModule)
    except:
        return None

def xml_error_handler(arg, ctxt):
    pass

libxml2.registerErrorHandler(xml_error_handler, None)


# Main program start

# Parameters
submodes_path = "/home/danilo/cvs/i18n/xml2po/modes"
default_mode = 'docbook'

filename = ''
mofile = ''
ultimate = [ ]
ignored = [ ]
filenames = [ ]

mode = 'pot' # 'pot' or 'merge'
automatic = 0

output  = '-' # this means to stdout

import getopt, fileinput

args = sys.argv[1:]
opts, args = getopt.getopt(args, 'avhm:t:o:p:u:',
                           ['automatic-tags','version', 'help', 'mode=', 'translation=',
                            'output=', 'po-file=', 'update-translation=' ])
for opt, arg in opts:
    if opt in ('-m', '--mode'):
        default_mode = arg
    if opt in ('-a', '--automatic-tags'):
        automatic = 1
    elif opt in ('-t', '--translation'):
        mofile = arg
        mode = 'merge'
        translationlanguage = os.path.splitext(mofile)[0]
    elif opt in ('-u', '--update-translation'):
        tryToUpdate(sys.argv, arg)
    elif opt in ('-p', '--po-file'):
        mofile = ".xml2po.mo"
        pofile = arg
        translationlanguage = os.path.splitext(pofile)[0]
        os.system("msgfmt -o %s %s >/dev/null" % (mofile, pofile)) and sys.exit(7)
        mode = 'merge'
    elif opt in ('-o', '--output'):
        output = arg
    elif opt in ('-v', '--version'):
        print VERSION
        sys.exit(0)
    elif opt in ('-h', '--help'):
        print >> sys.stderr, "Usage:  %s [OPTIONS] [XMLFILE]..." % (sys.argv[0])
        print >> sys.stderr, """
OPTIONS may be some of:
    -a    --automatic-tags     Automatically decides if tags are to be considered
                                 "final" or not (overrides -f and -i options)
    -m    --mode=TYPE          Treat tags as type TYPE (default: docbook)
    -o    --output=FILE        Print resulting text (XML or POT) to FILE
    -p    --po-file=FILE       Specify PO file containing translation, and merge
                                 Overwrites temporary file .xml2po.mo.
    -t    --translation=FILE   Specify MO file containing translation, and merge
    -u    --update-translation=LANG   Updates a PO file using msgmerge program
    -v    --version            Output version of the xml2po program

    -h    --help               Output this message

EXAMPLES:
    To create a POTemplate book.pot from input files chapter1.xml and
    chapter2.xml, run the following:
        %s -o book.pot chapter1.xml chapter2.xml

    After translating book.pot into de.po, merge the translations back,
    using -p option for each XML file:
        %s -p de.po chapter1.xml > chapter1.de.xml
        %s -p de.po chapter2.xml > chapter2.de.xml
""" % (sys.argv[0], sys.argv[0], sys.argv[0])
        sys.exit(0)

# Treat remaining arguments as XML files
while args:
    filenames.append(args.pop())

if len(filenames) > 1 and mode=='merge':
    print  >> sys.stderr, "Error: You can merge translations with only one XML file at a time."
    sys.exit(2)

try:
    CurrentXmlMode = load_mode(default_mode)()
except:
    CurrentXmlMode = None
    print >> sys.stderr, "Warning: cannot load module '%s', using automatic detection (-a)." % (default_mode)
    automatic = 1

if mode=='merge' and mofile=='':
    print >> sys.stderr, "Error: You must specify MO file when merging translations."
    sys.exit(3)

ultimate_tags = read_finaltags(ultimate)
ignored_tags = read_ignoredtags(ignored)

# I'm not particularly happy about making any of these global,
# but I don't want to bother too much with it right now
semitrans = {}
PlaceHolder = 0
msg = MessageOutput()

for filename in filenames:
    try:
        ctxt = libxml2.createFileParserCtxt(filename)
        ctxt.lineNumbers(1)
        ctxt.parseDocument()
        doc = ctxt.doc()
        if doc.name != filename:
            print >> sys.stderr, "Error: I tried to open '%s' but got '%s' -- how did that happen?" % (filename, doc.name)
            sys.exit(4)
    except:
        print >> sys.stderr, "Error: cannot open file '%s'." % (filename)
        sys.exit(1)

    msg.setFilename(filename)
    if CurrentXmlMode:
        CurrentXmlMode.preProcessXml(doc,msg)
    doSerialize(doc)

if output == '-':
    out = sys.stdout
else:
    try:
        out = file(output, 'w')
    except:
        print >> sys.stderr, "Error: cannot open file %s for writing." % (output)
        sys.exit(5)

if mode != 'merge':
    if CurrentXmlMode:
        tcmsg = CurrentXmlMode.getStringForTranslators()
        tccom = CurrentXmlMode.getCommentForTranslators()
        if tcmsg:
            msg.outputMessage(tcmsg, 0, tccom)

    msg.outputAll(out)
else:
    if CurrentXmlMode:
        tcmsg = CurrentXmlMode.getStringForTranslators()
        if tcmsg:
            outtxt = getTranslation(tcmsg)
        else:
            outtxt = ''
        CurrentXmlMode.postProcessXmlTranslation(doc, translationlanguage, outtxt)
    out.write(doc.serialize('utf-8', 1))
