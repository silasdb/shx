#!/bin/sh
#
# Escapes a string so the shell can handle it.

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
	shx_priv_echo "$shx_priv_e"
}

# Force escaping all options echo accepts (like -n and sometimes -e)
shx_priv_echo ()
{
	echo -- "$@" | sed 's/-- //'
}

shx_priv_add_backslash ()
{
	shx_priv_e=`shx_priv_echo "$shx_priv_e" | sed "s/$1/\\\\\\\\$1/g"`
}
