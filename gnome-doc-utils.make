## Public variables

DOC_MODULE ?=
DOC_ENTITIES ?=
DOC_INCLUDES ?=

DOC_FORMATS ?=

DOC_LINGUAS ?=
DOC_PODIR ?=

XSLDOC_DIRS ?=
RNGDOC_DIRS ?=


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
	$(foreach lc,C $(DOC_LINGUAS),$(lc)/$(DOC_MODULE)-$(lc).omf

_DOC_DESKTOP_IN = $(DOC_MODULE).desktop.in
_DOC_DESKTOP_OUTS =							\
	$(foreach lc,C $(DOC_LINGUAS),$(lc)/$(DOC_MODULE).$(lc).desktop

