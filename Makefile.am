include $(top_srcdir)/gnome-doc-utils.make
include $(top_srcdir)/bootstrap.make

SUBDIRS = doc po xslt

if ENABLE_BUILD_UTILS
DOC_H_FILE = gnome-doc-utils.h
DOC_H_DOCS = doc/xslt/C/gnome-doc-xslt.xml doc/gnome-doc-make/C/gnome-doc-make.xml

aclocaldir = $(datadir)/aclocal
aclocal_DATA = gnome-doc-utils.m4

sharedir = $(datadir)/gnome-doc-utils
share_DATA = gnome-doc-utils.make

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = gnome-doc-utils.pc
endif

EXTRA_DIST += 						\
	$(aclocal_DATA)					\
	$(share_DATA)					\
	$(pkgconfig_DATA)				\
	bootstrap.make					\
	intltool-extract.in  				\
	intltool-merge.in    				\
	intltool-update.in				\
	gnome-doc-utils.make
