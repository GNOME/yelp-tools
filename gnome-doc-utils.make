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
_DOC_REAL_FORMATS = $(if $(DOC_USER_FORMATS),$(DOC_USER_FORMATS),$(DOC_FORMATS))

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
## For bootstrapping gnome-doc-utils only

_db2omf ?= `pkg-config --variable db2omf gnome-doc-utils`
_rngdoc ?= `pkg-config --variable rngdoc gnome-doc-utils`
_xsldoc ?= `pkg-config --variable xsldoc gnome-doc-utils`


################################################################################
## @@ Rules for rngdoc

rngdoc_args =									\
	--stringparam rngdoc.id							\
	$(shell echo $(basename $(notdir $(1))) | sed -e 's/[^A-Za-z0-9_-]/_/g')\
	$(_rngdoc) $(filter %/$(basename $(notdir $(1))).rng,$(_RNGDOC_RNGS))

## @ _RNGDOC_RNGS
## The actual RNG files for which to generate documentation with rngdoc
_RNGDOC_RNGS = $(foreach dir,$(RNGDOC_DIRS),				\
	$(wildcard $(dir)/*.rng))

## @ _RNGDOC_C_DOCS
## The generated rngdoc documentation in the C locale
_RNGDOC_C_DOCS = $(foreach rng,$(_RNGDOC_RNGS),				\
	C/$(basename $(notdir $(rng))).xml)

# FIXME: Fix the dependancies
$(_RNGDOC_C_DOCS) : $(_RNGDOC_RNGS)
	xsltproc -o $@ $(call rngdoc_args,$@,$<)

.PHONY: rngdoc
rngdoc: $(_RNGDOC_C_DOCS)


################################################################################
## @@ Rules for xsldoc

xsldoc_args =									\
	--stringparam xsldoc.id							\
	$(shell echo $(basename $(notdir $(1))) | sed -e 's/[^A-Za-z0-9_-]/_/g')\
	$(_xsldoc) $(filter %/$(basename $(notdir $(1))).xsl,$(_XSLDOC_XSLS))

## @ _XSLDOC_XSLS
## The actual XSLT files for which to generate documentation with xsldoc
_XSLDOC_XSLS = $(foreach dir,$(XSLDOC_DIRS),				\
	$(wildcard $(dir)/*.xsl))

## @ _XSLDOC_C_DOCS
## The generated xsldoc documentation in the C locale
_XSLDOC_C_DOCS = $(foreach xsl,$(_XSLDOC_XSLS),				\
	C/$(basename $(notdir $(xsl))).xml)

# FIXME: Fix the dependancies
$(_XSLDOC_C_DOCS) : $(_XSLDOC_XSLS)
	xsltproc -o $@ $(call xsldoc_args,$@,$<)

.PHONY: xsldoc
xsldoc: $(_XSLDOC_C_DOCS)


################################################################################
## @@ OMF Files

db2omf_args =									\
	--stringparam db2omf.omf_dir $(OMF_DIR)					\
	--stringparam db2omf.help_dir $(HELP_DIR)				\
	--stringparam db2omf.omf_in `pwd`/$(_DOC_OMF_IN)			\
	$(_db2omf) $(2)

## @ _DOC_OMF_IN
## The OMF input file
_DOC_OMF_IN = $(DOC_MODULE).omf.in

## @ _DOC_OMF_DB
## The OMF files for DocBook output
_DOC_OMF_DB =									\
	$(foreach lc,C $(DOC_LINGUAS),$(DOC_MODULE)-$(lc).omf)

$(_DOC_OMF_DB) : $(_DOC_OMF_IN)
$(_DOC_OMF_DB) : $(DOC_MODULE)-%.omf : %/$(DOC_MODULE).xml
	xsltproc -o $@ $(call db2omf_args,$@,$<)

## @ _DOC_OMF_HTML
## The OMF files for HTML output
_DOC_OMF_HTML =									\
	$(foreach lc,C $(DOC_LINGUAS),$(DOC_MODULE)-html-$(lc).omf)

$(_DOC_OMF_HTML) : $(_DOC_OMF_IN)
$(_DOC_OMF_HTML) : $(DOC_MODULE)-html-%.omf : %/$(DOC_MODULE).xml
	xsltproc -o $@ $(call db2omf_args,$@,$<)

## @ _DOC_OMF_ALL
## All OMF output files to be built
# FIXME
_DOC_OMF_ALL =									\
	$(if $(findstring docbook,$(_DOC_REAL_FORMATS)),$(_DOC_OMF_DB))		\
	$(if $(findstring html,$(_DOC_REAL_FORMATS)),$(_DOC_OMF_HTML))

.PHONY: omf
omf: $(_DOC_OMF_ALL)


################################################################################
## @@ Desktop Entry Files

## @ _DOC_DSK_IN
## The desktop entry input file
_DOC_DSK_IN = $(DOC_MODULE).desktop.in

## @ _DOC_DSK_DB
## The desktop entry files for DocBook output
_DOC_DSK_DB =									\
	$(foreach lc,C $(DOC_LINGUAS),$(DOC_MODULE).db.$(lc).desktop)

# FIXME
$(_DOC_DSK_DB) : $(_DOC_DSK_IN)
$(_DOC_DSK_DB) : $(DOC_MODULE).db.%.desktop : %/$(DOC_MODULE).xml
	echo $@

## @ _DOC_DSK_HTML
## The desktop entry files for HTML output
_DOC_DSK_HTML =									\
	$(foreach lc,C $(DOC_LINGUAS),$(DOC_MODULE).html.$(lc).desktop)

$(_DOC_DSK_HTML) : $(_DOC_DSK_IN)
$(_DOC_DSK_HTML) : $(DOC_MODULE).html.%.desktop : %/$(DOC_MODULE).xml
	echo $@

## @ _DOC_DSK_ALL
## All desktop entry output files to be built
# FIXME
_DOC_DSK_ALL =									\
	$(if $(findstring docbook,$(_DOC_REAL_FORMATS)),$(_DOC_DSK_DB))		\
	$(if $(findstring html,$(_DOC_REAL_FORMATS)),$(_DOC_DSK_HTML))

.PHONY: dsk
dsk: $(_DOC_DSK_ALL)


################################################################################
## @@ C Locale Documents

## @ _DOC_C_MODULE
## The top-level documentation file in the C locale
_DOC_C_MODULE = C/$(DOC_MODULE).xml

## @ _DOC_C_ENTITIES
## Files included with a SYSTEM entity in the C locale
_DOC_C_ENTITIES = $(foreach ent,$(DOC_ENTITIES),C/$(ent))

## @ _DOC_C_XINCLUDES
## Files included with XInclude entity in the C locale
_DOC_C_INCLUDES = $(foreach inc,$(DOC_INCLUDES),C/$(inc))

## @ _DOC_C_DOCS
## All documentation files in the C locale
_DOC_C_DOCS =								\
	$(_DOC_C_ENTITIES) $(_DOC_C_INCLUDES)				\
	$(_RNGDOC_C_DOCS)  $(_XSLDOC_C_DOCS)				\
	$(_DOC_C_MODULE)

## @ _DOC_C_HTML
## All HTML documentation in the C locale
# FIXME: probably have to shell escape to determine the file names
_DOC_C_HTML = ($patsubst %.xml,%.html,$(_DOC_C_MODULE))


################################################################################
## @@ Other Locale Documentation

## @ _DOC_LC_MODULE
## The top-level documentation file in all other locales
_DOC_LC_MODULE = $(foreach lc,$(DOC_LINGUAS),$(lc)/$(DOC_MODULE).xml)

## @ _DOC_LC_ENTITIES
## Files included with a SYSTEM entity in all other locales
_DOC_LC_ENTITIES =							\
	$(foreach lc,$(DOC_LINGUAS),$(foreach ent,$(_DOC_C_ENTITIES),	\
		$(lc)/$(notdir $(ent)) ))

## @ _DOC_LC_XINCLUDES
## Files included with XInclude entity in all other locales
_DOC_LC_INCLUDES =							\
	$(foreach lc,$(DOC_LINGUAS),$(foreach inc,$(_DOC_C_INCLUDES),	\
		$(lc)/$(notdir $(inc)) ))

## @ _RNGDOC_LC_DOCS
## The generated rngdoc documentation in all other locales
_RNGDOC_LC_DOCS =							\
	$(foreach lc,$(DOC_LINGUAS),$(foreach doc,$(_RNGDOC_C_DOCS),	\
		$(lc)/$(notdir $(doc)) ))

## @ _XSLDOC_LC_DOCS
## The generated xsldoc documentation in all other locales
_XSLDOC_LC_DOCS =							\
	$(foreach lc,$(DOC_LINGUAS),$(foreach doc,$(_XSLDOC_C_DOCS),	\
		$(lc)/$(notdir $(doc)) ))

## @ _DOC_LC_HTML
## All HTML documentation in all other locales
# FIXME: same as above
_DOC_LC_HTML =								\
	$(foreach lc,$(DOC_LINGUAS),$(foreach doc,$(_DOC_C_HTML),	\
		$(lc)/$(notdir $(doc)) ))

## @ _DOC_LC_DOCS
## All documentation files in all other locales
_DOC_LC_DOCS =								\
	$(_DOC_LC_MODULE)						\
	$(_DOC_LC_ENTITIES) $(_DOC_LC_INCLUDES)				\
	$(_RNGDOC_LC_DOCS)  $(_XSLDOC_LC_DOCS)				\
	$(if $(findstring html,$(_DOC_REAL_FORMATS)),$(_DOC_LC_HTML))

# FIXME: fix the dependancy
# FIXME: hook xml2po up
$(_DOC_LC_DOCS) : $(_DOC_LINGUAS)
$(_DOC_LC_DOCS) : $(_DOC_C_DOCS)
	cp C/$(shell echo $@ | sed -e 's/^.*\///') $@

$(_DOC_LINGUAS):
	if ! test -d $@; then echo $@; fi

################################################################################
## @@ All Documentation

## @ _DOC_HTML_ALL
## All HTML documentation
_DOC_HTML_ALL = $(_DOC_C_HTML) $(_DOC_LC_HTML)

## @ _DOC_ALL
## All files distributed, built, or installed
_DOC_ALL =							\
	$(_DOC_C_DOCS)						\
	$(_DOC_LC_DOCS)						\
	$(_DOC_OMF_ALL)						\
	$(if $(findstring html,$(_DOC_REAL_FORMATS)),$(_DOC_HTML_ALL))
# $(_DOC_DSK_ALL)


################################################################################

.PHONY: clean-rngdoc clean-xsldoc clean-omf clean-dsk clean-lc

clean-rngdoc: ; rm -f $(_RNGDOC_C_DOCS) $(_RNGDOC_LC_DOCS)
clean-xsldoc: ; rm -f $(_XSLDOC_C_DOCS) $(_XSLDOC_LC_DOCS)
clean-omf: ; rm -f $(_DOC_OMF_DB) $(_DOC_OMF_HTML)
clean-dsk: ; rm -f $(_DOC_DSK_DB) $(_DOC_DSK_HTML)
clean-lc:  ; rm -f $(_DOC_LC_DOCS)

clean: clean-rngdoc clean-xsldoc clean-omf clean-dsk clean-lc
distclean: clean-omf clean-dsk
mostlyclean: clean-rngdoc clean-xsldoc clean-omf clean-dsk clean-lc
maintainer-clean: clean-rngdoc clean-xsldoc clean-omf clean-dsk clean-lc

.PHONY: gnome-doc-dist-hook

# FIXME: need to handle figures, etc.
EXTRA_DIST = $(_DOC_ALL) $(_DOC_OMF_IN) $(_DOC_DSK_IN)

all: $(_DOC_ALL)

.PHONY: check-doc check-omf
check: check-doc check-omf
check-doc:
	for lc in C $(DOC_LINGUAS); do \
	  xmllint --noout --xinclude --postvalid $$lc/$(DOC_MODULE).xml; \
	done
check-omf:
	for omf in $(_DOC_OMF_ALL); do \
	  xmllint --noout $$omf; \
	done

.PHONY: install-doc install-html install-omf
installs =								\
	$(if $(findstring docbook,$(_DOC_REAL_FORMATS)),install-doc)	\
	$(if $(findstring html,$(_DOC_REAL_FORMATS)),install-html)	\
	install-omf
install-data-local: $(installs)
install-doc:
	echo install-doc
install-html:
	echo install-html
install-omf:
	$(mkinstalldirs) $(OMF_DIR)/$(DOC_MODULE)
	cp $(_DOC_OMF_ALL) $(OMF_DIR)/$(DOC_MODULE)/

# install
# uninstall
# installcheck
# installdirs
