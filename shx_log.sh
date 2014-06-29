#!/bin/sh

shx_log_loaded="yes"

# Outputs a message to stderr and exit with error
shx_fatal ()
{
	shx_echoln "$*" >&2
	shx_exit 1
}

# Outputs a message to stderr, a debug message and then exit with error
shx_fatal_d ()
{
	shx_echoln "shx: You may want use \"-! d\" to debug your script." >&2
	shx_fatal "$*"
	# NOT REACHED
}

shx_warn ()
{
	shx_echoln "$*" >&2
}

