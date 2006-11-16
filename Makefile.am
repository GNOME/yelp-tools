if ENABLE_BUILD_UTILS
build_SUBDIRS = tools xml2po

pkgdata_DATA=\
	template.omf.in \
	template.make \
	template-document.xml

bin_SCRIPTS = gnome-doc-prepare gnome-doc-html
endif

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = gnome-doc-utils.pc

# doc must go last
SUBDIRS = po xslt $(build_SUBDIRS) doc

ACLOCAL_AMFLAGS=-I .

EXTRA_DIST = 						\
	$(pkgconfig_DATA)				\
	$(pkgdata_DATA)					\
	COPYING.GPL					\
	COPYING.LGPL					\
	bootstrap.make					\
	gnome-doc-prepare.in				\
	gnome-doc-utils.m4				\
	gnome-doc-utils.make				\
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
