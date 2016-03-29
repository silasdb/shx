#!/bin/sh

shx_priv_md5cmd=

# Checks if root is running the script. If it is not, outputs an error message
# and exits.
shx_onlyroot ()
{
	if [ `id -u` -ne 0 ]; then
		shx_echoln "Only root can run this script" >&2
		return 2
	fi
}

shx_depends ()
{
	for f in $@; do
		if ! which "${f}" > /dev/null 2>&1; then
			shx_warnln "This script needs ${f}. ${f} not found."
			return 3
		fi
	done
}

# Returns the md5 (the md5 only) for a given file or stdin.
#
# $1 -> The file.  stdin if ommited.
shx_md5 ()
{
	if [ -z "$shx_priv_md5cmd" ]; then
		shx_priv_set_md5cmd || return 1
	fi

	$shx_priv_md5cmd "$@" | awk '{ print $1; }'
}

shx_filesize ()
{
	wc -c "$1" | awk '{ print $1; }'
	# TODO: wc doesn't work for file it cannot read.  Besides wc, having non
	# portable "stat" might be a good idea.
}

shx_priv_set_md5cmd ()
{
	local x

	x="$(which md5)"
	if [ -n "$x" ]; then
		shx_priv_md5cmd="md5 -n"
		return 0
	fi

	x="$(which md5sum)"
	if [ -n "$x" ]; then
		shx_priv_md5cmd="md5sum"
		return 0
	fi

	shx_warnln "No md5 program found."
	return 1
}
