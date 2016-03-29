#!/bin/sh

# TODO: add stuff to allow easy log to a file, if the user wants to.

# Outputs a message to stderr and exit with error
shx_log_fatal ()
{
	shx_echoln "$*" >&2
	shx_exit 1
}

# Outputs a message to stderr, a debug message and then exit with error
shx_log_fatal_d ()
{
	shx_echoln "shx: You may want use \"-! d\" to debug your script." >&2
	shx_fatal "$*"
	# NOT REACHED
}
