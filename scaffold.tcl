#!/usr/bin/tclsh8.3

# cgi variables
set env(DOCUMENT_ROOT) /var/www/html
set env(SERVER_NAME) localhost
set env(SERVER_ADDR) 127.0.0.1
set env(REMOTE_ADDR) 127.0.0.1
set env(SERVER_PORT) 80
set env(SCRIPT_NAME) /cgi_bin/webdot
set env(REQUEST_METHOD) GET
set env(HTTP_PRAGMA) no-cache
#set env(PATH_INFO) /webdot/demo.dot.gif
#set env(PATH_INFO) /webdot/demo.dot.png
#set env(PATH_INFO) /webdot/demo.dot.png.help
#set env(PATH_INFO) /webdot/demo.dot.pdf
set env(PATH_INFO) /webdot/demo.html

source webdot
