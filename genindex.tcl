#!/usr/bin/tclsh8.3

set f [open html/webdot/demo.html w]
set h /webdot/
set w /cgi-bin/webdot
set p /webdot/graphs/directed
cd html/webdot/graphs/directed

puts $f "<html>
<head>
<title>WebDot Demo Graphs</title>
</head>
<body bgcolor=#ffffff>
<h1><a href=$h>WebDot</a> Demo Graphs</h1>
<table border=1><tr>
<th>Directed</th>
<th colspan=3>DOT</th><th></th><th colspan=3>NEATO</th>
<th colspan=2></th>
<th colspan=3>DOT</th><th></th><th colspan=3>NEATO</th>
<th colspan=2></th>
<th colspan=3>DOT</th><th></th><th colspan=3>NEATO</th>
</tr><tr>"

set e dot
set oe neato
set i 0
foreach dd [lsort [glob *.dot]] {
	set d [file rootname $dd]
	if {$i%3} {puts $f "<td></td>"}
	puts $f "<td><a href=$w$p/$dd.src>$d</a></td>
<td><a href=$w$p/$dd.$e.png.help>png</a></td>
<td><a href=$w$p/$dd.$e.tcl.help>tcl</a></td>
<td><a href=$w$p/$dd.$e.svg>svg</a></td>
<!-- <td><a href=$w$p/$dd.$e.ps>ps</a></td> -->
<td><a href=$w$p/$dd.$e.pdf>pdf</a></td>
<td></td>
<td><a href=$w$p/$dd.$oe.png.help>png</a></td>
<td><a href=$w$p/$dd.$oe.tcl.help>tcl</a></td>
<td><a href=$w$p/$dd.$oe.svg>svg</a></td>
<!-- <td><a href=$w$p/$dd.$oe.ps>ps</a></td> -->
<td><a href=$w$p/$dd.$oe.pdf>pdf</a></td>"
	if {!([incr i]%3)} {puts $f "</tr><tr>"}
}

set p /webdot/graphs/undirected
cd ../undirected
puts $f "</tr><tr></tr><tr>
<th>Undirected</th>
<th colspan=3>DOT</th><th></th><th colspan=3>NEATO</th>
<th colspan=2></th>
<th colspan=3>DOT</th><th></th><th colspan=3>NEATO</th>
<th colspan=2></th>
<th colspan=3>DOT</th><th></th><th colspan=3>NEATO</th>
</tr><tr>"

set i 0
foreach dd [lsort [glob *.dot]] {
	set d [file rootname $dd]
	if {$i%3} {puts $f "<td></td>"}
	puts $f "<td><a href=$w$p/$dd.src>$d</a></td>
<td><a href=$w$p/$dd.$e.png.help>png</a></td>
<td><a href=$w$p/$dd.$e.tcl.help>tcl</a></td>
<td><a href=$w$p/$dd.$e.svg>svg</a></td>
<!-- <td><a href=$w$p/$dd.$e.ps>ps</a></td> -->
<td><a href=$w$p/$dd.$e.pdf>pdf</a></td>
<td></td>
<td><a href=$w$p/$dd.$oe.png.help>png</a></td>
<td><a href=$w$p/$dd.$oe.tcl.help>tcl</a></td>
<td><a href=$w$p/$dd.$oe.svg>svg</a></td>
<!-- <td><a href=$w$p/$dd.$oe.ps>ps</a></td> -->
<td><a href=$w$p/$dd.$oe.pdf>pdf</a></td>"
	if {!([incr i]%3)} {puts $f "</tr><tr>"}
}

puts $f "</tr>
</table>
<p>
<table>
<tr>
<td>For viewing <b>pdf</b> files you will need the pdf plugin:</td>
<td><a href=http://www.adobe.com/prodindex/acrobat/readstep.html>
<img src=getacro.png width=89 height=30 align=center
border=0 alt=\"get acrobat reader\"></a></td>
<td>and for viewing <b>tcl</b> files you will need the tcl plugin:</td>
<td><a href=http://www.demailly.com/tcl/plugin/download.html>
<img src=tclp.png width=42 height=64 align=center
border=0 alt=\"get tcl plugin\"></a></td>
</tr>
</table>

<p>
The graph renderings are produced on-demand by the 
<a href=$h>WebDot Graph Server</a>.
Please send problem reports first to the person that installed
this server locally.  WebDot was written by:
<a href=mailto:ellson@lucent.com>John Ellson</a>.
<p>
Thanks for trying <a href=$h>WebDot</a>.
</body>
</html>"

close $f
