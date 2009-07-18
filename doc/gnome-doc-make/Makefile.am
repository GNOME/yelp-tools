include $(top_srcdir)/tools/gnome-doc-utils.make
include $(top_srcdir)/bootstrap.make
dist-hook: doc-dist-hook

DOC_MODULE = gnome-doc-make
DOC_INCLUDES = legal.xml make-ref.xml

$(srcdir)/C/make-ref.xml: $(top_srcdir)/tools/gnome-doc-utils.make
	$(GDU_AWK) -f $(srcdir)/gnome-doc-make.awk $< > $@

EXTRA_DIST = gnome-doc-make.awk

DOC_LINGUAS = de
