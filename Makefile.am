SUBDIRS = tools xml2po

EXTRA_DIST = 						\
	COPYING.GPL					\
	COPYING.LGPL

ChangeLog:
	@if test -f $(top_srcdir)/.git/HEAD; then \
	  git log --stat > $@; \
	fi

dist: ChangeLog
.PHONY: ChangeLog
