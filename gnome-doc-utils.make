# These are things that should be set by Makefile.am

DOC_MODULE ?=
DOC_ENTITIES ?=

DOC_LINGUAS ?=
DOC_PODIR ?= $(DOC_MODULE).po

XSLDOC_SOURCE_DIRS ?=
XSLDOC_PARAMS ?=

RNGDOC_SOURCE_DIRS ?=
RNGDOC_PARAMS ?=

# This is for testing purposes
echo :
	@echo omf_in   :: $(doc_omf_in)
	@echo dsk_in   :: $(doc_dsk_in)
	@echo omf_outs :: $(doc_omf_outs)
	@echo dsk_outs :: $(doc_dsk_outs)
	@echo sources :: $(doc_sources)
	@echo locales :: $(doc_locales)

# These are private variables used throughout this file
doc_omf_in = $(DOC_MODULE).omf.in
doc_dsk_in = $(DOC_MODULE).desktop.in
doc_omf_outs = $(foreach lang,$(DOC_LINGUAS),$lang/$(DOC_MODULE)-$lang.omf)
doc_dsk_outs = $(foreach lang,$(DOC_LINGUAS),$lang/$(DOC_MODULE).$lang.desktop)

doc_sources = C/$(DOC_MODULE).xml $(patsubst %,C/%,$(DOC_ENTITIES))
doc_locales = $(foreach lang,$(DOC_LINGUAS),$(patsubst C/%,$lang/%,$(doc_sources)))


