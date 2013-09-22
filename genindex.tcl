#!/usr/bin/tclsh

cd html
set oldpwd [pwd]

set h /webdot
set w /cgi-bin/webdot

set g $h/graphs
set f [open .$h/demo.html w]

set layout_engines {dot neato twopi}
set nl [llength $layout_engines]

#set formats {{png help} {gif help} {tcl help} ps pdf svg}
set formats {{png help} ps pdf svgz {tcl help}}
set nf [llength $formats]

set directions {Directed Undirected}
set nd [llength $directions]

set ncol 2

puts $f "<html>
<head>
<title>WebDot Demo Graphs</title>
<link rel=\"shortcut icon\" href=\"$h/icon.png\">
</head>
<body bgcolor=#ffffff>
<h1><a href=$h/>WebDot</a> Demo Graphs</h1>
<table border=1><tr>"

set k 0
foreach dir {Directed Undirected} {
  set p $g/[string tolower $dir]
  cd $oldpwd$g/[string tolower $dir]

  for {set i 1} {$i <= $ncol} {incr i} {
    puts $f "<th>$dir</th><th colspan=$nf>DOT</th>"
    puts $f "<th></th><th colspan=$nf>NEATO</th>"
    puts $f "<th></th><th colspan=$nf>TWOPI</th>"
    if {$i != $ncol} {
      puts $f "<th></th>"
    } {
      puts $f "</tr><tr>"
    }
  }

  set i 0
  foreach dd [lsort [glob *.dot]] {
    set d [file rootname $dd]
    if {$i%$ncol} {
      puts $f "<td></td>"
    }
    puts $f "<td><a href=$w$p/$dd.src>$d</a></td>"
    set j 0
    foreach le $layout_engines {
      foreach fo $formats {
        if {[llength $fo] == 2} {
          foreach {fo hl} $fo {break}
          set hl .$hl
        } {
          set hl {}
        }
        puts $f "<td><a href=$w$p/$dd.$le.$fo$hl>$fo</a></td>"
      }
      if {[incr j] != $nl} {
        puts $f "<td></td>"
      }
    }
    if {!([incr i]%$ncol)} {puts $f "</tr><tr>"}
  }
  if {[incr k] != $nd} {
    puts $f "</tr><tr></tr><tr>"
  }
}

puts $f "</tr>
</table>
<p>
The graph renderings are produced on-demand by the 
<a href=$h/>WebDot Graph Server</a>.
Please send problem reports first to the person that installed
this server locally.  WebDot was written by:
<a href=mailto:ellson@research.att.com>John Ellson</a>.
<p>
Thanks for trying <a href=$h/>WebDot</a>.
</body>
</html>"

close $f
