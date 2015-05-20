#!/bin/sh
# Run this to generate all the initial makefiles, etc.

WEBDOT_VERSION_DATE=$( git log -n 1 --format=%ct )
if test $? -eq 0; then
    WEBDOT_VERSION_DATE=$( date -u +%Y%m%d.%H%M -d @$WEBDOT_VERSION_DATE )
    echo "Version date is based on time of last commit: $WEBDOT_VERSION_DATE"
else
    WEBDOT_VERSION_DATE=$( date -u +%Y%m%d.%H%M )
    echo "Warning: we do not appear to be running in a git clone."
    echo "Version date is based on time now: $WEBDOT_VERSION_DATE"
fi

# initialize version for a "stable" build
cat >./version.m4 <<EOF
dnl webdot package version number, (as distinct from shared library version)
dnl For the minor number: odd => unstable series
dnl                       even => stable series
dnl For the micro number: 0 => in-progress development
dnl                       timestamp => tar-file snapshot or release
m4_define(webdot_version_major, 2)
m4_define(webdot_version_minor, 39)
dnl NB: the next line gets changed to a date/time string for development releases
m4_define(webdot_version_micro, 0)
m4_define(webdot_version_date, $WEBDOT_VERSION_DATE)
m4_define(webdot_collection, test)
m4_define(webdot_version_commit, unknown)
EOF


# default tools
#AUTOMAKE=automake
#ACLOCAL=aclocal
AUTOCONF=autoconf
#LIBTOOL=libtool
#LIBTOOLIZE=libtoolize

# prefer known working versions if available
#if test -x /usr/bin/automake-1.5 ; then AUTOMAKE=automake-1.5 ; fi 
#if test -x /usr/bin/automake-1.6 ; then AUTOMAKE=automake-1.6 ; fi
#if test -x /usr/bin/aclocal-1.5 ; then ACLOCAL=aclocal-1.5 ; fi
#if test -x /usr/bin/aclocal-1.6 ; then ACLOCAL=aclocal-1.6 ; fi
if test -x /usr/bin/autoconf-2.53 ; then AUTOCONF=autoconf-2.53 ; fi
if test -x /usr/bin/autoconf-2.57 ; then AUTOCONF=autoconf-2.57 ; fi

#echo "Using tools: $AUTOMAKE, $AUTOCONF, $ACLOCAL, $LIBTOOL, $LIBTOOLIZE"
echo "Using tools: $AUTOCONF"

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

ORIGDIR=`pwd`
cd $srcdir
PROJECT=webdot
TEST_TYPE=-f
FILE=cgi-bin/webdot

DIE=0

#($LIBTOOL --version) < /dev/null > /dev/null 2>&1 || {
#        echo
#        echo "You must have libtool installed to compile $PROJECT."
#        echo "Get ftp://alpha.gnu.org/gnu/libtool-1.2d.tar.gz"
#        echo "(or a newer version if it is available)"
#        DIE=1
#}
#
#($AUTOMAKE --version) < /dev/null > /dev/null 2>&1 || {
#	echo
#	echo "You must have automake installed to compile $PROJECT."
#	echo "Get ftp://sourceware.cygnus.com/pub/automake/automake-1.4.tar.gz"
#	echo "(or a newer version if it is available)"
#	DIE=1
#}

($AUTOCONF --version) < /dev/null > /dev/null 2>&1 || {
	echo
	echo "You must have autoconf installed to compile $PROJECT."
	echo "Download the appropriate package for your distribution,"
	echo "or get the source tarball at ftp://ftp.gnu.org/pub/gnu/"
	DIE=1
}

if test "$DIE" -eq 1; then
	exit 1
fi

test $TEST_TYPE $FILE || {
	echo "You must run this script in the top-level $PROJECT directory"
	exit 1
}

#case $CC in
#*xlc | *xlc\ * | *lcc | *lcc\ *) am_opt=--include-deps;;
#esac
#
#rm -f missing depcomp mkinstalldirs install-sh ltmain.sh \
#	config.sub config.guess ylwrap \
#	config/config.guess config/config.sub config/ltmain.sh \
#	config/install-sh config/mkinstalldirs config/missing \
#	config/depcomp config/ylwrap
#
#mkdir -p config
#
#$LIBTOOLIZE --force --copy
#
#$ACLOCAL -I m4 $ACLOCAL_FLAGS
#
## optionally feature autoheader
#(autoheader --version)  < /dev/null > /dev/null 2>&1 && autoheader
#
## don't need default COPYING.  This is to suppress the automake message
#touch COPYING
#
#$AUTOMAKE --add-missing --copy $am_opt
$AUTOCONF
#cd $ORIGDIR
#
## ensure depcomp exists even if still using automake-1.4
## otherwise "make dist" fails.
#touch depcomp
#
## ensure COPYING is based on LICENSE.html
#rm -f COPYING
#lynx -dump LICENSE.html >COPYING
#
echo 
echo "Now type './configure' to configure $PROJECT."
