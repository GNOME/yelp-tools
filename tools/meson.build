yelp_tools_in = configuration_data()
yelp_tools_in.set('DATADIR', pkgdir)

yelp_tools_in.set('YELP_JS_DIR', yelp_js_dir)

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

if get_option('yelpm4') == true
  install_data(
    'yelp.m4',
    install_dir: join_paths(
      autoconfdatadir,
    )
  )
endif
