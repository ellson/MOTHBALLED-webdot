# Location for the webdot cgi program
CGI-BIN_DIR=/var/www/cgi-bin

# Location for some example web pages using webdot
HTML_DIR=/var/www/html

# A place that the webdot cgi program can cache its generated images
# (make install creates a webdot subdirectory in this dir.)
CACHE_DIR=/var/cache

# The uid:gid in effect when cgi-bin programs are running, only this
# user should be able to read/write the webdot cache.
HTTPD-USER-GROUP=apache:apache

# Location of tclsh8.3 (or later) executable
TCLSH_EXECUTABLE=/usr/bin/tclsh8.3

# Direct reference to libtcldot.so to avoid directory searching overhead
# of tcl package mechanism.
LIBTCLDOT=/usr/lib/graphviz/libtcldot.so

# Ghostscript is used for pdf output format
GS=/usr/bin/gs

# ps2epsi for epsi output format
PS2EPSI=/usr/bin/ps2epsi

# LOCALHOSTONLY set to 0 to allow conversion of graphs from other hosts
#      warning: use only if you want to provide a public graph server
#      this can result in uncontrolled load on your system
LOCALHOSTONLY=1

# version number for webdot-*.tar.gz
VERSION=1.10.2

###############################################################

all:

install:
	mkdir -p $(CGI-BIN_DIR)
	echo "#!$(TCLSH_EXECUTABLE)" > $(CGI-BIN_DIR)/webdot
	echo "set LIBTCLDOT $(LIBTCLDOT)" >> $(CGI-BIN_DIR)/webdot
	echo "set CACHE_ROOT $(CACHE_DIR)/webdot" >> $(CGI-BIN_DIR)/webdot
	echo "set GS $(GS)" >> $(CGI-BIN_DIR)/webdot
	echo "set PS2EPSI $(PS2EPSI)" >> $(CGI-BIN_DIR)/webdot
	echo "set LOCALHOSTONLY  $(LOCALHOSTONLY)" >> $(CGI-BIN_DIR)/webdot
	cat cgi-bin/webdot >> $(CGI-BIN_DIR)/webdot
	cp cgi-bin/webdot.tclet $(CGI-BIN_DIR)/webdot.tcl
	chmod +x $(CGI-BIN_DIR)/webdot
	cp -r html/webdot $(HTML_DIR)/
	rm -rf $(CACHE_DIR)/webdot
	mkdir $(CACHE_DIR)/webdot
	chmod 700 $(CACHE_DIR)/webdot
	chown $(HTTPD-USER-GROUP) $(CACHE_DIR)/webdot

uninstall:
	rm -f $(CGI-BIN_DIR)/webdot
	rm -f $(CGI-BIN_DIR)/webdot.tclet
	rm -rf $(HTML_DIR)/webdot
	rm -rf $(CACHE_DIR)/webdot

distdir=webdot-$(VERSION)

dist: 
	rm -rf $(distdir)*
	mkdir -p $(distdir)/cgi-bin $(distdir)/html/webdot
	cp AUTHORS CHANGES COPYING INSTALL README $(distdir)
	cp Makefile webdot.spec $(distdir)
	cp scaffold.tcl $(distdir)
	cp cgi-bin/webdot $(distdir)/cgi-bin/
	cp cgi-bin/webdot.tclet $(distdir)/cgi-bin/
	cp html/webdot/*.html $(distdir)/html/webdot/
	cp html/webdot/*.dot $(distdir)/html/webdot/
	cp html/webdot/*.png $(distdir)/html/webdot/
	cp html/webdot/*.gif $(distdir)/html/webdot/
	cp -r html/webdot/graphs $(distdir)/html/webdot/
	tar cf - $(distdir) | gzip > $(distdir).tar.gz
	rm -rf $(distdir)
