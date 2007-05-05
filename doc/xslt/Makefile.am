include $(top_srcdir)/tools/gnome-doc-utils.make
include $(top_srcdir)/bootstrap.make
dist-hook: doc-dist-hook

xsldoc_dirs = 					\
	$(top_srcdir)/xslt/common		\
	$(top_srcdir)/xslt/gettext		\
	$(top_srcdir)/xslt/docbook/common	\
	$(top_srcdir)/xslt/docbook/html		\
	$(top_srcdir)/xslt/docbook/omf
xsldoc_xsls = $(filter-out %db2html-suppressed.xsl,				\
	$(sort $(patsubst ./%, %, $(foreach dir,$(xsldoc_dirs),			\
	$(wildcard $(dir)/*.xsl) $(wildcard $(srcdir)/$(dir)/*.xsl) ))) )
xsldoc_base = $(sort $(foreach xsl,$(xsldoc_xsls), $(basename $(notdir $(xsl)))))
xsldoc_docs = $(patsubst %, C/%.xsldoc, $(xsldoc_base))
xsldoc_xmls = $(patsubst %, C/%.xml, $(xsldoc_base))

all: $(xsldoc_docs)
$(xsldoc_docs): $(xsldoc_xsls) xsldoc.awk xsldoc-fill.xsl
	$(GDU_AWK) -f "$(srcdir)/xsldoc.awk" "$(filter %/$(basename $(notdir $@)).xsl,$(xsldoc_xsls))" \
	| xsltproc -o "$@" \
	--stringparam basename "$(basename $(notdir $@))" \
	--stringparam xsl_file "$(filter %/$(basename $(notdir $@)).xsl,$(xsldoc_xsls))" \
	"$(srcdir)/xsldoc-fill.xsl" -

$(xsldoc_xmls): xsldoc.xsl
$(xsldoc_xmls): C/%.xml : C/%.xsldoc
	xsltproc -o "$@" \
	--stringparam basename "$(basename $(notdir $@))" \
	--stringparam xsl_file "$(filter %/$(basename $(notdir $@)).xsl,$(xsldoc_xsls))" \
	"$(srcdir)/xsldoc.xsl" "$<"

gnome_doc_xslt_includes='\
/<\!--BEGIN-->/ { inc=1; }\
/<\!--END-->/ { inc=0; }\
inc {\
  if (match($$0, /<include href="[^"]*\.xml"/)) {\
    base = $$0;\
    sub(/.*<include href="/, "", base);\
    sub(/\.xml".*/, "", base);\
    print base;\
  }\
}'

.PHONY: gnome-doc-xslt-check-includes gnome-doc-xslt-check-xsldoc
all: gnome-doc-xslt-check-includes gnome-doc-xslt-check-xsldoc
gnome-doc-xslt-check-includes:
	@incs=`$(GDU_AWK) $(gnome_doc_xslt_includes) "$(srcdir)/C/gnome-doc-xslt.xml" | sort`; \
	xmls=`echo $(xsldoc_base) | sort`; \
	exs=""; \
	for xml in $$xmls; do \
	  if echo "$$incs" | tr '\n' '\ ' | grep -v "\<$$xml\>" 1>/dev/null; then \
	    exs="$$exs$$xml "; \
	fi; done; \
	if [ "x$$exs" != "x" ]; then \
	  echo "gnome-doc-xslt.xml does not include the following reference pages: $$exs" 1>&2; \
	  exit 1; \
	fi
gnome-doc-xslt-check-xsldoc:
	@echo "Running xsldoc checks";
	@(echo "<xsldoc>"; cat $(xsldoc_docs); echo "</xsldoc>") \
	| xsltproc "$(srcdir)/xsldoc-check.xsl" - 1> /dev/null

clean-local:
	rm -f $(xsldoc_docs) $(xsldoc_xmls)

EXTRA_DIST = xsldoc.awk xsldoc.xsl

DOC_MODULE = gnome-doc-xslt
DOC_INCLUDES = legal.xml translating.xml $(patsubst %,%.xml,$(xsldoc_base))

DOC_LINGUAS =
