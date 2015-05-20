# Process this file with autoconf to produce a configure script
# Try to use version available on FC8
AC_PREREQ(2.61)

# set:
#       webdot_version_major
#       webdot_version_minor
#       webdot_version_micro
#       webdot_collection
#       webdot_version_date
#       webdot_version_commit
m4_include(./version.m4)

AC_INIT([webdot],[webdot_version_major().webdot_version_minor().webdot_version_micro()],[http://www.graphviz.org/])

WEBDOT_VERSION_MAJOR=webdot_version_major()
WEBDOT_VERSION_MINOR=webdot_version_minor()
WEBDOT_VERSION_MICRO=webdot_version_micro()

#NB: "stable" or "development"
WEBDOT_COLLECTION=webdot_collection()

#NB: date/time of last commit - or "0"
WEBDOT_VERSION_DATE=webdot_version_date()

#NB: git commit hash of last commit
WEBDOT_VERSION_COMMIT=webdot_version_commit()

WEBDOT_SOURCES=webdot/$WEBDOT_COLLECTION/SOURCES

AC_SUBST([WEBDOT_VERSION_MAJOR])
AC_SUBST([WEBDOT_VERSION_MINOR])
AC_SUBST([WEBDOT_VERSION_MICRO])
AC_SUBST([WEBDOT_VERSION_DATE])
AC_SUBST([WEBDOT_VERSION_COMMIT])
AC_SUBST([WEBDOT_COLLECTION])
AC_SUBST([WEBDOT_SOURCES])

dnl ===========================================================================

AC_CONFIG_SRCDIR([configure.ac])
AC_CONFIG_AUX_DIR(config)

# Checks for system type
AC_CANONICAL_TARGET

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
