#!/bin/python3
#
# yelp-check
# Copyright (C) 2011-2020 Shaun McCance <shaunm@gnome.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.


import lxml.etree
import os
import sys
import urllib.request
import shutil
import subprocess
import tempfile

# FIXME: don't hardcode this
DATADIR = '/usr/share/yelp-tools'

XML_ID = '{http://www.w3.org/XML/1998/namespace}id'
NAMESPACES = {
    'mal':   'http://projectmallard.org/1.0/',
    'cache': 'http://projectmallard.org/cache/1.0/',
    'db':    'http://docbook.org/ns/docbook',
    'e':     'http://projectmallard.org/experimental/',
    'ui':    'http://projectmallard.org/ui/1.0/',
    'uix':   'http://projectmallard.org/experimental/ui/',
    'xlink': 'http://www.w3.org/1999/xlink'
    }

def _stringify(el):
    ret = el.text or ''
    for ch in el:
        ret = ret + _stringify(ch)
    if el.tail is not None:
        ret = ret + el.tail
    return ret

def get_format(node):
    ns = lxml.etree.QName(node).namespace
    if ns in (NAMESPACES['mal'], NAMESPACES['cache']):
        return 'mallard'
    elif ns == NAMESPACES['db']:
        return 'docbook5'
    elif ns is None:
        # For now, just assume no ns means docbook4
        return 'docbook4'
    else:
        return None

class InputFile:
    def __init__(self, filepath, filename, sitedir=None):
        self.filepath = filepath
        self.filename = filename
        self.absfile = os.path.join(filepath, filename)
        self.absdir = os.path.dirname(self.absfile)
        self.sitedir = sitedir or ''
        self.sitefilename = self.sitedir + self.filename


class Checker:
    name = None
    desc = None
    blurb = None
    formats = []
    arguments = []
    postblurb = None
    xinclude = True

    def __init__(self, yelpcheck):
        self.yelpcheck = yelpcheck
        self.options = {}
        self.fileargs = []
        self.tmpdir = None

    def __del__(self):
        if self.tmpdir is not None:
            shutil.rmtree(self.tmpdir)
            self.tmpdir = None

    def parse_args(self, args):
        while len(args) > 0:
            isopt = False
            for arg in self.arguments:
                if arg[0] == args[0]:
                    if arg[1] is not None:
                        if len(args) < 2:
                            self.print_help()
                            return 1
                        if args[0] == '--allow':
                            # FIXME we shouldn't just special-case --allow
                            self.options.setdefault(args[0], [])
                            self.options[args[0]].append(args[1])
                        else:
                            self.options[args[0]] = args[1]
                        args = args[2:]
                    else:
                        self.options[args[0]] = True
                        args = args[1:]
                    isopt = True
                    break
            if not isopt:
                self.fileargs.append(args[0])
                args = args[1:]
        return 0

    def iter_files(self, sitedir=None):
        issite = self.options.get('-s', False)
        for filearg in self.fileargs:
            if os.path.isdir(filearg):
                if issite:
                    for infile in self.iter_site(filearg, '/'):
                        yield infile
                else:
                    for fname in os.listdir(filearg):
                        if fname.endswith('.page'):
                            yield InputFile(filearg, fname)
            else:
                yield InputFile(os.getcwd(), filearg)

    def iter_site(self, filepath, sitedir):
        for fname in os.listdir(filepath):
            newpath = os.path.join(filepath, fname)
            if os.path.isdir(newpath):
                if fname == '__pintail__':
                    continue
                for infile in self.iter_site(newpath, sitedir + fname + '/'):
                    yield infile
            elif fname.endswith('.page'):
                yield InputFile(filepath, fname, sitedir)

    def get_xml(self, xmlfile):
        # FIXME: we can cache these if we add a feature to run multiple
        # checkers at once
        tree = lxml.etree.parse(xmlfile.absfile)
        if self.xinclude:
            lxml.etree.XInclude()(tree.getroot())
        return tree

    def create_tmpdir(self):
        if self.tmpdir is None:
            self.tmpdir = tempfile.mkdtemp()

    def print_help(self):
        print('Usage:   yelp-check ' + self.name + ' [OPTIONS] [FILES]')
        print('Formats: ' + ' '.join(self.formats) + '\n')
        #FIXME: prettify names of formats
        print(self.blurb)
        print('\nOptions:')
        maxarglen = 2
        for arg in self.arguments:
            if arg[1] is not None:
                maxarglen = max(len(arg[1]) + len(arg[0]) + 1, maxarglen)
        for arg in self.arguments:
            arg1 = (' ' + arg[1]) if arg[1] is not None else ''
            print('  ' + (arg[0] + arg1).ljust(maxarglen) + '  ' + arg[2])
        if self.postblurb is not None:
            print(self.postblurb)

    def main(self, args):
        pass


