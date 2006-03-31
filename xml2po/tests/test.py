#!/usr/bin/env python
import sys, os

SIMPLETESTS = { 'deep-finals.xml' : {},
                'deep-nonfinals.xml': {},
                'attribute-entities.xml': {},
                'docbook.xml' : {},
                'utf8-original.xml': {},
                'footnotes.xml': {},
                'keepents.xml': { "options" : "-k" },
                'adjacent-ents.xml': { "options" : "-k" },
                }

OTHERTESTS = [ ('relnotes', 'test.sh') ]

if len(sys.argv) > 1:
    input = sys.argv[1]
    pot = input.replace(".xml", ".pot")
    po = input.replace(".xml", ".po")
    myopts = ""
    if len(sys.argv) > 2:
        for opt in sys.argv[2:]:
            myopts += " " + opt
    output = input.replace(".xml", ".xml.out")
    ret = os.system("../xml2po %s %s | sed 's/\"POT-Creation-Date: .*$/\"POT-Creation-Date: \\\\n\"/' | diff -u %s -" % (myopts, input, pot))
    if ret:
        print "Problem: extraction from '%s'" % (input)
    ret = os.system("../xml2po -p %s %s %s | diff -u %s -" % (po, myopts, input, output))
    if ret:
        print "Problem: merging translation into '%s'" % (input)
else:
    for t in SIMPLETESTS:
        if SIMPLETESTS[t].has_key("options"):
            myopts = SIMPLETESTS[t]["options"]
        else: myopts = ""
        if os.system("%s %s %s" % (sys.argv[0], t, myopts)):
            print "WARNING: Test %s failed." % (t)
    
    for t in OTHERTESTS:
        if os.system("cd %s && ./%s" % (t[0], t[1])):
            print "WARNING: Test %s failed." % (t[0])
    
