## Public variables

DOC_MODULE ?=
DOC_ENTITIES ?=
DOC_INCLUDES ?=

DOC_FORMATS ?=

DOC_LINGUAS ?=
DOC_PODIR ?= $(DOC_MODULE).po

XSLDOC_DIRS ?=
RNGDOC_DIRS ?=


## For bootstrapping gnome-doc-utils only

_db2omf ?= `pkg-config --variable db2omf gnome-doc-utils`
_rngdoc ?= `pkg-config --variable rngdoc gnome-doc-utils`
_xsldoc ?= `pkg-config --variable xsldoc gnome-doc-utils`


## Setting variables

_RNGDOC_RNGS = $(foreach dir,$(RNGDOC_DIRS),		\
	$(wildcard $(dir)/*.rng))
_RNGDOC_C_DOCS = $(foreach rng,$(_RNGDOC_RNGS),		\
	C/$(basename $(notdir $(rng))).xml)

_XSLDOC_XSLS = $(foreach dir,$(XSLDOC_DIRS),		\
	$(wildcard $(dir)/*.xsl))
_XSLDOC_C_DOCS = $(foreach xsl,$(_XSLDOC_XSLS),		\
	C/$(basename $(notdir $(xsl))).xml)

_DOC_C_ENTITIES = $(foreach ent,$(DOC_ENTITIES),C/$(ent))
_DOC_C_INCLUDES = $(foreach inc,$(DOC_INCLUDES),C/$(inc))

_DOC_C_MODULES = C/$(DOC_MODULE).xml
_DOC_C_DOCS =							\
	$(_DOC_C_ENTITIES) $(_DOC_C_INCLUDES)			\
	$(_RNGDOC_C_DOCS)  $(_XSLDOCS_C_DOCS)			\
	$(_DOC_C_MODULES)

_RNGDOC_LC_DOCS =							\
	$(foreach lc,$(DOC_LINGUAS),$(foreach doc,$(_RNGDOC_C_DOCS),	\
		$(lc)/$(notdir $(doc)) ))
_XSLDOC_LC_DOCS =							\
	$(foreach lc,$(DOC_LINGUAS),$(foreach doc,$(_XSLDOC_C_DOCS),	\
		$(lc)/$(notdir $(doc)) ))

_DOC_LC_ENTITIES =							\
	$(foreach lc,$(DOC_LINGUAS),$(foreach ent,$(_DOC_C_ENTITIES),	\
		$(lc)/$(notdir $(ent)) ))
_DOC_LC_INCLUDES =							\
	$(foreach lc,$(DOC_LINGUAS),$(foreach inc,$(_DOC_C_INCLUDES),	\
		$(lc)/$(notdir $(inc)) ))

_DOC_LC_MODULES = $(foreach lc,$(DOC_LINGUAS),$(lc)/$(DOC_MODULE).xml)
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


## Targets

# Uncomment when xml2po is hooked up
#all: $(_DOC_C_DOCS) $(_DOC_LC_DOCS) $(_DOC_OMF_OUTS) $(_DOC_DESKTOP_OUTS)
all: $(_DOC_C_DOCS) C/$(DOC_MODULE).omf C/$(DOC_MODULE).desktop

## Building .desktop files

$(_DOC_DESKTOP_OUTS) : $(_DOC_DESKTOP_IN)
$(_DOC_DESKTOP_OUTS) : %/$(DOC_MODULE).desktop : %/$(DOC_MODULE).xml


## Building .omf files

$(_ODC_OMF_OUTS) : $(_DOC_OMF_IN)
$(_DOC_OMF_OUTS) : %/$(DOC_MODULE).omf : %/$(DOC_MODULE).xml
	xsltproc -o $@ \
	--stringparam db2omf.omf_in `pwd`/$(_DOC_OMF_IN) \
	$(_db2omf) $<

## Building rngdoc files
$(_RNGDOC_C_DOCS) : C/% : $(filter $(basename %), $(_RNGDOC_RNGS))
	xsltproc -o $@ $(_rngdoc) $<

## Building xsldoc files
$(_XSLDOC_C_DOCS) : C/% : $(filter $(basename %), $(_XSLDOC_XSLS))
	xsltproc -o $@ $(_xsldoc) $<

