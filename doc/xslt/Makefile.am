include $(top_srcdir)/gnome-doc-utils.make
include $(top_srcdir)/bootstrap.make
dist-hook: doc-dist-hook

DOC_MODULE = gnome-doc-xslt
DOC_INCLUDES = legal.xml

DOC_LINGUAS = sr

XSLDOC_DIRS = 					\
	$(top_srcdir)/xslt/gettext		\
	$(top_srcdir)/xslt/docbook/common	\
	$(top_srcdir)/xslt/docbook/html		\
	$(top_srcdir)/xslt/docbook/omf		\
	$(top_srcdir)/xslt/rngdoc		\
	$(top_srcdir)/xslt/xsldoc
