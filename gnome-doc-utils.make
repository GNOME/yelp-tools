################################################################################
## Public variables

DOC_MODULE ?=

# Files included with a SYSTEM entity
DOC_ENTITIES ?=

# Files included with XInclude
DOC_INCLUDES ?=

# Any of docbook, html, man, and info
DOC_FORMATS ?= docbook

DOC_LINGUAS ?=
DOC_PODIR ?= $(DOC_MODULE).po

XSLDOC_DIRS ?=
RNGDOC_DIRS ?=


################################################################################
## Convenience variables
## It might be useful to expose these

_DB2OMF_PARAMS = 						\
	--stringparam db2omf.omf_in `pwd`/$(_DOC_OMF_IN)
_RNGDOC_PARAMS =
_XSLDOC_PARAMS =


################################################################################
## For bootstrapping gnome-doc-utils only

_db2omf ?= `pkg-config --variable db2omf gnome-doc-utils`
_rngdoc ?= `pkg-config --variable rngdoc gnome-doc-utils`
_xsldoc ?= `pkg-config --variable xsldoc gnome-doc-utils`


################################################################################
## Setting internal variables

_RNGDOC_RNGS = $(foreach dir,$(RNGDOC_DIRS),				\
	$(wildcard $(dir)/*.rng))
_RNGDOC_C_DOCS = $(foreach rng,$(_RNGDOC_RNGS),				\
	C/$(basename $(notdir $(rng))).xml)
_RNGDOC_LC_DOCS =							\
	$(foreach lc,$(DOC_LINGUAS),$(foreach doc,$(_RNGDOC_C_DOCS),	\
		$(lc)/$(notdir $(doc)) ))

_XSLDOC_XSLS = $(foreach dir,$(XSLDOC_DIRS),				\
	$(wildcard $(dir)/*.xsl))
_XSLDOC_C_DOCS = $(foreach xsl,$(_XSLDOC_XSLS),				\
	C/$(basename $(notdir $(xsl))).xml)
_XSLDOC_LC_DOCS =							\
	$(foreach lc,$(DOC_LINGUAS),$(foreach doc,$(_XSLDOC_C_DOCS),	\
		$(lc)/$(notdir $(doc)) ))

_DOC_C_ENTITIES = $(foreach ent,$(DOC_ENTITIES),C/$(ent))
_DOC_LC_ENTITIES =							\
	$(foreach lc,$(DOC_LINGUAS),$(foreach ent,$(_DOC_C_ENTITIES),	\
		$(lc)/$(notdir $(ent)) ))

_DOC_C_INCLUDES = $(foreach inc,$(DOC_INCLUDES),C/$(inc))
_DOC_LC_INCLUDES =							\
	$(foreach lc,$(DOC_LINGUAS),$(foreach inc,$(_DOC_C_INCLUDES),	\
		$(lc)/$(notdir $(inc)) ))

_DOC_C_MODULES = C/$(DOC_MODULE).xml
_DOC_LC_MODULES = $(foreach lc,$(DOC_LINGUAS),$(lc)/$(DOC_MODULE).xml)

_DOC_C_DOCS =								\
	$(_DOC_C_ENTITIES) $(_DOC_C_INCLUDES)				\
	$(_RNGDOC_C_DOCS)  $(_XSLDOC_C_DOCS)				\
	$(_DOC_C_MODULES)
_DOC_LC_DOCS =								\
	$(_DOC_LC_ENTITIES) $(_DOC_LC_INCLUDES)				\
	$(_RNGDOC_LC_DOCS)  $(_XSLDOC_LC_DOCS)				\
	$(_DOC_LC_MODULES)

_DOC_OMF_IN = $(DOC_MODULE).omf.in
_DOC_OMF_OUTS =								\
	$(foreach lc,C $(DOC_LINGUAS),$(lc)/$(DOC_MODULE).omf)

_DOC_DESKTOP_IN = $(DOC_MODULE).desktop.in
_DOC_DESKTOP_OUTS =							\
	$(foreach lc,C $(DOC_LINGUAS),$(lc)/$(DOC_MODULE).desktop)


################################################################################
## The all target

# Uncomment when xml2po is hooked up
#all: $(_DOC_C_DOCS) $(_DOC_LC_DOCS) $(_DOC_OMF_OUTS) $(_DOC_DESKTOP_OUTS)
all: $(_DOC_C_DOCS) C/$(DOC_MODULE).omf C/$(DOC_MODULE).desktop


################################################################################
## The clean target

.PHONY: clean-lc-docs clean-omf clean-desktop clean-rngdoc clean-xsldoc
clean: clean-lc-docs clean-omf clean-desktop clean-rngdoc clean-xsldoc
clean-lc-docs :	; rm -f $(_DOC_LC_DOCS)
clean-omf :	; rm -f $(_DOC_OMF_OUTS)
clean-desktop :	; rm -f $(_DOC_DESKTOP_OUTS)
clean-rngdoc :	; rm -f $(_RNGDOC_C_DOCS)
clean-xsldoc :	; rm -f $(_XSLDOC_C_DOCS)


################################################################################
## Some extra convenience targets

.PHONY: omf
omf: $(_DOC_OMF_OUTS)

.PHONY: desktop
desktop: $(_DOC_DESKTOP_OUTS)

.PHONY: rngdoc
rngdoc: $(_RNGDOC_C_DOCS)

.PHONY: xsldoc
xsldoc: $(_XSLDOC_C_DOCS)


################################################################################
## Building metadata files

$(_DOC_DESKTOP_OUTS) : $(_DOC_DESKTOP_IN)
$(_DOC_DESKTOP_OUTS) : %/$(DOC_MODULE).desktop : %/$(DOC_MODULE).xml
	echo $@

$(_DOC_OMF_OUTS) : $(_DOC_OMF_IN)
$(_DOC_OMF_OUTS) : %/$(DOC_MODULE).omf : %/$(DOC_MODULE).xml
	xsltproc -o $@ $(_DB2OMF_PARAMS) $(_db2omf) $<


################################################################################
## Building rngdoc and xsldoc files

# Fix the dependancies on these!

xsldoc_args =									\
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

