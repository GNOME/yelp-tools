AC_INIT(xml2po.py)

dnl 
AM_INIT_AUTOMAKE(xml2po, 1.0.7.1)

dnl Default to same installation prefix as intltool
AC_PREFIX_PROGRAM(intltool-update)

AC_PROG_INSTALL

dnl Test for Python: not sure about the version, tested with 2.2.1
AM_PATH_PYTHON([2.0])

dnl I'm not sure about the version, tested with 2.5.11 and 2.6.*
LIBXML_REQUIRED=2.5.11

dnl Check pkg-config is installed ("borrowed" from shared-mime-info)
if test -z "$PKG_CONFIG"; then
  PKG_CONFIG=pkg-config
fi
AC_SUBST(PKG_CONFIG)

AC_MSG_CHECKING(that pkg-config runs)
if "$PKG_CONFIG" --version > /dev/null 2>&1 ; then
  AC_MSG_RESULT(yes)
else
  AC_MSG_RESULT(no)
  AC_MSG_ERROR([*** $PKG_CONFIG missing ***

\'$PKG_CONFIG --version\' failed to run - make sure it is inside one of the
directories in your PATH environment variable!

pkg-config is available from this web page:

http://www.freedesktop.org/software/pkgconfig
])
fi


AC_DEFUN(REQUIRE, [
AC_MSG_CHECKING(that $1 (version >= $2) is installed)
if "$PKG_CONFIG" --atleast-version=$2 $1 ; then
  AC_MSG_RESULT(yes)
else
  AC_MSG_RESULT(no)
  if "$PKG_CONFIG" --exists $1 ; then
    AC_MSG_ERROR(Current version is only `"$PKG_CONFIG" "$1" --modversion`)
  else
    AC_MSG_ERROR(Package is not installed)
  fi
fi
])

dnl Check for libxml
REQUIRE(libxml-2.0, $LIBXML_REQUIRED)

dnl PKG_CHECK_MODULES(XML2PO, libxml-2.0 >= $LIBXML_REQUIRED)

AC_OUTPUT([Makefile xml2po.pc modes/Makefile examples/Makefile])
