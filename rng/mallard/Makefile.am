AUTOMAKE_OPTIONS = -Wno-portability

all: mallard.rnc mallard.rng

_specs1=$(top_srcdir)/doc/mallard/C/mal_page.page   \
        $(top_srcdir)/doc/mallard/C/mal_block.page  $(wildcard $(top_srcdir)/doc/mallard/C/mal_block_*.page) \
        $(top_srcdir)/doc/mallard/C/mal_inline.page $(wildcard $(top_srcdir)/doc/mallard/C/mal_inline_*.page)
_specs=$(_specs1) $(filter-out $(_specs1), $(wildcard $(top_srcdir)/doc/mallard/C/*.page))

mallard.rnc: $(wildcard $(top_srcdir)/doc/mallard/C/*.page)
	for file in $(_specs); do \
	  xsltproc $(srcdir)/mal2rnc.xsl $$file; \
	done > mallard.rnc

# http://bugs.opensolaris.org/bugdatabase/view_bug.do?bug_id=1236105
# This bug in gawk on solaris causes rnc2rng to fail it mysterious and
# spectacular ways.  See comment #13 here for more details:
# http://bugzilla.gnome.org/show_bug.cgi?id=590694
# Unsetting LANG for the awk call works around this.
mallard.rng: mallard.rnc rnc2rng.awk
	LANG= $(GDU_AWK) -f $(srcdir)/rnc2rng.awk mallard.rnc > $@.tmp || ( rm -f $@.tmp && exit 1 )
	xmllint --format $@.tmp | \
	  sed -e 's/^  //' \
	      -e 's/ xmlns/\n    xmlns/g' \
	      -e 's/" ns=/"\n    ns=/' \
	      -e 's/^<s/\n<s/' \
	      -e 's/^<d/\n<d/' \
	  > $@ || ( rm -f $@.tmp && exit 1 ) && rm -f $@.tmp

specdir = $(datadir)/xml/mallard/1.0/
spec_DATA = mallard.rnc mallard.rng

EXTRA_DIST = mal2rnc.xsl rnc2rng.awk

CLEANFILES = $(spec_DATA)
DISTCLEANFILES = $(spec_DATA)