class HrefsChecker (Checker):
    name = 'hrefs'
    desc = 'Find broken external links in a document'
    blurb = ('Find broken href links in FILES in a Mallard document, or\n' +
             'broken ulink or XLink links in FILES in a DocBook document.')
    formats = ['docbook4', 'docbook5', 'mallard']
    arguments = [
        ('-h', None, 'Show this help and exit'),
        ('-s', None, 'Treat pages as belonging to a Mallard site')]

    def main(self, args):
        if self.parse_args(args) != 0:
            return 1
        if '-h' in self.options:
            self.print_help()
            return 0

        # safelisting URLs that we use as identifiers
        hrefs = {
             'http://creativecommons.org/licenses/by-sa/3.0/': True,
            'https://creativecommons.org/licenses/by-sa/3.0/': True,
             'http://creativecommons.org/licenses/by-sa/3.0/us/': True,
            'https://creativecommons.org/licenses/by-sa/3.0/us/': True
        }
        retcode = 0

        for infile in self.iter_files():
            xml = self.get_xml(infile)
            for el in xml.xpath('//*[@href | @xlink:href | self::ulink/@url]',
                                namespaces=NAMESPACES):
                href = el.get('href', None)
                if href is None:
                    href = el.get('{www.w3.org/1999/xlink}href')
                if href is None:
                    href = el.get('url')
                if href is None:
                    continue
                if href.startswith('mailto:'):
                    continue
                if href not in hrefs:
                    try:
                        req = urllib.request.urlopen(href)
                        hrefs[href] = (req.status == 200)
                    except Exception as e:
                        hrefs[href] = False
                if not hrefs[href]:
                    retcode = 1
                    print(infile.sitefilename + ': ' + href)

        return retcode


class IdsChecker (Checker):
    name = 'ids'
    desc = 'Find Mallard page IDs that do not match file names'
    blurb = ('Find pages in a Mallard document whose page ID does not match\n' +
             'the base file name of the page file.')
    formats = ['mallard']
    arguments = [
        ('-h', None, 'Show this help and exit'),
        ('-s', None, 'Treat pages as belonging to a Mallard site')]

    def main(self, args):
        if self.parse_args(args) != 0:
            return 1
        if '-h' in self.options:
            self.print_help()
            return 0

        retcode = 0

        for infile in self.iter_files():
            xml = self.get_xml(infile)
            isok = False
            pageid = None
            if infile.filename.endswith('.page'):
                try:
                    pageid = xml.getroot().get('id')
                    isok = (pageid == os.path.basename(infile.filename)[:-5])
                except:
                    isok = False
            if not isok:
                retcode = 1
                print(infile.sitefilename + ': ' + (pageid or ''))

        return retcode


