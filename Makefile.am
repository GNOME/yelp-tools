include $(top_srcdir)/gnome-doc-utils.make
include $(top_srcdir)/bootstrap.make
dist-hook: doc-dist-hook

if ENABLE_BUILD_UTILS
xml2po_SUBDIRS = xml2po

DOC_H_FILE = gnome-doc-utils.h
DOC_H_DOCS =					\
	doc/xslt/C/gnome-doc-xslt.xml		\
	doc/gnome-doc-make/C/gnome-doc-make.xml

aclocaldir = $(datadir)/aclocal
aclocal_DATA = gnome-doc-utils.m4

sharedir = $(datadir)/gnome-doc-utils
share_DATA = gnome-doc-utils.make

pkgdata_DATA=\
	template.omf.in \
	template.make \
	template-document.xml

bin_SCRIPTS = gnome-doc-prepare gnome-doc-html
endif

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = gnome-doc-utils.pc

# doc must go last
SUBDIRS = po xslt $(xml2po_SUBDIRS) doc

ACLOCAL_AMFLAGS=-I .

EXTRA_DIST = 						\
	$(aclocal_DATA)					\
	$(share_DATA)					\
	$(pkgconfig_DATA)				\
	$(pkgdata_DATA)					\
	COPYING.GPL					\
	COPYING.LGPL					\
	bootstrap.make					\
	gnome-doc-prepare.in				\
	intltool-extract.in  				\
	intltool-merge.in    				\
	intltool-update.in

DISTCLEANFILES =					\
	intltool-extract  				\
	intltool-merge    				\
	intltool-update					\
	gnome-doc-utils.make

DISTCHECK_CONFIGURE_FLAGS = --disable-scrollkeeper

distuninstallcheck_listfiles =  \
find -regex '.*/var/scrollkeeper/.*' -prune -or -type f -print
