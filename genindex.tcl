foreach {server docroot webdotdir webdotcgi demodir} $argv {break}
set w $server/$webdotdir/$webdotcgi
set p $server/$webdotdir/$demodir

set f [open $docroot/$webdotdir/$demodir/index.html w]
cd $docroot/$webdotdir/$demodir

puts $f "<html>
<head>
<title>WebDot Demo Graphs</title>
</head>
<body bgcolor=#ffffff>
<h1><a href=$w>WebDot</a> Demo Graphs</h1>
<table border=1>"

set i 0
foreach d [lsort [glob *.dot]] {
	if {$i%4} {puts $f "<td><td>"}
	puts $f "<td><a href=$w/$p/$d.src>$d</a></td>
<td><a href=$w/$p/$d.png>png</a></td>
<td><a href=$w/$p/$d.tcl>tcl</a></td>
<td><a href=$w/$p/$d.ps>ps</a></td>
<td><a href=$w/$p/$d.pdf>pdf</a></td>"
	if {!([incr i]%4)} {puts $f "</tr><tr>"}
}

puts $f "</tr>
</table>
<p>
For viewing <b>pdf</b> files you will need the pdf plugin:
<a href=http://www.adobe.com/prodindex/acrobat/readstep.html>
<IMG SRC=$server/$webdotdir/images/getacro.png WIDTH=89 HEIGHT=30 ALIGN=CENTER
BORDER=0 ALT=\"get acrobat reader\"></a>
<p> 
For viewing <b>tcl</b> files you will need the tcl plugin:
<a href=http://www.scriptics.com/plugin/>
<IMG SRC=$server/$webdotdir/images/tclp.png WIDTH=42 HEIGHT=64 ALIGN=CENTER
BORDER=0 ALT=\"get tcl plugin\"></a>

<p>
The graph renderings are produced on-demand by the 
<a href=$w>WebDot Graph Server</a>.
<br>
Please send any suggestions for improvement, or
problem reports to:
<a href=mailto:ellson@lucent.com>John Ellson</a>.
<p>
Thanks for trying <a href=$w>WebDot</a>.
</body>
</html>"

close $f