class LinksChecker (Checker):
    name = 'links'
    desc = 'Find broken xref or linkend links in a document'
    blurb = ('Find broken xref links in FILES in a Mallard document,\n' +
             'or broken linkend links in FILES in a DocBook document.')
    formats = ['docbook4', 'docbook5', 'mallard']
    arguments = [
        ('-h', None, 'Show this help and exit'),
        ('-s', None, 'Treat pages as belonging to a Mallard site'),
        ('-c', 'CACHE', 'Use the existing Mallard cache CACHE'),
        ('-i', None, 'Ignore xrefs where href is present')]

    def __init__(self, yelpcheck):
        super().__init__(yelpcheck)
        self.idstoxrefs = {}
        self.idstolinkends = {}

    def _accumulate_mal(self, node, pageid, sectid, xrefs, sitedir=None):
        thisid = node.get('id')
        if thisid is not None:
            if node.tag == '{' + NAMESPACES['mal'] + '}page':
                pageid = thisid
            else:
                sectid = thisid
        curid = pageid
        if curid is not None:
            if sectid is not None:
                # id attrs in cache files are already fully formed
                if '#' in sectid:
                    curid = sectid
                else:
                    curid = curid + '#' + sectid
            if sitedir is not None:
                # id attrs in cache files already have sitedir prefixed
                if curid[0] != '/':
                    curid = sitedir + curid
            self.idstoxrefs.setdefault(curid, [])
            if xrefs:
                xref = node.get('xref')
                if xref is not None:
                    self.idstoxrefs[curid].append(xref)
        for child in node:
            self._accumulate_mal(child, pageid, sectid, xrefs, sitedir)

    def _accumulate_db(self, node, nodeid):
        thisid = node.get('id')
        if thisid is None:
            thisid = node.get(XML_ID)
        if thisid is not None:
            nodeid = thisid
            self.idstolinkends.setdefault(nodeid, [])
        if nodeid is not None:
            linkend = node.get('linkend')
            if linkend is not None:
                self.idstolinkends[nodeid].append(linkend)
        for child in node:
            self._accumulate_db(child, nodeid)

    def main(self, args):
        if self.parse_args(args) != 0:
            return 1
        if '-h' in self.options:
            self.print_help()
            return 0

        retcode = 0

        if '-c' in self.options:
            xml = self.get_xml(InputFile(os.getcwd(), self.options['-c']))
            self._accumulate_mal(xml.getroot(), None, None, False)

        for infile in self.iter_files():
            xml = self.get_xml(infile)
            format = get_format(xml.getroot())
            if format == 'mallard':
                self._accumulate_mal(xml.getroot(), None, None, True, infile.sitedir)
            elif format in ('docbook4', 'docbook5'):
                # For DocBook, we assume each filearg is its own document, so
                # we reset the dict each time and only check within the file.
                # Note that XInclude and SYSTEM includes DO happen first.
                self.idstolinkends = {}
                self._accumulate_db(xml.getroot(), None)
                for curid in self.idstolinkends:
                    for linkend in self.idstolinkends[curid]:
                        if linkend not in self.idstolinkends:
                            print(curid + ': ' + linkend)
                            retcode = 1

        for curid in self.idstoxrefs:
            for xref in self.idstoxrefs[curid]:
                checkref = xref
                if checkref[0] == '#':
                    checkref = curid.split('#')[0] + checkref
                if curid[0] == '/' and checkref[0] != '/':
                    checkref = curid[:curid.rfind('/')+1] + checkref
                if checkref not in self.idstoxrefs:
                    print(curid + ': ' + xref)
                    retcode = 1

        return retcode


class MediaChecker (Checker):
    name = 'media'
    desc = 'Find broken references to media files'
    blurb = ('Find broken references to media files. In Mallard, this\n' +
             'checks media and thumb elements. In DocBook, this checks\n' +
             'audiodata, imagedata, and videodata elements.')
    formats = ['docbook4', 'docbook5', 'mallard']
    arguments = [
        ('-h', None, 'Show this help and exit'),
        ('-s', None, 'Treat pages as belonging to a Mallard site')]

    def main(self, args):
        if self.parse_args(args) != 0:
            return 1
        if '-h' in self.options:
            self.print_help()
            return 0

        retcode = 0

        for infile in self.iter_files():
            xml = self.get_xml(infile)
            format = get_format(xml.getroot())
            srcs = []
            if format == 'mallard':
                for el in xml.xpath('//mal:media[@src] | //uix:thumb | //ui:thumb | //e:mouseover',
                                    namespaces=NAMESPACES):
                    srcs.append(el.get('src'))
            elif format == 'docbook5':
                # FIXME: do we care about entityref?
                for el in xml.xpath('//db:audiodata | //db:imagedata | //db:videodata',
                                    namespaces=NAMESPACES):
                    srcs.append(el.get('fileref'))
            elif format == 'docbook4':
                for el in xml.xpath('//audiodata | //imagedata | //videodata'):
                    srcs.append(el.get('fileref'))
            for src in srcs:
                fsrc = os.path.join(infile.absdir, src)
                if not os.path.exists(fsrc):
                    print(infile.sitefilename + ': ' + src)
                    retcode = 1

        return retcode


