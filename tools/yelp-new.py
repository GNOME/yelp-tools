#!/bin/python3
#
# yelp-new
# Copyright (C) 2010-2020 Shaun McCance <shaunm@gnome.org>
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

import configparser
import datetime
import os
import subprocess
import sys

# FIXME: don't hardcode this
DATADIR = os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'templates', 'py')

class YelpNew:
    arguments = [
        ('help', '-h', None, 'Show this help and exit'),
        ('stub', None, None, 'Create a stub file with .stub appended'),
        ('tmpl', None, None, 'Copy an installed template to a local template'),
        ('version', '-v', 'VERS', 'Specify the version number to substitute')
    ]

    def __init__(self):
        self.options = {}
        self.fileargs = []
        self.parse_args(sys.argv[1:])
        self.config = configparser.ConfigParser()
        try:
            self.config.read('.yelp-tools.cfg')
        except:
            self.config = None


    def parse_args(self, args):
        while len(args) > 0:
            argdef = None
            if args[0].startswith('--'):
                for arg_ in self.arguments:
                    if args[0] == '--' + arg_[0]:
                        argdef = arg_
                        break
                if argdef is None:
                    self.print_usage()
                    return 1
            elif args[0].startswith('-'):
                for arg_ in self.arguments:
                    if args[0] == arg_[1]:
                        argdef = arg_
                        break
                if argdef is None:
                    self.print_usage()
                    return 1
            if argdef is not None:
                takesarg = (argdef[2] is not None)
                if takesarg:
                    if len(args) < 2:
                        self.print_usage()
                        return 1
                    self.options.setdefault(argdef[0], [])
                    self.options[argdef[0]].append(args[1])
                    args = args[2:]
                else:
                    self.options[argdef[0]] = True
                    args = args[1:]
            else:
                self.fileargs.append(args[0])
                args = args[1:]


    def get_option_bool(self, arg):
        if arg in self.options:
            return self.options[arg] == True
        if self.config is not None:
            val = self.config.get('new', arg, fallback=None)
            if val is not None:
                return (val == 'true')
            val = self.config.get('default', arg, fallback=None)
            if val is not None:
                return (val == 'true')
        return False


    def get_option_str(self, arg):
        if arg in self.options:
            if isinstance(self.options[arg], list):
                return self.options[arg][-1]
        if self.config is not None:
            val = self.config.get('new', arg, fallback=None)
            if val is not None:
                return val
            val = self.config.get('default', arg, fallback=None)
            if val is not None:
                return val
        return None


    def get_replacements(self, pageid):
        repl = {'ID' : pageid}
        if len(self.fileargs) > 2:
            repl['TITLE'] = ' '.join(self.fileargs[2:])
        else:
            repl['TITLE'] = 'TITLE'
        today = datetime.datetime.now()
        repl['DATE'] = today.strftime('%Y-%m-%d')
        repl['YEAR'] = today.strftime('%Y')

        username = None
        useremail = None
        isgit = False
        isbzr = False
        cwd = os.getcwd()
        while cwd:
            if os.path.exists(os.path.join(cwd, '.git')):
                isgit = True
                break
            if os.path.exists(os.path.join(cwd, '.bzr')):
                isbzr = True
                break
            newcwd = os.path.dirname(cwd)
            if newcwd == cwd:
                break
            cwd = newcwd
        if isbzr:
            try:
                who = subprocess.run(['bzr', 'whoami'], check=True,
                                     capture_output=True, encoding='utf8')
                username, useremail = who.stdout.split('<')
                username = username.strip()
                useremail = useremail.split('>')[0].strip()
            except:
                username = None
                useremail = None
        if username is None:
            try:
                who = subprocess.run(['git', 'config', 'user.name'], check=True,
                                     capture_output=True, encoding='utf8')
                username = who.stdout.strip()
                who = subprocess.run(['git', 'config', 'user.email'], check=True,
                                     capture_output=True, encoding='utf8')
                useremail = who.stdout.strip()
            except:
                username = None
                useremail = None
        repl['NAME'] = username or 'YOUR NAME'
        repl['EMAIL'] = useremail or 'YOUR EMAIL ADDRESS'
        repl['VERSION'] = self.get_option_str('version') or 'VERSION.NUMBER'
        return repl


    def main(self):
        if len(self.fileargs) < 2:
            self.print_usage()
            return 1

        tmpl = self.fileargs[0]
        if '.' not in tmpl:
            tmpl = tmpl + '.page'
            ext = '.page'
        elif tmpl.endswith('.page'):
            ext = '.page'
        elif tmpl.endswith('.duck'):
            ext = '.duck'
        if self.get_option_bool('stub'):
            ext = ext + '.stub'
        tmplfile = os.path.join(os.getcwd(), tmpl + '.tmpl')
        if not os.path.exists(tmplfile):
            tmplfile = os.path.join(DATADIR, 'templates', tmpl)
            if not os.path.exists(tmplfile):
                print('No template found named ' + tmpl, file=sys.stderr)
                sys.exit(1)
        pageid = self.fileargs[1]
        istmpl = self.get_option_bool('tmpl')
        if istmpl:
            ext = ext + '.tmpl'
            repl = {}
        else:
            repl = self.get_replacements(pageid)
        def _writeout(outfile, infilename, depth=0):
            if depth > 10:
                # We could do this smarter by keeping a stack of infilenames, but why?
                print('Recursion limit reached for template includes', file=sys.stderr)
                sys.exit(1)
            for line in open(infilename):
                if (not istmpl) and line.startswith('<?yelp-tmpl-desc'):
                    continue
                if (not istmpl) and line.startswith('[-] yelp-tmpl-desc'):
                    continue
                while line is not None and '{{' in line:
                    before, after = line.split('{{', maxsplit=1)
                    if '}}' in after:
                        var, after = after.split('}}', maxsplit=1)
                        outfile.write(before)
                        isinclude = var.startswith('INCLUDE ')
                        if isinclude:
                            newfile = os.path.join(os.path.dirname(infilename), var[8:].strip())
                            _writeout(outfile, newfile, depth=depth+1)
                        elif istmpl:
                            outfile.write('{{' + var + '}}')
                        else:
                            outfile.write(repl.get(var, '{{' + var + '}}'))
                        if isinclude and after == '\n':
                            line = None
                        else:
                            line = after
                    else:
                        outfile.write(line)
                        line = None
                if line is not None:
                    outfile.write(line)

        if os.path.exists(pageid + ext):
            print('Output file ' + pageid + ext + ' already exists', file=sys.stderr)
            sys.exit(1)
        with open(pageid + ext, 'w') as outfile:
            _writeout(outfile, tmplfile)


    def print_usage(self):
        print('Usage: yelp-new [OPTIONS] <TEMPLATE> <ID> [TITLE]\n')
        print('Create a new file from an installed or local template file,\n' +
              'or create a new local template. TEMPLATE must be the name of\n' +
              'an installed or local template. ID is a page ID (and base\n' +
              'filename) for the new page. The optional TITLE argument\n'
              'provides the page title\n')
        print('Options:')
        maxarglen = 2
        args = []
        for arg in self.arguments:
            argkey = '--' + arg[0]
            if arg[1] is not None:
                argkey = arg[1] + ', ' + argkey
            if arg[2] is not None:
                argkey = argkey + ' ' + arg[2]
            args.append((argkey, arg[3]))
        for arg in args:
            maxarglen = max(maxarglen, len(arg[0]) + 1)
        for arg in args:
            print('  ' + (arg[0]).ljust(maxarglen) + '  ' + arg[1])
        localpages = []
        localducks = []
        installedpages = []
        installedducks = []
        descs = {}
        maxlen = 0
        def _getdesc(fpath):
            for line in open(fpath):
                if line.startswith('<?yelp-tmpl-desc '):
                    s = line[16:].strip()
                    if s.endswith('?>'):
                        s = s[:-2]
                    return s
                if line.startswith('[-] yelp-tmpl-desc'):
                    return line[18:].strip()
            return ''
        for fname in os.listdir(os.getcwd()):
            if fname.endswith('.page.tmpl'):
                fname = fname[:-5]
                maxlen = max(maxlen, len(fname))
                localpages.append(fname)
            elif fname.endswith('.duck.tmpl'):
                fname = fname[:-5]
                maxlen = max(maxlen, len(fname))
                localducks.append(fname)
            else:
                continue
            descs[fname] = _getdesc(os.path.join(os.getcwd(), fname + '.tmpl'))
        for fname in os.listdir(os.path.join(DATADIR, 'templates')):
            if fname.endswith('.page'):
                if fname in localpages:
                    continue
                maxlen = max(maxlen, len(fname))
                installedpages.append(fname)
            elif fname.endswith('.duck'):
                if fname in localducks:
                    continue
                maxlen = max(maxlen, len(fname))
                installedducks.append(fname)
            else:
                continue
            descs[fname] = _getdesc(os.path.join(DATADIR, 'templates', fname))
        if len(localpages) > 0:
            print('\nLocal Mallard Templates:')
            for page in localpages:
                print('  ' + page.ljust(maxlen) + '  ' + descs.get(page, ''))
        if len(localducks) > 0:
            print('\nLocal Ducktype Templates:')
            for duck in localducks:
                print('  ' + duck.ljust(maxlen) + '  ' + descs.get(duck, ''))
        if len(installedpages) > 0:
            print('\nInstalled Mallard Templates:')
            for page in installedpages:
                print('  ' + page.ljust(maxlen) + '  ' + descs.get(page, ''))
        if len(installedducks) > 0:
            print('\nInstalled Ducktype Templates:')
            for duck in installedducks:
                print('  ' + duck.ljust(maxlen) + '  ' + descs.get(duck, ''))


if __name__ == '__main__':
    try:
        sys.exit(YelpNew().main())
    except KeyboardInterrupt:
        sys.exit(1)
