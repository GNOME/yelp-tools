dnl GNOME_DOC_INIT([MINIMUM-VERSION])

dnl Do not call GNOME_DOC_DEFINES directly.  It is split out from
dnl GNOME_DOC_INIT to allow gnome-doc-utils to bootstrap off itself.
AC_DEFUN([GNOME_DOC_DEFINES],
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

AC_ARG_ENABLE([scrollkeeper],
	[AC_HELP_STRING([--disable-scrollkeeper],
			[do not make updates to the scrollkeeper database])],,
	enable_scrollkeeper=yes)
AM_CONDITIONAL(ENABLE_SK, test "x$enable_scrollkeeper" = "xyes")

])

AC_DEFUN([GNOME_DOC_INIT],
[
GDU_REQUIRED_VERSION=0.3.2
if test -n "$1"; then
  GDU_REQUIRED_VERSION=$1
fi

PKG_CHECK_MODULES([GDU_MODULE_VERSION_CHECK],[gnome-doc-utils >= $GDU_REQUIRED_VERSION])

GNOME_DOC_DEFINES
])
