#!/bin/sh

echo "<report>"
for element in `cat elements`; do
    echo "<element name='"$element"'/>"
done;
for file in db2html*.xsl; do
    echo "<file href='"$file"'>";
    xml sel -t \
	-m "//xsl:template[@match and not(@mode)]" \
	-e template -a match -v "@match" \
	$file;
    xml sel -t \
	-m "//xsl:template[@match and @mode]" \
	-e template -a match -v "@match" --break -a mode -v "@mode" \
	$file;
    echo "</file>";
done;
echo "</report>"