class OrphansChecker (Checker):
    name = 'orphans'
    desc = 'Find orphaned pages in a Mallard document'
    blurb = ('Locate orphaned pages among FILES in a Mallard document.\n' +
             'Orphaned pages are any pages that cannot be reached by\n' +
             'topic links alone from the index page.')
    formats = ['mallard']
    arguments = [
        ('-h', None, 'Show this help and exit'),
        ('-s', None, 'Treat pages as belonging to a Mallard site'),
        ('-c', 'CACHE', 'Use the existing Mallard cache CACHE')]

    def __init__(self, yelpcheck):
        super().__init__(yelpcheck)
        self.guidelinks = {}
        self.sitesubdirs = set()

    def _collect_links(self, node, sitedir):
        pageid = node.get('id')
        if pageid[0] != '/':
            # id attrs in cache files already have sitedir prefixed
            pageid = sitedir + pageid
        else:
            sitedir = pageid[:pageid.rfind('/')+1]
        self.guidelinks.setdefault(pageid, set())
        # For the purposes of finding orphans, we'll just pretend that
        # all links to or from sections are just to or from pages.
        for el in node.xpath('//mal:info/mal:link[@type="guide"]',
                             namespaces=NAMESPACES):
            xref = el.get('xref')
            if xref is None or xref == '':
                continue
            if xref[0] == '#':
                continue
            if '#' in xref:
                xref = xref[:xref.find('#')]
            if sitedir is not None and sitedir != '':
                if xref[0] != '/':
                    xref = sitedir + xref
            self.guidelinks[pageid].add(xref)
        for el in node.xpath('//mal:info/mal:link[@type="topic"]',
                             namespaces=NAMESPACES):
            xref = el.get('xref')
            if xref is None or xref == '':
                continue
            if xref[0] == '#':
                continue
            if '#' in xref:
                xref = xref[:xref.find('#')]
            if sitedir is not None and sitedir != '':
                if xref[0] != '/':
                    xref = sitedir + xref
            self.guidelinks.setdefault(xref, set())
            self.guidelinks[xref].add(pageid)
        for el in node.xpath('//mal:links[@type="site-subdirs" or @type="site:subdirs"]',
                             namespaces=NAMESPACES):
            self.sitesubdirs.add(pageid)

    def main(self, args):
        if self.parse_args(args) != 0:
            return 1
        if '-h' in self.options:
            self.print_help()
            return 0

        retcode = 0

        if '-c' in self.options:
            xml = self.get_xml(InputFile(os.getcwd(), self.options['-c']))
            for page in xml.getroot():
                if page.tag == '{' + NAMESPACES['mal'] + '}page':
                    pageid = page.get('id')
                    if pageid is None or pageid == '':
                        continue
                    self._collect_links(page)

        pageids = set()
        for infile in self.iter_files():
            xml = self.get_xml(infile)
            pageid = xml.getroot().get('id')
            if pageid is None:
                continue
            pageids.add(infile.sitedir + pageid)
            self._collect_links(xml.getroot(), infile.sitedir)

        siteupdirs = {}
        for pageid in self.sitesubdirs:
            dirname = pageid[:pageid.rfind('/')+1]
            for subid in self.guidelinks:
                if subid.startswith(dirname):
                    if subid.endswith('/index'):
                        mid = subid[len(dirname):-6]
                        if mid != '' and '/' not in mid:
                            siteupdirs[subid] = pageid

        if '-s' in self.options:
            okpages = set(['/index'])
        else:
            okpages = set(['index'])
        for pageid in sorted(pageids):
            if pageid in okpages:
                isok = True
            else:
                isok = False
                guides = [g for g in self.guidelinks[pageid]]
                if pageid in siteupdirs:
                    updir = siteupdirs[pageid]
                    if updir not in guides:
                        guides.append(updir)
                cur = 0
                while cur < len(guides):
                    if guides[cur] in okpages:
                        isok = True
                        break
                    if guides[cur] in self.guidelinks:
                        for guide in self.guidelinks[guides[cur]]:
                            if guide not in guides:
                                guides.append(guide)
                    cur += 1
            if isok:
                okpages.add(pageid)
            else:
                print(pageid)
                retcode = 1

        return retcode


