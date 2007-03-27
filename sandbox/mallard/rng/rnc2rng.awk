#!/bin/awk
# rnc2rng.awk - Convert RELAX NG Compact Syntax to XML Syntax
# Copyright (C) 2007 Shaun McCance <shaunm@gnome.org>
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 2 of the License, or (at your
# option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

# This program is free software, but that doesn't mean you should use it.
# I wanted to write and maintain the Mallard schema in RNC in code blocks
# within the specification, but I needed to distribute the schema in RNG.
# Since xmllint (libxml2) does not currently support RNC, and since I'm
# not willing to introduce more dependencies, awk was my only option.
#
# This awk script is *NOT* a complete implementation, and probably never
# will be.  Its sole purpose is to handle the Mallard schema, and it is
# sufficient for that task.
#
# You are, of course, free to use any of this.  If you do proliferate this
# hack, it is requested (though not required, that would be non-free) that
# you atone for your actions.  A good atonement would be contributing to
# free software.

function runline (line) {
  sub(/^ */, "", line)
  c = substr(line, 1, 1);
  if (c == "(" || c == "{") {
    stack[++stack_i] = substr(line, 1, 1);
    paren[++paren_i] = stack_i;
    runline(substr(line, 2));
  }
  else if (c == ")" || c == "}") {
    open = stack[paren[paren_i]];
    oc = substr(open, 1, 1) c;
    if (oc != "()" && oc != "{}") {
      print "Mismatched parentheses on line " FNR | "cat 1>&2";
      error = 1;
      exit 1
    }

    tag = "";
    if (length(open) > 1 && substr(open, 2, 1) == "&") {
      tag = "interleave";
    }
    else if (length(open) > 1 && substr(open, 2, 1) == "|") {
      tag = "choice";
    }
    else if (oc == "()") {
      tag = "group";
    }

    tmp = "";
    if (tag != "") {
      tmp = "<" tag ">";
    }
    for (i = paren[paren_i] + 1; i <= stack_i; i++) {
      tmp = tmp stack[i] "\n";
    }
    if (tag != "") {
      tmp = tmp "</" tag ">";
    }
    stack_i = paren[paren_i];
    stack[stack_i] = tmp;
    paren_i--;

    if (oc == "{}") {
      if (substr(stack[stack_i - 1], 1, 8) == "<element") {
	tmp = stack[stack_i - 1] "\n";
	tmp = tmp stack[stack_i] "\n";
	tmp = tmp "</element>";
	stack[--stack_i] = tmp;
      }
      else if (substr(stack[stack_i - 1], 1, 10) == "<attribute") {
	tmp = stack[stack_i - 1] "\n";
	tmp = tmp stack[stack_i] "\n";
	tmp = tmp "</attribute>";
	stack[--stack_i] = tmp;
      }
      else if (stack[stack_i - 1] == "<list>") {
	tmp = stack[stack_i - 1] "\n";
	tmp = tmp stack[stack_i] "\n";
	tmp = tmp "</list>";
	stack[--stack_i] = tmp;
      }
    }
    if (paren_i == 0) {
      mode = "top";
    }
    runline(substr(line, 2));
  }
  else if (c == "|" || c == "&" || c == ",") {
    if (length(stack[paren[paren_i]]) == 1) {
      stack[paren[paren_i]] = stack[paren[paren_i]] c;
    }
    else if (substr(stack[paren[paren_i]], 2) != c) {
      print "Mismatched infix operators on line " FNR | "cat 1>&2";
      error = 1;
      exit 1
    }
    runline(substr(line, 2));
  }
  else if (c == "?") {
    stack[stack_i] = "<optional>" stack[stack_i] "</optional>"
    runline(substr(line, 2));
  }
  else if (c == "*") {
    stack[stack_i] = "<zeroOrMore>" stack[stack_i] "</zeroOrMore>"
    runline(substr(line, 2));
  }
  else if (c == "+") {
    stack[stack_i] = "<oneOrMore>" stack[stack_i] "</oneOrMore>"
    runline(substr(line, 2));
  }
  else if (c == "\"") {
    txt = substr(line, 2);
    sub(/".*/, "", txt)
    stack[++stack_i] = "<value>" txt "</value>";
    runline(substr(line, length(txt) + 3));
  }
  else if (substr(line, 1, 8) == "element ") {
    aft = substr(line, 8);
    sub(/^ */, "", aft);
    name = aft;
    sub(/[^[:alpha:]_]+.*/, "", name);
    aft = substr(aft, length(name) + 1);
    stack[++stack_i] = sprintf("<element name=\"%s\">", name);
    runline(aft);
  }
  else if (substr(line, 1, 10) == "attribute ") {
    aft = substr(line, 10);
    sub(/^ */, "", aft);
    name = aft;
    sub(/[^[:alpha:]_]+.*/, "", name);
    aft = substr(aft, length(name) + 1);
    stack[++stack_i] = sprintf("<attribute name=\"%s\">", name);
    runline(aft);
  }
  else if (substr(line, 1, 5) == "list ") {
    aft = substr(line, 5);
    sub(/^ */, "", aft);
    stack[++stack_i] = "<list>";
    runline(aft);
  }
  else if (match(line, /^text[^[:alpha:]]/)) {
    stack[++stack_i] = "<text/>";
    runline(substr(line, 5));
  }
  else if (substr(line, 1, 18) == "default namespace ") {
    print "default namespace appeared out of context on line " FNR | "cat 1>&2";
    error = 1;
    exit 1
  }
  else if (substr(line, 1, 6) == "start ") {
    print "start appeared out of context on line " FNR | "cat 1>&2";
    error = 1;
    exit 1
  }
  else if (match(line, /^xsd:[[:alpha:]_]/)) {
    name = substr(line, 1);
    sub(/^xsd:/, "", name);
    sub(/[^[:alpha:]_]+.*/, "", name);
    aft = substr(line, length(name) + 5);
    stack[++stack_i] = sprintf("<data type=\"%s\" datatypeLibrary=\"http://www.w3.org/2001/XMLSchema-datatypes\"/>",
			      name);
    runline(aft);
  }
  else if (match(line, /^[[:alpha:]_]/)) {
    name = substr(line, 1);
    sub(/[^[:alpha:]_]+.*/, "", name);
    aft = substr(line, length(name) + 1);
    stack[++stack_i] = sprintf("<ref name=\"%s\"/>", name);
    runline(aft);
  }
}

function printstack () {
  if (substr(stack[pos], 1, 6) == "<start") {
    print stack[pos++];
    printstack();
    print "</start>"
  }
  else if (substr(stack[pos], 1, 7) == "<define") {
    print stack[pos++];
    printstack();
    print "</define>"
  }
  else {
    print stack[pos++];
  }
}

BEGIN {
  mode = "top";
  stack_i = 0;
  paren_i = 0;
}

END {
  if (!error) {
    printf "<grammar xmlns='http://relaxng.org/ns/structure/1.0' ns='%s'>\n", namespace;
    tab = 1;
    pos = 1;
    while (pos <= stack_i) {
      printstack()
    }
    print "</grammar>"
  }
}

mode != "top" {
  runline($0);
}
mode == "top" && /.*=/ {
  name = substr($0, 1, index($0, "=") - 1);
  sub(/ /, "", name);
  if (substr($0, 1, 17) == "default namespace") {
    namespace = substr($0, index($0, "=") + 1);
    sub(/^ *"/, "", namespace);
    sub(/" *$/, "", namespace);
  }
  else if (name == "start") {
    stack[++stack_i] = "<start>"
    mode = "blank";
    runline(substr($0, index($0, "=") + 1))
  }
  else {
    stack[++stack_i] = sprintf("<define name=\"%s\">", name);
    mode = "blank";
    runline(substr($0, index($0, "=") + 1))
  }
}
