project('yelp-tools',
  version: '42.1',
  license: 'GPL-2.0-or-later',
  meson_version: '>= 0.51.0',
)

gnome = import('gnome')

python = import('python')
pyinst = python.find_installation('python3', required: true, modules: ['lxml'])

package_name = meson.project_name()

# Paths
prefix = get_option('prefix')

bindir = join_paths(prefix, get_option('bindir'))
datadir = join_paths(prefix, get_option('datadir'))

autoconfdatadir = join_paths(datadir, 'aclocal')
pkgdir = join_paths(datadir, package_name)
pkgtemplatesdir = join_paths(pkgdir, 'templates')
pkgxsltdir = join_paths(pkgdir, 'xslt')

# Dependencies
yelp_xsl_req = '>= 3.38.0'

yelp_xsl_dep = dependency('yelp-xsl', version: yelp_xsl_req)

xmllint_prg = find_program('xmllint', required: true)
xsltproc_prg = find_program('xsltproc', required: true)
itstool_prg = find_program('itstool', required: true)

yelp_db2html_path = yelp_xsl_dep.get_pkgconfig_variable('db2html')
yelp_db2xhtml_path = yelp_xsl_dep.get_pkgconfig_variable('db2xhtml')
yelp_mal2html_path = yelp_xsl_dep.get_pkgconfig_variable('mal2html')
yelp_mal2xhtml_path = yelp_xsl_dep.get_pkgconfig_variable('mal2xhtml')

yelp_xslt_dir = yelp_xsl_dep.get_pkgconfig_variable('xsltdir')
yelp_js_dir = yelp_xsl_dep.get_pkgconfig_variable('jsdir')
yelp_templates_dir = pkgtemplatesdir
yelp_icons_dir = join_paths(
  yelp_xsl_dep.get_pkgconfig_variable('icondir'),
  'hicolor', '24x24', 'status',
)

subdir('xslt')
subdir('templates')
subdir('tools')

if get_option('help') == true
  subdir('help')
endif

summary = [
  '',
  '------',
  'yelp-tools @0@'.format(meson.project_version()),
  '',
  '    yelp.m4: @0@'.format(get_option('yelpm4')),
  '       help: @0@'.format(get_option('help')),
  '',
  'Directories:',
  '     prefix: @0@'.format(prefix),
  '    datadir: @0@'.format(datadir),
  '------',
]

message('\n'.join(summary))