class ValidateChecker (Checker):
    name = 'validate'
    desc = 'Validate files against a DTD or RNG'
    blurb = ('Validate FILES against the appropriate DTD or RNG.\n' +
             'For Mallard pages, perform automatic RNG merging\n' +
             'based on the version attribute.')
    formats = ['docbook4', 'docbook5', 'mallard']
    arguments = [
        ('-h', None, 'Show this help and exit'),
        ('-s', None, 'Treat pages as belonging to a Mallard site'),
        ('--strict', None, 'Disallow unknown namespaces'),
        ('--allow', 'NS', 'Explicitly allow namespace NS in strict mode'),
        ('--jing', None, 'Use jing instead of xmllint for RNG validation')]

    def main(self, args):
        if self.parse_args(args) != 0:
            return 1
        if '-h' in self.options:
            self.print_help()
            return 0

        retcode = 0

        for infile in self.iter_files():
            xml = self.get_xml(infile)
            format = get_format(xml.getroot())
            command = None
            if format == 'mallard':
                version = xml.getroot().get('version')
                if version is None or version == '':
                    tag = xml.getroot().tag
                    if tag == '{' + NAMESPACES['mal'] + '}stack':
                        # 1.2 isn't final yet as of 2020-01-09. Stacks will
                        # likely be in 1.2, so we can assume at least that.
                        version = '1.2'
                    elif tag == '{' + NAMESPACES['cache'] + '}cache':
                        version = 'cache/1.0'
                    else:
                        version = '1.0'
                self.create_tmpdir()
                rng = os.path.join(self.tmpdir,
                                   version.replace('/', '__').replace(' ', '__'))
                if not os.path.exists(rng):
                    strict = 'true()' if ('--strict' in self.options) else 'false()'
                    if '--allow' in self.options:
                        allow = ' '.join(self.options['--allow'])
                    else:
                        allow = ' '
                    subprocess.call(['xsltproc', '-o', rng,
                                    '--param', 'rng.strict', strict,
                                    '--stringparam', 'rng.strict.allow', allow,
                                    os.path.join(DATADIR, 'xslt', 'mal-rng.xsl'),
                                    infile.absfile])
                if '--jing' in self.options:
                    command = ['jing', '-i', rng, infile.filename]
                else:
                    command = ['xmllint', '--noout', '--xinclude', '--noent',
                               '--relaxng', rng, infile.filename]
            elif format == 'docbook4':
                if xml.docinfo.doctype.startswith('<!DOCTYPE'):
                    command = ['xmllint', '--noout', '--xinclude', '--noent',
                               '--postvalid', infile.filename]
                else:
                    command = ['xmllint', '--noout', '--xinclude', '--noent',
                               '--dtdvalid',
                               'http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd',
                               infile.filename]
            elif format == 'docbook5':
                version = xml.getroot().get('version')
                if version is None or version == '':
                    version = '5.0'
                # Canonical URIs are http, but they 301 redirect to https. jing
                # can handle https fine, but not the redirect. And jing doesn't
                # look at catalogs. So just always feed jing an https URI.
                rnghttp = 'http://docbook.org/xml/' + version + '/rng/docbook.rng'
                rnghttps = 'https://docbook.org/xml/' + version + '/rng/docbook.rng'
                if '--jing' in self.options:
                    command = ['jing', '-i', rnghttps, infile.filename]
                else:
                    # xmllint, on the other hand, does support catalogs. It also
                    # doesn't do the redirect, but it wouldn't matter if it did
                    # because it doesn't do https. So if the schema is available
                    # locally in the catalog, hand xmllint the http URI so it
                    # can use the local copy. Otherwise, we have to get curl
                    # involved to do https.
                    try:
                        catfile = subprocess.check_output(['xmlcatalog',
                                                           '/etc/xml/catalog',
                                                           rnghttp],
                                                          stderr=subprocess.DEVNULL,
                                                          text=True)
                        for catline in catfile.split('\n'):
                            if catline.startswith('file://'):
                                command = ['xmllint', '--noout', '--xinclude',  '--noent',
                                           '--relaxng', rnghttp, infile.filename]
                    except:
                        pass
                    if command is None:
                        self.create_tmpdir()
                        rngfile = os.path.join(self.tmpdir, 'docbook-' + version + '.rng')
                        if not os.path.exists(rngfile):
                            urllib.request.urlretrieve(rnghttps, rngfile)
                        command = ['xmllint', '--noout', '--xinclude',  '--noent',
                                   '--relaxng', rngfile, infile.filename]
            if command is not None:
                try:
                    subprocess.check_output(command,
                                            cwd=infile.filepath,
                                            stderr=subprocess.STDOUT,
                                            text=True)
                except subprocess.CalledProcessError as e:
                    retcode = e.returncode
                    print(e.output)
            else:
                retcode = 1

        return retcode


