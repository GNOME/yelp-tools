_xml2po = PYTHONPATH="$(shell pwd)/$(top_srcdir)/xml2po/modes" "$(shell pwd)/$(top_srcdir)/xml2po/xml2po"

_db2omf = $(top_srcdir)/xslt/docbook/omf/db2omf.xsl
_rngdoc = $(top_srcdir)/xslt/rngdoc/rngdoc.xsl
_xsldoc = $(top_srcdir)/xslt/xsldoc/xsldoc.xsl

_credits = $(top_srcdir)/xslt/docbook/utils/credits.xsl
_ids     = $(top_srcdir)/xslt/docbook/utils/ids.xsl
