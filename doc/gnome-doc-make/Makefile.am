@GNOME_DOC_RULE@

include $(top_srcdir)/bootstrap.make

DOC_MODULE = gnome-doc-make
DOC_INCLUDES = legal.xml make-ref.xml

C/make-ref.xml: ../../gnome-doc-utils.make
	awk -f gnome-doc-make.awk $< > $@

EXTRA_DIST = gnome-doc-make.awk
