#!/bin/sh

shx_log_loaded="yes"

# Outputs a message to stderr and exit with error
shx_fatal ()
{
	echo "$*" >&2
	echo "You may want use \"-! d\" to debug." >&2
	shx_exit 1
}

shx_warn ()
{
	echo "$*" >&2
}

