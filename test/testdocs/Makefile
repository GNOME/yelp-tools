db2html = db2html.xsl

tests = $(filter-out template.xml,$(wildcard *.xml))
htmls = $(patsubst %.xml,html/%,$(tests))

htmlargs =							\
	-o $@/$(patsubst html/%,%.html,$1)			\
	--stringparam db.chunk.max_depth 0 			\
	--param db.chunk.chunk_top 'false()'			\
	--stringparam db.chunk.basename $(patsubst html/%,%,$1)	\
	$(db2html)

$(htmls) : html/% : %.xml
	@mkdir -p $@
	xsltproc $(call htmlargs,$@) $<

test: $(htmls)

clean:
	rm -rf html/*
