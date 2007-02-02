.PHONY: check-validate check-links

check-validate:
	@(cd ../rng/ && $(MAKE) mallard.rnc)
	xmllint --noout --relaxng ../rng/mallard.rng *.xml

check-links:
	@files=$$(for file in *.xml; do \
	  xml sel -t -m "//*[@xref and contains(@xref, '#')]" \
          -v "substring-before(@xref, '#')" -n "$$file"; \
	  xml sel -t -m "//*[@xref and not(contains(@xref, '#'))]" \
          -v "@xref" -n "$$file"; \
	done | sort -u); \
	for file in $$files; do \
	  if [ ! -f "$$file.xml" -a ! -f "$$file.TODO" ]; then \
	    echo "$$file not found"; \
	    exit 1; \
	  fi; \
	done;



