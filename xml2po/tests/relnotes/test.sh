#!/bin/sh
ALLFILES=`cat XMLFILES`
XML2PO="../../xml2po/xml2po"
($XML2PO $ALLFILES | sed 's/"POT-Creation-Date: .*$/"POT-Creation-Date: \\n"/' | diff -u release-notes.pot -) || echo "Problem with POT extraction"
for i in $ALLFILES; do
    ($XML2PO -p el.po $i | diff -u el/$i -) || echo "Problem with merging $i"
done
