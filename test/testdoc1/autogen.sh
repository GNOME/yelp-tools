#!/bin/sh
# Run this to generate all the initial makefiles, etc.

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

PKG_NAME="testdoc1"

(test -f $srcdir/configure.in \
  && test -f $srcdir/README \
  && test -d $srcdir/help) || {
    echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
    echo " top-level $PKG_NAME directory"
    exit 1
}

which gnome-autogen.sh || {
    echo "You need to install gnome-common from the GNOME CVS"
    exit 1
}

# Don't do this in an actual package.  This is just so I can test changes
# to gnome-doc-utils.m4 without doing a make install.
ACLOCAL_FLAGS="-I . $ACLOCAL_FLAGS"
export ACLOCAL_FLAGS

USE_GNOME2_MACROS=1 . gnome-autogen.sh
