################################################################################
## @@ Public variables

## @ DOC_MODULE
## The name of the document being built
DOC_MODULE ?=

## @ DOC_ENTITIES
## Files included with a SYSTEM entity
DOC_ENTITIES ?=

## @ DOC_INCLUDES
## Files included with XInclude
DOC_INCLUDES ?=

## @ DOC_FORMATS
## The default formats to be built and installed
DOC_FORMATS ?= docbook

## @ DOC_LINGUAS
## The languages this document is translated into
DOC_LINGUAS ?=

## @ DOC_PODIR
## The directory containing the po files for translation
DOC_PODIR ?= $(DOC_MODULE).po

## @ RNGDOC_DIRS
## The directories containing RNG files to be documented with rngdoc
RNGDOC_DIRS ?=

## @ XSLDOC_DIRS
## The directories containing XSLT files to be documented with xsldoc
XSLDOC_DIRS ?=


################################################################################
## @@ Convenience Variables
## These are a number of variables that are used throughout the rules.
## It may be useful to expose them as public variables at some point.

## @ _DB2OMF_PARAMS
## The parameters to pass to db2omf
_DB2OMF_PARAMS = 						\
	--stringparam db2omf.omf_in `pwd`/$(_DOC_OMF_IN)

## @ RNGDOC_PARAMS
## The parameters to pass to rngdoc
_RNGDOC_PARAMS =

## @ XSLDOC_PARAMS
## The parameters to pass to xsldoc
_XSLDOC_PARAMS =


################################################################################
## For bootstrapping gnome-doc-utils only

_db2omf ?= `pkg-config --variable db2omf gnome-doc-utils`
_rngdoc ?= `pkg-config --variable rngdoc gnome-doc-utils`
_xsldoc ?= `pkg-config --variable xsldoc gnome-doc-utils`


################################################################################
## @@ Internal Variables

