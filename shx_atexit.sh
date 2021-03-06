#!/bin/sh

# shx_atexit functions.
#
# The following shx_atexit functions and variables are used to register tasks to
# be done when finishing the program, either at normal exit or when receiving an
# INT signal.

# shx_atexit_rm enqueues files to be removed.  Those files are stored in the
# shx_atexit_rm_$i variable (where $i is an integer number starting from 0 -
# zero).  shx_atexit_rm_count stores the number of files enqueued.  For instance,
# if the programmer enqueued three files:
#
#    shx_atexit_rm tmp1.txt
#    shx_atexit_rm tmp2.txt
#
# Then shx_atexit_rm_count will be 2.  And there will be two variables with the
# enqueued files:
#
#    shx_atexit_rm_0: tmp1.txt
#    shx_atexit_rm_1: tmp2.txt
#
# We cannot just implement a shx_mktemp() function that joins mktemp(1) and
# shx_atexit_rm() because it would be executed in a subshell, like:
#
#    myfile="$(shx_mktemp "bla.XXXX")"
#
# Since it is executed in a subshell, our control variables would be lost.  The
# user have to call first mktemp(1) and then shx_atexit_rm().

shx_atexit_rm_count=0
shx_atexit_rm () {
	setvar "shx_atexit_rm_$shx_atexit_rm_count" "$1"
	shx_atexit_rm_count=$((shx_atexit_rm_count+1))
}

# Remove enqueued files, if there is any.  This function is not meant to be
# called from users, but from the shx_priv_trapint and shx_init functions only.
shx_atexit_rm_enqueued_files ()
{
	# If there is no enqueued files, return.
	test  "$shx_atexit_rm_count" -eq 0 && return

	local vname
	local filepath
	local rflag
	rflag=""
	shx_atexit_rm_count=$((shx_atexit_rm_count-1))
	# Remove every enqueued file or directory.
	for i in `seq 0 $shx_atexit_rm_count`; do
		vname="\$shx_atexit_rm_$i"
		filepath="$(eval "shx_echo $vname")"

		# If filename starts with dash, prepend "./" so rm later don't
		# think it is a parameter.  See
		# http://www.dwheeler.com/essays/filenames-in-shell.html
		# item 2.1.6 for more information.
		expr "$filepath" : '^-' >/dev/null \
		    && filepath="./$filepath"

		test -d "$filepath" && rflag="r"
		rm -f$rflag "$filepath"
	done
	shx_atexit_rm_count=0
}
