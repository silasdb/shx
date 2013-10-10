#!/bin/sh

shx_system_loaded="yes"

# Checks if root is running the script. If it is not, outputs an error message
# and exits.
shx_onlyroot ()
{
	if [ `id -u` -ne 0 ]; then
		echo "Only root can run this script" >&2
		return 2
	fi
}

shx_depends ()
{
	for f in $@; do
		if ! which "${f}" > /dev/null 2>&1; then
			shx_warn "This script needs ${f}. ${f} not found."
			return 3
		fi
	done
}
