# Useful functions for scripts.
#
# Note: All of them must start with shx_ to not conflict with scripts functions.

set -e
set -u

# Workarounds for different shell quirks.
. "$SHX_HOME/shx_quirks.sh"

. "$SHX_HOME/shx_string.sh"
. "$SHX_HOME/shx_io.sh"
. "$SHX_HOME/shx_log.sh"

# Used for shx_require and shx_priv_module_loaded functions.  Hold a list of
# loaded modules.
shx_priv_module_list=

# Load a module if not loaded yet.
#
# $1 -> Name of the module.
shx_require ()
{
	local f
	for f in "$@"; do
		shx_priv_module_loaded "$f" && return 0
		test -f "$SHX_HOME/shx_$f.sh" \
		    || shx_fatalln 1 "shx: Module \"$f\" not found."
		# Maybe NOT REACHED
		. "$SHX_HOME/shx_$f.sh"
		shx_priv_module_list="$shx_priv_module_list $f"
	done
}

# Check if a module is loaded.
#
# $1 -> Module to check if it is loaded.
shx_priv_module_loaded ()
{
	local m
	for m in $shx_priv_module_list; do
		test "$m" = "$1" && return 0
	done
	return 1
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
				shx_warnln "Unknown argument to -!: \"$a\""
				;;
			esac
		elif [ $first -eq 1 ]; then
			args="$(shx_quote "$a")"
			first=0
		else
			args="$args $(shx_quote "$a")"
		fi
	done

	if [ "$debug" = "yes" ]; then
		set -x
	fi

	# Call main script function.
	eval "main $args"

	shx_exit "$?"
}

# exit wrapper.  Executes a bunch of tasks before exiting the program, including
# temporary files.  Programs should not use exit function anymore, but shx_exit
# instead.
shx_exit () {
	# Remove any enqueued files.
	if shx_priv_module_loaded 'atexit'; then
		shx_atexit_rm_enqueued_files
	fi
	local f
	for f in "$shx_priv_cleanup_functions"; do
		$f
	done
	exit "$1"
}

shx_priv_cleanup_functions=''
# User defined cleanup function.  They are called whenever the program exits, no
# matter if it it a normal exit or a trap.
#
# $1 -> Name of the function to be called.
shx_cleanup_add ()
{
	shx_priv_cleanup_functions="$shx_priv_cleanup_functions $@"
}

# Traps for clear exit
trap 'shx_exit 129' HUP
trap 'shx_exit 130' INT
trap 'shx_exit 131' QUIT
trap 'shx_exit 143' TERM
