dnl GNOME_DOC_INIT

AC_DEFUN([GNOME_DOC_INIT],
[
AC_ARG_WITH(helpdir,
  AC_HELP_STRING([--with-helpdir=DIR], [path to help docs]),,
  [with_helpdir='${datadir}/help'])
HELP_DIR="$with_helpdir"
AC_SUBST(HELP_DIR)

AC_ARG_WITH(omfdir,
  AC_HELP_STRING([--with-omfdir=DIR], [path to OMF files]),,
  [with_omfdir='${datadir}/omf'])
OMF_DIR="$with_omfdir"
AC_SUBST(OMF_DIR)
])
