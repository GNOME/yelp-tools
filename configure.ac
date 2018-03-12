AC_INIT([yelp-tools], [3.28.0],
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

AC_CHECK_PROG(XMLLINT, xmllint, xmllint)
if test x"$XMLLINT" = x; then
  AC_MSG_ERROR([xmllint not found])
fi
if test `$XMLLINT --version 2>&1 | head -n1 | cut -d' ' -f5` -lt 20612 ; then
   AC_MSG_ERROR([xmllint too old; 2.6.12 required])
fi

AC_CHECK_PROG(XSLTPROC, xsltproc, xsltproc)
if test x"$XSLTPROC" = x; then
  AC_MSG_ERROR([xsltproc not found])
fi
if test `$XSLTPROC --version 2>&1 | head -n1 | cut -d' ' -f5` -lt 10108 ; then
   AC_MSG_ERROR([xsltproc too old; 1.1.8 required])
fi

AC_CHECK_PROG(ITSTOOL, itstool, itstool)
if test x"$ITSTOOL" = x; then
  AC_MSG_ERROR([itstool not found])
fi

PKG_CHECK_MODULES(YELP_XSL,
[
	yelp-xsl >= 3.17.3
])

XSL_PATH="`$PKG_CONFIG --variable=xsltdir yelp-xsl`"

DATADIR=`(
    case $prefix in
        NONE) prefix=$ac_default_prefix ;;
        *) ;;
    esac
    eval echo $(eval echo $datadir)/yelp-tools
)`
AC_SUBST([DATADIR])

XSL_MAL_CACHE="$XSL_PATH""/mallard/cache/mal-cache.xsl"
AC_SUBST(XSL_MAL_CACHE)

XSL_MAL_LINK="$XSL_PATH""/mallard/common/mal-link.xsl"
AC_SUBST(XSL_MAL_LINK)

XSL_MAL_SORT="$XSL_PATH""/mallard/common/mal-sort.xsl"
AC_SUBST(XSL_MAL_SORT)

XSL_DB2HTML="`$PKG_CONFIG --variable=db2html yelp-xsl`"
AC_SUBST(XSL_DB2HTML)

XSL_DB2XHTML="`$PKG_CONFIG --variable=db2xhtml yelp-xsl`"
AC_SUBST(XSL_DB2XHTML)

XSL_MAL2HTML="`$PKG_CONFIG --variable=mal2html yelp-xsl`"
AC_SUBST(XSL_MAL2HTML)

XSL_MAL2XHTML="`$PKG_CONFIG --variable=mal2xhtml yelp-xsl`"
AC_SUBST(XSL_MAL2XHTML)

YELP_ICON_DIR="`$PKG_CONFIG --variable=icondir yelp-xsl`"/hicolor/24x24/status
AC_SUBST(YELP_ICON_DIR)

YELP_JS_DIR="`$PKG_CONFIG --variable=jsdir yelp-xsl`"
AC_SUBST(YELP_JS_DIR)

YELP_TMPL_DIR=`(
        case $prefix in
             NONE) prefix=$ac_default_prefix ;;
             *) ;;
        esac
        eval echo $(eval echo $datadir)/yelp-tools/templates/
)`
AC_SUBST(YELP_TMPL_DIR)

AC_CONFIG_FILES([
Makefile
templates/Makefile
tools/Makefile
tools/yelp-build
tools/yelp-check
tools/yelp-new
xslt/Makefile
xslt/mal-ncx.xsl
xslt/mal-opf.xsl
])

AC_OUTPUT
