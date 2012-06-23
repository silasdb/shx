# Useful functions for scripts.
#
# Note: All of them must start with shx_ to not conflict with scripts functions.

. "$SHX_HOME/shx_escape.sh"
. "$SHX_HOME/shx_log.sh"

shx_require ()
{
	local vname
	local value
	for f in "$@"; do
		vname="shx_${f}_loaded"
		eval "value=\$$vname"
		test "$f" = "$value" && continue
		test -f "$SHX_HOME/shx_$f.sh" \
		    || shx_fatal "shx: Module \"$f\" not found."
		. "$SHX_HOME/shx_$f.sh"
	done
}

# Initialization function.  This function performs several tasks before
# executing the script, so it can prepare environment for the upcoming code that
# is going to be evaluated.  An use example for this function is to check for
# the "-!" flag, that enables debug in all scripts that use the shx_init system.
# After setting environment, it calls main script function, main().
shx_init ()
{
	local args
	local shx_flag
	local debug
	local first
	local dashdash

	args=
	debug=
	shx_flag=no
	first=1
	dashdash=no

	# Check all arguments, looking for "-!".  With exception of "-!", it
	# puts al remaining arguments in $args, so it can be passed to main()
	# later.
	for a in "$@"; do
		if [ "$a" = "--" ]; then
			dashdash=yes
		fi
		if [ "$a" = "-!" -a "$dashdash" = "no" ]; then
			shx_flag=yes
		elif [ "$shx_flag" = "yes"  -a "$dashdash" = "no" ]; then
			shx_flag=no
			case "$a" in
			d)
				debug="yes"
				;;
			*)
				shx_warn "Unknown argument to -!: \"$a\""
				;;
			esac
		elif [ $first -eq 1 ]; then
			args="`shx_escape "$a"`"
			first=0
		else
			args="$args `shx_escape "$a"`"
		fi
	done

	if [ "$debug" = "yes" ]; then
		set -x
	fi

	# Call main script function.
	main $args

	shx_exit 0
}

# exit wrapper.  Executes a bunch of tasks before exiting the program, including
# temporary files.  Programs should not use exit function anymore, but shx_exit
# instead.
shx_exit () {
	# Remove any enqueued files.
	if [ "$shx_atexit_loaded" = "yes" ]; then
		shx_atexit_rm_enqueued_files
	fi

	exit "$1"
}
