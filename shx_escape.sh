#!/bin/sh
#
# Escapes a string so the shell can handle it.
#
# Realize that we do not use echo, but printf, which is more secure, since echo
# handles escape characters and dashes in a way difficult to make sure it will
# always work.  Check http://www.dwheeler.com/essays/filenames-in-shell.html for
# more information.

shx_escape_loaded="yes"

shx_priv_e=

shx_escape ()
{
	shx_priv_e="$*"

	# This must be before everything else
	shx_priv_add_backslash '\\'

	shx_priv_add_backslash ' '
	shx_priv_add_backslash '!'
	shx_priv_add_backslash '#'
	shx_priv_add_backslash '\$'
	shx_priv_add_backslash '&'
	shx_priv_add_backslash '*'
	shx_priv_add_backslash '('
	shx_priv_add_backslash ')'
	shx_priv_add_backslash '\['
	shx_priv_add_backslash '\]'
	shx_priv_add_backslash '`'
	shx_priv_add_backslash '<'
	shx_priv_add_backslash '>'
	shx_priv_add_backslash '?'
	shx_priv_add_backslash "'"
	shx_priv_add_backslash '"'
	printf '%s' "$shx_priv_e"
}

shx_priv_add_backslash ()
{
	shx_priv_e=$(printf '%s' "$shx_priv_e" | sed "s/$1/\\\\$1/g")
}