class CommentsChecker (Checker):
    name = 'comments'
    desc = 'Print the editorial comments in a document'
    blurb = ('Print the editorial comments in the files FILES, using the\n' +
             'comment element in Mallard and the remark element in DocBook.')
    formats = ['docbook4', 'docbook5', 'mallard']
    arguments = [
        ('-h', None, 'Show this help and exit'),
        ('-s', None, 'Treat pages as belonging to a Mallard site')]

    def main(self, args):
        if self.parse_args(args) != 0:
            return 1
        if '-h' in self.options:
            self.print_help()
            return 0

        for infile in self.iter_files():
            xml = self.get_xml(infile)
            format = get_format(xml.getroot())
            if format == 'mallard':
                for el in xml.xpath('//mal:comment', namespaces=NAMESPACES):
                    thisid = xml.getroot().get('id')
                    par = el
                    while par is not None:
                        if par.tag == '{' + NAMESPACES['mal'] + '}section':
                            sectid = par.get('id')
                            if sectid is not None:
                                thisid = thisid + '#' + sectid
                                break
                        par = par.getparent()
                    print('Page:  ' + infile.sitedir + thisid)
                    for ch in el.xpath('mal:cite[1]', namespaces=NAMESPACES):
                        name = _stringify(ch).strip()
                        href = ch.get('href')
                        if href is not None and href.startswith('mailto:'):
                            name = name + ' <' + href[7:] + '>'
                        print('From:  ' + name)
                        date = ch.get('date')
                        if date is not None:
                            print('Date:  ' + date)
                    print('')
                    for ch in el:
                        if isinstance(ch, lxml.etree._ProcessingInstruction):
                            continue
                        elif ch.tag == '{' + NAMESPACES['mal'] + '}cite':
                            continue
                        elif ch.tag in ('{' + NAMESPACES['mal'] + '}p',
                                        '{' + NAMESPACES['mal'] + '}title'):
                            for s in _stringify(ch).strip().split('\n'):
                                print('  ' + s.strip())
                            print('')
                        else:
                            name = lxml.etree.QName(ch).localname
                            print('  <' + name + '>...</' + name + '>\n')
            elif format in ('docbook4', 'docbook5'):
                if format == 'docbook4':
                    dbxpath = '//remark'
                else:
                    dbxpath = '//db:remark'
                for el in xml.xpath(dbxpath, namespaces=NAMESPACES):
                    thisid = infile.filename
                    par = el
                    while par is not None:
                        sectid = par.get('id')
                        if sectid is None:
                            sectid = par.get(XML_ID)
                        if sectid is not None:
                            thisid = thisid + '#' + sectid
                            break
                        par = par.getparent()
                    print('Page:  ' + thisid)
                    flag = el.get('revisionflag')
                    if flag is not None:
                        print('Flag:  ' + flag)
                    print('')
                    for s in _stringify(el).strip().split('\n'):
                        print('  ' + s.strip())
                    print('')

        return 0


