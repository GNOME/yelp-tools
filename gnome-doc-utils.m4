dnl GNOME_DOC_INIT

AC_DEFUN([GNOME_DOC_INIT],
[
AC_ARG_WITH([helpdir],
  AC_HELP_STRING([--with-helpdir=DIR], [path to help docs]),,
  [with_helpdir='${datadir}/help'])
HELP_DIR="$with_helpdir"
AC_SUBST(HELP_DIR)

AC_ARG_WITH([omfdir],
  AC_HELP_STRING([--with-omfdir=DIR], [path to OMF files]),,
  [with_omfdir='${datadir}/omf'])
OMF_DIR="$with_omfdir"
AC_SUBST(OMF_DIR)

GNOME_DOC_RULE='include $(top_srcdir)/gnome-doc-utils.make'
AC_SUBST(GNOME_DOC_RULE)

AC_OUTPUT_COMMANDS([
gdumk=`pkg-config --variable prefix gnome-doc-utils`/share/gnome-doc-utils/gnome-doc-utils.make
if ! test -f gnome-doc-utils.m4; then
  if ! cmp -s $gdumk gnome-doc-utils.make; then
    cp $gdumk .
  fi
fi
if ! grep -q 'gnome-doc-utils\.make' Makefile.am; then
  echo gnome-doc-utils.make should be added to EXTRA_DIST in Makefile.am
fi
])
])
