# Adjust these as needed

TCLSH	= `which tclsh`
GS	= `which gs`
PS2EPSI	= `which ps2epsi`
TTFDIR	= /usr/local/share/ttf

DOCROOT = /home/httpd/html
SERVER	= hops.hobl.lucent.com
WEBDOTDIR = webdot
WEBDOTCGI = index.cgi

#######################################################################

all:
	@echo "Nothing to make.  Type 'make install'"

install: uninstall
	mkdir $(DOCROOT)/$(WEBDOTDIR) $(DOCROOT)/$(WEBDOTDIR)/cache
	chmod 777 $(DOCROOT)/$(WEBDOTDIR)/cache
	cp -r data images $(DOCROOT)/$(WEBDOTDIR)/
	cp -r ../graphs $(DOCROOT)/$(WEBDOTDIR)/demo
	(echo \#!$(TCLSH) ; \
	  echo set GS $(GS); \
	  echo set PS2EPSI $(PS2EPSI); \
	  echo set TTFDIR $(TTFDIR); \
	  cat tcl/webdot.tcl) > $(DOCROOT)/$(WEBDOTDIR)/$(WEBDOTCGI)
	chmod +x $(DOCROOT)/$(WEBDOTDIR)/$(WEBDOTCGI)
	$(TCLSH) tcl/genindex.tcl http://$(SERVER) \
	  $(DOCROOT) $(WEBDOTDIR) $(WEBDOTCGI) demo/directed
	$(TCLSH) tcl/genindex.tcl http://$(SERVER) \
	  $(DOCROOT) $(WEBDOTDIR) $(WEBDOTCGI) demo/undirected
	@echo "##############################################################"
	@echo ""
	@echo "Please see README for Apache httpd configuration instructions."
	@echo ""
	@echo "Your new WebDot server should now be available at:"
	@echo ""
	@echo "         http://$(SERVER)/$(WEBDOTDIR)/$(WEBDOTCGI)"
	@echo ""
	@echo "##############################################################"

test:
	(cd $(DOCROOT)/$(WEBDOTDIR); SERVER_NAME=$(SERVER) \
	  SERVER_PORT=80 \
	  SCRIPT_NAME=/$(WEBDOTDIR)/$(WEBDOTCGI) \
	  REQUEST_METHOD=GET PATH_INFO=file://$(DOCROOT)/data/demo.dot.png \
	  $(TCLSH) $(DOCROOT)/$(WEBDOTDIR)/$(WEBDOTCGI) | tail +5 | xv - &)
	chmod -R 777 $(DOCROOT)/$(WEBDOTDIR)/cache

uninstall:
	rm -rf $(DOCROOT)/$(WEBDOTDIR)
