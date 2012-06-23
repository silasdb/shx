#!/bin/sh

shx_log_loaded="yes"

# Outputs a message to stderr and exit with error
shx_fatal ()
{
	echo "$*" >&2
	shx_exit 1
}

# Outputs a message to stderr, a debug message and then exit with error
shx_fatal_d ()
{
	echo "shx: You may want use \"-! d\" to debug your script." >&2
	shx_fatal "$*"
	# NOT REACHED
}

shx_warn ()
{
	echo "$*" >&2
}

