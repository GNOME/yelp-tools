#!/bin/sh

echo "<report>"
for element in `cat elements`; do
    echo "<element name='"$element"'>"
    for file in db2html*.xsl; do
	match=`xml sel -t \
	    -m "//xsl:template[not(@mode)][@match='"$element"']" \
	    -v "@match" $file`;
	if test x"$match" != x""; then
	    echo "  <template href='"$file"'/>"
	fi;
	modes=`xml sel -t \
	    -m "//xsl:template[@mode][@match='"$element"']" \
	    -v "concat(@mode, ' ')" $file`;
	if test x"$modes" != x""; then
	    for mode in $modes; do
		echo "  <template href='"$file"' mode='"$mode"'/>";
	    done;
	fi;
    done;
    echo "</element>"
done;
echo "</report>"