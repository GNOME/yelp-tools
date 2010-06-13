AC_DEFUN([HELP_INIT],
[
m4_pattern_allow([AM_V_at])
m4_pattern_allow([AM_V_GEN])
AC_ARG_WITH([help-dir],
            AC_HELP_STRING([--with-help-dir=DIR],
                           [path where help files are installed]),,
            [with_help_dir='${datadir}/help'])
HELP_DIR="$with_help_dir"
AC_SUBST(HELP_DIR)

HELP_RULES='
HELP_ID ?=
HELP_FILES ?=
HELP_EXTRA ?=
HELP_MEDIA ?=
HELP_LINGUAS ?=

_HELP_FORMAT = $(if $(filter %.page,$(HELP_FILES)),mallard,docbook)
_HELP_LINGUAS = $(if $(filter environment,$(origin LINGUAS)), $(filter $(LINGUAS),$(HELP_LINGUAS)), $(HELP_LINGUAS))
_HELP_POTFILE = $(if $(HELP_ID), $(HELP_ID).pot)
_HELP_POFILES = $(if $(HELP_ID), $(foreach lc,$(_HELP_LINGUAS),$(lc)/$(lc).po))
_HELP_MOFILES = $(patsubst %.po,%.mo,$(_HELP_POFILES))
_HELP_C_FILES = $(foreach f,$(HELP_FILES),$(abs_srcdir)/C/$(f))
_HELP_C_EXTRA = $(foreach f,$(HELP_EXTRA),$(abs_srcdir)/C/$(f))
_HELP_C_FILES = $(foreach f,$(HELP_FILES),C/$(f))
_HELP_C_EXTRA = $(foreach f,$(HELP_EXTRA),C/$(f))
_HELP_LC_FILES = $(foreach lc,$(_HELP_LINGUAS),$(foreach f,$(HELP_FILES),$(lc)/$(f)))

all: $(_HELP_C_FILES) $(_HELP_LC_FILES) $(_HELP_POFILES)

.PHONY: pot
pot: $(_HELP_POTFILE)
$(_HELP_POTFILE): $(_HELP_C_FILES)
	$(AM_V_GEN)xml2po -m $(_HELP_FORMAT) -e -o "[$]@" $^

$(_HELP_POFILES):
	$(AM_V_at)if ! test -d "$(dir [$]@)"; then mkdir "$(dir [$]@)"; fi
	$(AM_V_at)if test ! -f "[$]@" -a -f "$(srcdir)/[$]@"; then cp "$(srcdir)/[$]@" "[$]@"; fi
	$(AM_V_GEN)if ! test -f "[$]@"; then \
	  (cd "$(dir [$]@)" && \
	    xml2po -m $(_HELP_FORMAT) -e $(_HELP_C_FILES) > "$(notdir [$]@).tmp" && \
	    cp "$(notdir [$]@).tmp" "$(notdir [$]@)" && "rm -f $(notdir [$]@).tmp"); \
	else \
	  (cd "$(dir [$]@)" && \
	    xml2po -m $(_HELP_FORMAT) -e -u "$(notdir [$]@)" $(_HELP_C_FILES)); \
	fi

$(_HELP_MOFILES): %.mo: %.po
	$(AM_V_at)if ! test -d "$(dir [$]@)"; then mkdir "$(dir [$]@)"; fi
	$(AM_V_GEN)msgfmt -o "[$]@" "$<"

$(_HELP_LC_FILES): $(_DOC_MOFILES)
$(_HELP_LC_FILES): $(_DOC_C_DOCS)
	$(AM_V_at)if ! test -d "$(dir [$]@)"; then mkdir "$(dir [$]@)"; fi
	$(AM_V_GEN)if test -f "C/$(notdir [$]@)"; then d="../"; else d="$(abs_srcdir)/"; fi; \
	mo="$(dir [$]@)$(patsubst %/$(notdir [$]@),%,[$]@).mo"; \
	if test -f "$${mo}"; then mo="../$${mo}"; else mo="$(abs_srcdir)/$${mo}"; fi; \
	(cd "$(dir [$]@)" && \
	  xml2po -m $(_HELP_FORMAT) -e -t "$${mo}" "$${d}C/$(notdir [$]@)" > "$(notdir [$]@).tmp" && \
	  cp "$(notdir [$]@).tmp" "$(notdir [$]@)" && rm -f "$(notdir [$]@).tmp")

.PHONY: clean-help
mostlyclean-am: $(if $(HELP_ID),clean-help)
clean-help:
	rm -f $(_HELP_LC_FILES)

EXTRA_DIST ?=
EXTRA_DIST += $(_HELP_C_FILES) $(_HELP_LC_FILES) $(_HELP_C_EXTRA) $(_HELP_POFILES)
EXTRA_DIST += $(foreach f,$(HELP_MEDIA),$(foreach lc,$(_HELP_LINGUAS),$(wildcard $(lc)/$(f))))

.PHONY: install-help
install-data-am: $(if $(HELP_ID),install-help)
install-help:
	@for lc in C $(_HELP_LINGUAS); do \
	  $(mkinstalldirs) "$(DESTDIR)$(HELP_DIR)/$$lc/$(HELP_ID)" || exit 1; \
	done
	@for f in $(_HELP_C_FILES) $(_HELP_LC_FILES) $(_HELP_C_EXTRA); do \
	  lc=`dirname "$$f"`; lc=`basename "$$lc"`; \
	  if test -f "$$f"; then d=; else d="$(srcdir)/"; fi; \
	  helpdir="$(DESTDIR)$(HELP_DIR)/$$lc/$(HELP_ID)/"; \
	  if ! test -d "$$helpdir"; then $(mkinstalldirs) "$$helpdir"; fi; \
	  echo "$(INSTALL_DATA) $$d$$f $$helpdir`basename $$f`"; \
	  $(INSTALL_DATA) "$$d$$f" "$$helpdir`basename $$f`" || exit 1; \
	done
	@for f in $(HELP_MEDIA); do \
	  for lc in C $(_HELP_LINGUAS); do \
	    if test -f "$$lc$$f"; then d=; else d="$(srcdir)/"; fi; \
	    helpdir="$(DESTDIR)$(HELP_DIR)/$$lc/$(HELP_ID)/"; \
	    mdir=`dirname "$$f"`; \
	    if test "x$mdir" = "x."; then mdir=""; fi; \
	    if ! test -d "$$helpdir$$mdir"; then $(mkinstalldirs) "$$helpdir$$mdir"; fi; \
	    if test -f "$$d$$lc/$$f"; then \
	      echo "$(INSTALL_DATA) $$d$$lc/$$f $$helpdir$$f"; \
	      $(INSTALL_DATA) "$$d$$lc/$$f" "$$helpdir$$f" || exit 1; \
	    fi; \
	  done; \
	done

.PHONY: uninstall-help
uninstall-am: $(if $(HELP_ID),uninstall-help)
uninstall-help:
	@for f in $(_HELP_C_FILES) $(_HELP_LC_FILES) $(_HELP_C_EXTRA); do \
	  lc=`dirname "$$f"`; lc=`basename "$$lc"`; \
	  helpdir="$(DESTDIR)$(HELP_DIR)/$$lc/$(HELP_ID)/"; \
	  echo "rm -f $$helpdir`basename $$f`"; \
	  rm -f "$$helpdir`basename $$f`"; \
	done
	@for f in $(HELP_MEDIA); do \
	  for lc in C $(_HELP_LINGUAS); do \
	    helpdir="$(DESTDIR)$(HELP_DIR)/$$lc/$(HELP_ID)/"; \
	    echo "rm -f $$helpdir$$f"; \
	    rm -f "$$helpdir$$f"; \
	  done; \
	done;
'
AC_SUBST([HELP_RULES])
m4_ifdef([_AM_SUBST_NOTMAKE], [_AM_SUBST_NOTMAKE([HELP_RULES])])
])
