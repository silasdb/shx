#!/bin/sh

shx_io_loaded="yes"

# We do not use echo, but printf, which is more secure, since echo handles
# escape characters and dashes in a way difficult to make sure it will always
# work.  Check http://www.dwheeler.com/essays/filenames-in-shell.html for more
# information.
shx_echo ()
{
	printf '%s' "$*"
}

# shx_echo with new line at the end.
shx_echoln ()
{
	printf '%s\n' "$*"
}

# shx_echo to stderr.
shx_warn ()
{
	shx_echo "$*" >&2
}

# shx_echoln to stderr.
shx_warnln ()
{
	shx_echoln "$*" >&2
}

# shx_warn to stderr and exit.
shx_fatal ()
{
	local err
	err="$1"
	shift
	shx_warn "$*" >&2
	shx_exit "$err"
}

# shx_warnln to stderr and exit.
shx_fatalln ()
{
	local err
	err="$1"
	shift
	shx_warnln "$*" >&2
	shx_exit "$err"
}

