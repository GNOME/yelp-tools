dnl GNOME_DOC_INIT

AC_DEFUN([GNOME_DOC_INIT],
[
AC_ARG_WITH([help-dir],
  AC_HELP_STRING([--with-help-dir=DIR], [path to help docs]),,
  [with_help_dir='${datadir}/gnome/help'])
HELP_DIR="$with_help_dir"
AC_SUBST(HELP_DIR)

AC_ARG_WITH([omf-dir],
  AC_HELP_STRING([--with-omf-dir=DIR], [path to OMF files]),,
  [with_omf_dir='${datadir}/omf'])
OMF_DIR="$with_omf_dir"
AC_SUBST(OMF_DIR)

AC_ARG_WITH([help-formats],
  AC_HELP_STRING([--with-help-formats=FORMATS], [list of formats]),,
  [with_help_formats=''])
DOC_USER_FORMATS="$with_help_formats"
AC_SUBST(DOC_USER_FORMATS)

AC_OUTPUT_COMMANDS([
gdumk=`pkg-config --variable prefix gnome-doc-utils`/share/gnome-doc-utils/gnome-doc-utils.make
if ! test -f gnome-doc-utils.m4; then
  if ! cmp -s $gdumk gnome-doc-utils.make; then
    cp $gdumk .
  fi
fi
if ! grep -q 'gnome-doc-utils\.make' $ac_top_srcdir/Makefile.am; then
  echo gnome-doc-utils.make should be added to EXTRA_DIST in Makefile.am
fi
])
])
