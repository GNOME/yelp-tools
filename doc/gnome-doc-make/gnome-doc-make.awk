BEGIN { print "<article>" }
BEGIN { print "<title>Variable Reference</title>" }

/^[^#]/ {
  if (invar) {
    print "    </para></listitem>";
    print "  </varlistentry>";
    invar = 0;
  }
}

/^## [^@]/ {
  if(invar) {
    sub(/^## /, "    ", $0);
    print $0;
  }
}

/^## @ / {
  sub(/^## @ /, "", $0);
  print "  <varlistentry>";
  print "    <term><parameter>" $0 "</parameter></term>";
  print "    <listitem><para>";
  invar = 1;
}

/^## @@ / {
  if (insect) print "</variablelist>";
  sub(/^## @@ /, "", $0);
  print "<variablelist>";
  print "  <title>" $0 "</title>";
  insect = 1;
}

END {
  if(invar) {
    print "    </para></listitem>";
    print "  </varlistentry>";
    invar = 0;
  }
  if(insect) print "</variablelist>";
  print "</article>";
}
