#!/usr/bin/tclsh

set INDIR html.in
set OUTDIR html/webdot

set HTMLBASE /webdot
set CGIBASE /cgi-bin/webdot

set DOCS {
	basic "Basic graph creation" 0
	basicpublic "Basic graph creation - public WebDot server" 0
	hnodes "Clickable nodes" 0
	hedges "Clickable edges" 0
	svgembed "Embedded SVG graph" 0
	clientmap "Client-side maps" 1
	svginline "Inline SVG graphs" 1
	tclembed "Graphs in Tclets" 1
	graphquest "GraphQuest - pan &amp; zoom &amp; client-side maps" 0
}

set OTHER {
	index.html
	webdot_op.dot
	webdot_libs.dot
}

set header {<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta name="robots" content="noindex,nofollow">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="shortcut icon" href="$HTMLBASE/icon.png">
<title>WebDot Tutorial: $TITLE</title>
</head>
<body bgcolor="white">
<a href="$PREVBASE/$PREVIOUS">[previous]</a>
<a href="$NEXTBASE/$NEXT">[next]</a>
<font size="+2"><b>WebDot Tutorial: $TITLE</b></font>
}

set footer {</body>
</html>}

set PREVIOUS index.html
set PREVTITLE "WebDot Home"
set PREVBASE $HTMLBASE
for {set i 0} {$i < [llength $DOCS]} {} {
	set SELF [lindex $DOCS $i]
	set TITLE [lindex $DOCS [incr i]]
	if {[lindex $DOCS [incr i]]} {
		set BASE $CGIBASE$HTMLBASE
	} {
		set BASE $HTMLBASE
	}
	incr i
	if {$i == [llength $DOCS]} {
		set NEXT index.html
		set NEXTTITLE "WebDot Home"
		set NEXTBASE $HTMLBASE
	} {
		set NEXT [lindex $DOCS $i].html
		set NEXTTITLE [lindex $DOCS [expr $i + 1]]
		if {[lindex $DOCS [expr $i + 2]]} {
			set NEXTBASE $CGIBASE$HTMLBASE
		} {
			set NEXTBASE $HTMLBASE
		}
	}
	set fin $INDIR/$SELF.dot.in
	set fout $OUTDIR/$SELF.dot
	set DOT {}
	if {[file exists $fin]} {
		set f [open $fin r]
		set s [read $f [file size $fin]]
		close $f
		puts "writing $fout"
		set f [open $fout w]
		set DOT [subst -nocommands -nobackslashes $s]
		puts $f $DOT
		close $f
		regsub -all {<} $DOT {\&lt;} DOT
		regsub -all {>} $DOT {\&gt;} DOT
		set DOT "<table border=\"1\"><tr><td><pre>\n$DOT</pre></td></tr></table>"
	}
	set fin $INDIR/$SELF.html.in
	set fout $OUTDIR/$SELF.html
	if {[file exists $fin]} {
		set f [open $fin r]
		set s $header[read $f [file size $fin]]$footer
		close $f
		puts "writing $fout"
		set f [open $fout w]
		puts $f [subst -nocommands -nobackslashes $s]
		close $f
	}
	lappend CONTENTS "<li><a href=\"$BASE/$SELF.html\">$TITLE</a>"
	set PREVIOUS $SELF.html
	set PREVBASE $BASE
}	

set CONTENTS "<ol>\n[join $CONTENTS \n]\n</ol>"

foreach fn $OTHER {
	set fin $INDIR/$fn.in
	set fout $OUTDIR/$fn
	if {[file exists $fin]} {
		set f [open $fin r]
		set s [read $f [file size $fin]]
		close $f
		puts "writing $fout"
		set f [open $fout w]
		puts $f [subst -nocommands -nobackslashes $s]
		close $f
	}
}
