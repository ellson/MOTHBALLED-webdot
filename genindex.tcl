#!/usr/bin/tclsh8.3

set w http://localhost/cgi-bin/webdot
set p http://localhost/webdot/graphs/directed

set f [open html/webdot/demo.html w]
cd html/webdot/graphs/directed

puts $f "<html>
<head>
<title>WebDot Demo Graphs</title>
</head>
<body bgcolor=#ffffff>
<h1><a href=$w>WebDot</a> Demo Graphs</h1>
<table border=1>"

set e dot
set i 0
foreach d [lsort [glob *.dot]] {
	if {$i%4} {puts $f "<td><td>"}
	puts $f "<td><a href=$w/$p/$d.src>$d</a></td>
<td><a href=$w/$p/$d.$e.png>png</a></td>
<td><a href=$w/$p/$d.$e.tcl>tcl</a></td>
<td><a href=$w/$p/$d.$e.ps>ps</a></td>
<td><a href=$w/$p/$d.$e.pdf>pdf</a></td>"
	if {!([incr i]%4)} {puts $f "</tr><tr>"}
}

puts $f "</tr>
</table>
<p>
For viewing <b>pdf</b> files you will need the pdf plugin:
<a href=http://www.adobe.com/prodindex/acrobat/readstep.html>
<img src=getacro.png width=89 height=30 align=center
border=0 alt=\"get acrobat reader\"></a>
<p> 
For viewing <b>tcl</b> files you will need the tcl plugin:
<a href=http://www.scriptics.com/plugin/>
<img src=tclp.png width=42 height=64 align=center
border=0 alt=\"get tcl plugin\"></a>

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