class LicenseChecker (Checker):
    name = 'license'
    desc = 'Report the license of Mallard pages'
    blurb = ('Report the license of the Mallard page files FILES. Each\n' +
             'matching page is reporting along with its license, reported\n' +
             'based on the href attribute of the license element. Common\n' +
             'licenses use a shortened identifier. Pages with multiple\n' +
             'licenses have the identifiers separated by spaces. Pages\n' +
             'with no license element report \'none\'. Licenses with no\n' +
             'href attribute are reported as \'unknown\'')
    formats = ['mallard']
    arguments = [
        ('-h', None, 'Show this help and exit'),
        ('-s', None, 'Treat pages as belonging to a Mallard site'),
        ('--only', 'LICENSES', 'Only show pages whose license is in LICENSES'),
        ('--except', 'LICENSES', 'Exclude pages whose license is in LICENSES'),
        ('--totals', None, 'Show total counts for each license')]
    postblurb = 'LICENSES may be a comma- and/or space-separated list.'

    def get_license(self, href):
        if href is None:
            return 'unknown'
        elif (href.startswith('http://creativecommons.org/licenses/') or
              href.startswith('https://creativecommons.org/licenses/')):
            return 'cc-' + '-'.join([x for x in href.split('/') if x][3:])
        elif (href.startswith('http://www.gnu.org/licenses/') or
              href.startswith('https://www.gnu.org/licenses/')):
            return href.split('/')[-1].replace('.html', '')
        else:
            return 'unknown'

    def main(self, args):
        if self.parse_args(args) != 0:
            return 1
        if '-h' in self.options:
            self.print_help()
            return 0

        totals = {}

        for infile in self.iter_files():
            xml = self.get_xml(infile)
            thisid = xml.getroot().get('id') or infile.filename
            licenses = []
            for el in xml.xpath('/mal:page/mal:info/mal:license',
                                namespaces=NAMESPACES):
                licenses.append(self.get_license(el.get('href')))
            if len(licenses) == 0:
                licenses.append('none')

            if '--only' in self.options:
                only = self.options['--only'].replace(',', ' ').split()
                skip = True
                for lic in licenses:
                    if lic in only:
                        skip = False
                if skip:
                    continue
            if '--except' in self.options:
                cept = self.options['--except'].replace(',', ' ').split()
                skip = False
                for lic in licenses:
                    if lic in cept:
                        skip = True
                if skip:
                    continue

            if '--totals' in self.options:
                for lic in licenses:
                    totals.setdefault(lic, 0)
                    totals[lic] += 1
            else:
                print(infile.sitedir + thisid + ': ' + ' '.join(licenses))

        if '--totals' in self.options:
            for lic in sorted(totals):
                print(lic + ': ' + str(totals[lic]))

        return 0


class StatusChecker (Checker):
    name = 'status'
    desc = 'Report the status of Mallard pages'
    blurb = ('Report the status of the Mallard page files FILES. Each\n' +
             'matching page is reporting along with its status.')
    formats = ['mallard']
    arguments = [
        ('-h', None, 'Show this help and exit'),
        ('-s', None, 'Treat pages as belonging to a Mallard site'),
        ('--version', 'VER', 'Select revisions with the version attribute VER'),
        ('--docversion', 'VER', 'Select revisions with the docversion attribute VER'),
        ('--pkgversion', 'VER', 'Select revisions with the pkgversion attribute VER'),
        ('--older', 'DATE', 'Only show pages older than DATE'),
        ('--newer', 'DATE', 'Only show pages newer than DATE'),
        ('--only', 'STATUSES', 'Only show pages whose status is in STATUSES'),
        ('--except', 'STATUSES', 'Exclude pages whose status is in STATUSES'),
        ('--totals', None, 'Show total counts for each status')]
    postblurb = 'VER and STATUSES may be comma- and/or space-separated lists.'

    def main(self, args):
        if self.parse_args(args) != 0:
            return 1
        if '-h' in self.options:
            self.print_help()
            return 0

        totals = {}

        for infile in self.iter_files():
            xml = self.get_xml(infile)
            pageid = xml.getroot().get('id')
            bestrev = None
            for rev in xml.xpath('/mal:page/mal:info/mal:revision', namespaces=NAMESPACES):
                revversion = (rev.get('version') or '').split()
                docversion = rev.get('docversion')
                if docversion is not None:
                    revversion.append('doc:' + docversion)
                pkgversion = rev.get('pkgversion')
                if pkgversion is not None:
                    revversion.append('pkg:' + pkgversion)
                checks = []
                if '--version' in self.options:
                    checks.append(self.options['--version'].replace(',', ' ').split())
                if '--docversion' in self.options:
                    checks.append(['doc:' + s for s in self.options['--docversion'].replace(',', ' ').split()])
                if '--pkgversion' in self.options:
                    checks.append(['pkg:' + s for s in self.options['--pkgversion'].replace(',', ' ').split()])
                revok = True
                for check in checks:
                    checkok = False
                    for v in check:
                        if v in revversion:
                            checkok = True
                            break
                    if not checkok:
                        revok = False
                        break
                if revok:
                    if bestrev is None:
                        bestrev = rev
                        continue
                    bestdate = bestrev.get('date')
                    thisdate = rev.get('date')
                    if bestdate is None:
                        bestrev = rev
                    elif thisdate is None:
                        pass
                    elif thisdate >= bestdate:
                        bestrev = rev
            if bestrev is not None:
                status = bestrev.get('status') or 'none'
                date = bestrev.get('date') or None
            else:
                status = 'none'
                date = None
            if '--older' in self.options:
                if date is None or date >= self.options['--older']:
                    continue
            if '--newer' in self.options:
                if date is None or date <= self.options['--newer']:
                    continue
            if '--only' in self.options:
                if not status in self.options['--only'].replace(',', ' ').split():
                    continue
            if '--except' in self.options:
                if status in self.options['--except'].replace(',', ' ').split():
                    continue
            if '--totals' not in self.options:
                print(infile.sitedir + pageid + ': ' + status)
            else:
                totals.setdefault(status, 0)
                totals[status] += 1

        if '--totals' in self.options:
            for st in sorted(totals):
                print(st + ': ' + str(totals[st]))

        return 0


