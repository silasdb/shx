#!/bin/sh

shx_string_loaded="yes"

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
	local old_opts
	old_opts="$(set +o)"
	set +x
	local q=''
	local str
	q="$(printf "%s" "$*" | sed "s/'/'\\\''/g")"
	printf '%s' "'$q'"
	eval "$old_opts" 2>/dev/null
}
