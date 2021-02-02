yelp_tools_xslt_data = ['mal-rng.xsl']

install_data(
  yelp_tools_xslt_data,
  install_dir: join_paths(
    pkgxsltdir,
  )
)

yelp_xslt_in = configuration_data()

yelp_xslt_in.set('XSL_MAL_LINK', join_paths(
  yelp_xslt_dir,
  'mallard',
  'common',
  'mal-link.xsl',
  )
)

yelp_xslt_in.set('XSL_MAL_SORT', join_paths(
  yelp_xslt_dir,
  'mallard',
  'common',
  'mal-sort.xsl',
  )
)

configure_file(
  input: 'mal-ncx.xsl.in',
  output: 'mal-ncx.xsl',
  configuration: yelp_xslt_in,
  install: true,
  install_dir: pkgxsltdir
)

configure_file(
  input: 'mal-opf.xsl.in',
  output: 'mal-opf.xsl',
  configuration: yelp_xslt_in,
  install: true,
  install_dir: pkgxsltdir
)
