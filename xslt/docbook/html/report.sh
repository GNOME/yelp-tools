#!/bin/sh

echo "<_report>"
for element in `cat elements`; do
    echo "<_element name='"$element"'/>"
done;
for file in db2html*.xsl; do
    echo "<_file href='"$file"'>";
    xml sel -t \
	-m "//xsl:template[@match and not(@mode)]" \
	-e _template -a match -v "@match" \
	$file;
    xml sel -t \
	-m "//xsl:template[@match and @mode]" \
	-e _template -a match -v "@match" --break -a mode -v "@mode" \
	$file;
    echo "</_file>";
done;
echo "</_report>"
