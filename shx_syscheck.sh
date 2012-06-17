#!/bin/sh

shx_syscheck_loaded="yes"

# Checks if root is running the script. If it is not, outputs an error message
# and exits.
shx_onlyroot ()
{
	if [ `id -u` -ne 0 ]; then
		echo "Only root can run this script" >&2
		shx_exit 2
	fi
}

shx_depends ()
{
	for f in $@; do
		if ! which "${f}" > /dev/null 2>&1; then
			echo "This script needs ${f}. ${f} not found." > \
			/dev/stderr
			shx_exit 3
		fi
	done
}
