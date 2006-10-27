include $(top_srcdir)/gnome-doc-utils.make
include $(top_srcdir)/bootstrap.make
dist-hook: doc-dist-hook

xsldoc_dirs = 					\
	$(top_srcdir)/xslt/gettext		\
	$(top_srcdir)/xslt/docbook/common	\
	$(top_srcdir)/xslt/docbook/html		\
	$(top_srcdir)/xslt/docbook/omf
xsldoc_xsls = $(filter-out %db2html-suppressed.xsl,				\
	$(sort $(patsubst ./%, %, $(foreach dir,$(xsldoc_dirs),			\
	$(wildcard $(dir)/*.xsl) $(wildcard $(srcdir)/$(dir)/*.xsl) ))) )
xsldoc_base = $(sort $(foreach xsl,$(xsldoc_xsls), $(basename $(notdir $(xsl)))))
xsldoc_docs = $(patsubst %, C/%.xml, $(xsldoc_base))

all: $(xsldoc_docs)
$(xsldoc_docs): $(xsldoc_xsls) xsldoc.awk xsldoc.xsl
	$(AWK) -f "$(srcdir)/xsldoc.awk" "$(filter %/$(basename $(notdir $@)).xsl,$(xsldoc_xsls))" | xsltproc -o "$@" --stringparam basename "$(basename $(notdir $@))" --stringparam xsl_file "$(filter %/$(basename $(notdir $@)).xsl,$(xsldoc_xsls))" "$(srcdir)/xsldoc.xsl" -

gnome_doc_xslt_awk='\
/<\!--BEGIN-->/ { inc=1; }\
/<\!--END-->/ { inc=0; }\
inc {\
  if (match($$0, /<include href="([^"]*)\.xml"/, arr)) {\
    print arr[1];\
  }\
}'
.PHONY: gnome-doc-xslt-check
all: gnome-doc-xslt-check
gnome-doc-xslt-check:
	@incs=`$(AWK) $(gnome_doc_xslt_awk) "$(srcdir)/C/gnome-doc-xslt.xml" | sort`; \
	xmls=`echo $(xsldoc_base) | sed -e 's/ /\n/g' | sort`; \
	if [ "$$incs" != "$$xmls" ]; then \
	  echo "gnome-doc-xslt.xml does not include all reference pages" 1>&2; \
	  exit 1; \
	fi

EXTRA_DIST = xsldoc.awk xsldoc.xsl

DOC_MODULE = gnome-doc-xslt
DOC_INCLUDES = legal.xml translating.xml $(patsubst %,%.xml,$(xsldoc_base))

DOC_LINGUAS =
