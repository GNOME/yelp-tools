project('yelp-tools',
  version: '3.27.90',
  license: 'LGPL2.1+',
  meson_version: '>= 0.43.0',
)

gnome = import('gnome')

# Versioning
version = meson.project_version()
version_arr = version.split('.')
version_major = version_arr[0].to_int()
version_minor = version_arr[1].to_int()
version_micro = version_arr[2].to_int()

package_name = meson.project_name()

# Paths
srcdir = meson.source_root()
builddir = meson.build_root()

prefix = get_option('prefix')

bindir = join_paths(prefix, get_option('bindir'))
datadir = join_paths(prefix, get_option('datadir'))

autoconfdatadir = join_paths(datadir, 'aclocal')
pkgdir = join_paths(datadir, package_name)
pkgtemplatesdir = join_paths(pkgdir, 'templates')
pkgxsltdir = join_paths(pkgdir, 'xslt')

# Dependencies
yelp_xsl_req = '>= 3.17.3'

yelp_xsl_dep = dependency('yelp-xsl', version: yelp_xsl_req)

xmllint_prg = find_program('xmllint', required: true)
xsltproc_prg = find_program('xsltproc', required: true)
itstool_prg = find_program('itstool', required: true)

awk_prg = find_program('awk', required: false)

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

# Options
build_yelp_manual = get_option('yelp_manual')
if not awk_prg.found()
  build_yelp_manual = false
endif

subdir('xslt')
subdir('templates')

subdir('tools')

if build_yelp_manual == true
  subdir('help')
endif

summary = [
  '',
  '------',
  'yelp-tools @0@'.format(version),
  '',
  '  Autotools: @0@'.format(get_option('autotools')),
  '     Manual: @0@'.format(build_yelp_manual),
  '',
  'Directories:',
  '     prefix: @0@'.format(prefix),
  '    datadir: @0@'.format(datadir),
  '------',
]

message('\n'.join(summary))