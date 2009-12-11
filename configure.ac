# Process this file with autoconf to produce a configure script
AC_INIT(webdot, 2.26)
AC_CONFIG_SRCDIR([configure.ac])
AC_CONFIG_AUX_DIR(config)

# Checks for system type
AC_CANONICAL_TARGET

AC_DEFINE_UNQUOTED(BUILDDATE,"`date -u`",[Date (usually date of extraction from CVS).])
BUILDDATE="`date -u`"
AC_SUBST(BUILDDATE)

AC_PREFIX_DEFAULT([/usr/local])
if test "x${prefix}" = "xNONE"; then
	prefix=${ac_default_prefix}
	AC_SUBST(prefix)
fi

# checks for programs
AC_PROG_INSTALL
AC_PROG_LN_S

BUILD_DIR=`pwd`
cd ${srcdir}
TOP_DIR=`pwd`
cd ${BUILD_DIR}

AC_SUBST(TOP_DIR)
AC_SUBST(BUILD_DIR)

# Generate Makefiles
AC_OUTPUT(Makefile
	webdot.spec
	)
