SUBDIRS = doc po xslt

aclocaldir = $(datadir)/aclocal
aclocal_DATA = gnome-doc-utils.m4

sharedir = $(datadir)/gnome-doc-utils
share_DATA = gnome-doc-utils.make

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = gnome-doc-utils.pc

EXTRA_DIST = 						\
	$(aclocal_DATA)					\
	$(share_DATA)					\
	$(pkgconfig_DATA)				\
	bootstrap.make					\
	intltool-extract.in  				\
	intltool-merge.in    				\
	intltool-update.in
