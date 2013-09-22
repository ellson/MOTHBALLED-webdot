#!/bin/sh
# the next line is a comment in tcl, but executable by sh \
exec wish "$0" ${1+"$@"}

###########################################################################
#
# tclet preamble code that runs in the browser (no wish required on server)
#
# Zoomable canvas tclet preamble by: John Ellson (ellson@research.att.com)
# if running in a tclet...
# set tclet security policy to allow ::browser::displayURL
if {[catch {policy home}]} {
  set intclet 0
} {
  set intclet 1
}
# tclets probably don't have Tkspline available
set __tkgen_smooth_type true
# set default action  (Select, ZoomIn, ZoomOut)
set action Select
# initialize zoom values
set z_in_fact 1.11
set z_out_fact [expr 1.0 / $z_in_fact]
set z_depth 1.0
# create and pack the widgets
pack [frame .a] -side top -fill both -expand true
pack [frame .b] [frame .c] -side top -fill x
pack [scrollbar .a.v -command {.a.c yview}] -side right -fill y
set c [canvas .a.c -highlightthickness 0 -background lightblue \
  -xscrollcommand {.b.h set} -yscrollcommand {.a.v set}] 
pack $c -side left -fill both -expand true
pack [scrollbar .b.h -orient horiz -command {.a.c xview}] \
  -side left -fill x -expand true
pack [frame .b.pad -width [expr [.a.v cget -width] + \
    [.a.v cget -bd]*2 + [.a.v cget -highlightthickness]*2 ] \
  -height [expr [.b.h cget -width] + \
    [.b.h cget -bd]*2 + [.b.h cget -highlightthickness]*2 ]] -side right
pack [radiobutton .c.zoomout -text "ZoomOut " -value ZoomOut \
    -selectcolor yellow -variable action -indicatoron 0] \
  [radiobutton .c.zoomin -text "ZoomIn " -value ZoomIn \
    -selectcolor yellow -variable action -indicatoron 0] \
   [radiobutton .c.select -text Select  -value Select \
    -selectcolor yellow -variable action -indicatoron 0] -side right
pack [button .c.clear -text Clear -pady 0 -padx 0 \
  -command {.c.l configure -text {}}] -side left
