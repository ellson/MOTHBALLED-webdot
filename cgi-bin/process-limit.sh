#!/bin/ksh

# From: "Stephen C. North" <north@research.att.com> 
# Date: 01/02/01 17:05
# Subject: webdot cgi bin hack to limit cpu and virtual memory
# To: ellson@lucent.com
# 
# Please note that $(kill -k $?)  is a ksh93-ism.
# In bash or pdksh I guess you could wire in the
# signal numbers for SIGXCPU and SIGKILL.  
# I don't know if it's documented or portable that
# hitting ulimit -v  causes a SIGKILL to be issued.

TCL=/usr/north/cgi-bin/webdot/tcl8.0
WWW=/usr/north/wwwfiles/webdot
PATH=$TCL/bin:$PATH
HTTPHEADER="Content-Type: text/plain\n\n"
export LD_LIBRARY_PATH=$TCL/lib:$LD_LIBRARY_PATH
export TCLLIBPATH=$TCL/lib
export DOTFONTPATH=/home/north/www-etc/lib/fonts/dos/windows/fonts/
(
        # set limit on seconds of cpu and kilobytes of memory
        ulimit -t 1
        ulimit -v 10000
        tclsh8.0 $WWW/webdot.tcl
)
case $(kill -l $?) in
XCPU)   print $HTTPHEADER
        print "WebDot server exceeded CPU limit (graph too large?)\n"
        exit ;;
KILL)   print $HTTPHEADER
        print "WebDot server killed (graph too large?)\n"
        exit ;;
esac


