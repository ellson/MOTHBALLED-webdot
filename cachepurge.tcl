#!/usr/bin/tclsh

#set CACHE /var/cache/webdot
set CACHE var/cache/webdot
set BLOCKSIZE 4096
set TARGETSIZE [expr (1000000+$BLOCKSIZE-1)/$BLOCKSIZE]

# rremove
#
# remove files and/or empty directories in fileglob pattern
#    then recursively remove parent directories if they are now empty
#
# return number of blocks freed by the removals
#
proc rremove {fileglob} {
	global BLOCKSIZE
	set blocks 0
	foreach file [glob -nocomplain $fileglob] {
		while {[file exists $file]
		    && [llength [glob -nocomplain $file/*]] == 0
		    && ! [string equal $file .]} {
			set blocks [expr $blocks \
			    + ([file size $file] + $BLOCKSIZE-1)/$BLOCKSIZE]
			file delete $file
			set file [file dirname $file]
		}
	}
	return $blocks
}


cd $CACHE
# determine the current size of the cache and see if we need to do anything
foreach {size .} [exec du -s --block-size=$BLOCKSIZE .] {break}
if {$size < $TARGETSIZE} {exit}

# prepare listing of cache contents sorted by access time, oldest first.
set f [open "| find . -printf \"%A@ %h/%f\n\" | sort" r]
# iterate through listing removing files until target cache size is reached
while {![eof $f]} {
	# We need to read all the records from the pipe till eof
	# otherwise we'll get "broken pipe" complaints when we close it.
	set rec [gets $f]
	if {$size < $TARGETSIZE || [string length $rec] == 0} {continue}
	foreach {atime file} $rec {break}
	# The cache avoids repetition of two distinct processes:
	#   1) getting graphs from the upstream server
	#   2) transforming the graph into various products
	# The first generates "src" and "info" files, but we
	# only use "info" to decide staleness because only "info"
	# is accessed if we have already cached products. The access time
	# of "src" cannot be used for staleness decisions as we
	# may need it later to generate another product consistent
	# with existing products.  If "info" is stale then everything
	# related to that graph is stale including "src"
	# All other files are products which can be purged individually
	switch -- [file tail $file] {
		src {}
		info {incr size -[rremove [file dirname $file]/*]}
		default {incr size -[rremove $file]}
	}
}
close $f
