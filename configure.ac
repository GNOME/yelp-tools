AC_INIT([yelp-tools], [2.31.1],
        [http://bugzilla.gnome.org/enter_bug.cgi?product=yelp-tools])
AM_INIT_AUTOMAKE([1.9 no-dist-gzip dist-bzip2])

dnl  In the interest of portability, we don't use GNU awk extensions,
dnl  even though they rule.  To prevent accidental use and subsequent
dnl  bug reports after busted tarballs were shipped, we use -W compat
dnl  whenever our awk is gawk.
AC_PROG_AWK
if test x$AWK = xgawk; then
   GDU_AWK='gawk -W compat';
else
   GDU_AWK=$AWK;
fi
AC_SUBST(GDU_AWK)

AC_PROG_LN_S

AM_PATH_PYTHON([2.4])

PKG_CHECK_MODULES(GNOME_DOC_UTILS,
[
	libxml-2.0 >= 2.6.12
	libxslt    >= 1.1.8
	yelp-xsl
])

XSL_PATH="`$PKG_CONFIG --variable=xsltdir yelp-xsl`"

XSL_MAL_CACHE="$XSL_PATH""/mallard/cache/mal-cache.xsl"
AC_SUBST(XSL_MAL_CACHE)

AC_CONFIG_FILES([
Makefile
tools/Makefile
tools/yelp-cache
xml2po/Makefile
xml2po/xml2po.pc
xml2po/xml2po/Makefile
xml2po/xml2po/modes/Makefile
xml2po/examples/Makefile
])

AC_OUTPUT