pack [label .c.l -bg white -anchor w] -side left -fill x -expand true
# set up event bindings
bind $c <ButtonPress-1> {act $action %W %x %y}
bind $c <ButtonRelease-1> {endact $action %W}
bind $c <ButtonPress-2> {
  if {$action=="ZoomIn"} {set invaction ZoomOut} {set invaction ZoomIn}
  act $invaction %W %x %y
}
bind $c <ButtonRelease-2> {endact $invaction %W}
bind $c <ButtonPress-3> {rotateAction}
$c bind all <Enter> {balloon_up %W %x %y}
$c bind all <Leave> {balloon_down %W}
# binding support procs
proc balloon_up {c x y} {
  global currentItem saveFill balloon
    set currentItem [lindex [$c gettags current] 0] 
    if {$currentItem == "current"} {
    unset currentItem
    } {
    set currentItem [string range $currentItem 1 end]
      set saveFill [lindex [$c itemconfigure 1$currentItem -fill] 4]
      $c itemconfigure 1$currentItem -fill black -stipple gray25
      set balloon [after 100 "balloon_up2 $c $x $y"]
    }
}
proc balloon_up2 {c x y} {
  global currentItem labels
  foreach i [$c find withtag 0$currentItem] {
    if {[$c type $i] == "text"} {
      lappend label [lindex $labels($i) 0]
    }
  }
  if {[info exists label]} {
    set t [$c create text \
      [expr [$c canvasx $x] -5] [expr [$c canvasy $y] -5] \
      -anchor se -text [join $label \n] -tag _balloon]
    eval $c create rectangle [$c bbox $t] -fill white -tag _balloon
      $c raise $t
  }
}
proc balloon_down {c} {
  global currentItem saveFill balloon
  if {[info exists currentItem]} {
    $c itemconfigure 1$currentItem -fill $saveFill -stipple {}
    catch {after cancel $balloon}
    catch {$c delete _balloon}
    unset currentItem
  }
}
proc rotateAction {} {
  global action
  set actions {ZoomOut ZoomIn Select}
  set action [lindex $actions \
    [expr ([lsearch $actions $action] + 1) % [llength $actions]]]
}
proc act {action c x y} {
  global z_in_fact z_out_fact labels 
  switch $action {
    ZoomIn {
      balloon_down $c
      foreach i [array names labels] {
        $c itemconfigure $i -text {}
      }
      zoom $c [$c canvasx $x] [$c canvasy $y] $z_in_fact
    }
    ZoomOut {
      balloon_down $c
      foreach i [array names labels] {
        $c itemconfigure $i -text {}
      }
      zoom $c [$c canvasx $x] [$c canvasy $y] $z_out_fact
    }
    Select {
      select $c
    }
  }
}
proc endact {action c} {
  global repeat zoomaction z_depth labels
  catch {after cancel $repeat}
  foreach i [array names labels] {
    foreach {text fontname fontsize} $labels($i) {break}
    set fontsize [expr int($fontsize * $z_depth)]
    if {$fontsize} {
      $c itemconfigure $i -text $text -font [list $fontname $fontsize]
    }
  }
}
proc select {c} {
  global currentItem embed_args
  if {[info exists currentItem] && [info exists embed_args(src)]} {
    set t [.c.l cget -text]
    .c.l configure -text [lappend t $currentItem]
    set url [file tail $embed_args(src)]map?$currentItem
    browser::displayURL $url _current
  }
}
proc zoom {c x y fact} {
  global repeat z_depth
  $c scale all $x $y $fact $fact
  set z_depth [expr $z_depth * $fact]
  $c configure -scrollregion [$c bbox all]
  set repeat [after 100 "zoom $c $x $y $fact"]
}
# render data (if it was provided first in the form of array data)
if {[info exists classes]} {
  foreach {class shape props} $classes {
    foreach instance [array names $class] {
      foreach {aname zname} [split $instance .] {break}
      switch $class {
        nodes {
          eval $c move [eval $c create oval -2 -2 2 2 $props -tags 1$aname] $nodes($instance)
        }
        edges {
          eval $c create line $nodes($aname) $nodes($zname) $props -tags 1$instance
        }
        default {
          set coords [set [set class]($instance)]
          eval $c create $shape $coords $props -tags 1$aname
        }
      }
    }
  }
}
update
after idle {
  # when graph loading is complete...
  # scale graph to fit canvas
  foreach {llx lly urx ury} [$c bbox all] {break}
  if {[catch {
    set xscale [expr 1.0 * [winfo width $c] / ($urx - $llx)]
    set yscale [expr 1.0 * [winfo width $c] / ($urx - $llx)]
  }]} {
    set xscale 1.0
    set yscale 1.0
  }
  set scale [expr $xscale < $yscale ? $xscale : $yscale]
  if {$scale < 1.0} {
    $c scale all 0 0 $scale $scale
    set z_depth $scale
  }
  # find all text items and save text and font
  foreach i [$c find all] {
    if {[$c type $i] == "text"} {
      foreach {fontname fontsize} [$c itemcget $i -font] {break}
      set text [$c itemcget $i -text]
      set labels($i) [list $text $fontname $fontsize]
      # and adjust text size if we rescaled to fit canvas
      if {$z_depth != 1.0} {
        set fontsize [expr int($fontsize * $z_depth)]
        if {$fontsize} {
          $c itemconfigure $i -text $text -font [list $fontname $fontsize]
        } {
          $c itemconfigure $i -text {}
        }
      }
    }
  }
  $c configure -scrollregion [$c bbox all]
}

# image data needs to be appended here .....  this is done when the tclet is servers by webdot