class StyleChecker (Checker):
    name = 'style'
    desc = 'Report the style attribute of Mallard pages'
    blurb = ('Report the page style attribute of the Mallard page files\n' +
             'FILES. Each matching page is reporting along with its status.')
    formats = ['mallard']
    arguments = [
        ('-h', None, 'Show this help and exit'),
        ('-s', None, 'Treat pages as belonging to a Mallard site'),
        ('--only', 'STYLES', 'Only show pages whose style is in STATUSES'),
        ('--except', 'STYLES', 'Exclude pages whose style is in STATUSES'),
        ('--totals', None, 'Show total counts for each style')]
    postblurb = 'STYLES may be comma- and/or space-separated lists.'

    def main(self, args):
        if self.parse_args(args) != 0:
            return 1
        if '-h' in self.options:
            self.print_help()
            return 0

        totals = {}

        for infile in self.iter_files():
            xml = self.get_xml(infile)
            thisid = xml.getroot().get('id')
            style = xml.getroot().get('style')
            if style is None:
                style = 'none'
            styles = style.split()
            # We'll set style to None if it doesn't meat the criteria
            if '--only' in self.options:
                only = self.options['--only'].replace(',', ' ').split()
                if len(only) == 0:
                    # We treat a blank --only as requesting pages with no style
                    if style != 'none':
                        style = None
                else:
                    allow = False
                    for st in styles:
                        if st in only:
                            allow = True
                            break
                    if not allow:
                        style = None
            if '--except' in self.options:
                cept = self.options['--except'].replace(',', ' ').split()
                for st in styles:
                    if st in cept:
                        style = None
                        break
            if '--totals' not in self.options:
                if style is not None:
                    print(infile.sitedir + thisid + ': ' + style)
            else:
                if style is not None:
                    for st in styles:
                        totals.setdefault(st, 0)
                        totals[st] += 1

        if '--totals' in self.options:
            for st in sorted(totals):
                print(st + ': ' + str(totals[st]))

        return 0


class YelpCheck:
    def __init__(self):
        pass

    def main(self):
        if len(sys.argv) < 2:
            self.print_usage()
            return 1

        checker = None
        for cls in Checker.__subclasses__():
            if sys.argv[1] == cls.name:
                checker = cls

        if checker is None:
            self.print_usage()
            return 1

        return checker(self).main(sys.argv[2:])

    def print_usage(self):
        print('Usage: yelp-check <COMMAND> [OPTIONS] [FILES]')
        namelen = 2
        checks = []
        reports = []
        others = []
        for cls in sorted(Checker.__subclasses__(), key=(lambda cls: cls.name)):
            namelen = max(namelen, len(cls.name) + 2)
            if cls in (HrefsChecker, IdsChecker, LinksChecker,
                       MediaChecker, OrphansChecker, ValidateChecker):
                checks.append(cls)
            elif cls in (CommentsChecker, LicenseChecker, StatusChecker,
                         StyleChecker):
                reports.append(cls)
            else:
                others.append(cls)
        if len(checks) > 0:
            print('\nCheck commands:')
            for cls in checks:
                print('  ' + cls.name.ljust(namelen) + cls.desc)
        if len(reports) > 0:
            print('\nReport commands:')
            for cls in reports:
                print('  ' + cls.name.ljust(namelen) + cls.desc)
        if len(others) > 0:
            print('\nOther commands:')
            for cls in others:
                print('  ' + cls.name.ljust(namelen) + cls.desc)


if __name__ == '__main__':
    try:
        sys.exit(YelpCheck().main())
    except KeyboardInterrupt:
        sys.exit(1)

