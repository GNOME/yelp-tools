SUBDIRS = modes examples

nodist_bin_SCRIPTS = xml2po
CLEANFILES = xml2po

commondir = $(datadir)/xml2po

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = xml2po.pc

xml2po: xml2po.py configure.ac
	sed -e "s/^VERSION =.*/VERSION = \"@VERSION@\"/" \
	    -e "s+^submodes_path =.*+submodes_path = \"$(commondir)\"+" \
	    -e "s+^#!.*python.*+#!$(PYTHON)+" \
	  < $(srcdir)/xml2po.py > xml2po
	chmod +x xml2po

$(srcdir)/README: README.in
	sed -e "s/\@VERSION\@/@VERSION@/g" < README.in > README

publish: dist
	scp @PACKAGE@-@VERSION@.tar.gz danilo@kvota.net:/home/danilo/kvota.net/hacks/xml2po


EXTRA_DIST = \
	     README    \
	     README.in \
	     TODO      \
	     xml2po.py \
             xml2po.pc.in
