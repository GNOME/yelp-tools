yelp_tools_in = configuration_data()
yelp_tools_in.set('DATADIR', pkgdir)

yelp_tools_in.set('YELP_XSLT_DIR', yelp_xslt_dir)
yelp_tools_in.set('YELP_TMPL_DIR', join_paths(yelp_templates_dir, '')) # Hack for trailing '/'
yelp_tools_in.set('YELP_JS_DIR', yelp_js_dir)
yelp_tools_in.set('YELP_ICON_DIR', yelp_icons_dir)

yelp_tools_in.set('XSL_DB2HTML', yelp_db2html_path)
yelp_tools_in.set('XSL_DB2XHTML', yelp_db2xhtml_path)
yelp_tools_in.set('XSL_MAL2HTML', yelp_mal2html_path)
yelp_tools_in.set('XSL_MAL2XHTML', yelp_mal2xhtml_path)

yelp_tools_in.set('XSL_MAL_CACHE', join_paths(
  yelp_xslt_dir,
  'mallard',
  'cache',
  'mal-cache.xsl',
  )
)

yelp_tools_in.set('XSL_MAL_LINK', join_paths(
  yelp_xslt_dir,
  'mallard',
  'common',
  'mal-link.xsl',
  )
)

yelp_tools_in.set('ID', '@ID@')
yelp_tools_in.set('DATE', '@DATE@')
yelp_tools_in.set('YEAR', '@YEAR@')
yelp_tools_in.set('NAME', '@NAME@')
yelp_tools_in.set('EMAIL', '@EMAIL@')
yelp_tools_in.set('TITLE', '@TITLE@')

configure_file(
  input: 'yelp-build.in',
  output: 'yelp-build',
  configuration: yelp_tools_in,
  install: true,
  install_dir: bindir,
)

configure_file(
  input: 'yelp-check.in',
  output: 'yelp-check',
  configuration: yelp_tools_in,
  install: true,
  install_dir: bindir,
)

configure_file(
  input: 'yelp-new.in',
  output: 'yelp-new',
  configuration: yelp_tools_in,
  install: true,
  install_dir: bindir,
)

if get_option('autotools') == true
  install_data(
    'yelp.m4',
    install_dir: join_paths(
      autoconfdatadir,
    )
  )
endif