#!/bin/sh

# Quotes strings to avoid make them safer.  Specially for strings that will be
# used in >eval< later.  The technique consists in replacing all single quotes
# by the sequence "'\''" which means 1. close current string, 2. add a single
# quote (\') 3. open the string again
#
# (Note: inside single quoted strings, it is not possible to escape a single
# quote by preceding it with a backslash.  So it it necessary to 1. close the
# string. 2. add a single quote. 3. open the string again.)
#
# Finally, we just surround the resulting string with single quotes, to be used
# safely by eval.
#
# Before seeing this in NetBSD code (link below) I used to use a much more
# dangerous approach (see in git log of this file), which consists in escaping
# every possible unsafe character but it was very hard to identify those.
#
# Inspired by: http://nxr.netbsd.org/xref/src/usr.sbin/postinstall/postinstall#shell_quote
shx_quote ()
{
	local q str
	q="$(printf "%s" "$*" | sed "s/'/'\\\''/g")"
	printf '%s' "'$q'"
}

# Prints the given field of a string.
#
# This function accepts two forms, reading the string from stdin or passing it
# as the second parameter.  Fields are strings separated by spaces.  If the user
# wants the 3rd word of the following string: "foo bar baz yyy", it may use one
# of the forms:
#
#    echo "foo bar baz yyy" | shx_field 3
#    shx_field 3 "foo bar baz yyy"
#
# $1 -> Field to be retrieved
# $2 -> String.  Optional.  If ommited, it is read from stdin.
#
# Returns 0 if ok, 1 if the first parameter is not a decimal integer.
shx_field ()
{
	if [ $# -eq 2 ]; then
		# If the string were passed to us, we reset positional
		# parameters, so we avoid forking a new awk.
		local n="$1"
		# TODO: we should check if it is positive too.
		shx_is_decimal "$n" || return 1
		# We need to set -f in order to prevent glob expansion when
		# passing $@.  We use a subshell to not allow set -f affect
		# external shell.
		(
		set -f
		set -- $@
		shift
		eval "shx_echo \$$n"
		)
	else
		awk "{ print \$$1 }"
	fi
}

# Test if the string is a decimal integer.
#
# $1 -> String to check.
#
# Returns: 0, if it is a decimal integer, 1 otherwise.
shx_is_decimal ()
{
	# Thanks to
	# http://stackoverflow.com/questions/13147038/check-if-the-argument-is-a-number-inside-the-shell-script
	(test "$1" -ge 0 || test "$1" -lt 0) 2>/dev/null || return 1
}