## @ _RNGDOC_RNGS
## The actual RNG files for which to generate documentation with rngdoc
_RNGDOC_RNGS = $(foreach dir,$(RNGDOC_DIRS),				\
	$(wildcard $(dir)/*.rng))

## @ _RNGDOC_C_DOCS
## The generated rngdoc documentation in the C locale
_RNGDOC_C_DOCS = $(foreach rng,$(_RNGDOC_RNGS),				\
	C/$(basename $(notdir $(rng))).xml)

## @ _RNGDOC_LC_DOCS
## The generated rngdoc documentation in all other locales
_RNGDOC_LC_DOCS =							\
	$(foreach lc,$(DOC_LINGUAS),$(foreach doc,$(_RNGDOC_C_DOCS),	\
		$(lc)/$(notdir $(doc)) ))

## @ _XSLDOC_XSLS
## The actual XSLT files for which to generate documentation with xsldoc
_XSLDOC_XSLS = $(foreach dir,$(XSLDOC_DIRS),				\
	$(wildcard $(dir)/*.xsl))

## @ _XSLDOC_C_DOCS
## The generated xsldoc documentation in the C locale
_XSLDOC_C_DOCS = $(foreach xsl,$(_XSLDOC_XSLS),				\
	C/$(basename $(notdir $(xsl))).xml)

## @ _XSLDOC_LC_DOCS
## The generated xsldoc documentation in all other locales
_XSLDOC_LC_DOCS =							\
	$(foreach lc,$(DOC_LINGUAS),$(foreach doc,$(_XSLDOC_C_DOCS),	\
		$(lc)/$(notdir $(doc)) ))

## @ _DOC_C_ENTITIES
## Files included with a SYSTEM entity in the C locale
_DOC_C_ENTITIES = $(foreach ent,$(DOC_ENTITIES),C/$(ent))

## @ _DOC_LC_ENTITIES
## Files included with a SYSTEM entity in all other locales
_DOC_LC_ENTITIES =							\
	$(foreach lc,$(DOC_LINGUAS),$(foreach ent,$(_DOC_C_ENTITIES),	\
		$(lc)/$(notdir $(ent)) ))

## @ _DOC_C_ENTITIES
## Files included with XInclude entity in the C locale
_DOC_C_INCLUDES = $(foreach inc,$(DOC_INCLUDES),C/$(inc))

## @ _DOC_LC_ENTITIES
## Files included with XInclude entity in all other locales
_DOC_LC_INCLUDES =							\
	$(foreach lc,$(DOC_LINGUAS),$(foreach inc,$(_DOC_C_INCLUDES),	\
		$(lc)/$(notdir $(inc)) ))

## @ _DOC_C_MODULE
## The top-level documentation file in the C locale
_DOC_C_MODULE = C/$(DOC_MODULE).xml

## @ _DOC_LC_MODULE
## The top-level documentation file in all other locales
_DOC_LC_MODULE = $(foreach lc,$(DOC_LINGUAS),$(lc)/$(DOC_MODULE).xml)

## @ _DOC_C_DOCS
## All documentation files in the C locale
_DOC_C_DOCS =								\
	$(_DOC_C_ENTITIES) $(_DOC_C_INCLUDES)				\
	$(_RNGDOC_C_DOCS)  $(_XSLDOC_C_DOCS)				\
	$(_DOC_C_MODULE)

## @ _DOC_LC_DOCS
## All documentation files in all other locales
_DOC_LC_DOCS =								\
	$(_DOC_LC_ENTITIES) $(_DOC_LC_INCLUDES)				\
	$(_RNGDOC_LC_DOCS)  $(_XSLDOC_LC_DOCS)				\
	$(_DOC_LC_MODULE)

## @ _DOC_OMF_IN
## The OMF input file
_DOC_OMF_IN = $(DOC_MODULE).omf.in

## @ _DOC_OMF_HTMLS
## The OMF files for HTML output
_DOC_OMF_HTMLS =								\
	$(foreach lc,C $(DOC_LINGUAS),$(lc)/$(DOC_MODULE)-html-$(lc).omf)

## @ _DOC_OMF_DOCBOOKS
## The OMF files for DocBook output
_DOC_OMF_DOCBOOKS =								\
	$(foreach lc,C $(DOC_LINGUAS),$(lc)/$(DOC_MODULE)-db-$(lc).omf)

## @ _DOC_DESKTOP_IN
## The desktop entry input file
_DOC_DESKTOP_IN = $(DOC_MODULE).desktop.in

## @ _DOC_DESKTOP_HTMLS
## The desktop entry files for HTML output
_DOC_DESKTOP_HTMLS =								\
	$(foreach lc,C $(DOC_LINGUAS),$(lc)/$(DOC_MODULE).html.$(lc).desktop)

## @ _DOC_DESKTOP_DOCBOOKS
## The desktop entry files for DocBook output
_DOC_DESKTOP_DOCBOOKS =								\
	$(foreach lc,C $(DOC_LINGUAS),$(lc)/$(DOC_MODULE).db.$(lc).desktop)


################################################################################
## The all target

# Uncomment when xml2po is hooked up
#all: $(_DOC_C_DOCS) $(_DOC_LC_DOCS) $(_DOC_OMF_DOCBOOKS) $(_DOC_DESKTOP_DOCBOOKS)
all: $(_DOC_C_DOCS) C/$(DOC_MODULE).omf C/$(DOC_MODULE).desktop


################################################################################
## The clean target

.PHONY: clean-lc-docs clean-omf clean-desktop clean-rngdoc clean-xsldoc
clean: clean-lc-docs clean-omf clean-desktop clean-rngdoc clean-xsldoc
clean-lc-docs :	; rm -f $(_DOC_LC_DOCS)
clean-omf :	; rm -f $(_DOC_OMF_DOCBOOKS) $(_DOC_OMF_HTMLS)
clean-desktop :	; rm -f $(_DOC_DESKTOP_DOCBOOKS) $(_DOC_DESTOP_HTMLS)
clean-rngdoc :	; rm -f $(_RNGDOC_C_DOCS)
clean-xsldoc :	; rm -f $(_XSLDOC_C_DOCS)


################################################################################
## Some extra convenience targets

.PHONY: omf
omf: $(_DOC_OMF_DOCBOOKS)

.PHONY: desktop
desktop: $(_DOC_DESKTOP_DOCBOOKS)

.PHONY: rngdoc
rngdoc: $(_RNGDOC_C_DOCS)

.PHONY: xsldoc
xsldoc: $(_XSLDOC_C_DOCS)


################################################################################
## Building metadata files

$(_DOC_DESKTOP_DOCBOOKS) : $(_DOC_DESKTOP_IN)
$(_DOC_DESKTOP_DOCBOOKS) : %/$(DOC_MODULE).desktop : %/$(DOC_MODULE).xml
	echo $@

$(_DOC_OMF_DOCBOOKS) : $(_DOC_OMF_IN)
$(_DOC_OMF_DOCBOOKS) : %/$(DOC_MODULE).omf : %/$(DOC_MODULE).xml
	xsltproc -o $@ $(_DB2OMF_PARAMS) $(_db2omf) $<


################################################################################
## Building rngdoc and xsldoc files

# Fix the dependancies on these!

rngdoc_args =									\
	$(_RNGDOC_PARAMS) --stringparam rngdoc.id				\
	$(shell echo $(basename $(notdir $(1))) | sed -e 's/[^A-Za-z0-9_-]/_/g')\
	$(_rngdoc) $(filter %/$(basename $(notdir $(1))).rng,$(_RNGDOC_RNGS))

$(_RNGDOC_C_DOCS) : C/% : $(filter $(basename %), $(_RNGDOC_RNGS))
	xsltproc -o $@ $(call rngdoc_args,$@)

xsldoc_args =									\
	$(_XSLDOC_PARAMS) --stringparam xsldoc.id				\
	$(shell echo $(basename $(notdir $(1))) | sed -e 's/[^A-Za-z0-9_-]/_/g')\
	$(_xsldoc) $(filter %/$(basename $(notdir $(1))).xsl,$(_XSLDOC_XSLS))

$(_XSLDOC_C_DOCS) : C/% : $(_XSLDOC_XSLS)
	xsltproc -o $@ $(call xsldoc_args,$@)

